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
	  -in      (value can be a comma-separated list, e.g. "name -in a,b,c")
	  -notin   (value can be a comma-separated list, e.g. "name -notin a,b,c")
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
            "-notcontains" = "!contain"
            "-in" = "in"
            "-notin" = "!in"
        }
    }

    process {
        if ($Filter) { $filterInputArray += $Filter }
    }

    end {
        foreach ($filterString in $filterInputArray) {
            Write-PSFMessage "Analysiere '$filterString'"
            $operatorRegex = $operatorTranslation.Keys -join '|'
            # $regexResults = [regex]::Matches($filterString, "(?<attribute>.*) (?<operator>-eq|-ne|-notlike|-like|-contains) (?<value>.*)")
            $regexResults = [regex]::Matches($filterString, "(?<attribute>.*) (?<operator>$operatorRegex) (?<value>.*)")
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
                if($operator -in 'in', '!in') {
                    $value = $value -split ',' | ForEach-Object { $_.Trim() }
                }
                else {
                    $value = $value.Trim()
                }
                $currentFilter += @($attribute, $operator)+ $value
                $resultArray += , ($currentFilter)
            }
            else {
                Write-PSFMessage -Level Warning "No valid filter string: $filterString"
            }
        }
        Write-PSFMessage "Result= $($resultArray| ConvertTo-Json -WarningAction SilentlyContinue)"
        return $resultArray
    }
}