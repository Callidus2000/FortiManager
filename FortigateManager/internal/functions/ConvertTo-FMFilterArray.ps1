function ConvertTo-FMFilterArray {
    [CmdletBinding()]
    param (
        [parameter(mandatory = $false, ValueFromPipeline = $true, ParameterSetName = "default")]
        [string[]]$Filter
    )

    begin {
        $resultArray = @()
        $filterInputArray = @()
        $operatorTranslation = @{
            "-eq"       = "=="
            "-ne"       = "!=="
            "-like"     = "like"
            "-notlike"  = "!like"
            "-contains" = "contain"
        }
    }

    process {
        if ($Filter) { $filterInputArray += $Filter }
    }

    end {
        foreach ($filterString in $filterInputArray) {
            Write-PSFMessage "Analysiere '$filterString'"
            $regexResults = [regex]::Matches($filterString, "(?<attribute>.*) (?<operator>-eq|-ne|-notlike|-like|-contains) (?<value>.*)")
            Write-PSFMessage "`$regexResults=$($regexResults)"
            if ($regexResults) {
                $attribute = $regexResults[0].Groups["attribute"].value
                $operator = $operatorTranslation."$($regexResults[0].Groups["operator"].value)"
                $value = $regexResults[0].Groups["value"].value
                if ($operator -like '!*') {
                    $currentFilter = @("!")
                    $operator = $operator.Trim("!")
                }
                else {
                    $currentFilter = @()
                }
                $currentFilter += @($attribute, $operator, $value)
                $resultArray += , ($currentFilter)
            }
            else {
                Write-PSFMessage -Level Warning "No valid filter string: $filterString"
            }
        }
        Write-PSFMessage "Result= $($resultArray|ConvertTo-Json)"
        return $resultArray
    }
}