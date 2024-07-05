function Get-FMDeviceStaticRoute {
    <#
    .SYNOPSIS
        Retrieves static routes from the Fortigate Manager.

    .DESCRIPTION
        This function connects to the Fortigate Manager API and retrieves the list of static routes.
        It requires the VDOM (Virtual Domain) and DeviceName.

    .PARAMETER Connection
        The connection object to the Fortigate Manager. If not provided, the last connection will be used.

    .PARAMETER EnableException
        A boolean value indicating whether to enable exceptions. Default is $true.

    .PARAMETER VDOM
        The Virtual Domain from which to retrieve the static routes.

    .PARAMETER DeviceName
        The name of the device from which to retrieve the static routes.

    .EXAMPLE
        Get-FMDeviceStaticRoute -VDOM "vdom1" -DeviceName "device1"

        This example retrieves all static routes from the "device1" in the "vdom1" VDOM.

    .NOTES
        This function uses the Fortigate Manager API to retrieve static routes.
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
    $Parameter = @{
        'filter'   = ($Filter | ConvertTo-FMFilterArray)
    } | Remove-FMNullValuesFromHashtable
    $apiCallParameter = @{
        EnableException     = $EnableException
        Connection          = $Connection
        LoggingAction       = "Get-FMDeviceStaticRoute"
        LoggingActionValues = @($DeviceName, $VDOM)
        method              = "get"
        Parameter           = $Parameter
        Path                = "/pm/config/device/$DeviceName/vdom/$VDOM/router/static"
    }

    $result = Invoke-FMAPI @apiCallParameter
    Write-PSFMessage "Result-Status: $($result.result.status)"
    return $result.result.data
}
