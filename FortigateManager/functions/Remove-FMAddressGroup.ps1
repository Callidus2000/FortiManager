function Remove-FMAddressGroup {
    <#
    .SYNOPSIS
    Removes a firewall address group by name.

    .DESCRIPTION
    Removes a firewall address group by name.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER Name
    Name of the address group to be removed.

    .PARAMETER RevisionNote
    The change note which should be saved for this revision, see about_RevisionNote

  	.PARAMETER EnableException
	Should Exceptions been thrown?

    .EXAMPLE
    $testGroup = Get-FMAddressGroup -Connection $Connection -Filter "name -eq Dummy-Group"
    Lock-FMAdom -Connection $connection
    try {
        $testGroup | remove-fmaddressgroup -connection $connection
        Publish-FMAdomChange -Connection $connection
    }
    catch {
        Write-PSFMessage -Level Warning "$_"
    }
    finally {
        UnLock-FMAdom -Connection $connection
    }
    Disconnect-FM -connection $Connection

    Removes the named address group.
    .NOTES
    General notes
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param (
        [parameter(Mandatory=$false)]
        $Connection = (Get-FMLastConnection),
        [string]$ADOM,
        [string]$RevisionNote,
        [bool]$EnableException = $true,
        [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Name
    )
    begin {
        $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM
        Write-PSFMessage "`$explicitADOM=$explicitADOM"
        if ($Commit) {
            Publish-FMAdomChange -Connection $Connection -Adom $explicitADOM -EnableException $EnableException
        }
        $apiCallParameter = @{
            EnableException     = $EnableException
            RevisionNote        = $RevisionNote
            Connection          = $Connection
            LoggingAction       = "Remove-FMAddressGroup"
            LoggingActionValues = $explicitADOM
            method              = "delete"
        }
        $groupList = @()
    }
    process {
        $groupList += $Name #-replace '/', '\/'
    }
    end {
        # Removing potential Null values
        $groupList = $groupList | Where-Object { $_ } | ConvertTo-FMUrlPart
        foreach ($groupName in $groupList) {
            $apiCallParameter.Path = "/pm/config/adom/$explicitADOM/obj/firewall/addrgrp/$groupName"
            $apiCallParameter.LoggingActionValues = $groupName
            $result = Invoke-FMAPI @apiCallParameter
        }
        # If EnableException an exception would have be thrown, otherwise the function returns true for success or false for failure
        if (-not $EnableException) {
            return ($null -ne $result)
        }
    }

}