function Disconnect-FM {
    <#
    .SYNOPSIS
    Disconnects from an existing connection

    .DESCRIPTION
    Disconnects from an existing connection

    .PARAMETER Connection
    The API connection object.
  	.PARAMETER EnableException
	Should Exceptions been thrown?


    .EXAMPLE
    To be added

    in the Future

    .NOTES
    General notes
    #>
    param (
        [parameter(Mandatory=$false)]
        $Connection = (Get-FMLastConnection),
        [bool]$EnableException = $true
    )
    $apiCallParameter = @{
        EnableException = $EnableException
        Connection      = $Connection
        LoggingAction       = "Disconnect-FM"
        LoggingActionValues = ""
        method          = "exec"
        Path            = "sys/logout"
    }
    $lastConnection=Get-FMLastConnection -EnableException $EnableException
    $result=Invoke-FMAPI @apiCallParameter
    if ($lastConnection -and $lastConnection.forti.session -eq $Connection.forti.session){
        Write-PSFMessage "Remove stored last connection"
        Remove-PSFConfig -FullName 'FortigateManager.LastConnection' -Confirm:$false
    }
    if (-not $EnableException) {
        return ($null -ne $result)
    }
}