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

    .PARAMETER After
    If used the policy will be added after the policy with the given ID

    .PARAMETER Before
    If used the policy will be added before the policy with the given ID

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
        [parameter( ParameterSetName = "default")]
        #[parameter( ParameterSetName = "undocumentedAfter")]
        #[parameter( ParameterSetName = "undocumentedBefore")]
        $Connection = (Get-FMLastConnection),
        [parameter( ParameterSetName = "default")]
        #[parameter( ParameterSetName = "undocumentedAfter")]
        #[parameter( ParameterSetName = "undocumentedBefore")]
        [string]$ADOM,
        [parameter(mandatory = $true, ParameterSetName = "default")]
        [parameter(mandatory = $true, ParameterSetName = "undocumentedAfter")]
        [parameter( mandatory = $true, ParameterSetName = "undocumentedBefore")]
        [PSFramework.TabExpansion.PsfArgumentCompleterAttribute("FortigateManager.FirewallPackage")]
        [string]$Package,
        #[parameter( ParameterSetName = "undocumentedAfter")]
        [string]$After,
        #[parameter( ParameterSetName = "undocumentedBefore")]
        [string]$Before,
        [parameter(mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "default")]
        # [parameter(mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "undocumentedAfter")]
        # [parameter(mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "undocumentedBefore")]
        [object[]]$Policy,
        [parameter( ParameterSetName = "default")]
        #[parameter( ParameterSetName = "undocumentedAfter")]
        #[parameter( ParameterSetName = "undocumentedBefore")]
        [switch]$Overwrite,
        [parameter( ParameterSetName = "default")]
        #[parameter( ParameterSetName = "undocumentedAfter")]
        #[parameter( ParameterSetName = "undocumentedBefore")]
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
        if (-not [string]::IsNullOrEmpty($After)) {
            Write-PSFMessage "Using undocumented after parameter"
            $apiCallParameter.Parameter.after = "$after"
        }
        if (-not [string]::IsNullOrEmpty($Before)) {
            Write-PSFMessage "Using undocumented before parameter"
            $apiCallParameter.Parameter.before = "$Before"
        }
        $result = Invoke-FMAPI @apiCallParameter
        if (-not $EnableException) {
            return ($null -ne $result)
        }
    }
}
