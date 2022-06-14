function ConvertTo-CamelCase {
    <#
    .SYNOPSIS
    Converts attribute names into CamelCase parameter names.

    .DESCRIPTION
    Converts attribute names into CamelCase parameter names.

    .PARAMETER Text
    The text to be converted.

    .EXAMPLE
    ConvertTo-CamelCase -Text "first_hit"

    Returns FirstHit

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory = $true,Position = 0)]
        [string]$Text
    )
    return [regex]::Replace($Text.Trim('_').Trim(' '), '(?i)(?:^|-| )(\p{L})', { $args[0].Groups[1].Value.ToUpper() })
}