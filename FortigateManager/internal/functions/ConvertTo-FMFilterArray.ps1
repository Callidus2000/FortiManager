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
            "-like"     = "like"
            "-contains" = "contain"
        }
    }

    process {
        if ($Filter) { $filterInputArray += $Filter }
    }

    end {
        foreach ($filterString in $filterInputArray) {
            Write-PSFMessage "Analysiere '$filterString'"
            $regexResults = [regex]::Matches($filterString, "(?<attribute>.*) (?<operator>-eq|-like|-contains) (?<value>.*)")
            Write-PSFMessage "`$regexResults=$($regexResults)"
            if ($regexResults) {
                $currentFilter = @(
                    $regexResults[0].Groups["attribute"].value,
                    $operatorTranslation."$($regexResults[0].Groups["operator"].value)",
                    $regexResults[0].Groups["value"].value
                )
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