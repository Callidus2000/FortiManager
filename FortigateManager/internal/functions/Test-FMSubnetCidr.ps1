function Test-FMSubnetCidr {
    <#
    .SYNOPSIS
    Helper for verifying that a subnet contains a netmask.

    .DESCRIPTION
    Helper for verifying that a subnet contains a netmask.

    .PARAMETER Subnet
    The Subnet

    .EXAMPLE
    An example

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param (
        [string]$Subnet
    )
    $Subnet = $Subnet.Trim()
    if ($Subnet -match '^\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b$') {
        Write-PSFMessage "Subnet $Subnet is missing the subnet mask"
        $cidr = ""
        switch -regex ($Subnet) {
            '^\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b$' { $cidr = "/32" }
            '^\b\d{1,3}\.\d{1,3}\.\d{1,3}\.0$' { $cidr = "/24" }
            default {
                Write-PSFMessage "Cannot guess cidr for Subnet $Subnet"
            }
        }
        $Subnet += $cidr
        Write-PSFMessage "New Subnet: $Subnet"
    }
    return $Subnet
}