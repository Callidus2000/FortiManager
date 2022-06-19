Describe  "Connection tests" {
    BeforeAll {
        $whiteSpaceDemo = @{
            name     = "Foo "
            type     = "Bar"
            TypeName = " Foo Bar"
        }
        # . "C:\DEV\odin.git\GitHub\FortigateManager\FortigateManager\internal\functions\Remove-FMWhitespacesFromAttributes.ps1"
    }
    It "Remove Whitespace from Hashtable by parameter" {
        $cleanVersion = Remove-FMWhitespacesFromAttributes -InputObject $whiteSpaceDemo.Clone()
        $cleanVersion.name | Should -be "Foo"
        $cleanVersion.type | Should -be "Bar"
        $cleanVersion.TypeName | Should -be "Foo Bar"
    }
    It "Remove Whitespace from PSCustomObject by parameter" {
        $cleanVersion = Remove-FMWhitespacesFromAttributes -InputObject ([PSCustomObject]$whiteSpaceDemo.Clone())
        $cleanVersion.name | Should -be "Foo"
        $cleanVersion.type | Should -be "Bar"
        $cleanVersion.TypeName | Should -be "Foo Bar"
    }
    It "Remove Whitespace from Hashtable by Pipeline" {
        $cleanVersion = $whiteSpaceDemo.Clone() | Remove-FMWhitespacesFromAttributes
        $cleanVersion.name | Should -be "Foo"
        $cleanVersion.type | Should -be "Bar"
        $cleanVersion.TypeName | Should -be "Foo Bar"
    }
    It "Remove Whitespace from PSCustomObject by Pipeline" {
        $cleanVersion = ([PSCustomObject]$whiteSpaceDemo.Clone()) | Remove-FMWhitespacesFromAttributes
        $cleanVersion.name | Should -be "Foo"
        $cleanVersion.type | Should -be "Bar"
        $cleanVersion.TypeName | Should -be "Foo Bar"
    }

}