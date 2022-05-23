function ConvertTo-FMStartEndIp {
    <#
    .SYNOPSIS
    Helper for extracting start- and end-ip from a iprange in a string.

    .DESCRIPTION
    Helper for extracting start- and end-ip from a iprange in a string.
    Returns an array, $result[0] is the start and $result[1] the end ip

    .PARAMETER IPRange
    The ipRange

    .EXAMPLE
    ConvertTo-FMStartEndIp -IPRange "1.1.1.1-1.1.2.3"

    Returns @("1.1.1.1","1.1.2.3")

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    [OutputType([object[]])]
    param (
        [string]$IpRange
    )
    $returnArray=@(0..1)
    Write-PSFMessage "Extracting Start- and End-IP from Range $IpRange"
    $regex = "(\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b)[ -]+(\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b)"
    $rangeMatches = $IpRange | Select-String -Pattern $regex
    $returnArray[0] = $rangeMatches.Matches[0].Groups[1].Value
    $returnArray[1] = $rangeMatches.Matches[0].Groups[2].Value
    Write-PSFMessage "StartIP=$($returnArray[0])  EndIp=$($returnArray[1])"
    return $returnArray
}