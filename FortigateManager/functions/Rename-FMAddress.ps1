function Rename-FMAddress {
    <#
    .SYNOPSIS
    Renames an existing addresses.

    .DESCRIPTION
    Renames an existing addresses.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER Name
    The name of the address to be changed

    .PARAMETER NewName
    The new name of the address

    .PARAMETER EnableException
    If set to true, inner exceptions will be rethrown. Otherwise the an empty result will be returned.

    .EXAMPLE
    Rename-FMAddress -Name "MyDUMMY" -NewName "MyDummy 2"

    Performs the renaming.

    .NOTES
    General notes
    #>
    param (
        [parameter(Mandatory=$false)]
        $Connection = (Get-FMLastConnection),
        [string]$ADOM,
        [parameter(mandatory = $true, ValueFromPipeline = $false, ParameterSetName = "default")]
        [string]$Name,
        [parameter(mandatory = $true, ValueFromPipeline = $false, ParameterSetName = "default")]
        [string]$NewName,
        [bool]$EnableException = $true
    )
    begin {
    }
    process {
    }
    end {
        $existingAddress=Get-FMAddress -Connection $Connection -filter "name -eq $Name"

        if (-not $existingAddress) {
            Stop-PSFFunction -AlwaysWarning -EnableException $EnableException -Message "No address with the name '$Name' could be found"
            # return
        }
        $existingAddress.name=$NewName
        return Update-FMAddress -Address $existingAddress -Connection $Connection -ADOM $ADOM -Name $Name
    }
}