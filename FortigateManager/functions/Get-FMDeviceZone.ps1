function Get-FMDeviceZone {
    <#
    .SYNOPSIS
        Retrieves device zones from the Fortigate Manager.

    .DESCRIPTION
        This function connects to the Fortigate Manager API and retrieves the list of device zones.
        It requires the VDOM (Virtual Domain) and DeviceName.

    .PARAMETER Connection
        The connection object to the Fortigate Manager. If not provided, the last connection will be used.

    .PARAMETER EnableException
        A boolean value indicating whether to enable exceptions. Default is $true.

    .PARAMETER VDOM
        The Virtual Domain from which to retrieve the device zones.

    .PARAMETER DeviceName
        The name of the device from which to retrieve the zones.

    .EXAMPLE
        Get-FMDeviceZone -VDOM "vdom1" -DeviceName "device1"

        This example retrieves all zones from the "device1" in the "vdom1" VDOM.

    .NOTES
        This function uses the Fortigate Manager API to retrieve device zones.
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $false)]
        $Connection = (Get-FMLastConnection),
        [bool]$EnableException = $true,
        [parameter(mandatory = $true, ParameterSetName = "default")]
        [String]$VDOM,
        [parameter(mandatory = $true, ParameterSetName = "default")]
        [String]$DeviceName
    )
    # TODO Device Interfaces
    # VLAN und Tunnel
    # "/pm/config/device/TKBEDC1FW001/vdom/TKBE/system/interface"
    # Static Routes
    # "/pm/config/device/TKBEDC1FW001/vdom/TKBE/router/static"
    $Parameter = @{
        'filter'   = ($Filter | ConvertTo-FMFilterArray)
    } | Remove-FMNullValuesFromHashtable
    $apiCallParameter = @{
        EnableException     = $EnableException
        Connection          = $Connection
        LoggingAction       = "Get-FMDeviceZone"
        LoggingActionValues = @($DeviceName, $VDOM)
        method              = "get"
        Parameter           = $Parameter
        Path                = "/pm/config/device/$DeviceName/vdom/$VDOM/system/zone"
    }

    $result = Invoke-FMAPI @apiCallParameter
    Write-PSFMessage "Result-Status: $($result.result.status)"
    return $result.result.data
}
