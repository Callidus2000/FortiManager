function ConvertTo-CamelCase {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [string]$Text
    )
    return [regex]::Replace($Text.Trim('_').Trim(' '), '(?i)(?:^|-| )(\p{L})', { $args[0].Groups[1].Value.ToUpper() })
}