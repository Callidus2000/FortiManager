function Update-FMInterface {
    <#
    .SYNOPSIS
    Updates an existing Interfacees.

    .DESCRIPTION
    Updates an existing Interfacees.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER Name
    The name of the Interface to be changed (neccessary if the 'name' property itself changes)
    This is the *old* Name of the existing object! The new name has to be set in the object itself.

    .PARAMETER Interface
    The new Interface, generated e.g. by using New-FMObjInterface or Get-FMInterface

    .PARAMETER RevisionNote
    The change note which should be saved for this revision, see about_RevisionNote

  	.PARAMETER EnableException
	Should Exceptions been thrown?

    .EXAMPLE
    $testInterface=Get-FMInterface -filter "name -eq MyDUMMY" -verbose
    $testInterface.comment="Modified at $(Get-Date)"
    $testInterface | Update-fmInterface

    Sets the comment field (must exist or you need to have e.g. Add-Member.)

    .NOTES
    If an Interface object does not contain every attribute which is already set,
    then the existing values will be kept.
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param (
        [parameter(Mandatory = $false)]
        $Connection = (Get-FMLastConnection),
        [string]$ADOM,
        [parameter(mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "default")]
        [object[]]$Interface,
        [string]$Name,
        [string]$RevisionNote,
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
        if ($InterfaceList.count -gt 1 -and $Name) {
            Stop-PSFFunction -AlwaysWarning -EnableException $EnableException -Message "Usage of -Name and more than one -Interface is not permitted"
            return
        }
        $apiCallParameter = @{
            RevisionNote        = $RevisionNote
            EnableException     = $EnableException
            Connection          = $Connection
            LoggingAction       = "Update-FMInterface"
            LoggingActionValues = @($InterfaceList.count, $explicitADOM, $Name)
            method              = "update"
            Path                = "/pm/config/adom/$explicitADOM/obj/dynamic/interface"
            Parameter           = @{
                "data" = $InterfaceList
            }
        }
        if ($Name) {
            $apiCallParameter.Path = "/pm/config/adom/$explicitADOM/obj/firewall/Interface/$($Name|ConvertTo-FMUrlPart)"
            # if name is given 'data' does only accept one object but no array
            $apiCallParameter.Parameter.data = $InterfaceList[0]
        }
        $result = Invoke-FMAPI @apiCallParameter
        if (-not $EnableException) {
            return ($null -ne $result)
        }
    }
}