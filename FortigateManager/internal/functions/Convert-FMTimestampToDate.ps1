function Convert-FMTimestampToDate {
    <#
    .SYNOPSIS
    Helper function to convert Unix timestamps to DateTime.

    .DESCRIPTION
    Helper function to convert Unix timestamps to DateTime.

    .PARAMETER TimeStamp
    The timestamp to be converted

    .EXAMPLE
    Convert-FMTimestampToDate -TimeStamp 1655983275

    Returns 'Thursday, 23 June 2022 11:21:15'

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipeline=$true)]
        $TimeStamp
    )
    process{
        return (Get-Date 01.01.1970) + ([System.TimeSpan]::fromseconds($TimeStamp))
    }
}