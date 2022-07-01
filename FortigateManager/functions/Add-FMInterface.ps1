function Add-FMInterface {
    <#
    .SYNOPSIS
    Adds new interfaces to the given ADOM.

    .DESCRIPTION
    Adds new interfaces to the given ADOM.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER Interface
    The new interface, generated e.g. by using New-FMObjInterface

    .PARAMETER Overwrite
    If used and an Interface with the given name already exists the data will be
    overwritten. Attention! If used and the new Interface lacks attributes which
    are already present in the table, this will result in a delta update.

  	.PARAMETER EnableException
	Should Exceptions been thrown?

    .EXAMPLE
    To be written

    sometime
    .NOTES
    General notes
    #>
    param (
        [parameter(Mandatory=$false)]
        $Connection = (Get-FMLastConnection),
        [string]$ADOM,
        [parameter(mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "default")]
        [object[]]$Interface,
        [switch]$Overwrite,
        [bool]$EnableException = $true
    )
    begin {
        $InterfaceList = @()
        $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM
        Write-PSFMessage "`$explicitADOM=$explicitADOM"
        $validAttributes = Get-PSFConfigValue -FullName 'FortigateManager.ValidAttr.FirewallInterface'
    }
    process {
        $Interface | ForEach-Object { $InterfaceList += $_ | ConvertTo-PSFHashtable -Include $validAttributes }
    }
    end {
        $apiCallParameter = @{
            EnableException     = $EnableException
            Connection          = $Connection
            LoggingAction       = "Add-FMInterface"
            LoggingActionValues = @($InterfaceList.count, $explicitADOM)
            method              = "add"
            Path                = "/pm/config/adom/$explicitADOM/obj/dynamic/interface"
            Parameter           = @{
                "data" = $InterfaceList
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