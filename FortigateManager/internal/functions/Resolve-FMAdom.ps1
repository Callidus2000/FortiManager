﻿function Resolve-FMAdom {
    <#
    .SYNOPSIS
    Internal Helper for getting the ADOM from the given parameter or from the connection default.

    .DESCRIPTION
    Internal Helper for getting the ADOM from the given parameter or from the connection default.

    .PARAMETER Connection
    The connection object

    .PARAMETER ADOM
    The explicit ADOM.

    .PARAMETER EnableException
    Should an exception be thrown if no ADOM can be resolved.

    .EXAMPLE
    An example

    may be provided later

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [parameter(Mandatory)]
        $Connection,
        [string]$ADOM,
        [bool]$EnableException = $true
    )
    $adomAvailable = "$([string]::IsNullOrEmpty($ADOM) -eq $false)/$([string]::IsNullOrEmpty($connection.forti.defaultADOM) -eq $false)".ToLower()
    Write-PSFMessage "Checking ADOM availibility: $adomAvailable (explicit/default)" -Level Debug
    Write-PSFMessage "`$ADOM=$ADOM" -Level Debug
    Write-PSFMessage "`$connection.forti.defaultADOM=$($connection.forti.defaultADOM)" -Level Debug
    switch -wildcard ($adomAvailable) {
        "true/*" {
            Write-PSFMessage "Explicit ADOM found" -Level Debug
            return $ADOM
        }
        "false/true" {
            Write-PSFMessage "No explicit ADOM but Default found" -Level Debug
            return $connection.forti.defaultADOM
        }
        "false/false" {
            Write-PSFMessage "Neither explicit nor Default ADOM found" -Level Debug
            if ($EnableException) {
                throw "Neither explicit nor Default ADOM found"
            }
            return $null
        }
    }
}