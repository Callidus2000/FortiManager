function Convert-FMSubnetMask {
    <#
    .SYNOPSIS
    Converts a subnet mask between long and short-version

    .DESCRIPTION
    Long description

    .PARAMETER Target
    What is the desired return format?
    CIDR:   single digit, 1-32
    Octet:  xxx.xxx.xxx.xxx
    Auto:   Convert depending on the current format, CIDR->Octect and revers

    .PARAMETER SubnetMask
    The current subnet mask which should be converted

    .PARAMETER IPMask
    The current ip/subnetmask which should be converted

    .PARAMETER EnableException
	Should Exceptions been thrown? If the SubnetMask can't be converted and set
    to $true an exception will be thrown, otherwise the function returns $null

    .EXAMPLE
    Convert-FMSubnetMask -SubnetMask 255.255.255.255

    Returns 32

    .EXAMPLE
    Convert-FMSubnetMask -SubnetMask 24

    Returns 255.255.255.0
    .EXAMPLE
    Convert-FMSubnetMask -IPMask "192.16.0.0/255.255.255.0"

    Returns 192.16.0.0/24

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param (
        # [parameter(mandatory = $true, ParameterSetName = "cidr")]
        # [string]$Cidr,
        [parameter(mandatory = $true, ParameterSetName = "subnet")]
        [string]$SubnetMask,
        [parameter(mandatory = $true, ParameterSetName = "ipMask")]
        [string]$IPMask,
        [ValidateSet("Auto", "CIDR", "Octet")]
        [string]$Target="Auto",
        [bool]$EnableException = $true
    )

    begin {
        $conversionTable = @{
            "255.128.0.0"     = "9"
            "255.255.224.0"   = "19"
            "255.255.255.240" = "28"
            "12"              = "255.240.0.0"
            "27"              = "255.255.255.224"
            "4"               = "240.0.0.0"
            "32"              = "255.255.255.255"
            "6"               = "252.0.0.0"
            "2"               = "192.0.0.0"
            "20"              = "255.255.240.0"
            "29"              = "255.255.255.248"
            "8"               = "255.0.0.0"
            "23"              = "255.255.254.0"
            "255.248.0.0"     = "13"
            "3"               = "224.0.0.0"
            "255.255.248.0"   = "21"
            "255.255.240.0"   = "20"
            "16"              = "255.255.0.0"
            "18"              = "255.255.192.0"
            "255.255.192.0"   = "18"
            "128.0.0.0"       = "1"
            "22"              = "255.255.252.0"
            "255.255.255.128" = "25"
            "255.192.0.0"     = "10"
            "255.252.0.0"     = "14"
            "255.224.0.0"     = "11"
            "255.254.0.0"     = "15"
            "19"              = "255.255.224.0"
            "255.240.0.0"     = "12"
            "14"              = "255.252.0.0"
            "192.0.0.0"       = "2"
            "7"               = "254.0.0.0"
            "31"              = "255.255.255.254"
            "28"              = "255.255.255.240"
            "21"              = "255.255.248.0"
            "10"              = "255.192.0.0"
            "254.0.0.0"       = "7"
            "240.0.0.0"       = "4"
            "11"              = "255.224.0.0"
            "255.255.255.252" = "30"
            "1"               = "128.0.0.0"
            "255.255.128.0"   = "17"
            "255.0.0.0"       = "8"
            "17"              = "255.255.128.0"
            "26"              = "255.255.255.192"
            "30"              = "255.255.255.252"
            "248.0.0.0"       = "5"
            "5"               = "248.0.0.0"
            "255.255.255.248" = "29"
            "15"              = "255.254.0.0"
            "255.255.252.0"   = "22"
            "255.255.255.254" = "31"
            "9"               = "255.128.0.0"
            "255.255.255.192" = "26"
            "252.0.0.0"       = "6"
            "25"              = "255.255.255.128"
            "13"              = "255.248.0.0"
            "24"              = "255.255.255.0"
            "255.255.255.255" = "32"
            "224.0.0.0"       = "3"
            "255.255.255.0"   = "24"
            "255.255.255.224" = "27"
            "255.255.0.0"     = "16"
            "255.255.254.0"   = "23"
        }
    }

    end {
        if($IPMask){
            Write-PSFMessage "Splitting ipMask into ip and subnet: $IPMask"
            $pair=$IPMask -split '/'
            $ip = $pair[0]
            $SubnetMask = $pair[1]
            Write-PSFMessage "Splitting ipMask into ip ($($pair[0]))and subnet $($pair[1]): $IPMask"
        }
        if($SubnetMask.length -gt 2){
            $currentFormat= "Octet"
        }else{
            $currentFormat= "CIDR"
        }
        Write-PSFMessage "Converting $currentFormat>$Target"
        if($currentFormat -eq $Target){
            Write-PSFMessage "No Conversion of $SubnetMask needed"
            $result="$SubnetMask"
        }else{
            $result = $conversionTable."$SubnetMask"
        }
        if($null -eq $result -and $EnableException){
            throw "Could not convert subnet mask $SubnetMask"
        }
        Write-PSFMessage "`$result=$result"

        if($IPMask){
            return "$ip/$result"
        }
        return $result
    }
}
