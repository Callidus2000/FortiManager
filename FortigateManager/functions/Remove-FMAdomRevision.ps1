function Remove-FMAdomRevision {
    <#
    .SYNOPSIS
    Removes an existing ADOM revision.

    .DESCRIPTION
    Removes an existing ADOM revision.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER Version
    Version number of the revision to be removed.

  	.PARAMETER EnableException
	Should Exceptions been thrown?

    .EXAMPLE
    Remove-FMAdomRevision -Version 3

    Removes the revision with the ID 3
    .NOTES
    General notes
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param (
        [parameter(Mandatory = $false)]
        $Connection = (Get-FMLastConnection),
        [string]$ADOM,
        [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Version,
        [bool]$EnableException = $true
    )
    begin {
        $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM
        Write-PSFMessage "`$explicitADOM=$explicitADOM"
        $apiCallParameter = @{
            EnableException     = $EnableException
            RevisionNote        = $RevisionNote
            Connection          = $Connection
            LoggingActionValues = $explicitADOM
            method              = "delete"
            parameter           = @()
        }
        $revisionList = @()
    }
    process {
        # foreach($id in $version){
        #     Write-PSFMessage "$id = $($id.GetType())"
        #     $revisionList+=$id
        # }
        $revisionList += $Version
    }
    end {
        # Removing potential Null values
        $revisionList = $revisionList | Where-Object { $_ }
        Write-PSFMessage "Removing revisions $($revisionList -join ',')"
        # Different Logging if multiple or single address should be deleted
        if ($revisionList.count -gt 1) {
            $apiCallParameter.LoggingAction = "Remove-FMAdomRevision-Multiple"
            $apiCallParameter.LoggingActionValues = $revisionList.count
        }
        else {
            $apiCallParameter.LoggingAction = "Remove-FMAdomRevision"
            $apiCallParameter.LoggingActionValues = $revisionList
        }
        foreach ($id in $revisionList) {
            $dataSet = @{
                url = "/dvmdb/adom/$explicitADOM/revision/$id"
            }
            $apiCallParameter.parameter += $dataSet
        }
        $result = Invoke-FMAPI @apiCallParameter
        # If EnableException an exception would have be thrown, otherwise the function returns true for success or false for failure
        if (-not $EnableException) {
            return ($null -ne $result)
        }
    }

}