function Remove-FMNullValuesFromHashtable {
    <#
    .SYNOPSIS
    Helper function to remove empty attributes from a provided HashTable.

    .DESCRIPTION
    Helper function to remove empty attributes from a provided HashTable.

    .PARAMETER InputObject
    The original Hastable

    .PARAMETER NullHandler
    How should empty values be handled?
    -Keep: Keep the Attribute
    -RemoveAttribute: Remove the Attribute (default)
    -ClearContent: Clear the value

    .PARAMETER LongNullValue
    Which long value should be interpretated as "empty"

    .EXAMPLE
    An example

    has to be provided later
    .NOTES
    General notes
    #>
    [CmdletBinding()]
    [OutputType([Hashtable])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessforStateChangingFunctions', '')]
    param (
        [parameter(mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "default")]
        # [parameter(mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "clearEmpty")]
        # [parameter(mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "removeEmpty")]
        [HashTable]$InputObject,
        [ValidateSet("Keep", "RemoveAttribute", "ClearContent")]
        [parameter(mandatory = $false, ParameterSetName = "default")]
        $NullHandler = "RemoveAttribute",
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$LongNullValue = -1
        # ,
        # [parameter(mandatory = $false, ParameterSetName = "clearEmpty")]
        # [switch]$ClearEmptyArrays,
        # [parameter(mandatory = $false, ParameterSetName = "keepEmpty")]
        # [switch]$KeepEmptyAttribute
    )

    begin {
        if ($NullHandler -eq "RemoveAttribute") {
            $logLevel = "Debug"
        }
        else {
            $logLevel = "Verbose"
        }
    }

    process {
    }

    end {
        if ($NullHandler -eq "Keep") {
            Write-PSFMessage "Returning inputObject unchanged" -Level $logLevel
            return $InputObject
        }
        $keyList = $InputObject.Keys | ForEach-Object { "$_" }
        foreach ($key in $keyList) {
            if ($null -eq $InputObject.$key) {
                continue
            }
            $paramaterType = $InputObject.$key.gettype()
            switch -regex ($paramaterType) {
                ".*\[\]" {
                    write-psfmessage "Prüfe Null-Arrays" -Level $logLevel
                    if ($InputObject.$key.Count -gt 0 -and ([string]::IsNullOrEmpty($InputObject.$key[0]))) {
                        if ($NullHandler -eq "ClearContent") {
                            write-psfmessage "Replacing Array Attribute $key with empty Array" -Level $logLevel
                            $InputObject.$key = @()
                        }
                        else {
                            write-psfmessage "Removing Array Attribute $key" -Level $logLevel
                            $InputObject.Remove($key)
                        }
                    }
                }
                "string" {
                    if (($NullHandler -eq "RemoveAttribute") -and ([string]::IsNullOrEmpty($InputObject.$key))) {
                        write-psfmessage "Removing String Attribute $key" -Level $logLevel
                        $InputObject.Remove($key)
                    }
                }
                "long" {
                    if ($NullHandler -eq "RemoveAttribute" -and $InputObject.$key -eq $LongNullValue) {
                        write-psfmessage "Removing Long Attribute $key" -Level $logLevel
                        $InputObject.Remove($key)
                    }
                }
                Default { Write-PSFMessage "Unknown ParamaterType $paramaterType" -Level $logLevel }
            }
        }
        return $InputObject
    }
}