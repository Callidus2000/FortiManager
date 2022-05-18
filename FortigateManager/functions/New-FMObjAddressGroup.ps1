function New-FMObjAddressGroup {
    [CmdletBinding()]
    param (
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$ImageBase64,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$AllowRouting,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Category,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$Color = -1,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Comment,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$DynamicMapping,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Exclude,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string[]]$ExcludeMember,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$FabricObject,
        [parameter(mandatory = $true, ParameterSetName = "default")]
        [string[]]$Member,
        [parameter(mandatory = $true, ParameterSetName = "default")]
        [string]$Name,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$Tagging,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Type,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Uuid,
        [ValidateSet("Keep", "RemoveAttribute", "ClearContent")]
        [parameter(mandatory = $false, ValueFromPipeline = $false, ParameterSetName = "default")]
        $NullHandler = "RemoveAttribute"
    )
    $data = @{
        '_image-base64'   = "$ImageBase64"
        'allow-routing'   = "$AllowRouting"
        'category'        = "$Category"
        'color'           = $Color
        'comment'         = "$Comment"
        'dynamic_mapping' = @($DynamicMapping)
        'exclude'         = "$Exclude"
        'exclude-member'  = @($ExcludeMember)
        'fabric-object'   = "$FabricObject"
        'member'          = @($Member)
        'name'            = "$Name"
        'tagging'         = @($Tagging)
        'type'            = "$Type"
        'uuid'            = "$Uuid"
    }
    return $data | Remove-FMNullValuesFromHashtable -NullHandler $NullHandler
}
