function Disconnect-FM {
    <#
    .SYNOPSIS
    Disconnects from an existing connection

    .DESCRIPTION
    Disconnects from an existing connection

    .PARAMETER Connection
    Parameter description

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
        Connection   = $Connection
        method       = "exec"
        Path         ="sys/logout"
    }

    Invoke-FMAPI @apiCallParameter
}