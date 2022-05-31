function Convert-FMApi2Hashtable {
    <#
    .SYNOPSIS
    Helper function for creating Powershell code out of HashTable Definitions in JSON.

    .DESCRIPTION
    Helper function for creating Powershell code out of HashTable Definitions in JSON.

    .PARAMETER objectName
    The new Object Name for the function Name

    .EXAMPLE
    InModuleScope fortigatemanager {Convert-FMApi2HashTable}

    Takes the JSON Code from the clipboard and replaces it with an auto generated Powershell function.

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [String]
        $objectName = ""
    )
    Write-Host "ParameterSetName=$ParameterSetName"
    $json = Get-Clipboard

    $newLineDelim = @"
,

"@
    try {
        $copy2ClipBoardData = @()
        $copy2ClipBoardData += @"
function New-FMObj$objectName {
    [CmdletBinding()]
    param (
"@
        $defParameter = @()
        $defHashMap = @()
        $sourceHashTable = $json | ConvertFrom-Json -ErrorAction Stop | convertto-psfhashtable
        $sourceKeyList = $sourceHashTable.Keys | Sort-Object
        foreach ($sourceKey in $sourceKeyList) {
            $parameterName = [regex]::Replace($sourceKey.Trim('_'), '(?i)(?:^|-| )(\p{L})', { $args[0].Groups[1].Value.ToUpper() })
            $parameterType = $sourceHashTable.$sourceKey.gettype()
            $parameterValue = $sourceHashTable.$sourceKey
            Write-Host "`$parameterName=$parameterName; Type=$parameterType;value=$parameterValue"
            #     $defParameter+=@"
            #         [parameter(mandatory = `$false, ParameterSetName = "default")]
            #         [$parameterType]`$$parameterName
            # "@
            # Hashtable Definition ergänzen
            switch ($parameterType) {
                "long" {
                    $defParameter += @"
        [parameter(mandatory = `$false, ParameterSetName = "default")]
        [$parameterType]`$$parameterName=-1
"@
                }
                Default {
                    switch -regex ($parameterValue) {
                        "disable|disable" {
                            $defParameter += @"
            [parameter(mandatory = `$false, ParameterSetName = "default")]
            [ValidateSet("disable", "enable")]
            [$parameterType]`$$parameterName
"@
                        }
                        Default {
                            $defParameter += @"
            [parameter(mandatory = `$false, ParameterSetName = "default")]
            [$parameterType]`$$parameterName
"@
                        }
                    }
                }
            }
            # Hashtable Definition ergänzen
            switch ($parameterType) {
                "System.Object[]" { $defHashMap += "'$sourceKey'=@(`$$parameterName)" }
                "string" { $defHashMap += "'$sourceKey'=`"`$$parameterName`"" }
                "long" { $defHashMap += "'$sourceKey'=`$$parameterName" }
                Default { Write-PSFMessage -Level Warning "Unknown ParamaterType $parameterType" }
            }
        }
        $defParameter += @"
        [ValidateSet("Keep", "RemoveAttribute", "ClearContent")]
        [parameter(mandatory = `$false, ValueFromPipeline = `$false, ParameterSetName = "default")]
        `$NullHandler = "RemoveAttribute"
"@
        $copy2ClipBoardData += ($defParameter | Join-String $newLineDelim)
        $copy2ClipBoardData += ")"
        $copy2ClipBoardData += "`$data=@{"
        $copy2ClipBoardData += ($defHashMap | Out-String)
        $copy2ClipBoardData += "}"
        $copy2ClipBoardData += "return `$data | Remove-FMNullValuesFromHashtable -NullHandler `$NullHandler"
        $copy2ClipBoardData += "}"
        write-host ($copy2ClipBoardData  | out-string)
        $copy2ClipBoardData  | out-string | Set-Clipboard
        # write-host ($defParameter | Join-String $newLineDelim | out-string)
    }
    catch {
        Write-Host "Clipboard did not contain a JSON String, $_"
    }
}