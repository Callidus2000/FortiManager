function New-FMObjAddress {
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
    return $data | Remove-FMNullValuesFromHashtable -NullHandler $NullHandler
}
