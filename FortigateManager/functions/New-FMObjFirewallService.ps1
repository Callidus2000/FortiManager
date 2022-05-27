function New-FMObjFirewallService {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER AppCategory
    Parameter description

    .PARAMETER AppServiceType
    Parameter description

    .PARAMETER Application
    Parameter description

    .PARAMETER Category
    Parameter description

    .PARAMETER CheckResetRange
    Parameter description

    .PARAMETER Color
    Parameter description

    .PARAMETER Comment
    Parameter description

    .PARAMETER FabricObject
    Parameter description

    .PARAMETER Fqdn
    Parameter description

    .PARAMETER Helper
    Parameter description

    .PARAMETER Icmpcode
    Parameter description

    .PARAMETER Icmptype
    Parameter description

    .PARAMETER Iprange
    Parameter description

    .PARAMETER Name
    Parameter description

    .PARAMETER Protocol
    Parameter description

    .PARAMETER ProtocolNumber
    Parameter description

    .PARAMETER Proxy
    Parameter description

    .PARAMETER SctpPortrange
    Parameter description

    .PARAMETER SessionTtl
    Parameter description

    .PARAMETER TcpHalfcloseTimer
    Parameter description

    .PARAMETER TcpHalfopenTimer
    Parameter description

    .PARAMETER TcpPortrange
    Comma seperated List of Ports/Port-Ranges; if the source port should be limited use a colon for seperation
    E.g.
    80,443,8443:1-1000
    would allow access to 80&443 from every sourceport, but the destination 8443 is limited.

    .PARAMETER TcpRstTimer
    Parameter description

    .PARAMETER TcpTimewaitTimer
    Parameter description

    .PARAMETER UdpIdleTimer
    Parameter description

    .PARAMETER UdpPortrange
    Comma seperated List of Ports/Port-Ranges; if the source port should be limited use a colon for seperation
    E.g.
    80,443,8443:1-1000
    would allow access to 80&443 from every sourceport, but the destination 8443 is limited.


    .PARAMETER Visibility
    Parameter description

    .EXAMPLE
    An example

    may be provided later

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param (
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$AppCategory,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "app-id", "app-category")]
        [string]$AppServiceType,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$Application,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Category,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "default", "strict")]
        [string]$CheckResetRange,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$Color = -1,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Comment,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$FabricObject,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Fqdn,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "auto", "ftp", "tftp", "ras", "h323", "tns", "mms", "sip", "pptp", "rtsp", "dns-udp", "dns-tcp", "pmap", "rsh", "dcerpc", "mgcp", "gtp-c", "gtp-u", "gtp-b", "pfcp")]
        [string]$Helper,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$Icmpcode = -1,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$Icmptype = -1,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Iprange,
        [parameter(mandatory = $true, ParameterSetName = "default")]
        [string]$Name,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("ICMP", "IP", "TCP/UDP/SCTP", "ICMP6", "HTTP", "FTP", "CONNECT", "SOCKS", "ALL", "SOCKS-TCP", "SOCKS-UDP")]
        [string]$Protocol,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$ProtocolNumber = -1,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$Proxy,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$SctpPortrange,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$SessionTtl = -1,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$TcpHalfcloseTimer = -1,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$TcpHalfopenTimer = -1,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$TcpPortrange,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$TcpRstTimer = -1,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$TcpTimewaitTimer = -1,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$UdpIdleTimer = -1,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$UdpPortrange,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$Visibility,
        [ValidateSet("Keep", "RemoveAttribute", "ClearContent")]
        [parameter(mandatory = $false, ValueFromPipeline = $false, ParameterSetName = "default")]
        $NullHandler = "RemoveAttribute"
    )
    $data = @{
        'app-category'        = @($AppCategory)
        'app-service-type'    = "$AppServiceType"
        'application'         = @($Application)
        'category'            = "$Category"
        'check-reset-range'   = "$CheckResetRange"
        'color'               = $Color
        'comment'             = "$Comment"
        'fabric-object'       = "$FabricObject"
        'fqdn'                = "$Fqdn"
        'helper'              = "$Helper"
        'icmpcode'            = $Icmpcode
        'icmptype'            = $Icmptype
        'iprange'             = @($Iprange -split ',')
        'name'                = "$Name"
        'protocol'            = "$Protocol"
        'protocol-number'     = $ProtocolNumber
        'proxy'               = "$Proxy"
        'sctp-portrange'      = "$SctpPortrange"
        'session-ttl'         = $SessionTtl
        'tcp-halfclose-timer' = $TcpHalfcloseTimer
        'tcp-halfopen-timer'  = $TcpHalfopenTimer
        'tcp-portrange'       = "$TcpPortrange"
        'tcp-rst-timer'       = $TcpRstTimer
        'tcp-timewait-timer'  = $TcpTimewaitTimer
        'udp-idle-timer'      = $UdpIdleTimer
        'udp-portrange'       = @($UdpPortrange -split ',')
        'visibility'          = "$Visibility"
    }
    return $data | Remove-FMNullValuesFromHashtable -NullHandler $NullHandler
}
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

    .PARAMETER DynamicMapping
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

  	.PARAMETER EnableException
	Should Exceptions been thrown?

    .EXAMPLE
    An example

    may be provided later

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessforStateChangingFunctions', '')]
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
        [System.Object[]]$DynamicMapping,
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
        [parameter(mandatory = $false, ParameterSetName = "default")]
        $NullHandler = "RemoveAttribute"
    )
    if ($IpRange) {
        $singleIps = ConvertTo-FMStartEndIp -IpRange $IpRange
        $StartIp = $singleIps[0]
        $EndIp = $singleIps[1]
    }
    elseif ($Subnet) { $Subnet = Test-FMSubnetCidr -Subnet $Subnet }
    # if ($Subnet -match '^\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b$'){
    #     Write-PSFMessage "Subnet $Subnet is missing the subnet mask"
    #     $cidr=""
    #     switch -regex ($Subnet){
    #         '^\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b$'{$cidr="/32"}
    #         '^\b\d{1,3}\.\d{1,3}\.\d{1,3}\.0$'{$cidr="/24"}
    #         default{
    #             Write-PSFMessage "Cannot guess cidr for Subnet $Subnet"
    #         }
    #     }
    #     $Subnet+=$cidr
    #     Write-PSFMessage "New Subnet: $Subnet"
    # }
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
        'dynamic_mapping'      = @($DynamicMapping)
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
    if ($data.subnet) {
        Write-PSFMessage "Converting ipMask $($data.subnet) to CIDR Notation if neccessary"
        $data.subnet = Convert-FMSubnetMask -Target CIDR -IPMask $data.subnet
        Write-PSFMessage " > ipMask= $($data.subnet)"
    }
    return $data
}
