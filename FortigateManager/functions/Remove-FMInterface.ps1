function Remove-FMInterface {
    <#
    .SYNOPSIS
    Removes a firewall Interface by name.

    .DESCRIPTION
    Removes a firewall Interface by name.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER Name
    Name of the Interface to be removed.

  	.PARAMETER EnableException
	Should Exceptions been thrown?

    .EXAMPLE
    $testInterfacees = Get-FMInterface -Connection $Connection -Filter "comment -like %API Test%" |select -first 3
    Lock-FMAdom -Connection $connection
    try {
        $testInterfacees | remove-fmInterface -connection $connection
        Publish-FMAdomChange -Connection $connection
    }
    catch {
        Write-PSFMessage -Level Warning "$_"
    }
    finally {
        UnLock-FMAdom -Connection $connection
    }

    Query Interfacees by comment and removes them
    .NOTES
    General notes
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param (
        [parameter(Mandatory=$false)]
        $Connection = (Get-FMLastConnection),
        [string]$ADOM,
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
            Connection          = $Connection
            LoggingAction       = "Remove-FMInterface"
            LoggingActionValues = $explicitADOM
            method              = "delete"
        }
        $InterfaceList = @()
    }
    process {
        $InterfaceList += $Name #-replace '/', '\/'
    }
    end {
        # Removing potential Null values
        $InterfaceList = $InterfaceList | Where-Object { $_ } | ConvertTo-FMUrlPart
        foreach ($addrName in $InterfaceList) {
            $apiCallParameter.Path = "/pm/config/adom/$explicitADOM/obj/dynamic/interface/$addrName"
            $apiCallParameter.LoggingActionValues = $addrName
            $result = Invoke-FMAPI @apiCallParameter
        }
        # If EnableException an exception would have be thrown, otherwise the function returns true for success or false for failure
        if (-not $EnableException) {
            return ($null -ne $result)
        }
    }

}