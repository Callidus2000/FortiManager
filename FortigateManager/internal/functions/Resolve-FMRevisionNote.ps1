function Resolve-FMRevisionNote {
    <#
    .SYNOPSIS
    Internal Helper for getting the RevisionNote from the given parameter or from the connection default.

    .DESCRIPTION
    Internal Helper for getting the RevisionNote from the given parameter or from the connection default.

    .PARAMETER Connection
    The connection object

    .PARAMETER RevisionNote
    The explicit RevisionNote.

    .PARAMETER EnableException
    Should an exception be thrown if no RevisionNote can be resolved.

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
        [string]$RevisionNote,
        [bool]$EnableException = $true
    )
    $RevisionNoteAvailable = "$([string]::IsNullOrEmpty($RevisionNote) -eq $false)/$([string]::IsNullOrEmpty($connection.forti.defaultRevisionNote) -eq $false)".ToLower()
    Write-PSFMessage "Checking RevisionNote availibility: $RevisionNoteAvailable (explicit/default)" -Level Debug
    Write-PSFMessage "`$RevisionNote=$RevisionNote" -Level Debug
    Write-PSFMessage "`$connection.forti.defaultRevisionNote=$($connection.forti.defaultRevisionNote)" -Level Debug
    switch -wildcard ($RevisionNoteAvailable) {
        "true/*" {
            Write-PSFMessage "Explicit RevisionNote found" -Level Debug
            return $RevisionNote
        }
        "false/true" {
            Write-PSFMessage "No explicit RevisionNote but Default found" -Level Debug
            return $connection.forti.defaultRevisionNote
        }
        "false/false" {
            Write-PSFMessage "Neither explicit nor Default RevisionNote found" -Level Debug
            if ($EnableException) {
                throw "Neither explicit nor Default RevisionNote found; RevisionNote is needed, provide it for the API-Call or while locking the ADOM, see about_RevisionNote"
            }
            return $null
        }
    }
}