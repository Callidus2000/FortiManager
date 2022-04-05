function Update-FMAddress {
    <#
    .SYNOPSIS
    Updates an existing addresses.

    .DESCRIPTION
    Updates an existing addresses.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER Name
    The name of the address to be changed (neccessary if the 'name' property itself changes)

    .PARAMETER Address
    The new address, generated e.g. by using New-FMObjAddress or Get-FMAddress

    .PARAMETER Overwrite
    If used and an address with the given name already exists the data will be overwritten.

    .EXAMPLE
    $testAddress=Get-FMAddress -filter "name -eq MyDUMMY" -verbose
    $testAddress.comment="Modified at $(Get-Date)"
    $testAddress | Update-fmaddress

    Sets the comment field (must exist or you need to have e.g. Add-Member.)

    .EXAMPLE
    $testAddress=Get-FMAddress -filter "name -eq MyDUMMY" -verbose
    $testAddress.name="MyDUMMY 2"
    Update-fmaddress -Address $testAddress -Name "MyDUMMY"

    Renames the address

    .NOTES
    General notes
    #>
    param (
        [parameter(Mandatory=$false)]
        $Connection = (Get-FMLastConnection),
        [string]$ADOM,
        [parameter(mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "default")]
        [object[]]$Address,
        [string]$Name,
        [switch]$Overwrite,
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
        if ($addressList.count -gt 1 -and $Name){
            Stop-PSFFunction -AlwaysWarning -EnableException $EnableException -Message "Usage of -Name and more than one -Address is not permitted"
            return
        }
        $apiCallParameter = @{
            EnableException     = $EnableException
            Connection          = $Connection
            LoggingAction       = "Update-FMAddress"
            LoggingActionValues = @($addressList.count, $explicitADOM,$Name)
            method              = "update"
            Path                = "/pm/config/adom/$explicitADOM/obj/firewall/address"
            Parameter           = @{
                "data" = $addressList
            }
        }
        if ($Name){
            $apiCallParameter.Path = "/pm/config/adom/$explicitADOM/obj/firewall/address/$($Name|ConvertTo-FMUrlPart)"
            # if name is given 'data' does only accept one object but no array
            $apiCallParameter.Parameter.data=$addressList[0]
        }
        $result = Invoke-FMAPI @apiCallParameter
        if (-not $EnableException) {
            return ($null -ne $result)
        }
    }
}