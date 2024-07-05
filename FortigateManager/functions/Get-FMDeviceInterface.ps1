function Get-FMDeviceInterface {
    <#
    .SYNOPSIS
        Retrieves device interfaces from the Fortigate Manager.

    .DESCRIPTION
        This function connects to the Fortigate Manager API and retrieves the list of device interfaces.
        It requires the the VDOM (Virtual Domain) and DeviceName.

    .PARAMETER Connection
        The connection object to the Fortigate Manager. If not provided, the last connection will be used.

    .PARAMETER EnableException
        A boolean value indicating whether to enable exceptions. Default is $true.

    .PARAMETER VDOM
        The Virtual Domain from which to retrieve the device interfaces.

    .PARAMETER DeviceName
        The name of the device(s) from which to retrieve the interfaces.

    .EXAMPLE
        Get-FMDeviceInterface-DeviceName "device1" -VDOM "vdom1"

        This example retrieves all interfaces from the "device1" in the "vdom1" VDOM.

    .NOTES

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
        LoggingAction       = "Get-FMDeviceInterface"
        LoggingActionValues = @($DeviceName, $VDOM)
        method              = "get"
        Parameter           = $Parameter
        Path                = "/pm/config/device/$DeviceName/vdom/$VDOM/system/interface"
    }

    $result = Invoke-FMAPI @apiCallParameter
    Write-PSFMessage "Result-Status: $($result.result.status)"
    return $result.result.data
}
