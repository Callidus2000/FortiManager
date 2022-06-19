function Remove-FMWhitespacesFromAttributes {
    <#
    .SYNOPSIS
    Helper function to trim all string attributes.

    .DESCRIPTION
    Helper function to trim all string attributes.

    .PARAMETER InputObject
    The original Object/Hashtable.

    .PARAMETER CharToTrim
    Which characters should be trimmed? Defaults to whitespace


    .EXAMPLE
    An example

    has to be provided later
    .NOTES
    General notes
    #>
    [CmdletBinding()]
    [OutputType([Object])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessforStateChangingFunctions', '')]
    param (
        [parameter(mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "default")]
        $InputObject,
        [string]$CharToTrim=" "
    )

    begin {    }

    process {
        if ($null -eq $InputObject){
            Write-PSFMessage "Input-Object is Null"
            return
        }
        if ($InputObject -is [HashTable]) {
            $propertyNames = @() + $InputObject.Keys
        }
        else {
            $propertyNames = $InputObject.PSObject.Properties.Name
        }
        Write-PSFMessage "`$propertyNames=$propertyNames"
        foreach ($prop in $propertyNames) {
            switch ($InputObject.$prop.gettype()) {
                "string" {
                    $InputObject.$prop = $InputObject.$prop.Trim($CharToTrim)
                }
            }
        }
        return $InputObject
    }

    end {    }
}