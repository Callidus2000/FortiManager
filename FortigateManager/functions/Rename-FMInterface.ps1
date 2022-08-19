function Rename-FMInterface {
    <#
    .SYNOPSIS
    Renames an existing Interfacees.

    .DESCRIPTION
    Renames an existing Interfacees.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER Name
    The name of the Interface to be changed

    .PARAMETER NewName
    The new name of the Interface

    .PARAMETER Mapping
    A mapping table between old (=Key) and new (=Value) name.

    .PARAMETER RevisionNote
    The change note which should be saved for this revision, see about_RevisionNote

    .PARAMETER EnableException
    If set to true, inner exceptions will be rethrown. Otherwise the an empty result will be returned.

    .EXAMPLE
    Rename-FMInterface -Name "MyDUMMY" -NewName "MyDummy 2"

    Performs the renaming.

    .EXAMPLE
    $renameMatrix = @{
                    "PESTER Tick $pesterGUID"  = "PESTER Huey $pesterGUID"
                    "PESTER Trick $pesterGUID" = "PESTER Dewey $pesterGUID"
                    "PESTER Track $pesterGUID" = "PESTER Louie $pesterGUID"
                }
    Rename-FMInterface -Mapping $renameMatrix

    Performs the renaming of all three Interfacees.

    .NOTES
    General notes
    #>
    param (
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
    $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM

    if ($PSCmdlet.ParameterSetName -eq 'single') {
        $Mapping = @{$name = $NewName }
    }
    $apiCallParameter = @{
        RevisionNote        = $RevisionNote
        EnableException     = $EnableException
        Connection          = $Connection
        LoggingAction       = "Rename-FMInterface"
        LoggingActionValues = @($Mapping.count, $explicitADOM)
        method              = "update"
        Parameter           = @()
    }
    foreach ($oldName in $Mapping.Keys) {
        $apiCallParameter.Parameter += @{
            url  = "/pm/config/adom/$explicitADOM/obj/dynamic/interface/$($oldName|ConvertTo-FMUrlPart)"
            data = @{name = $Mapping.$oldName }
        }
    }
    # Write-PSFMessage -Level Host "`$apiCallParameter=$($apiCallParameter|ConvertTo-PSFHashtable -Exclude connection |ConvertTo-Json -Depth 4)"
    $result = Invoke-FMAPI @apiCallParameter
    if (-not $EnableException) {
        return $result
        return ($null -ne $result)
    }
}