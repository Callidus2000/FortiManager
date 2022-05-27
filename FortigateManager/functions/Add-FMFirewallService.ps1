function Add-FMFirewallService {
    <#
    .SYNOPSIS
    Adds new firewall services to the given ADOM.

    .DESCRIPTION
    Adds new firewall services to the given ADOM.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER Service
    The new service, generated e.g. by using New-FMObjFirewallService

    .PARAMETER Overwrite
    If used and an address with the given name already exists the data will be overwritten.

  	.PARAMETER EnableException
	Should Exceptions been thrown?

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
        [parameter(Mandatory=$false)]
        $Connection = (Get-FMLastConnection),
        [string]$ADOM,
        [parameter(mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "default")]
        [object[]]$Service,
        [switch]$Overwrite,
        [bool]$EnableException = $true
    )
    begin {
        $serviceList = @()
        $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM
        Write-PSFMessage "`$explicitADOM=$explicitADOM"
        $validAttributes = Get-PSFConfigValue -FullName 'FortigateManager.ValidAttr.FirewallService'
    }
    process {
        $Service | ForEach-Object { $serviceList += $_ | ConvertTo-PSFHashtable -Include $validAttributes }
    }
    end {
        $apiCallParameter = @{
            EnableException     = $EnableException
            Connection          = $Connection
            LoggingAction       = "Add-FMFirewallService"
            LoggingActionValues = @($serviceList.count, $explicitADOM)
            method              = "add"
            Path                = "/pm/config/adom/$explicitADOM/obj/firewall/service/custom"
            Parameter           = @{
                "data" = $serviceList
            }
        }
        if ($Overwrite){
            Write-PSFMessage "Existing data should be overwritten"
            $apiCallParameter.method="set"
        }
        $result = Invoke-FMAPI @apiCallParameter
        if (-not $EnableException) {
            return ($null -ne $result)
        }
    }
}