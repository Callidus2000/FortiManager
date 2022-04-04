function Add-FMAddress {
    <#
    .SYNOPSIS
    Adds new addresses to the given ADOM.

    .DESCRIPTION
    Adds new addresses to the given ADOM.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER Address
    The new address, generated e.g. by using New-FMObjAddress

    .EXAMPLE
    # Read some input in the format [IP]/[Subnet-Mask]
    $missingAddresses=Get-Content "PATH TO SOME FILE"
    # prepare a temporary Array
    $newFMAddresses=@()
    # Fill the array with the needed structure
    foreach ($newAddress in $missingAddresses) {
        $newFMAddresses += New-FMObjAddress -Name "$newAddress" -Type ipmask -Subnet "$newAddress"  -Comment "Created for testing purposes"
    }
    # Lock + Add + Commit + Unlock
    Lock-FMAdom -Connection $connection
    $newFMAddresses | Add-FMaddress -connection $connection
    Publish-FMAdomChange -Connection $connection
    UnLock-FMAdom -Connection $connection

    Read som subet information and add the subnets to the fortigate manager
    .NOTES
    General notes
    #>
    param (
        [parameter(Mandatory)]
        $Connection,
        [string]$ADOM,
        [parameter(mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "default")]
        [object[]]$Address,
        [bool]$EnableException = $true
    )
    begin {
        $addressList = @()
        $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM
        Write-PSFMessage "`$explicitADOM=$explicitADOM"
    }
    process {
        $Address | ForEach-Object { $addressList += $_ }
    }
    end {
        $apiCallParameter = @{
            EnableException     = $EnableException
            Connection          = $Connection
            LoggingAction       = "Add-FMAddress"
            LoggingActionValues = @($addressList.count, $explicitADOM)
            method              = "add"
            Path                = "/pm/config/adom/$explicitADOM/obj/firewall/address"
            Parameter           = @{
                "data" = $addressList
            }
        }

        $result = Invoke-FMAPI @apiCallParameter
        if (-not $EnableException) {
            return ($null -ne $result)
        }
    }
}