function Update-FMAddressGroup {
    <#
    .SYNOPSIS
    Updates an existing address group.

    .DESCRIPTION
    Updates an existing address group.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER Name
    The name of the address group to be changed (neccessary if the 'name' property itself changes)

    .PARAMETER AddressGroup
    The new address group, generated e.g. by using New-FMObjAddress or Get-FMAddress

    .PARAMETER RevisionNote
    The change note which should be saved for this revision, see about_RevisionNote

  	.PARAMETER EnableException
	Should Exceptions been thrown?

    .EXAMPLE
    $testGroup = Get-FMAddressGroup -Connection $Connection -Filter "name -eq Dummy-Group"| ConvertTo-PSFHashtable
    $testGroup.comment = "Modified at $(Get-Date)"
    $testGroup | Update-fmaddressgroup -verbose

    Sets the comment field (must exist or you need to have e.g. Add-Member.)

    .NOTES
    General notes
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param (
        [parameter(Mandatory = $false)]
        $Connection = (Get-FMLastConnection),
        [string]$ADOM,
        [parameter(mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "default")]
        [object[]]$AddressGroup,
        [string]$Name,
        [string]$RevisionNote,
        [bool]$EnableException = $true
    )
    begin {
        $groupList = @()
        $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM
        Write-PSFMessage "`$explicitADOM=$explicitADOM"
        $validAttributes = Get-PSFConfigValue -FullName 'FortigateManager.ValidAttr.FirewallAddressGroups'
        $validAttributesDynaMapping = Get-PSFConfigValue -FullName 'FortigateManager.ValidAttr.FirewallAddressGroups.dynamicMapping'
    }
    process {
        $AddressGroup | ForEach-Object {
            $currentHash = $_ | ConvertTo-PSFHashtable -Include $validAttributes
            if ($currentHash.ContainsKey('dynamic_mapping')) {
                Write-PSFMessage "Modify/clean dynamic_mapping attribute"
                $currentHash.dynamic_mapping = $currentHash.dynamic_mapping | ConvertTo-PSFHashtable -Include $validAttributesDynaMapping
            }
            $groupList += $currentHash
        }
    }
    end {
        if ($groupList.count -gt 1 -and $Name) {
            Stop-PSFFunction -AlwaysWarning -EnableException $EnableException -Message "Usage of -Name and more than one -AddressGroup is not permitted"
            return
        }
        $apiCallParameter = @{
            EnableException     = $EnableException
            RevisionNote        = $RevisionNote
            Connection          = $Connection
            LoggingAction       = "Update-FMAddressGroup"
            LoggingActionValues = @($groupList.count, $explicitADOM, $Name)
            method              = "update"
            Path                = "/pm/config/adom/$explicitADOM/obj/firewall/addrgrp"
            Parameter           = @{
                "data" = $groupList
            }
        }
        if ($Name) {
            $apiCallParameter.Path = "/pm/config/adom/$explicitADOM/obj/firewall/addrgrp/$($Name|ConvertTo-FMUrlPart)"
            # if name is given 'data' does only accept one object but no array
            $apiCallParameter.Parameter.data = $groupList[0]
        }
        $result = Invoke-FMAPI @apiCallParameter
        if (-not $EnableException) {
            return ($null -ne $result)
        }
    }
}