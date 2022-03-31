function Remove-FMNullValuesFromHashtable {
    [CmdletBinding()]
    param (
        [parameter(mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "default")]
        [parameter(mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "clearEmpty")]
        [parameter(mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "removeEmpty")]
        [HashTable]$InputObject,
        [parameter(mandatory = $false, ParameterSetName = "clearEmpty")]
        [switch]$ClearEmptyArrays,
        [parameter(mandatory = $false, ParameterSetName = "removeEmpty")]
        [switch]$RemoveEmptyAttribute
    )

    begin {
    }

    process {
    }

    end {
        $keyList = $InputObject.Keys | ForEach-Object { "$_" }
        foreach ($key in $keyList) {
            $paramaterType = $InputObject.$key.gettype()
            switch ($paramaterType) {
                "System.Object[]" {
                    write-psfmessage "Prüfe Null-Arrays"
                    if ($InputObject.$key.Count -gt 0 -and ($null -eq $InputObject.$key[0])) {
                        if ($ClearEmptyArrays) {
                            write-psfmessage "Lösche Array unter Key $key, in denen kein Wert steht"
                            $InputObject.$key = @()
                        }elseif($RemoveEmptyAttribute){
                            write-psfmessage "Lösche Attribut unter Key $key, in denen kein Wert steht"
                            $InputObject.Remove($key)
                        }
                    }
                }
                "string" {
                    if ($RemoveEmptyAttribute -and ([string]::IsNullOrEmpty($InputObject.$key))){
                        write-psfmessage "Lösche String Attribut unter Key $key, in denen kein Wert steht"
                        $InputObject.Remove($key)
                    }
                }
                # "long" { $defHashMap += "'$sourceKey'=`$$parameterName" }
                Default { Write-PSFMessage -Level Verbose "Unknown ParamaterType $paramaterType" }
            }
        }
        return $InputObject
    }
}