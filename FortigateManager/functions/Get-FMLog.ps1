function Get-FMLog {
    <#
    .SYNOPSIS
    Retrieves the log entries from Write-ARAHCallMessage for a specific request id.

    .DESCRIPTION
    Retrieves the log entries from Write-ARAHCallMessage for a specific request id.

    .PARAMETER Id
    The Id of the API request. This is logged in every Request prefixed with #

    .EXAMPLE
    # If the following is displayed/logged:
    # Execution Confirmed: #63:
    Get-FMLog -Id 63

    Retrieves the detailed Logging for the specific request as a JSON string.

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '')]
    param (
        [parameter(mandatory = $true, Position = 1)]
        [int]$Id
    )
    return Get-PSFMessage -Tag "APICALL" | Select-Object -ExpandProperty 'Message' | Where-Object { $_ -match "`"id`": $Id" }
}