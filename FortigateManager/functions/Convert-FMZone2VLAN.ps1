function Convert-FMZone2VLAN {
    <#
    .SYNOPSIS
    Converts an interface from a firewall policy to the addresses of the physical interfaces/vlan on the relevant devices.

    .DESCRIPTION
    Converts an interface from a firewall policy to the addresses of the physical interfaces/vlan on the relevant devices.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER LoggingLevel
    On which level should die diagnostic Messages be logged?

    .PARAMETER EnableException
    If set to True, errors will throw an exception

    .PARAMETER Zone
    The names of the interface/Zone/localiced interface name (found in policy rules)

    .PARAMETER ReturnType
    How should the results be returned?
    'simpleIpList': Array of ipmasks
    'ZoneVLANHash': Hashtable, @{"$zoneName"=[Array of ipmasks]}
    'ZoneVDOMVLANHash': Hashtable,
        values=[Array of ipmasks]
        keys= "{ZONE-Name}|{VDOM}"

    .PARAMETER Scope
    The scope which should be looked up.
    @(@{name='deviceName';vdom='vdom name'})

    By default all available devices/vdoms will be looked up.

    .EXAMPLE
     $policy=Get-FMFirewallPolicy -Package ALL -Option 'scope member' -filter "policyid -eq 1234"
     Convert-FMZone2VLAN -Zone $policy.srcintf,$policy.dstintf

     Returns a list of ipmasks

    .EXAMPLE
     $policy=Get-FMFirewallPolicy -Package ALL -Option 'scope member' -filter "policyid -eq 1234"
     Convert-FMZone2VLAN -Zone $policy.srcintf,$policy.dstintf

     Returns a list of ipmasks

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $false)]
        $Connection = (Get-FMLastConnection),
        [parameter(Mandatory = $true)]
        [string[]]$Zone,
        [ValidateSet('simpleIpList', 'ZoneVLANHash', 'ZoneVDOMVLANHash')]
        $ReturnType = 'simpleIpList',
        [string]$LoggingLevel='Verbose',
        $Scope,
        [bool]$EnableException = $true
    )
    Write-PSFMessage "Determine VLANs from Zones: $($Zone -join ',')"
    Write-PSFMessage "Query all VDOMs and corresponding VLANs"
    if ($null -eq $Scope) {
        Write-PSFMessage "Scope is ALL devices and vdoms"
        # $Scope = Get-FMDeviceInfo -Connection $connection -Option 'object member' | Select-Object -ExpandProperty "object member" | Where-Object { $_.vdom } | ConvertTo-PSFHashtable -Include name, vdom
        $Scope = Get-FMFirewallScope -Connection $Connection | ConvertTo-PSFHashtable -Include name, vdom
    }else{
        $Scope = $Scope|ConvertTo-PSFHashtable
    }
    # Query all localized interface names into a HashTable
    # Key-Format: [Localized Interface Name]|[Device Name]|[Device VDOM]
    # Value: List of local Zone/Interface Names
    $localizedInterfaceList = Get-FMInterface
    $localizedInterfaceHashMap = @{}
    foreach ($interface in $localizedInterfaceList) {
        $localizedName = $interface.name
        foreach ($dynaMapping in $interface.dynamic_mapping) {
            foreach ($interfaceScope in $dynaMapping._scope) {
                $key = "$localizedName|$($interfaceScope.name)|$($interfaceScope.vdom)"
                $localizedInterfaceHashMap.$key = $dynaMapping."local-intf"
            }
        }
    }
    # $Scope = Get-FMDeviceInfo -Connection $connection -Option 'object member' | Select-Object -ExpandProperty "object member" | Where-Object { $_.vdom } | ConvertTo-PSFHashtable -Include name, vdom -Remap @{name = 'device' }
    foreach ($device in $Scope) {
        Write-PSFMessage "Query Device $($device| ConvertTo-Json -WarningAction SilentlyContinue -Compress)"
        $apiCallParameter = @{
            EnableException     = $EnableException
            LoggingAction       = "Undocumented"
            Connection          = $Connection
            LoggingActionValues = "Query all interface VLAN from a specific Device/VDOM"
            method              = "get"
            LoggingLevel        = $LoggingLevel
            path                = "/pm/config/device/{name}/vdom/{vdom}/system/interface" | Merge-FMStringHashMap -Data $device
        }
        $device.vlanHash = @{}

        $currentInterfaces = Invoke-FMAPI @apiCallParameter # | ConvertTo-Json -WarningAction SilentlyContinue -Depth 6
        foreach ($interface in $currentInterfaces.result.data) {
            $name = $interface.name
            $device.vlanHash.$name = $interface.ip
            # if ($interface.ip[1] -eq '0.0.0.0') {
            #     $address = "$($interface.ip[0])/0"
            # }
            # else {
            #     $address = Convert-FMSubnetMask -IPMask "$($interface.ip[0])/$($interface.ip[1])"
            # }
            # $device.vlanHash.$name = $address
        }
    }
    switch -regex ($ReturnType) {
        '.*List' {
            $returnValue = @()
        }
        '.*Hash' {
            $returnValue = @{}
        }
    }
    Write-PSFMessage "`$returnValue.type=$($returnValue.GetType())"
    foreach ($curZone in $Zone) {
        Write-PSFMessage "Checking Zone: $curZone"
        switch ($ReturnType) {
            'ZoneVLANHash' { $returnValue.$curZone = @() }
        }
        $queryData = @{zone = $curZone | convertto-fmurlpart }
        $apiCallParameter = @{
            EnableException     = $true
            Connection          = $Connection
            LoggingAction       = "Undocumented"
            LoggingActionValues = "Query interfaces from a specific Device/VDOM"
            method              = "get"
            LoggingLevel        = 'Verbose'
        }
        $singleDeviceVdomURL = "/pm/config/device/{{name}}/vdom/{{vdom}}/system/zone/{zone}"
        foreach ($queryData in $Scope) {
            $hashKey = "$curZone|$($queryData.name)|$($queryData.vdom)"
            Write-PSFMessage "`$hashKey=$hashKey"
            $localZoneName = $localizedInterfaceHashMap.$hashKey
            Write-PSFMessage "Local Interface Name from localized Name $curZone=$localZoneName"
            if ([string]::IsNullOrEmpty($localZoneName)) {
                Write-PSFMessage "No local name found, continue"
                continue
            }
            $queryData.zone = $localZoneName | convertto-fmurlpart
            $apiCallParameter.path = $singleDeviceVdomURL | Merge-FMStringHashMap -Data $queryData
            Write-PSFMessage "`$queryData=$($queryData| ConvertTo-Json -WarningAction SilentlyContinue -compress), Path=$($apiCallParameter.path)"
            try {
                $result = Invoke-FMAPI @apiCallParameter
                Write-PSFMessage "Found"
                $interfaceList = $result.result.data.interface
                # Write-PSFMessage "Query: $($queryData| ConvertTo-Json -WarningAction SilentlyContinue -compress), Results: $($result| ConvertTo-Json -WarningAction SilentlyContinue -Depth 4)"
                Write-PSFMessage "interfaceList for $($queryData| ConvertTo-Json -WarningAction SilentlyContinue -compress): $($interfaceList -join ',')"
                foreach ($interface in $interfaceList) {
                    $vlanIP = $queryData.vlanHash.$interface
                    if ($vlanIP[1] -eq '0.0.0.0') {
                        $address = "$($vlanIP[0])/0"
                    }
                    else {
                        $address = Convert-FMSubnetMask -IPMask "$($vlanIP[0])/$($vlanIP[1])" -Verbose:$false
                    }

                    switch ($ReturnType) {
                        'simpleIpList' {
                            Write-PSFMessage "Adding VLAN Info to simpleIpListList"
                            $returnValue += $address
                        }
                        'ZoneVLANHash' {
                            Write-PSFMessage "Adding Interfaces to ZoneVLANHash"
                            $returnValue.$curZone += $address
                        }
                        'ZoneVDOMVLANHash' {
                            $returnKey = "$curZone|$($queryData.vdom)"
                            Write-PSFMessage "returnKey=$returnKey" -Tag "hubba"
                            $returnValue.$returnKey = $address
                        }
                        default {
                            Write-PSFMessage "`$ReturnType $ReturnType unknown"
                        }
                    }
                }

            }
            catch {
                Write-PSFMessage "Zone does not exist for $($queryData|Select-Object name,vdom| ConvertTo-Json -WarningAction SilentlyContinue -Compress)"
            }
        }
    }
    # Write-PSFMessage "`$returnValue=$($returnValue| ConvertTo-Json -WarningAction SilentlyContinue)"        # $localizedInterfaceHashMap | json
    return $returnValue
}