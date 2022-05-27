function Update-FMFirewallService {
    <#
    .SYNOPSIS
    Adds new firewall services to the given ADOM.

    .DESCRIPTION
    Adds new firewall services to the given ADOM.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER Name
    The name of the service to be changed (neccessary if the 'name' property itself changes)
    This is the *old* Name of the existing object! The new name has to be set in the object itself.

    .PARAMETER Service
    The new service, generated e.g. by using New-FMObjFirewallService

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
        [string]$Name,
        [bool]$EnableException = $true
    )
    begin {
        $serviceList = @()
        $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM
        Write-PSFMessage "`$explicitADOM=$explicitADOM"
        $validAttributes = Get-PSFConfigValue -FullName 'FortigateManager.ValidAttr.FirewallService'
    }
    process {
        $Service | ForEach-Object { $serviceList += $_|ConvertTo-PSFHashtable -Include $validAttributes }
    }
    end {
        if ($serviceList.count -gt 1 -and $Name) {
            Stop-PSFFunction -AlwaysWarning -EnableException $EnableException -Message "Usage of -Name and more than one -Service is not permitted"
            return
        }
        $apiCallParameter = @{
            EnableException     = $EnableException
            Connection          = $Connection
            LoggingAction       = "Update-FMFirewallService"
            LoggingActionValues = @($serviceList.count, $explicitADOM,$Name)
            method              = "update"
            Path                = "/pm/config/adom/$explicitADOM/obj/firewall/service/custom"
            Parameter           = @{
                "data" = $serviceList
            }
        }
        if ($Name) {
            $apiCallParameter.Path = "/pm/config/adom/$explicitADOM/obj/firewall/service/custom/$($Name|ConvertTo-FMUrlPart)"
            # if name is given 'data' does only accept one object but no array
            $apiCallParameter.Parameter.data = $serviceList[0]
        }
        $result = Invoke-FMAPI @apiCallParameter
        if (-not $EnableException) {
            return ($null -ne $result)
        }
    }
}