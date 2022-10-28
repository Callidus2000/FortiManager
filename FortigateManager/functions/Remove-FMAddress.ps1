function Remove-FMAddress {
    <#
    .SYNOPSIS
    Removes a firewall address by name.

    .DESCRIPTION
    Removes a firewall address by name.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER Name
    Name of the address to be removed.

    .PARAMETER RevisionNote
    The change note which should be saved for this revision, see about_RevisionNote

  	.PARAMETER EnableException
	Should Exceptions been thrown?

    .PARAMETER Force
    If used addresses can be removed even if it is used within the ADOM.

    .EXAMPLE
    $testAddresses = Get-FMAddress -Connection $Connection -Filter "comment -like %API Test%" |select -first 3
    Lock-FMAdom -Connection $connection
    try {
        $testAddresses | remove-fmaddress -connection $connection
        Publish-FMAdomChange -Connection $connection
    }
    catch {
        Write-PSFMessage -Level Warning "$_"
    }
    finally {
        UnLock-FMAdom -Connection $connection
    }

    Query addresses by comment and removes them
    .NOTES
    General notes
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param (
        [parameter(Mandatory = $false)]
        $Connection = (Get-FMLastConnection),
        [string]$ADOM,
        [string]$RevisionNote,
        [bool]$EnableException = $true,
        [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Name,
        [switch]$Force
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
            LoggingActionValues = $explicitADOM
            method              = "delete"
            parameter           = @()
        }
        $addressList = @()
    }
    process {
        $addressList += $Name #-replace '/', '\/'
    }
    end {
        # Removing potential Null values
        $addressList = $addressList | Where-Object { $_ } | ConvertTo-FMUrlPart
        # Different Logging if multiple or single address should be deleted
        if ($addressList.count -gt 1) {
            $apiCallParameter.LoggingAction = "Remove-FMAddress-Multiple"
            $apiCallParameter.LoggingActionValues = $addressList.count
        }
        else {
            $apiCallParameter.LoggingAction = "Remove-FMAddress"
            $apiCallParameter.LoggingActionValues = $addressList
        }
        foreach ($addrName in $addressList) {
            $dataSet = @{
                url = "/pm/config/adom/$explicitADOM/obj/firewall/address/$addrName"
            }
            if ($Force) {
                $dataSet.option = 'force'
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