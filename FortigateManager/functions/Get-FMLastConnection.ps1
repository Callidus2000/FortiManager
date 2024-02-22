function Get-FMLastConnection {
    <#
    .SYNOPSIS
    Gets the last connection as default for other function parameters

    .DESCRIPTION
    Long description
    .PARAMETER Type
    To which type of endpoint server should the connection be established?
    Manager -  FortiManager
    Analyzer - Forti Analyzer
    Connections of type 'manager' (default) are used for [Verb]-FM[Noun] commands,
    type 'Analyzer' is needed for the [Verb]-FMA[Noun] commands

    .PARAMETER EnableException
    Should Exceptions been thrown?

    .EXAMPLE
    An example

    may be provided later

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param (
    [ValidateSet("Manager", "Analyzer")]
    [string]$Type = "Manager",
    [bool]$EnableException = $true
    )
    $connection = Get-PSFConfigValue -FullName "FortigateManager.LastConnection.$Type"
    if ($null -eq $connection -and $EnableException){
        throw "No last connection available"
    }
    return $connection
}