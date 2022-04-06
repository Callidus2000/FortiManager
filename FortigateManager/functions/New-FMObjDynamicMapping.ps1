function New-FMObjDynamicMapping {
    <#
    .SYNOPSIS
    Creates a new DynamicMapping object with the given attributes.

    .DESCRIPTION
    Creates a new DynamicMapping object with the given attributes.
    The result can be used for Dynamic_mapping parameters

    .PARAMETER ImageBase64
    Parameter description

    .PARAMETER Scope
    Parameter description

    .PARAMETER AllowRouting
    Parameter description

    .PARAMETER Category
    Parameter description

    .PARAMETER Color
    Parameter description

    .PARAMETER Comment
    Parameter description

    .PARAMETER Exclude
    Parameter description

    .PARAMETER ExcludeMember
    Parameter description

    .PARAMETER FabricObject
    Parameter description

    .PARAMETER GlobalObject
    Parameter description

    .PARAMETER Member
    Parameter description

    .PARAMETER Tags
    Parameter description

    .PARAMETER Type
    Parameter description

    .PARAMETER Uuid
    Parameter description

    .PARAMETER Visibility
    Parameter description

    .PARAMETER NullHandler
    Parameter description

    .EXAMPLE
    An example

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param (
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$ImageBase64,
        [parameter(mandatory = $true, ParameterSetName = "default")]
        [System.Object[]]$Scope,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$AllowRouting,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Category,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$Color = -1,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Comment,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Exclude,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string[]]$ExcludeMember,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$FabricObject,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$GlobalObject = -1,
        [parameter(mandatory = $true, ParameterSetName = "default")]
        [string[]]$Member,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string[]]$Tags,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Type,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Uuid,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$Visibility,
        [ValidateSet("Keep", "RemoveAttribute", "ClearContent")]
        [parameter(mandatory = $false, ValueFromPipeline = $false, ParameterSetName = "default")]
        $NullHandler = "RemoveAttribute"
    )
    $data = @{
        '_image-base64'  = "$ImageBase64"
        '_scope'         = @($Scope)
        'allow-routing'  = "$AllowRouting"
        'category'       = "$Category"
        'color'          = $Color
        'comment'        = "$Comment"
        'exclude'        = "$Exclude"
        'exclude-member' = @($ExcludeMember)
        'fabric-object'  = "$FabricObject"
        'global-object'  = $GlobalObject
        'member'         = @($Member)
        'tags'           = @($Tags)
        'type'           = "$Type"
        'uuid'           = "$Uuid"
        'visibility'     = "$Visibility"

    }
    return $data | Remove-FMNullValuesFromHashtable -NullHandler $NullHandler
}
