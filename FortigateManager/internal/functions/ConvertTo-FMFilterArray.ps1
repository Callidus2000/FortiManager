function ConvertTo-FMFilterArray {
    <#
    .SYNOPSIS
    Converts filter strings into the array type the API aspects.

    .DESCRIPTION
    Converts filter strings into the array type the API aspects.
    See about_FortigateManagerFilter

    .PARAMETER Filter
    The filter String in the following format:
	"{attribute} {operator} {value}"

	- The attribute depends on the object model you are querying.
	- the operator is one of the following:
	  -eq
	  -like   (use % (multi) and _ (single char) as a wildcard)
	  -contain (NO LIKE COMPARISON, checks if something is contained within an array)
	  -ne
	  -notlike
	- The value is the value used for filtering

	Example:


    .EXAMPLE
	Get-FMAddress -Filter "name -eq srv123"

    Returns the array @('name','==','srv123')
    .NOTES
    General notes
    #>
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