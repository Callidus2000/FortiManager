function Remove-FMNullValuesFromHashtable {
    [CmdletBinding()]
    param (
        [parameter(mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "default")]
        # [parameter(mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "clearEmpty")]
        # [parameter(mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "removeEmpty")]
        [HashTable]$InputObject,
        [ValidateSet("Keep", "RemoveAttribute", "ClearContent")]
        [parameter(mandatory = $false, ValueFromPipeline = $false, ParameterSetName = "default")]
        $NullHandler = "RemoveAttribute",
        [parameter(mandatory = $false, ValueFromPipeline = $false, ParameterSetName = "default")]
        [long]$LongNullValue=-1
        # ,
        # [parameter(mandatory = $false, ParameterSetName = "clearEmpty")]
        # [switch]$ClearEmptyArrays,
        # [parameter(mandatory = $false, ParameterSetName = "keepEmpty")]
        # [switch]$KeepEmptyAttribute
    )

    begin {
    }

    process {
    }

    end {
        if ($NullHandler -eq "Keep"){
            Write-PSFMessage "Returning inputObject unchanged"
            return $InputObject
        }
        $keyList = $InputObject.Keys | ForEach-Object { "$_" }
        foreach ($key in $keyList) {
            if ($null -eq $InputObject.$key){
                continue
            }
            $paramaterType = $InputObject.$key.gettype()
            switch ($paramaterType) {
                "System.Object[]" {
                    write-psfmessage "Prüfe Null-Arrays"
                    if ($InputObject.$key.Count -gt 0 -and ($null -eq $InputObject.$key[0])) {
                        if ($NullHandler -eq "ClearContent") {
                            write-psfmessage "Replacing Array Attribute $key with empty Array"
                            $InputObject.$key = @()
                        }else{
                            write-psfmessage "Removing Array Attribute $key"
                            $InputObject.Remove($key)
                        }
                    }
                }
                "string" {
                    if (($NullHandler -eq "RemoveAttribute") -and ([string]::IsNullOrEmpty($InputObject.$key))){
                        write-psfmessage "Removing String Attribute $key"
                        $InputObject.Remove($key)
                    }
                }
                "long" {
if($NullHandler -eq "RemoveAttribute" -and $InputObject.$key -eq $LongNullValue){
                        write-psfmessage "Removing Long Attribute $key"
                        $InputObject.Remove($key)
                    }
                }
                Default { Write-PSFMessage -Level Verbose "Unknown ParamaterType $paramaterType" }
            }
        }
        return $InputObject
    }
}