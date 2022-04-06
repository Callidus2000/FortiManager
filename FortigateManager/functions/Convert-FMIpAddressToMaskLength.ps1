function Convert-FMIpAddressToMaskLength{
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