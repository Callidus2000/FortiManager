function Update-FMAddressGroupMember {
    <#
    .SYNOPSIS
    Updates the members of an existing address group.

    .DESCRIPTION
    Updates the members of an existing address group.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER Name
    The name of the address group(s) to be changed.

    .PARAMETER Member
    The members to be removed or added.

    .PARAMETER NoneMember
    If after a removal no member is left the address with this name
    (default="none") will be added to the empty member list

    .PARAMETER Action
    remove or add.

  	.PARAMETER EnableException
	Should Exceptions been thrown?

    .EXAMPLE
    Update-FMAddressGroupMember -Action add -Name "PESTER Single $pesterGUID" -Member "PESTER 3 $pesterGUID"

    adds the address "PESTER 3 $pesterGUID" to the addressgroup "PESTER Single $pesterGUID"

    .EXAMPLE
    Update-FMAddressGroupMember -Action add -Name @("PESTER Single 1","PESTER Single 2") -Member "PESTER 4"

    adds the address "PESTER 4" to the addressgroups "PESTER Single 1","PESTER Single 2"

    .EXAMPLE
     $actionMap = @(
        @{
            addrGrpName = "PESTER Twin1 $pesterGUID"
            addrName    = "PESTER 6 $pesterGUID"
            action      = "add"
        },
        @{
            addrGrpName = "PESTER Twin1 $pesterGUID"
            addrName    = "PESTER 1 $pesterGUID"
            action      = "remove"
        },
        @{
            addrGrpName = "PESTER Twin2 $pesterGUID"
            addrName    = "PESTER 7 $pesterGUID"
            action      = "add"
        },
        @{
            addrGrpName = "PESTER Twin2 $pesterGUID"
            addrName    = "PESTER 2 $pesterGUID"
            action      = "remove"
        }
    )
    Update-FMAddressGroupMember -ActionMap $actionMap

    Performs multiple additions/removals in one API call
    .NOTES
    General notes
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param (
        [parameter(Mandatory = $false)]
        $Connection = (Get-FMLastConnection),
        [string]$ADOM,
        [parameter(mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = "default")]
        [string[]]$Name,
        [parameter(mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = "default")]
        [string[]]$Member,
        [parameter(mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = "default")]
        [ValidateSet("remove", "add")]
        [string]$Action,
        [parameter(mandatory = $true, ParameterSetName = "table")]
        [object[]]$ActionMap,
        [string]$NoneMember = "none",
        [bool]$EnableException = $true
    )
    begin {
        $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM
        Write-PSFMessage "`$explicitADOM=$explicitADOM"
        $internalActionMap = @()
        $modifiedAddrGroups = @()
    }
    process {
        if ($PSCmdlet.ParameterSetName -eq 'default') {
            foreach ($group in $Name) {
                foreach ($memberName in $Member) {
                    $internalActionMap += @{
                        addrGrpName = $group
                        addrName    = $memberName
                        action      = $Action
                    }
                }
            }
        }
    }
    end {
        Write-PSFMessage "`$ActionMap=$($ActionMap|ConvertTo-Json -Depth 4)"
        Write-PSFMessage "`$internalActionMap=$($internalActionMap|ConvertTo-Json -Depth 4)"
        if ($ActionMap) {
            Write-PSFMessage "Using ActionMap from parameter"
            $groupedActions = $ActionMap | Group-Object -Property "addrGrpName"
        }
        else {
            $groupedActions = $internalActionMap | Group-Object -Property "addrGrpName"
            Write-PSFMessage "Using internalActionMap from manual mapping"
        }
        # Write-PSFMessage "`$groupedActions=$($groupedActions|ConvertTo-Json -Depth 4)"
        foreach ($actionGroup in $groupedActions) {
            # Write-PSFMessage "`$actionGroup=$($actionGroup|ConvertTo-Json -Depth 4)"
            Write-PSFMessage "Modify AddressGroup $($actionGroup.name)"
            $group = Get-FMAddressGroup -ADOM $explicitADOM -Filter "name -eq $($actionGroup.name)" -Option 'scope member' -Fields name, member
            # Write-PSFMessage "`$group= $($group.member.gettype())"
            $members = [System.Collections.ArrayList]($group.member)
            foreach ($memberAction in $actionGroup.Group) {
                # Write-PSFMessage "`$memberAction=$($memberAction|ConvertTo-Json -Depth 4)"
                Write-PSFMessage "$($memberAction.action) $($memberAction.addrName)"
                if ($memberAction.action -eq 'add') {
                    $members.Add($memberAction.addrName)
                }
                else {
                    $members.Remove($memberAction.addrName)
                }
            }
            $oldMembers = $group.member
            if ($members.Count -eq 0){
                Write-PSFMessage "Add member $NoneMember to empty member collection"
                $members.Add($NoneMember)
            }elseif($members.Contains($NoneMember)){
                Write-PSFMessage "Remove member $NoneMember from now not empty member collection"
                $members.Remove($NoneMember)
            }
            $group.member = $members.ToArray()
            Write-PSFMessage "OldMembers= $($oldMembers -join ',')"
            Write-PSFMessage "NewMembers= $($group.member -join ',')"
            $modifiedAddrGroups += $group
        }
        $modifiedAddrGroups | Update-FMAddressGroup -ADOM $explicitADOM
    }
}