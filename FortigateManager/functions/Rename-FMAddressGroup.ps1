function Rename-FMAddressGroup {
    <#
    .SYNOPSIS
    Renames an existing address group.

    .DESCRIPTION
    Renames an existing address group.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER Name
    The name of the address group to be changed

    .PARAMETER NewName
    The new name of the address group

    .PARAMETER EnableException
    If set to true, inner exceptions will be rethrown. Otherwise the an empty result will be returned.

    .EXAMPLE
    Rename-FMAddressGroup -Name "MyDUMMY" -NewName "MyDummy 2"

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
        $existingGroup=Get-FMAddressGroup -Connection $Connection -filter "name -eq $Name"

        if (-not $existingGroup) {
            Stop-PSFFunction -AlwaysWarning -EnableException $EnableException -Message "No address group with the name '$Name' could be found"
            # return
        }
        $existingGroup.name=$NewName
        return Update-FMAddressGroup -Address $existingGroup -Connection $Connection -ADOM $ADOM -Name $Name
    }
}