﻿<#
This is an example configuration file

By default, it is enough to have a single one of them,
however if you have enough configuration settings to justify having multiple copies of it,
feel totally free to split them into multiple files.
#>

<#
# Example Configuration
Set-PSFConfig -Module 'FortigateManager' -Name 'Example.Setting' -Value 10 -Initialize -Validation 'integer' -Handler { } -Description "Example configuration setting. Your module can then use the setting using 'Get-PSFConfigValue'"
#>

Set-PSFConfig -Module 'FortigateManager' -Name 'Import.DoDotSource' -Value $false -Initialize -Validation 'bool' -Description "Whether the module files should be dotsourced on import. By default, the files of this module are read as string value and invoked, which is faster but worse on debugging."
Set-PSFConfig -Module 'FortigateManager' -Name 'Import.IndividualFiles' -Value $false -Initialize -Validation 'bool' -Description "Whether the module files should be imported individually. During the module build, all module code is compiled into few files, which are imported instead by default. Loading the compiled versions is faster, using the individual files is easier for debugging and testing out adjustments."
Set-PSFConfig -Module 'FortigateManager' -Name 'Logging.Api' -Value "Host" -Initialize -Validation string -Description "Level Invoke-API should log to"

# For quick collection of valid attibutes copy an example hashtable to the clipboard and run
# Get-Clipboard | ConvertFrom-Json | ConvertTo-PSFHashtable | Select-Object -ExpandProperty keys | wrap "'" "'" | join ',' | Set-Clipboard -PassThru



Set-PSFConfig -Module 'FortigateManager' -Name 'ValidAttr.FirewallService' -Value @('fabric-object', 'tcp-portrange', 'visibility', 'tcp-halfclose-timer', 'iprange', 'name', 'udp-idle-timer', 'app-category', 'icmptype', 'udp-portrange', 'comment', 'session-ttl', 'helper', 'protocol', 'icmpcode', 'tcp-rst-timer', 'color', 'tcp-timewait-timer', 'sctp-portrange', 'protocol-number', 'application', 'check-reset-range', 'tcp-halfopen-timer', 'app-service-type', 'fqdn', 'category', 'proxy') -Initialize -Validation stringarray -Description "Which attributes are valid for firewall Services?"
Set-PSFConfig -Module 'FortigateManager' -Name 'ValidAttr.FirewallPolicy' -Value @("action", "anti-replay", "application-list", "auth-cert", "auth-path", "auth-redirect-addr", "auto-asic-offload", "av-profile", "block-notification", "captive-portal-exempt", "capture-packet", "cifs-profile", "comments", "custom-log-fields", "decrypted-traffic-mirror", "delay-tcp-npu-session", "diffserv-forward", "diffserv-reverse", "diffservcode-forward", "diffservcode-rev", "disclaimer", "dlp-profile", "dnsfilter-profile", "dsri", "dstaddr", "dstaddr-negate", "dstaddr6", "dstintf", "dynamic-shaping", "email-collect", "emailfilter-profile", "fec", "file-filter-profile", "firewall-session-dirty", "fixedport", "fsso-agent-for-ntlm", "fsso-groups", "geoip-anycast", "geoip-match", "global-label", "groups", "gtp-profile", "http-policy-redirect", "icap-profile", "identity-based-route", "inbound", "inspection-mode", "internet-service", "internet-service-custom", "internet-service-custom-group", "internet-service-group", "internet-service-name", "internet-service-negate", "internet-service-src", "internet-service-src-custom", "internet-service-src-custom-group", "internet-service-src-group", "internet-service-src-name", "internet-service-src-negate", "ippool", "ips-sensor", "label", "logtraffic", "logtraffic-start", "match-vip", "match-vip-only", "name", "nat", "nat46", "nat64", "natinbound", "natip", "natoutbound", "np-acceleration", "ntlm", "ntlm-enabled-browsers", "ntlm-guest", "outbound", "passive-wan-health-measurement", "per-ip-shaper", "permit-any-host", "permit-stun-host", "pfcp-profile", "policyid", "policy-expiry", "policy-expiry-date", "poolname", "poolname6", "profile-group", "profile-protocol-options", "profile-type", "radius-mac-auth-bypass", "redirect-url", "replacemsg-override-group", "reputation-direction", "reputation-minimum", "rtp-addr", "rtp-nat", "schedule", "schedule-timeout", "scope member", "sctp-filter-profile", "send-deny-packet", "service", "service-negate", "session-ttl", "sgt", "sgt-check", "src-vendor-mac", "srcaddr", "srcaddr-negate", "srcaddr6", "srcintf", "ssh-filter-profile", "ssh-policy-redirect", "ssl-ssh-profile", "status", "tcp-mss-receiver", "tcp-mss-sender", "tcp-session-without-syn", "timeout-send-rst", "tos", "tos-mask", "tos-negate", "traffic-shaper", "traffic-shaper-reverse", "users", "utm-status", "videofilter-profile", "vlan-cos-fwd", "vlan-cos-rev", "vlan-filter", "voip-profile", "vpntunnel", "waf-profile", "wanopt", "wanopt-detection", "wanopt-passive-opt", "wanopt-peer", "wanopt-profile", "wccp", "webcache", "webcache-https", "webfilter-profile", "webproxy-forward-server", "webproxy-profile", "ztna-ems-tag", "ztna-geo-tag", "ztna-status") -Initialize -Validation stringarray -Description "Which attributes are valid for firewall Policy?"
Set-PSFConfig -Module 'FortigateManager' -Name 'ValidAttr.FirewallAddress' -Value @('tag-detection-level', 'end-ip', 'fabric-object', 'name', 'sub-type', 'fsso-group', 'node-ip-only', 'subnet-name', 'sdn-tag', 'dynamic_mapping', 'filter', 'comment', 'organization', 'sdn', '_image-base64', 'sdn-addr-type', 'tagging', 'policy-group', 'macaddr', 'obj-type', 'dirty', 'allow-routing', 'color', 'country', 'interface', 'wildcard', 'start-ip', 'epg-name', 'obj-tag', 'wildcard-fqdn', 'subnet', 'type', 'fqdn', 'associated-interface', 'list', 'tag-type', 'tenant', 'clearpass-spt', 'cache-ttl') -Initialize -Validation stringarray -Description "Which attributes are valid for firewall addresses?"
Set-PSFConfig -Module 'FortigateManager' -Name 'ValidAttr.FirewallAddressGroups' -Value @('color', 'dynamic_mapping', 'member', 'type', 'tagging', 'comment', 'category', 'exclude-member', 'name', '_image-base64', 'exclude', 'fabric-object', 'allow-routing') -Initialize -Validation stringarray -Description "Which attributes are valid for firewall address groups?"
Set-PSFConfig -Module 'FortigateManager' -Name 'ValidAttr.FirewallInterface' -Value @('color', 'zone-only', 'description', 'ingress-shaping-profile', 'defmap-zonemember', 'single-intf', 'platform_mapping', 'egress-shaping-profile', 'defmap-intf', 'wildcard-intf', 'dynamic_mapping', 'name', 'default-mapping', 'defmap-intrazone-deny', 'wildcard') -Initialize -Validation stringarray -Description "Which attributes are valid for firewall interfaces?"