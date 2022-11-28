function Convert-FMZone2VLAN {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER LoggingLevel
    On which level should die diagnostic Messages be logged?

    .PARAMETER EnableException
    If set to True, errors will throw an exception

    .EXAMPLE
    An example

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $false)]
        $Connection = (Get-FMLastConnection),
        [string]$ADOM,
        [parameter(Mandatory = $true)]
        [string[]]$Zone,
        [ValidateSet('simpleIpList', 'ZoneVLANHash', 'ZoneVDOMVLANHash')]
        $ReturnType = 'simpleIpList',
        [string]$LoggingLevel,
        $Scope,
        [bool]$EnableException = $true
    )
    Write-PSFMessage "Determine VLANs from Zones: $($Zone -join ',')"
    Write-PSFMessage "Query all VDOMs and corresponding VLANs"
    if ($null -eq $Scope) {
        Write-PSFMessage "Scope is ALL devices and vdoms"
        $Scope = Get-FMDeviceInfo -Connection $connection -Option 'object member' | Select-Object -ExpandProperty "object member" | Where-Object { $_.vdom } | ConvertTo-PSFHashtable -Include name, vdom
    }
    $targetScopeStrings = $Scope | ForEach-Object { "$($_.name)|$($_.vdom)" }
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
        Write-PSFMessage "Query Device $($device|ConvertTo-Json -Compress)"
        $apiCallParameter = @{
            EnableException     = $true
            LoggingAction       = "Undocumented"
            Connection          = $Connection
            LoggingActionValues = "Query all interface VLAN from a specific Device/VDOM"
            method              = "get"
            LoggingLevel        = "Verbose"
            path                = "/pm/config/device/{name}/vdom/{vdom}/system/interface" | Merge-FMStringHashMap -Data $device
        }
        $device.vlanHash = @{}

        $currentInterfaces = Invoke-FMAPI @apiCallParameter # | ConvertTo-Json -Depth 6
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
            Write-PSFMessage "`$queryData=$($queryData|json -compress), Path=$($apiCallParameter.path)"
            try {
                $result = Invoke-FMAPI @apiCallParameter
                Write-PSFMessage "Found"
                $interfaceList = $result.result.data.interface
                # Write-PSFMessage "Query: $($queryData|ConvertTo-Json -compress), Results: $($result|ConvertTo-Json -Depth 4)"
                Write-PSFMessage "interfaceList for $($queryData|ConvertTo-Json -compress): $($interfaceList -join ',')"
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
                Write-PSFMessage "Zone does not exist for $($queryData|Select-Object name,vdom|ConvertTo-Json -Compress)"
            }
        }
    }
    # Write-PSFMessage "`$returnValue=$($returnValue|ConvertTo-Json)"        # $localizedInterfaceHashMap | json
    return $returnValue
}