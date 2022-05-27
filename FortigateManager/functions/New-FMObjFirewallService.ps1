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
    if ($Protocol -in @("IP", "TCP/UDP/SCTP") -and [string]::IsNullOrEmpty($Iprange)) {
        $Iprange = '0.0.0.0'
    }
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
        'iprange'             = $Iprange
        'name'                = "$Name"
        'protocol'            = "$Protocol"
        'protocol-number'     = $ProtocolNumber
        'proxy'               = "$Proxy"
        'sctp-portrange'      = "$SctpPortrange"
        'session-ttl'         = $SessionTtl
        'tcp-halfclose-timer' = $TcpHalfcloseTimer
        'tcp-halfopen-timer'  = $TcpHalfopenTimer
        'tcp-portrange'       = $TcpPortrange -split ','
        'tcp-rst-timer'       = $TcpRstTimer
        'tcp-timewait-timer'  = $TcpTimewaitTimer
        'udp-idle-timer'      = $UdpIdleTimer
        'udp-portrange'       = $UdpPortrange -split ','
        'visibility'          = "$Visibility"
    }
    return $data | Remove-FMNullValuesFromHashtable -NullHandler $NullHandler
}
