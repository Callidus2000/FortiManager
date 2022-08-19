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

    .PARAMETER Scope
    Can be used if the members of a specific dynamic_mapping should be changed.
    Format: Array of Hashtables, @{name="MyFirewall";vdom="MyVDOM"}
    or '*' if all available scopes should be changed


    .PARAMETER ActionMap
    Array of hashtable/PSCustomObjects with the attributes
    -addrGrpName
    -addrName
    -action
    -scope
    for performing multiple changes in one API call.

    .PARAMETER RevisionNote
    The change note which should be saved for this revision, see about_RevisionNote

  	.PARAMETER EnableException
	Should Exceptions been thrown?

    .EXAMPLE
    Update-FMAddressGroupMember -Action add -Name "PESTER Single $pesterGUID" -Member "PESTER 3 $pesterGUID"

    adds the address "PESTER 3 $pesterGUID" to the addressgroup "PESTER Single $pesterGUID"

    .EXAMPLE
    Update-FMAddressGroupMember -Action add -Name @("PESTER Single 1","PESTER Single 2") -Member "PESTER 4"

    adds the address "PESTER 4" to the addressgroups "PESTER Single 1","PESTER Single 2"

    .EXAMPLE
    Update-FMAddressGroupMember -Action add -Name "MyGroup" -Member "MyAddress" -Scope @{name="MyFirewall";vdom="MyVDOM"}

    Adds the address to the addressgroup but not for the default member collection but to the dynamic_mapping with the given scope.

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
        [parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = "default")]
        [object[]]$Scope,
        [parameter(mandatory = $true, ParameterSetName = "table")]
        [object[]]$ActionMap,
        [string]$NoneMember = "none",
        [string]$RevisionNote,
        [bool]$EnableException = $true
    )
    begin {
        $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM
        Write-PSFMessage "`$explicitADOM=$explicitADOM"
        $internalActionMap = @()
        $modifiedAddrGroups = @{}
        $availableScopes = @()
    }
    process {
        if ($PSCmdlet.ParameterSetName -eq 'default') {
            Write-PSFMessage "`$Scope=$($Scope|ConvertTo-Json -Compress)"
            foreach ($group in $Name) {
                foreach ($memberName in $Member) {
                    if ($Scope) {
                        if ($Scope -eq '*') {
                            Write-PSFMessage "Scope should be all available scopes"
                            if ($availableScopes.Count -eq 0) {
                                Write-PSFMessage "Query existing scopes from device info"
                                $devInfo = Get-FMDeviceInfo -Option 'object member'
                                $availableScopes = $devInfo."object member" | Select-Object name, vdom | Where-Object { $_.vdom }
                                $Scope = $availableScopes
                            }
                        }
                        foreach ($singleScope in $Scope) {
                            $internalActionMap += @{
                                addrGrpName = $group
                                addrName    = $memberName
                                action      = $Action
                                scope       = $singleScope
                            }
                        }
                    }
                    else {
                        $internalActionMap += @{
                            addrGrpName = $group
                            addrName    = $memberName
                            action      = $Action
                        }
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
            $groupedActions = $ActionMap | Group-Object -Property addrGrpName, scope
        }
        else {
            $groupedActions = $internalActionMap | Group-Object -Property addrGrpName, scope
            Write-PSFMessage "Using internalActionMap from manual mapping"
        }
        # Write-PSFMessage "`$groupedActions=$($groupedActions|ConvertTo-Json -Depth 4)"
        foreach ($actionGroup in $groupedActions) {
            $addressGroupName = $actionGroup.Values[0]
            $dynaScope = $actionGroup.Values[1]
            # Write-PSFMessage "`$actionGroup=$($actionGroup|ConvertTo-Json -Depth 4)"
            Write-PSFMessage "Modify AddressGroup $addressGroupName"
            Write-PSFMessage "`$dynaScope=$dynaScope"
            Write-PSFMessage "`$dynaScope=null=$($null -eq $dynaScope)"

            if ($modifiedAddrGroups.ContainsKey($addressGroupName)) {
                $group = $modifiedAddrGroups.$addressGroupName
            }
            else {
                $group = Get-FMAddressGroup -Connection $Connection  -ADOM $explicitADOM -Filter "name -eq $addressGroupName" -Option 'scope member' -Fields name, member
            }
            # Write-PSFMessage "`$group= $($group.member.gettype())"
            if ($null -eq $dynaScope) {
                $members = [System.Collections.ArrayList]($group.member)
            }
            else {
                Write-PSFMessage "Verwende Scope $($dynaScope.name) VDOM $($dynaScope.vdom)"
                Write-PSFMessage "`$group= $($group |ConvertTo-Json -Depth 5)"
                $dynamapping = $group.dynamic_mapping | Where-Object { $_._scope.name -eq $dynaScope.name -and $_._scope.vdom -eq $dynaScope.vdom }
                if ($null -eq $dynamapping) {
                    Write-PSFMessage "dynamic_mapping does not exist, create it"
                    $dynamapping = New-FMObjDynamicAddressGroupMapping -Scope $dynaScope -Member "none"
                    $group.dynamic_mapping = @($dynamapping)
                    # $group | Add-Member -name dynamic_mapping -Value @($dynamapping) -MemberType NoteProperty
                }
                $members = [System.Collections.ArrayList]($dynamapping.member)
            }
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
            if ($members.Count -eq 0) {
                Write-PSFMessage "Add member $NoneMember to empty member collection"
                $members.Add($NoneMember)
            }
            elseif ($members.Contains($NoneMember)) {
                Write-PSFMessage "Remove member $NoneMember from now not empty member collection"
                $members.Remove($NoneMember)
            }
            Write-PSFMessage "OldMembers= $($oldMembers -join ',')"
            Write-PSFMessage "NewMembers= $($members -join ',')"
            if ($dynaScope) {
                Write-PSFMessage "Speichere Scope"
                $dynamapping.member = $members.ToArray()
            }
            else {
                $group.member = $members.ToArray()
            }

            $modifiedAddrGroups.$addressGroupName = $group
        }
        $modifiedAddrGroups.values | Update-FMAddressGroup -Connection $Connection -ADOM $explicitADOM -EnableException $EnableException -RevisionNote $RevisionNote
    }
}