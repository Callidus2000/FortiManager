function Merge-FMStringHashMap {
    <#
    .SYNOPSIS
    Helper funtion to replace placeholders in an url with values from a hashtable.

    .DESCRIPTION
    Helper funtion to replace placeholders in an url with values from a hashtable.

    .PARAMETER String
    The string with placeholders



    .EXAMPLE
    $dataTable=@{device='FIREWALL';vdom='myVDOM'
    $url="/pm/config/device/{{device}}/vdom/{{vdom}}/system/zone"
    Merge-FMStringHashMap -String $url -Data $dataTable

    Returns "/pm/config/device/FIREWALL/vdom/myVDOM/system/zone"
    .EXAMPLE
    $dataTable=@{device='FIREWALL';vdom='myVDOM'
    "/pm/config/device/{{device}}/vdom/{{vdom}}/system/zone" | Merge-FMStringHashMap -String $url -Data $dataTable

    Returns "/pm/config/device/FIREWALL/vdom/myVDOM/system/zone"

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
    $result=$String
    foreach($key in $data.Keys){
        $result = $result -replace "[$PlaceHolderStart]+$key[$PlaceHolderEnd]+", $data.$key
    }
    $result
}