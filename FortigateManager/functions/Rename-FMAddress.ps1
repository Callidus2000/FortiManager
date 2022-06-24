function Rename-FMAddress {
    <#
    .SYNOPSIS
    Renames an existing addresses.

    .DESCRIPTION
    Renames an existing addresses.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER Name
    The name of the address to be changed

    .PARAMETER NewName
    The new name of the address

    .PARAMETER Mapping
    A mapping table between old (=Key) and new (=Value) name.

    .PARAMETER EnableException
    If set to true, inner exceptions will be rethrown. Otherwise the an empty result will be returned.

    .EXAMPLE
    Rename-FMAddress -Name "MyDUMMY" -NewName "MyDummy 2"

    Performs the renaming.

    .EXAMPLE
    $renameMatrix = @{
                    "PESTER Tick $pesterGUID"  = "PESTER Huey $pesterGUID"
                    "PESTER Trick $pesterGUID" = "PESTER Dewey $pesterGUID"
                    "PESTER Track $pesterGUID" = "PESTER Louie $pesterGUID"
                }
    Rename-FMAddress -Mapping $renameMatrix

    Performs the renaming of all three addresses.

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
        [bool]$EnableException = $true
    )
    $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM

    if ($PSCmdlet.ParameterSetName -eq 'single') {
        $Mapping = @{$name = $NewName }
    }
    $apiCallParameter = @{
        EnableException     = $EnableException
        Connection          = $Connection
        LoggingAction       = "Rename-FMAddress"
        LoggingActionValues = @($Mapping.count, $explicitADOM)
        method              = "update"
        Parameter           = @()
    }
    foreach ($oldName in $Mapping.Keys) {
        $apiCallParameter.Parameter += @{
            url  = "/pm/config/adom/$explicitADOM/obj/firewall/address/$($oldName|ConvertTo-FMUrlPart)"
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