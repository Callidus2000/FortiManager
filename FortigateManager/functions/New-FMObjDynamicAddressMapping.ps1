function New-FMObjDynamicAddressMapping {
    <#
    .SYNOPSIS
    Creates a new DynamicMapping object with the given attributes for Address-Objects.

    .DESCRIPTION
    Creates a new DynamicMapping object with the given attributes.
    The result can be used for DynamicMapping parameters
    Each parameter corresponds to an address attribute with the exception of
    IpRange. This will be split into the attributes StartIp and EndIp

    .PARAMETER ImageBase64
    Parameter description

    .PARAMETER Scope
    Parameter description

    .PARAMETER AllowRouting
    Parameter description

    .PARAMETER AssociatedInterface
    Parameter description

    .PARAMETER CacheTtl
    Parameter description

    .PARAMETER ClearpassSpt
    Parameter description

    .PARAMETER Color
    Parameter description

    .PARAMETER Comment
    Parameter description

    .PARAMETER Country
    Parameter description

    .PARAMETER Dirty
    Parameter description

    .PARAMETER EndIp
    Parameter description

    .PARAMETER EndMac
    Parameter description

    .PARAMETER EpgName
    Parameter description

    .PARAMETER FabricObject
    Parameter description

    .PARAMETER Filter
    Parameter description

    .PARAMETER Fqdn
    Parameter description

    .PARAMETER FssoGroup
    Parameter description

    .PARAMETER GlobalObject
    Parameter description

    .PARAMETER Interface
    Parameter description

    .PARAMETER IpRange
    Parameter description

    .PARAMETER Macaddr
    Parameter description

    .PARAMETER NodeIpOnly
    Parameter description

    .PARAMETER ObjId
    Parameter description

    .PARAMETER ObjTag
    Parameter description

    .PARAMETER ObjType
    Parameter description

    .PARAMETER Organization
    Parameter description

    .PARAMETER PatternEnd
    Parameter description

    .PARAMETER PatternStart
    Parameter description

    .PARAMETER PolicyGroup
    Parameter description

    .PARAMETER Sdn
    Parameter description

    .PARAMETER SdnAddrType
    Parameter description

    .PARAMETER SdnTag
    Parameter description

    .PARAMETER StartIp
    Parameter description

    .PARAMETER StartMac
    Parameter description

    .PARAMETER SubType
    Parameter description

    .PARAMETER Subnet
    Parameter description

    .PARAMETER SubnetName
    Parameter description

    .PARAMETER TagDetectionLevel
    Parameter description

    .PARAMETER TagType
    Parameter description

    .PARAMETER Tags
    Parameter description

    .PARAMETER Tenant
    Parameter description

    .PARAMETER Type
    Parameter description

    .PARAMETER Url
    Parameter description

    .PARAMETER Uuid
    Parameter description

    .PARAMETER Visibility
    Parameter description

    .PARAMETER Wildcard
    Parameter description

    .PARAMETER WildcardFqdn
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
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$Scope,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$AllowRouting,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$AssociatedInterface,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$CacheTtl = -1,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$ClearpassSpt,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$Color = -1,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Comment,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Country,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Dirty,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$EndIp,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$EndMac,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$EpgName,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$FabricObject,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Filter,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Fqdn,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$FssoGroup,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$GlobalObject = -1,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Interface,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$IpRange,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$Macaddr,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$NodeIpOnly,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$ObjId,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$ObjTag,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$ObjType,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Organization,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$PatternEnd = -1,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$PatternStart = -1,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$PolicyGroup,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Sdn,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$SdnAddrType,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$SdnTag,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$StartIp,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$StartMac,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$SubType,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Subnet,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$SubnetName,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$TagDetectionLevel,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$TagType,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$Tags,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Tenant,
        [parameter(mandatory = $true, ParameterSetName = "default")]
        [string]$Type,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Url,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Uuid,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$Visibility,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Wildcard,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$WildcardFqdn,
        [ValidateSet("Keep", "RemoveAttribute", "ClearContent")]
        [parameter(mandatory = $false, ValueFromPipeline = $false, ParameterSetName = "default")]
        $NullHandler = "RemoveAttribute"
    )
    if ($IpRange) {
        $singleIps = ConvertTo-FMStartEndIp -IpRange $IpRange
        $StartIp = $singleIps[0]
        $EndIp = $singleIps[1]
    }elseif ($Subnet) { $Subnet = Test-FMSubnetCidr -Subnet $Subnet }

    $data = @{
        '_image-base64'        = "$ImageBase64"
        '_scope'               = @($Scope)
        'allow-routing'        = "$AllowRouting"
        'associated-interface' = "$AssociatedInterface"
        'cache-ttl'            = $CacheTtl
        'clearpass-spt'        = "$ClearpassSpt"
        'color'                = $Color
        'comment'              = "$Comment"
        'country'              = "$Country"
        'dirty'                = "$Dirty"
        'end-ip'               = "$EndIp"
        'end-mac'              = "$EndMac"
        'epg-name'             = "$EpgName"
        'fabric-object'        = "$FabricObject"
        'filter'               = "$Filter"
        'fqdn'                 = "$Fqdn"
        'fsso-group'           = @($FssoGroup)
        'global-object'        = $GlobalObject
        'interface'            = "$Interface"
        'macaddr'              = @($Macaddr)
        'node-ip-only'         = "$NodeIpOnly"
        'obj-id'               = "$ObjId"
        'obj-tag'              = "$ObjTag"
        'obj-type'             = "$ObjType"
        'organization'         = "$Organization"
        'pattern-end'          = $PatternEnd
        'pattern-start'        = $PatternStart
        'policy-group'         = "$PolicyGroup"
        'sdn'                  = "$Sdn"
        'sdn-addr-type'        = "$SdnAddrType"
        'sdn-tag'              = "$SdnTag"
        'start-ip'             = "$StartIp"
        'start-mac'            = "$StartMac"
        'sub-type'             = "$SubType"
        'subnet'               = "$Subnet"
        'subnet-name'          = "$SubnetName"
        'tag-detection-level'  = "$TagDetectionLevel"
        'tag-type'             = "$TagType"
        'tags'                 = @($Tags)
        'tenant'               = "$Tenant"
        'type'                 = "$Type"
        'url'                  = "$Url"
        'uuid'                 = "$Uuid"
        'visibility'           = "$Visibility"
        'wildcard'             = "$Wildcard"
        'wildcard-fqdn'        = "$WildcardFqdn"

    }
    return $data | Remove-FMNullValuesFromHashtable -NullHandler $NullHandler
}
