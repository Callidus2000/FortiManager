﻿function Get-FMSystemStatus {
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
        $Connection
    )
    $apiCallParameter = @{
        EnableException = $EnableException
        Connection      = $Connection
        LoggingAction       = "Get-FMSystemStatus"
        LoggingActionValues = ""
        method          = "get"
        Path            = "sys/status"
    }

    Invoke-FMAPI @apiCallParameter
}