function Merge-FMStringHashMap {
    <#
    .SYNOPSIS
    Helper funtion to replace placeholders in an url with values from a hashtable.

    .DESCRIPTION
    Helper funtion to replace placeholders in an url with values from a hashtable.

    .PARAMETER String
    The string with placeholders. Placeholders may be enclosed with {...}  or þ...þ by default.

    .PARAMETER Data
    The hashtable with the data for the placeholders.

    .PARAMETER PlaceHolderStart
    If you need to change the placeholder enclosement then this is one of the needed parameters.

    .PARAMETER PlaceHolderEnd
    If you need to change the placeholder enclosement then this is one of the needed parameters.

    .EXAMPLE
    $dataTable=@{
            device='FIREWALL';
            vdom='myVDOM';
        }
    $url="/pm/config/device/{{device}}/vdom/{{vdom}}/system/zone"
    Merge-FMStringHashMap -String $url -Data $dataTable |Should -be
    $url|Merge-FMStringHashMap -Data $dataTable |Should -be "/pm/config/device/FIREWALL/vdom/myVDOM/system/zone"

    Returns both "/pm/config/device/FIREWALL/vdom/myVDOM/system/zone"

    .EXAMPLE
    $url="/pm/{keepMe}/device/{device}}/vdom/{vdom}}/system/zone"
    $url|Merge-FMStringHashMap -Data $dataTable

    Returns "/pm/{keepMe}/device/FIREWALL/vdom/myVDOM/system/zone"

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param (
        [parameter(mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "default")]
        [string]$String,
        [hashtable]$Data,
        [string]$PlaceHolderStart='{þ',
        [string]$PlaceHolderEnd='}þ'
    )
    begin{
    }
    process{
        $result=$String
        foreach($key in $data.Keys){
            $result = $result -replace "[$PlaceHolderStart]+$key[$PlaceHolderEnd]+", $data.$key
        }
        $result
    }
    end{
    }
}