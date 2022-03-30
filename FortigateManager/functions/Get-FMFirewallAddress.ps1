function Get-FMFirewallAddress {
    <#
    .SYNOPSIS
    Get list of all "address"

    .DESCRIPTION
    Get list of all "address" (ipmask, iprange, fqdn...)

    .PARAMETER Connection
        Parameter description

    .EXAMPLE
    Get-FMFirewallAddress

    Get list of all address object

    .EXAMPLE
    Get-FMFirewallAddress -name myFMGAddress

    Get address named myFMGAddress

    .EXAMPLE
    Get-FMFirewallAddress -name FMG -filter_type like

    Get address like with %FMG%

    .EXAMPLE
    Get-FMFirewallAddress -uuid 9e73a10e-1772-51ea-a8d7-297686fd7702

    Get address with uuid 9e73a10e-1772-51ea-a8d7-297686fd7702

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory)]
        $Connection,
        [Parameter (Mandatory = $false, Position = 1, ParameterSetName = "name")]
        [string]$name,
        [Parameter (Mandatory = $false, ParameterSetName = "uuid")]
        [string]$uuid,
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "filter")]
        [string]$filter_attribute,
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "name")]
        [Parameter (ParameterSetName = "uuid")]
        [Parameter (ParameterSetName = "filter")]
        [ValidateSet('equal', 'contains', 'like')]
        [string]$filter_type = "equal",
        [Parameter (Mandatory = $false)]
        [Parameter (ParameterSetName = "filter")]
        [psobject]$filter_value
    )
    begin {
        $invokeParams = @{ }

        switch ( $PSCmdlet.ParameterSetName ) {
            "name" {
                $filter_value = $name
                $filter_attribute = "name"
            }
            "uuid" {
                $filter_value = $uuid
                $filter_attribute = "uuid"
            }
            default { }
        }

        #if filter value and filter_attribute, add filter (by default filter_type is equal)
        if ( $filter_value -and $filter_attribute ) {
            $invokeParams.add( 'filter_value', $filter_value )
            $invokeParams.add( 'filter_attribute', $filter_attribute )
            $invokeParams.add( 'filter_type', $filter_type )
        }

    }

    process {
    }

    end {
        $apiCallParameter = @{
            Connection = $Connection
            method     = "get"
            Path       = "sys/status"
        }

        Invoke-FMAPI @apiCallParameter

    }
}