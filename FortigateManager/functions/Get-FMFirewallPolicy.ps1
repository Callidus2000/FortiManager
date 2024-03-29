﻿function Get-FMFirewallPolicy {
    <#
    .SYNOPSIS
    Queries existing IPv4/IPv6 policies.

    .DESCRIPTION
    Queries existing IPv4/IPv6 policies.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER EnableException
    If set to True, errors will throw an exception

    .PARAMETER Package
    The name of the policy package

    .PARAMETER Attr
    Parameter The name of the attribute to retrieve its datasource. Only used
    with datasrc option.

    .PARAMETER Fields
    Limit the output by returning only the attributes specified in the string
    array. If none specified, all attributes will be returned.

    .PARAMETER Filter
    Filter the result according to a set of criteria.For detailed help see
    about_FortigateManagerFilter

    .PARAMETER GetUsed
    Parameter description

    .PARAMETER Loadsub
    Enable or disable the return of any sub-objects. If not specified, the
    default is to return all sub-objects.

    .PARAMETER Option
    Set fetch option for the request. If no option is specified, by default the
    attributes of the objects will be returned. count - Return the number of
    matching entries instead of the actual entry data. scope member - Return a
    list of scope members along with other attributes. datasrc - Return all
    objects that can be referenced by an attribute. Require attr parameter. get
    reserved - Also return reserved objects in the result. syntax - Return the
    attribute syntax of a table or an object, instead of the actual entry data.
    All filter parameters will be ignored.

    .PARAMETER Range
    Limit the number of output. For a range of [a, n], the output will contain n
    elements, starting from the ath matching result.

    .PARAMETER Sortings
    Specify the sorting of the returned result.

    .PARAMETER IncludeHitCount
    Additional Switch; Query the current hitcount statistik and add the
    attributes to the result data as the following attributes:
    _byte
    _first_hit
    _first_session
    _hitcount
    _pkts
    _sesscount
    _first_hit
    _first_session
    _last_hit
    _last_session
    The _hitcount will be set to -1 if no statistics could be found.

    .PARAMETER IncludeHitCountForce
    Same as IncludeHitCount but the Data will be refreshed before.

    .PARAMETER NullHandler
    Parameter description

    .EXAMPLE
    An example

    may be provided later

    .NOTES
    See
    https://fndn.fortinet.net/index.php?/fortiapi/5-fortimanager/1636/5/pm/config/firewall/
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $false)]
        $Connection = (Get-FMLastConnection),
        [string]$ADOM,
        [bool]$EnableException = $true,
        [parameter(mandatory = $true, ParameterSetName = "default")]
        [PSFramework.TabExpansion.PsfArgumentCompleterAttribute("FortigateManager.FirewallPackage")]
        [string]$Package,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Attr,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("_policy_block", "action", "anti-replay", "application-list", "auth-cert", "auth-path", "auth-redirect-addr", "auto-asic-offload", "av-profile", "block-notification", "captive-portal-exempt", "capture-packet", "cifs-profile", "comments", "custom-log-fields", "decrypted-traffic-mirror", "delay-tcp-npu-session", "diffserv-forward", "diffserv-reverse", "diffservcode-forward", "diffservcode-rev", "disclaimer", "dlp-profile", "dnsfilter-profile", "dsri", "dstaddr", "dstaddr-negate", "dstaddr6", "dstintf", "dynamic-shaping", "email-collect", "emailfilter-profile", "fec", "file-filter-profile", "firewall-session-dirty", "fixedport", "fsso-agent-for-ntlm", "fsso-groups", "geoip-anycast", "geoip-match", "global-label", "groups", "gtp-profile", "http-policy-redirect", "icap-profile", "identity-based-route", "inbound", "inspection-mode", "internet-service", "internet-service-custom", "internet-service-custom-group", "internet-service-group", "internet-service-name", "internet-service-negate", "internet-service-src", "internet-service-src-custom", "internet-service-src-custom-group", "internet-service-src-group", "internet-service-src-name", "internet-service-src-negate", "ippool", "ips-sensor", "label", "logtraffic", "logtraffic-start", "match-vip", "match-vip-only", "name", "nat", "nat46", "nat64", "natinbound", "natip", "natoutbound", "np-acceleration", "ntlm", "ntlm-enabled-browsers", "ntlm-guest", "outbound", "passive-wan-health-measurement", "per-ip-shaper", "permit-any-host", "permit-stun-host", "pfcp-profile", "policy-expiry", "policy-expiry-date", "policyid", "poolname", "poolname6", "profile-group", "profile-protocol-options", "profile-type", "radius-mac-auth-bypass", "redirect-url", "replacemsg-override-group", "reputation-direction", "reputation-minimum", "rtp-addr", "rtp-nat", "schedule", "schedule-timeout", "sctp-filter-profile", "send-deny-packet", "service", "service-negate", "session-ttl", "sgt", "sgt-check", "src-vendor-mac", "srcaddr", "srcaddr-negate", "srcaddr6", "srcintf", "ssh-filter-profile", "ssh-policy-redirect", "ssl-ssh-profile", "status", "tcp-mss-receiver", "tcp-mss-sender", "tcp-session-without-syn", "timeout-send-rst", "tos", "tos-mask", "tos-negate", "traffic-shaper", "traffic-shaper-reverse", "users", "utm-status", "uuid", "videofilter-profile", "vlan-cos-fwd", "vlan-cos-rev", "vlan-filter", "voip-profile", "vpntunnel", "waf-profile", "wanopt", "wanopt-detection", "wanopt-passive-opt", "wanopt-peer", "wanopt-profile", "wccp", "webcache", "webcache-https", "webfilter-profile", "webproxy-forward-server", "webproxy-profile", "ztna-ems-tag", "ztna-geo-tag", "ztna-status")]
        [System.String[]]$Fields,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.String[]]$Filter,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$GetUsed = -1,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$Loadsub = -1,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("count", "scope member", "datasrc", "get reserved", "syntax")]
        [string]$Option,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$Range,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$Sortings,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [switch]$IncludeHitCount,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [switch]$IncludeHitCountForce,
        [ValidateSet("Keep", "RemoveAttribute", "ClearContent")]
        [parameter(mandatory = $false, ParameterSetName = "default")]
        $NullHandler = "RemoveAttribute"
    )
    # 'pkg_path'     = "$PkgPath"
    $Parameter = @{
        'attr'     = "$Attr"
        'fields'   = @($Fields)
        'filter'   = ($Filter | ConvertTo-FMFilterArray)
        'get used' = $GetUsed
        'loadsub'  = $Loadsub
        'option'   = "$Option"
        'range'    = @($Range)
        'sortings' = @($Sortings)
    } | Remove-FMNullValuesFromHashtable -NullHandler $NullHandler
    $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM -EnableException $EnableException
    $apiCallParameter = @{
        EnableException     = $EnableException
        Connection          = $Connection
        LoggingAction       = "Get-FMFirewallPolicy"
        LoggingActionValues = @($explicitADOM, $Package)
        method              = "get"
        Parameter           = $Parameter
        Path                = "/pm/config/adom/$explicitADOM/pkg/$Package/firewall/policy"
    }
    $result = Invoke-FMAPI @apiCallParameter
    Write-PSFMessage "Result-Status: $($result.result.status)"
    $policyData = $result.result.data
    if ($IncludeHitCount -or $IncludeHitCountForce) {
        $addAttributes = @('byte', 'first_hit', 'first_session', 'hitcount', 'pkts', 'sesscount')
        $addAttributesAsDate = @('first_hit', 'first_session', 'last_hit', 'last_session')
        Write-PSFMessage "Query hitcount statistics, statistics will be added as attributes: _byte, _first_hit, _first_session, _hitcount, _pkts, _sesscount, _first_hit, _first_session, _last_hit, _last_session"
        if($IncludeHitCountForce){
            $hitCountData = Get-FMFirewallHitCount -Package $Package -Force
        }else{
            $hitCountData = Get-FMFirewallHitCount -Package $Package
        }
        Write-PSFMessage "Associating hitcount data to policy rules"
        $hitCountDataHash = @{}
        $hitCountData.'firewall policy' | ForEach-Object { $hitCountDataHash.add("$($_.policyid)", $_) }
        $emptyCounter = @{
            byte          = -1
            hitcount      = -1
            pkts          = -1
            sesscount     = -1
            first_hit     = 0
            first_session = 0
            last_hit      = 0
            last_session  = 0
        }
        foreach ($policy in $policyData) {
            $counter = $hitCountDataHash."$($policy.policyid)"
            if ($null -eq $counter) {
                $counter = $emptyCounter
            }
            foreach ($attr in $addAttributes) {
                Add-Member -inputobject $policy -MemberType NoteProperty -Name "_$attr" -Value $counter.$attr -Force
            }
            foreach ($attr in $addAttributesAsDate) {
                Add-Member -inputobject $policy -MemberType NoteProperty -Name "_$attr" -Value (Convert-FMTimestampToDate $counter.$attr).toString() -Force
            }
        }
    }
    Write-PSFMessage "Associating hitcount data to policy rules - done"
    return $policyData
}
