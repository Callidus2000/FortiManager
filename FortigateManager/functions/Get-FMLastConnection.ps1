function Get-FMLastConnection {
    <#
    .SYNOPSIS
    Gets the last connection as default for other function parameters

    .DESCRIPTION
    Long description

    .PARAMETER EnableException
    Should Exceptions been thrown?

    .EXAMPLE
    An example

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param (
		[bool]$EnableException = $true
    )
    $connection = Get-PSFConfigValue -FullName 'FortigateManager.LastConnection'
    if ($null -eq $connection -and $EnableException){
        throw "No last connection available"
    }
    return $connection
}