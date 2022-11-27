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
        [ValidateSet('simpleIpList')]
        $ReturnType,
        [string]$LoggingLevel,
        [bool]$EnableException = $true
    )
    Write-PSFMessage "Determine VLANs from Zones: $($Zone -join ',')"

}