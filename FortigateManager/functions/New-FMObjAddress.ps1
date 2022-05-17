function New-FMObjAddress {
    <#
    .SYNOPSIS
    Helper for creating new Address-Objects.

    .DESCRIPTION
    Helper for creating new Address-Objects.
    Each parameter corresponds to an address attribute with the exception of
    IpRange. This will be split into the attributes StartIp and EndIp

    .PARAMETER ImageBase64
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

    .PARAMETER Dynamic_mapping
    Parameter description

    .PARAMETER EndIp
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

    .PARAMETER Interface
    Parameter description

    .PARAMETER IpRange
    Parameter description

    .PARAMETER List
    Parameter description

    .PARAMETER Macaddr
    Parameter description

    .PARAMETER Name
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

    .PARAMETER Tagging
    Parameter description

    .PARAMETER Tenant
    Parameter description

    .PARAMETER Type
    Parameter description

    .PARAMETER Uuid
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
        [System.Object[]]$Dynamic_mapping,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$EndIp,
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
        [string]$Interface,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$IpRange,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$List,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$Macaddr,
        [parameter(mandatory = $true, ParameterSetName = "default")]
        [string]$Name,
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
        [System.Object[]]$Tagging,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Tenant,
        [parameter(mandatory = $true, ParameterSetName = "default")]
        [ValidateSet("ipmask", "iprange", "dynamic", "fqdn")]
        [string]$Type,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Uuid,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Wildcard,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$WildcardFqdn,
        [ValidateSet("Keep", "RemoveAttribute", "ClearContent")]
        [parameter(mandatory = $false, ValueFromPipeline = $false, ParameterSetName = "default")]
        $NullHandler = "RemoveAttribute"
    )
    if ($IpRange){
        Write-PSFMessage "Extracting Start- and End-IP from Range $IpRange"
        $regex = "(\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b)[ -]+(\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b)"
        $rangeMatches=$IpRange|Select-String -Pattern $regex
        $StartIp = $rangeMatches.Matches[0].Groups[1].Value
        $EndIp = $rangeMatches.Matches[0].Groups[2].Value
        Write-PSFMessage "StartIP=$StartIp  EndIp=$EndIp"
    }
    $data = @{
        '_image-base64'        = "$ImageBase64"
        'allow-routing'        = "$AllowRouting"
        'associated-interface' = "$AssociatedInterface"
        'cache-ttl'            = $CacheTtl
        'clearpass-spt'        = "$ClearpassSpt"
        'color'                = $Color
        'comment'              = "$Comment"
        'country'              = "$Country"
        'dirty'                = "$Dirty"
        'dynamic_mapping'      = @($Dynamic_mapping)
        'end-ip'               = "$EndIp"
        'epg-name'             = "$EpgName"
        'fabric-object'        = "$FabricObject"
        'filter'               = "$Filter"
        'fqdn'                 = "$Fqdn"
        'fsso-group'           = @($FssoGroup)
        'interface'            = "$Interface"
        'list'                 = @($List)
        'macaddr'              = @($Macaddr)
        'name'                 = "$Name"
        'node-ip-only'         = "$NodeIpOnly"
        'obj-id'               = "$ObjId"
        'obj-tag'              = "$ObjTag"
        'obj-type'             = "$ObjType"
        'organization'         = "$Organization"
        'policy-group'         = "$PolicyGroup"
        'sdn'                  = "$Sdn"
        'sdn-addr-type'        = "$SdnAddrType"
        'sdn-tag'              = "$SdnTag"
        'start-ip'             = "$StartIp"
        'sub-type'             = "$SubType"
        'subnet'               = "$Subnet"
        'subnet-name'          = "$SubnetName"
        'tag-detection-level'  = "$TagDetectionLevel"
        'tag-type'             = "$TagType"
        'tagging'              = @($Tagging)
        'tenant'               = "$Tenant"
        'type'                 = "$Type"
        'uuid'                 = "$Uuid"
        'wildcard'             = "$Wildcard"
        'wildcard-fqdn'        = "$WildcardFqdn"
    }
    $data = $data | Remove-FMNullValuesFromHashtable -NullHandler $NullHandler
    if ($data.subnet){
        Write-PSFMessage "Converting ipMask $($data.subnet) to CIDR Notation if neccessary"
        $data.subnet = Convert-FMSubnetMask -Target CIDR -IPMask $data.subnet
        Write-PSFMessage " > ipMask= $($data.subnet)"
    }
    return $data
}
