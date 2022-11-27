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
        [ValidateSet('simpleIpList', 'ZoneVLANHash')]
        $ReturnType = 'simpleIpList',
        [string]$LoggingLevel,
        [bool]$EnableException = $true
    )
    Write-PSFMessage "Determine VLANs from Zones: $($Zone -join ',')"
    Write-PSFMessage "Query all VDOMs and corresponding VLANs"
    $deviceVdomList = Get-FMDeviceInfo -Connection $connection -Option 'object member' | Select-Object -ExpandProperty "object member" | Where-Object { $_.vdom } | ConvertTo-PSFHashtable -Include name, vdom -Remap @{name = 'device' }
    foreach ($device in $deviceVdomList) {
        Write-PSFMessage "Query Device $($device|ConvertTo-Json -Compress)"
        $apiCallParameter = @{
            EnableException     = $true
            LoggingAction       = "Undocumented"
            Connection          = $Connection
            LoggingActionValues = "Query all interface VLAN from a specific Device/VDOM"
            method              = "get"
            LoggingLevel        = "Verbose"
            path                = "/pm/config/device/{device}/vdom/{vdom}/system/interface" | Merge-FMStringHashMap -Data $device
        }
        $device.vlanHash = @{}

        $currentInterfaces = Invoke-FMAPI @apiCallParameter # | ConvertTo-Json -Depth 6
        foreach ($interface in $currentInterfaces.result.data) {
            $name = $interface.name
            if ($interface.ip[1] -eq '0.0.0.0') {
                $address = "$($interface.ip[0])/0"
            }
            else {
                $address = Convert-FMSubnetMask -IPMask "$($interface.ip[0])/$($interface.ip[1])"
            }
            $device.vlanHash.$name = $address
            # Write-PSFMessage "Add: $($device.name), $name, $address"
            # $vlanDataPerVDOM += [PSCustomObject]@{
            #     deviceName    = $device.name
            #     interfaceName = $name
            #     addresses     = $address
            # }
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
        $queryData = @{zone = $curZone | convertto-fmurlpart }
        $apiCallParameter = @{
            EnableException     = $true
            Connection          = $Connection
            LoggingAction       = "Undocumented"
            LoggingActionValues = "Query interfaces from a specific Device/VDOM"
            method              = "get"
            LoggingLevel        = 'Verbose'
        }
        $singleDeviceVdomURL = "/pm/config/device/{{device}}/vdom/{{vdom}}/system/zone/{zone}"
        foreach ($queryData in $deviceVdomList) {
            $queryData.zone = $curZone | convertto-fmurlpart
            $apiCallParameter.path = $singleDeviceVdomURL | Merge-FMStringHashMap -Data $queryData
            try {
                $result = Invoke-FMAPI @apiCallParameter
                Write-PSFMessage "Found"
                $interfaceList = $result.result.data.interface
                # Write-PSFMessage "Query: $($queryData|ConvertTo-Json -compress), Results: $($result|ConvertTo-Json -Depth 4)"
                Write-PSFMessage "interfaceList for $($queryData|ConvertTo-Json -compress): $($interfaceList -join ',')"
                foreach ($interface in $interfaceList) {
                    $vlanIP = $queryData.vlanHash.$interface
                    switch ($ReturnType) {
                        'simpleIpList' {
                            Write-PSFMessage "Adding VLAN Info to simpleIpListList"
                            $returnValue += $vlanIP
                        }
                        'ZoneVLANHash' {
                            Write-PSFMessage "Adding Interfaces to ZoneVLANHash"
                            if ( -not $returnValue.ContainsKey($curZone)) {
                                $returnValue.$curZone = @()
                            }
                            $returnValue.$curZone = $vlanIP
                        }
                        default {
                            Write-PSFMessage "`$ReturnType $ReturnType unknown"
                        }
                    }
                }

            }
            catch {
                Write-PSFMessage "Zone does not exist for $($queryData|ConvertTo-Json -Compress)"
            }
        }
    }
    Write-PSFMessage "`$returnValue=$($returnValue|ConvertTo-Json)"
    return $returnValue
}