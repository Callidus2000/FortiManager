function New-FMObjAddressGroup {
    <#
    .SYNOPSIS
    Helper for creating new Addressgroup-Objects.

    .DESCRIPTION
    Helper for creating new Addressgroup-Objects.
    Each parameter corresponds to an addressgroup attribute with the exception of
    IpRange. This will be split into the attributes StartIp and EndIp

    .PARAMETER ImageBase64
    Parameter description

    .PARAMETER AllowRouting
    Parameter description

    .PARAMETER Category
    Parameter description

    .PARAMETER Color
    Parameter description

    .PARAMETER Comment
    Parameter description

    .PARAMETER DynamicMapping
    Parameter description

    .PARAMETER Exclude
    Parameter description

    .PARAMETER ExcludeMember
    Parameter description

    .PARAMETER FabricObject
    Parameter description

    .PARAMETER Member
    Parameter description

    .PARAMETER Name
    Parameter description

    .PARAMETER Tagging
    Parameter description

    .PARAMETER Type
    Parameter description

    .PARAMETER Uuid
    Parameter description

    .PARAMETER NullHandler
    Parameter description

  	.PARAMETER EnableException
	Should Exceptions been thrown?

    .EXAMPLE
    An example

    may be provided later

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessforStateChangingFunctions", "")]
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
        [parameter(mandatory = $false, ParameterSetName = "default")]
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
