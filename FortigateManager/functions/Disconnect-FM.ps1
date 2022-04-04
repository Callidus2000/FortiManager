function Disconnect-FM {
    <#
    .SYNOPSIS
    Disconnects from an existing connection

    .DESCRIPTION
    Disconnects from an existing connection

    .PARAMETER Connection
    The API connection object.

    .EXAMPLE
    To be added

    in the Future

    .NOTES
    General notes
    #>
    param (
        [parameter(Mandatory)]
        $Connection,
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

    $result=Invoke-FMAPI @apiCallParameter
    if (-not $EnableException) {
        return ($null -ne $result)
    }
}