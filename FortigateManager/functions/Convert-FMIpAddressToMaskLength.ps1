function Convert-FMIpAddressToMaskLength{
    <#
    .SYNOPSIS
    Converts a IP Subnet-Mask to a Mask Length

    .DESCRIPTION
    Converts a IP Address to a Mask Length

    .PARAMETER dottedIpAddressString
    The input IP
  	.PARAMETER EnableException
	Should Exceptions been thrown?


    .EXAMPLE
    Convert-FMIpAddressToMaskLength -dottedIpAddressString "255.255.255.0"

    Returns 24

    .EXAMPLE
    Convert-FMIpAddressToMaskLength -dottedIpAddressString "255.255.255.255"

    Returns 32

    .NOTES
    General notes
    #>
    [OutputType([string])]
    param(
        [string] $dottedIpAddressString
        )

    $result = 0;
    try {
        # ensure we have a valid IP address
        [IPAddress] $ip = $dottedIpAddressString;
        $octets = $ip.IPAddressToString.Split('.');
        foreach ($octet in $octets) {
            while (0 -ne $octet) {
                $octet = ($octet -shl 1) -band [byte]::MaxValue
                $result++;
            }
        }
    }
    catch {
        Write-PSFMessage -Level Warning "No valid IP Mask"
    }
    return $result;
}