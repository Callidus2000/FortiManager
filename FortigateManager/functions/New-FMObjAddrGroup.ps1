function New-FMObjAddrGroup {
    [CmdletBinding()]
    param (
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$Dynamic_mapping,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Type,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Comment,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$ExcludeMember,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$ImageBase64,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$Tagging,
        [parameter(mandatory = $true, ParameterSetName = "default")]
        [System.Object[]]$Member,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$FabricObject,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Category,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Uuid,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$AllowRouting,
        [parameter(mandatory = $true, ParameterSetName = "default")]
        [string]$Name,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$Color = -1,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Exclude,
        [ValidateSet("Keep", "RemoveAttribute", "ClearContent")]
        [parameter(mandatory = $false, ValueFromPipeline = $false, ParameterSetName = "default")]
        $NullHandler = "RemoveAttribute"
    )
    $data = @{
        'dynamic_mapping' = @($Dynamic_mapping)
        'type'            = "$Type"
        'comment'         = "$Comment"
        'exclude-member'  = @($ExcludeMember)
        '_image-base64'   = "$ImageBase64"
        'tagging'         = @($Tagging)
        'member'          = @($Member)
        'fabric-object'   = "$FabricObject"
        'category'        = "$Category"
        'uuid'            = "$Uuid"
        'allow-routing'   = "$AllowRouting"
        'name'            = "$Name"
        'color'           = $Color
        'exclude'         = "$Exclude"

    }
    return $data | Remove-FMNullValuesFromHashtable -NullHandler $NullHandler
}
