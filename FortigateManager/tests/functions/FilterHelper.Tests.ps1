Describe  "Filter tests" {
    BeforeAll {
    }
    AfterAll {
    }
    It "Returns an array of arrays (<FilterString>)" -TestCases @(
        @{ FilterString = "name -eq srv123" ; count = 3; arrayInArray = $false }
        @{ FilterString = @("name -eq srv123", "name -eq srv321") ; count = 2; arrayInArray = $true }
    ) {
        $filterArray = ConvertTo-FMFilterArray -Filter $filterString #-Verbose
        Write-PSFMessage "Typ= $($filterArray.gettype())" -Level Host
        $filterArray -is [array] | Should -BeTrue
        $filterArray | Should -HaveCount $count
        if ($arrayInArray){
            foreach($filter in $filterArray){
                $filter -is [array] | Should -BeTrue
                $filter | Should -HaveCount 3
            }
        }
    }
}