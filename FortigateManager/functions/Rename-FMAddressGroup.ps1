function Rename-FMAddressGroup {
    <#
    .SYNOPSIS
    Renames an existing address group.

    .DESCRIPTION
    Renames an existing address group.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER Name
    The name of the address group to be changed

    .PARAMETER NewName
    The new name of the address group

    .PARAMETER Mapping
    A mapping table between old (=Key) and new (=Value) name.

    .PARAMETER RevisionNote
    The change note which should be saved for this revision, see about_RevisionNote

    .PARAMETER EnableException
    If set to true, inner exceptions will be rethrown. Otherwise the an empty result will be returned.

    .EXAMPLE
    Rename-FMAddressGroup -Name "MyDUMMY" -NewName "MyDummy 2"

    Performs the renaming.

    .EXAMPLE
    $renameMatrix = @{
                    "PESTER Tick $pesterGUID"  = "PESTER Huey $pesterGUID"
                    "PESTER Trick $pesterGUID" = "PESTER Dewey $pesterGUID"
                    "PESTER Track $pesterGUID" = "PESTER Louie $pesterGUID"
                }
    Rename-FMAddressGroup -Mapping $renameMatrix

    Performs the renaming of all three addresses. See notes for restrictions.

    .NOTES
    If you want to rename multiple groups in one call, take a look at the
    membership of the groups. If e.g.
    Group A contains Group B
    you cannot rename both in one call. Or at least be
    aware that this might happen ;-)

    #>
    param (
        [parameter(Mandatory = $false)]
        $Connection = (Get-FMLastConnection),
        [string]$ADOM,
        [parameter(mandatory = $true, ParameterSetName = "single")]
        [string]$Name,
        [parameter(mandatory = $true, ParameterSetName = "single")]
        [string]$NewName,
        [parameter(mandatory = $true, ParameterSetName = "multiple")]
        [Hashtable]$Mapping,
        [string]$RevisionNote,
        [bool]$EnableException = $true
    )
    # return Update-FMAddressGroup -Address @{name = $NewName } -Connection $Connection -ADOM $ADOM -Name $Name -EnableException $EnableException
    $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM

    if ($PSCmdlet.ParameterSetName -eq 'single') {
        $Mapping = @{$name = $NewName }
    }
    $apiCallParameter = @{
        RevisionNote        = $RevisionNote
        EnableException     = $EnableException
        Connection          = $Connection
        LoggingAction       = "Rename-FMAddressGroup"
        LoggingActionValues = @($Mapping.count, $explicitADOM)
        method              = "update"
        Parameter           = @()
    }
    foreach ($oldName in $Mapping.Keys) {
        $apiCallParameter.Parameter += @{
            url  = "/pm/config/adom/$explicitADOM/obj/firewall/addrgrp/$($oldName|ConvertTo-FMUrlPart)"
            data = @{name = $Mapping.$oldName }
        }
    }
    # Write-PSFMessage -Level Host "`$apiCallParameter=$($apiCallParameter|ConvertTo-PSFHashtable -Exclude connection | ConvertTo-Json -WarningAction SilentlyContinue -Depth 4)"
    $result = Invoke-FMAPI @apiCallParameter
    if (-not $EnableException) {
        return $result
        return ($null -ne $result)
    }
}