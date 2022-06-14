function Convert-FMApiGet2FunctionStub {
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
        [parameter(Mandatory = $false)]
        $Connection = (Get-FMLastConnection),
        [Parameter()]
        [String]
        $objectName = "",
        [string]$Url
    )
    $copy2ClipBoardData = @()
    $apiCallParameter = @{
        EnableException     = $true
        Connection          = $Connection
        LoggingAction       = "Query-Syntax"
        LoggingActionValues = $Url
        method              = "get"
        Parameter           = @{
            'option' = "syntax"
        }
        Path                = $Url
    }
    $newLineCommaDelim = @"
,

"@
    $newLineDelim = @"


"@

    $result = Invoke-FMAPI @apiCallParameter
    $global:syntax = $result.result[0]
    try {
        $objectName = $syntax.data.PSObject.Properties.name
        $objectNameCC = ConvertTo-CamelCase $objectName
        $copy2ClipBoardData = @()
        $copy2ClipBoardData += @"
        function New-FMObj$objectNameCC {
                <#
    .SYNOPSIS
    Creates a new $objectName object with the given attributes.

    .DESCRIPTION
    Creates a new $objectName object with the given attributes.
"@
        $defHelp = @()
        $defParameter = @()
        $defHashMap = @()
        #region Insert Parsed Data
        $attributes = $syntax.data.$objectName.attr
        $sortedAttributeNameList = $attributes.PSObject.Properties.name|Sort-Object
        foreach ($attr in $sortedAttributeNameList) {
            $parameterName = ConvertTo-CamelCase $attr
            # $parameterName = [regex]::Replace($sourceKey.Trim('_'), '(?i)(?:^|-| )(\p{L})', { $args[0].Groups[1].Value.ToUpper() })
            $defHelp+=("    .PARAMETER $parameterName")
            if ($attributes.$attr.help){
                $defHelp+=("    $($attributes.$attr.help)")
            }
            $defHelp+=("    This parameter is stored in the API attribute $attr.")
            if ($attributes.$attr.default){
                $defHelp+=("    Default Value: $($attributes.$attr.default)")
            }
            $defHelp+=$newLineDelim
            # $parameterType = $sourceHashTable.$sourceKey.gettype()
            # $parameterValue = $sourceHashTable.$sourceKey
            Write-PSFMessage "`$parameterName=$parameterName; Type=$parameterType;value=$parameterValue"
            #     $defParameter+=@"
            #         [parameter(mandatory = `$false, ParameterSetName = "default")]
            #         [$parameterType]`$$parameterName
            # "@
            # Hashtable Definition ergänzen
#             switch ($parameterType) {
#                 "long" {
#                     $defParameter += @"
#         [parameter(mandatory = `$false, ParameterSetName = "default")]
#         [$parameterType]`$$parameterName=-1
# "@
#                 }
#                 Default {
#                     switch -regex ($parameterValue) {
#                         "disable|disable" {
#                             $defParameter += @"
#             [parameter(mandatory = `$false, ParameterSetName = "default")]
#             [ValidateSet("disable", "enable")]
#             [$parameterType]`$$parameterName
# "@
#                         }
#                         Default {
#                             $defParameter += @"
#             [parameter(mandatory = `$false, ParameterSetName = "default")]
#             [$parameterType]`$$parameterName
# "@
#                         }
#                     }
#                 }
#             }
            # Hashtable Definition ergänzen
            # switch ($parameterType) {
            #     "System.Object[]" { $defHashMap += "'$sourceKey'=@(`$$parameterName)" }
            #     "string" { $defHashMap += "'$sourceKey'=`"`$$parameterName`"" }
            #     "long" { $defHashMap += "'$sourceKey'=`$$parameterName" }
            #     Default { Write-PSFMessage -Level Warning "Unknown ParamaterType $parameterType" }
            # }
        }
        #endregion
        $defHelp+=@"
    .EXAMPLE
    Example has to be

    implemented

    .NOTES
    General notes
    #>
"@
        $defParameter += @"
        [ValidateSet("Keep", "RemoveAttribute", "ClearContent")]
        [parameter(mandatory = `$false, ValueFromPipeline = `$false, ParameterSetName = "default")]
        `$NullHandler = "RemoveAttribute"
"@
        $copy2ClipBoardData += ($defHelp | Join-String $newLineDelim)
        $copy2ClipBoardData += ($defParameter | Join-String $newLineCommaDelim)
        $copy2ClipBoardData += ")"
        $copy2ClipBoardData += "`$data=@{"
        $copy2ClipBoardData += ($defHashMap | Out-String)
        $copy2ClipBoardData += "}"
        $copy2ClipBoardData += "return `$data | Remove-FMNullValuesFromHashtable -NullHandler `$NullHandler"
        $copy2ClipBoardData += "}"

        return $copy2ClipBoardData  | out-string
    }
    catch {
        Write-PSFMessage -Level Warning "Error, $_"
        Write-Host "Error, $_"
        throw $_
    }
    return $syntax #|convertto-json -Depth 10
    $json = Get-Clipboard

    $newLineCommaDelim = @"
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
            Write-PSFMessage "`$parameterName=$parameterName; Type=$parameterType;value=$parameterValue"
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
        $copy2ClipBoardData += ($defParameter | Join-String $newLineCommaDelim)
        $copy2ClipBoardData += ")"
        $copy2ClipBoardData += "`$data=@{"
        $copy2ClipBoardData += ($defHashMap | Out-String)
        $copy2ClipBoardData += "}"
        $copy2ClipBoardData += "return `$data | Remove-FMNullValuesFromHashtable -NullHandler `$NullHandler"
        $copy2ClipBoardData += "}"
        Write-PSFMessage -Level Host ($copy2ClipBoardData  | out-string)
        $copy2ClipBoardData  | out-string | Set-Clipboard
    }
    catch {
        Write-PSFMessage -Level Warning "Clipboard did not contain a JSON String, $_"
    }
}