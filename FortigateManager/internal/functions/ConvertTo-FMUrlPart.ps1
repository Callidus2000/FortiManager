function ConvertTo-FMUrlPart {
    <#
    .SYNOPSIS
    Helper funtion to escape characters which cannot be used within an URL parameter.

    .DESCRIPTION
    Helper funtion to escape characters which cannot be used within an URL parameter.

    .PARAMETER Input
    The parameter which has to be replaced.

    .EXAMPLE
    $apiCallParameter.Path = "/pm/config/adom/$explicitADOM/obj/firewall/address/$($Name|ConvertTo-FMUrlPart)"

    Creates a path for a named address.

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param (
        [parameter(mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "default")]
        [string[]]$Input
    )

    begin {
        $resultList=@()
    }

    process {
        foreach($string in $Input){
            $modifiedString=$string -replace '/', "\/"
            Write-PSFMessage -Level Debug "Replacing String $string Result $modifiedString"
            $resultList += $modifiedString
        }
    }

    end {
        if ($resultList.count -eq 1){
            return $resultList[0]
        }
        return $resultList
    }
}