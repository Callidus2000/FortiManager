function Add-FMFirewallPolicy {
    <#
    .SYNOPSIS
    Adds new firewall policies to the given ADOM and policy package.

    .DESCRIPTION
    Adds new firewall policies to the given ADOM and policy package. This
    function adds the policy to the End of the Package. If you need it elsewhere
    you have to use ""

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER Package
    The name of the policy package

    .PARAMETER Policy
    The new policy, generated e.g. by using New-FMObjAddress

    .PARAMETER Overwrite
    If used and an policy with the given name already exists the data will be
    overwritten.

    .EXAMPLE
    #To Be Provided

    Later
    .NOTES
    General notes
    #>
    param (
        [parameter(Mandatory = $false)]
        $Connection = (Get-FMLastConnection),
        [string]$ADOM,
        [parameter(mandatory = $true, ParameterSetName = "default")]
        [string]$Package,
        [parameter(mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "default")]
        [object[]]$Policy,
        [switch]$Overwrite,
        [bool]$EnableException = $true
    )
    begin {
        $policyList = @()
        $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM
        Write-PSFMessage "`$explicitADOM=$explicitADOM"
    }
    process {
        $Policy | ForEach-Object {
            $policyList += $_ | ConvertTo-PSFHashtable -Include @(
                "action"
                "anti-replay"
                "application-list"
                "auth-cert"
                "auth-path"
                "auth-redirect-addr"
                "auto-asic-offload"
                "av-profile"
                "block-notification"
                "captive-portal-exempt"
                "capture-packet"
                "cifs-profile"
                "comments"
                "custom-log-fields"
                "decrypted-traffic-mirror"
                "delay-tcp-npu-session"
                "diffserv-forward"
                "diffserv-reverse"
                "diffservcode-forward"
                "diffservcode-rev"
                "disclaimer"
                "dlp-profile"
                "dnsfilter-profile"
                "dsri"
                "dstaddr"
                "dstaddr-negate"
                "dstaddr6"
                "dstintf"
                "dynamic-shaping"
                "email-collect"
                "emailfilter-profile"
                "fec"
                "file-filter-profile"
                "firewall-session-dirty"
                "fixedport"
                "fsso-agent-for-ntlm"
                "fsso-groups"
                "geoip-anycast"
                "geoip-match"
                "global-label"
                "groups"
                "gtp-profile"
                "http-policy-redirect"
                "icap-profile"
                "identity-based-route"
                "inbound"
                "inspection-mode"
                "internet-service"
                "internet-service-custom"
                "internet-service-custom-group"
                "internet-service-group"
                "internet-service-name"
                "internet-service-negate"
                "internet-service-src"
                "internet-service-src-custom"
                "internet-service-src-custom-group"
                "internet-service-src-group"
                "internet-service-src-name"
                "internet-service-src-negate"
                "ippool"
                "ips-sensor"
                "label"
                "logtraffic"
                "logtraffic-start"
                "match-vip"
                "match-vip-only"
                "name"
                "nat"
                "nat46"
                "nat64"
                "natinbound"
                "natip"
                "natoutbound"
                "np-acceleration"
                "ntlm"
                "ntlm-enabled-browsers"
                "ntlm-guest"
                "outbound"
                "passive-wan-health-measurement"
                "per-ip-shaper"
                "permit-any-host"
                "permit-stun-host"
                "pfcp-profile"
                "policy-expiry"
                "policy-expiry-date"
                # "policyid"
                "poolname"
                "poolname6"
                "profile-group"
                "profile-protocol-options"
                "profile-type"
                "radius-mac-auth-bypass"
                "redirect-url"
                "replacemsg-override-group"
                "reputation-direction"
                "reputation-minimum"
                "rtp-addr"
                "rtp-nat"
                "schedule"
                "schedule-timeout"
                "scope member"
                "sctp-filter-profile"
                "send-deny-packet"
                "service"
                "service-negate"
                "session-ttl"
                "sgt"
                "sgt-check"
                "src-vendor-mac"
                "srcaddr"
                "srcaddr-negate"
                "srcaddr6"
                "srcintf"
                "ssh-filter-profile"
                "ssh-policy-redirect"
                "ssl-ssh-profile"
                "status"
                "tcp-mss-receiver"
                "tcp-mss-sender"
                "tcp-session-without-syn"
                "timeout-send-rst"
                "tos"
                "tos-mask"
                "tos-negate"
                "traffic-shaper"
                "traffic-shaper-reverse"
                "users"
                "utm-status"
                # "uuid"
                "videofilter-profile"
                "vlan-cos-fwd"
                "vlan-cos-rev"
                "vlan-filter"
                "voip-profile"
                "vpntunnel"
                "waf-profile"
                "wanopt"
                "wanopt-detection"
                "wanopt-passive-opt"
                "wanopt-peer"
                "wanopt-profile"
                "wccp"
                "webcache"
                "webcache-https"
                "webfilter-profile"
                "webproxy-forward-server"
                "webproxy-profile"
                "ztna-ems-tag"
                "ztna-geo-tag"
                "ztna-status"
            )
        }
    }
    end {
        $apiCallParameter = @{
            EnableException     = $EnableException
            Connection          = $Connection
            LoggingAction       = "Add-FMFirewallPolicy"
            LoggingActionValues = @($policyList.count, $explicitADOM, $Package)
            method              = "add"
            Path                = "/pm/config/adom/$explicitADOM/pkg/$Package/firewall/policy"
            Parameter           = @{
                "data" = $policyList
            }
        }
        if ($Overwrite) {
            Write-PSFMessage "Existing data should be overwritten"
            $apiCallParameter.method = "set"
        }
        $result = Invoke-FMAPI @apiCallParameter
        if (-not $EnableException) {
            return ($null -ne $result)
        }
    }
}
