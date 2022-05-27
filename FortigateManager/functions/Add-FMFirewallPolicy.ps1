function Add-FMFirewallPolicy {
    <#
    .SYNOPSIS
    Adds new firewall policies to the given ADOM and policy package.

    .DESCRIPTION
    Adds new firewall policies to the given ADOM and policy package. This
    function adds the policy to the End of the Package. If you need it elsewhere
    you have to use ""

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER Package
    The name of the policy package

    .PARAMETER Policy
    The new policy, generated e.g. by using New-FMObjAddress

    .PARAMETER Overwrite
    If used and an policy with the given name already exists the data will be
    overwritten.
  	.PARAMETER EnableException
	Should Exceptions been thrown?


    .EXAMPLE
    #To Be Provided

    Later
    .NOTES
    General notes
    #>
    param (
        [parameter(Mandatory = $false)]
        $Connection = (Get-FMLastConnection),
        [string]$ADOM,
        [parameter(mandatory = $true, ParameterSetName = "default")]
        [string]$Package,
        [parameter(mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "default")]
        [object[]]$Policy,
        [switch]$Overwrite,
        [bool]$EnableException = $true
    )
    begin {
        $policyList = @()
        $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM
        Write-PSFMessage "`$explicitADOM=$explicitADOM"
        $validAttributes = Get-PSFConfigValue -FullName 'FortigateManager.ValidAttr.FirewallPolicy'
    }
    process {
        $Policy | ForEach-Object {
            $policyList += $_ | ConvertTo-PSFHashtable -Include $validAttributes
        }
    }
    end {
        $apiCallParameter = @{
            EnableException     = $EnableException
            Connection          = $Connection
            LoggingAction       = "Add-FMFirewallPolicy"
            LoggingActionValues = @($policyList.count, $explicitADOM, $Package)
            method              = "add"
            Path                = "/pm/config/adom/$explicitADOM/pkg/$Package/firewall/policy"
            Parameter           = @{
                "data" = $policyList
            }
        }
        if ($Overwrite) {
            Write-PSFMessage "Existing data should be overwritten"
            $apiCallParameter.method = "set"
        }
        $result = Invoke-FMAPI @apiCallParameter
        if (-not $EnableException) {
            return ($null -ne $result)
        }
    }
}
