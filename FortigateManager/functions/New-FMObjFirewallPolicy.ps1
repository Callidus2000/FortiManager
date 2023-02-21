function New-FMObjFirewallPolicy {
    <#
    .SYNOPSIS
    Creates a new Firewall Policy object with the given attributes.

    .DESCRIPTION
    Creates a new Firewall Policy object with the given attributes.

    .PARAMETER Policy_block
    Parameter description

    .PARAMETER Action
    Parameter description

    .PARAMETER AntiReplay
    Parameter description

    .PARAMETER ApplicationList
    Parameter description

    .PARAMETER AuthCert
    Parameter description

    .PARAMETER AuthPath
    Parameter description

    .PARAMETER AuthRedirectAddr
    Parameter description

    .PARAMETER AutoAsicOffload
    Parameter description

    .PARAMETER AvProfile
    Parameter description

    .PARAMETER BlockNotification
    Parameter description

    .PARAMETER CaptivePortalExempt
    Parameter description

    .PARAMETER CapturePacket
    Parameter description

    .PARAMETER CifsProfile
    Parameter description

    .PARAMETER Comments
    Parameter description

    .PARAMETER CustomLogFields
    Parameter description

    .PARAMETER DecryptedTrafficMirror
    Parameter description

    .PARAMETER DelayTcpNpuSession
    Parameter description

    .PARAMETER DiffservForward
    Parameter description

    .PARAMETER DiffservReverse
    Parameter description

    .PARAMETER DiffservcodeForward
    Parameter description

    .PARAMETER DiffservcodeRev
    Parameter description

    .PARAMETER Disclaimer
    Parameter description

    .PARAMETER DlpProfile
    Parameter description

    .PARAMETER DnsfilterProfile
    Parameter description

    .PARAMETER Dsri
    Parameter description

    .PARAMETER Dstaddr
    Parameter description

    .PARAMETER DstaddrNegate
    Parameter description

    .PARAMETER Dstaddr6
    Parameter description

    .PARAMETER Dstintf
    Parameter description

    .PARAMETER DynamicShaping
    Parameter description

    .PARAMETER EmailCollect
    Parameter description

    .PARAMETER EmailfilterProfile
    Parameter description

    .PARAMETER Fec
    Parameter description

    .PARAMETER FileFilterProfile
    Parameter description

    .PARAMETER FirewallSessionDirty
    Parameter description

    .PARAMETER Fixedport
    Parameter description

    .PARAMETER FssoAgentForNtlm
    Parameter description

    .PARAMETER FssoGroups
    Parameter description

    .PARAMETER GeoipAnycast
    Parameter description

    .PARAMETER GeoipMatch
    Parameter description

    .PARAMETER GlobalLabel
    Parameter description

    .PARAMETER Groups
    Parameter description

    .PARAMETER GtpProfile
    Parameter description

    .PARAMETER HttpPolicyRedirect
    Parameter description

    .PARAMETER IcapProfile
    Parameter description

    .PARAMETER IdentityBasedRoute
    Parameter description

    .PARAMETER Inbound
    Parameter description

    .PARAMETER InspectionMode
    Parameter description

    .PARAMETER InternetService
    Parameter description

    .PARAMETER InternetServiceCustom
    Parameter description

    .PARAMETER InternetServiceCustomGroup
    Parameter description

    .PARAMETER InternetServiceGroup
    Parameter description

    .PARAMETER InternetServiceName
    Parameter description

    .PARAMETER InternetServiceNegate
    Parameter description

    .PARAMETER InternetServiceSrc
    Parameter description

    .PARAMETER InternetServiceSrcCustom
    Parameter description

    .PARAMETER InternetServiceSrcCustomGroup
    Parameter description

    .PARAMETER InternetServiceSrcGroup
    Parameter description

    .PARAMETER InternetServiceSrcName
    Parameter description

    .PARAMETER InternetServiceSrcNegate
    Parameter description

    .PARAMETER Ippool
    Parameter description

    .PARAMETER IpsSensor
    Parameter description

    .PARAMETER Label
    Parameter description

    .PARAMETER Logtraffic
    Enable or disable logging. Log all sessions or security profile sessions.
    "disable" Disable all logging for this policy.
    "all"     Log all sessions accepted or denied by this policy.
    "utm"     Log traffic that has a security profile applied to it.

    Log 'Security Events' will only log Security (UTM) events (e.g. AV, IPS,
    firewall web filter), providing you have applied one of them to a firewall
    (rule) policy.
    'Log all sessions' will include traffic log include both match and non-match
    UTM profile defined.

    .PARAMETER LogtrafficStart
    Parameter description

    .PARAMETER MatchVip
    Parameter description

    .PARAMETER MatchVipOnly
    Parameter description

    .PARAMETER Name
    Parameter description

    .PARAMETER Nat
    Parameter description

    .PARAMETER Nat46
    Parameter description

    .PARAMETER Nat64
    Parameter description

    .PARAMETER Natinbound
    Parameter description

    .PARAMETER Natip
    Parameter description

    .PARAMETER Natoutbound
    Parameter description

    .PARAMETER NpAcceleration
    Parameter description

    .PARAMETER Ntlm
    Parameter description

    .PARAMETER NtlmEnabledBrowsers
    Parameter description

    .PARAMETER NtlmGuest
    Parameter description

    .PARAMETER Outbound
    Parameter description

    .PARAMETER PassiveWanHealthMeasurement
    Parameter description

    .PARAMETER PerIpShaper
    Parameter description

    .PARAMETER PermitAnyHost
    Parameter description

    .PARAMETER PermitStunHost
    Parameter description

    .PARAMETER PfcpProfile
    Parameter description

    .PARAMETER PolicyExpiry
    Parameter description

    .PARAMETER PolicyExpiryDate
    Parameter description

    .PARAMETER Policyid
    Parameter description

    .PARAMETER Poolname
    Parameter description

    .PARAMETER Poolname6
    Parameter description

    .PARAMETER ProfileGroup
    Parameter description

    .PARAMETER ProfileProtocolOptions
    Parameter description

    .PARAMETER ProfileType
    Parameter description

    .PARAMETER RadiusMacAuthBypass
    Parameter description

    .PARAMETER RedirectUrl
    Parameter description

    .PARAMETER ReplacemsgOverrideGroup
    Parameter description

    .PARAMETER ReputationDirection
    Parameter description

    .PARAMETER ReputationMinimum
    Parameter description

    .PARAMETER RtpAddr
    Parameter description

    .PARAMETER RtpNat
    Parameter description

    .PARAMETER Schedule
    Parameter description

    .PARAMETER ScheduleTimeout
    Parameter description

    .PARAMETER ScopeMember
    The "Install on" property of a firewall policy; undocumented within the API.

    .PARAMETER SctpFilterProfile
    Parameter description

    .PARAMETER SendDenyPacket
    Parameter description

    .PARAMETER Service
    Parameter description

    .PARAMETER ServiceNegate
    Parameter description

    .PARAMETER SessionTtl
    Parameter description

    .PARAMETER Sgt
    Parameter description

    .PARAMETER SgtCheck
    Parameter description

    .PARAMETER SrcVendorMac
    Parameter description

    .PARAMETER Srcaddr
    Parameter description

    .PARAMETER SrcaddrNegate
    Parameter description

    .PARAMETER Srcaddr6
    Parameter description

    .PARAMETER Srcintf
    Parameter description

    .PARAMETER SshFilterProfile
    Parameter description

    .PARAMETER SshPolicyRedirect
    Parameter description

    .PARAMETER SslSshProfile
    Parameter description

    .PARAMETER Status
    Parameter description

    .PARAMETER TcpMssReceiver
    Parameter description

    .PARAMETER TcpMssSender
    Parameter description

    .PARAMETER TcpSessionWithoutSyn
    Parameter description

    .PARAMETER TimeoutSendRst
    Parameter description

    .PARAMETER Tos
    Parameter description

    .PARAMETER TosMask
    Parameter description

    .PARAMETER TosNegate
    Parameter description

    .PARAMETER TrafficShaper
    Parameter description

    .PARAMETER TrafficShaperReverse
    Parameter description

    .PARAMETER Users
    Parameter description

    .PARAMETER UtmStatus
    Parameter description

    .PARAMETER Uuid
    Parameter description

    .PARAMETER VideofilterProfile
    Parameter description

    .PARAMETER VlanCosFwd
    Parameter description

    .PARAMETER VlanCosRev
    Parameter description

    .PARAMETER VlanFilter
    Parameter description

    .PARAMETER VoipProfile
    Parameter description

    .PARAMETER Vpntunnel
    Parameter description

    .PARAMETER WafProfile
    Parameter description

    .PARAMETER Wanopt
    Parameter description

    .PARAMETER WanoptDetection
    Parameter description

    .PARAMETER WanoptPassiveOpt
    Parameter description

    .PARAMETER WanoptPeer
    Parameter description

    .PARAMETER WanoptProfile
    Parameter description

    .PARAMETER Wccp
    Parameter description

    .PARAMETER Webcache
    Parameter description

    .PARAMETER WebcacheHttps
    Parameter description

    .PARAMETER WebfilterProfile
    Parameter description

    .PARAMETER WebproxyForwardServer
    Parameter description

    .PARAMETER WebproxyProfile
    Parameter description

    .PARAMETER ZtnaEmsTag
    Parameter description

    .PARAMETER ZtnaGeoTag
    Parameter description

    .PARAMETER ZtnaStatus
    Parameter description

    .PARAMETER NullHandler
    Parameter description

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
        [long]$Policy_block = -1,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("deny", "accept", "ipsec", "ssl-vpn", "redirect", "isolate")]
        [string]$Action,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$AntiReplay,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$ApplicationList,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$AuthCert,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$AuthPath,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$AuthRedirectAddr,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$AutoAsicOffload,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$AvProfile,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$BlockNotification,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$CaptivePortalExempt,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$CapturePacket,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$CifsProfile,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Comments,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$CustomLogFields,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$DecryptedTrafficMirror,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$DelayTcpNpuSession,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$DiffservForward,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$DiffservReverse,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$DiffservcodeForward,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$DiffservcodeRev,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$Disclaimer,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$DlpProfile,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$DnsfilterProfile,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$Dsri,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$Dstaddr,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$DstaddrNegate,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$Dstaddr6,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$Dstintf,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$DynamicShaping,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$EmailCollect,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$EmailfilterProfile,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$Fec,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$FileFilterProfile,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$FirewallSessionDirty,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$Fixedport,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$FssoAgentForNtlm,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$FssoGroups,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$GeoipAnycast,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$GeoipMatch,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$GlobalLabel,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$Groups,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$GtpProfile,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$HttpPolicyRedirect,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$IcapProfile,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$IdentityBasedRoute,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$Inbound,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$InspectionMode,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$InternetService,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$InternetServiceCustom,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$InternetServiceCustomGroup,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$InternetServiceGroup,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$InternetServiceName,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$InternetServiceNegate,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$InternetServiceSrc,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$InternetServiceSrcCustom,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$InternetServiceSrcCustomGroup,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$InternetServiceSrcGroup,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$InternetServiceSrcName,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$InternetServiceSrcNegate,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$Ippool,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$IpsSensor,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Label,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "all", "utm")]
        [string]$Logtraffic,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$LogtrafficStart,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$MatchVip,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$MatchVipOnly,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Name,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$Nat,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$Nat46,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$Nat64,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$Natinbound,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Natip,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$Natoutbound,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$NpAcceleration,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$Ntlm,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$NtlmEnabledBrowsers,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$NtlmGuest,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$Outbound,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$PassiveWanHealthMeasurement,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$PerIpShaper,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$PermitAnyHost,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$PermitStunHost,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$PfcpProfile,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$PolicyExpiry,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$PolicyExpiryDate,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$Policyid = -1,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$Poolname,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$Poolname6,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$ProfileGroup,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$ProfileProtocolOptions,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$ProfileType,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$RadiusMacAuthBypass,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$RedirectUrl,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$ReplacemsgOverrideGroup,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$ReputationDirection,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$ReputationMinimum = -1,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$RtpAddr,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$RtpNat,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Schedule = "always",
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$ScheduleTimeout,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [object[]]$ScopeMember,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$SctpFilterProfile,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$SendDenyPacket,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$Service,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$ServiceNegate,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$SessionTtl = -1,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$Sgt,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$SgtCheck,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$SrcVendorMac,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$Srcaddr,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$SrcaddrNegate,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$Srcaddr6,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$Srcintf,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$SshFilterProfile,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$SshPolicyRedirect,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$SslSshProfile,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$Status,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$TcpMssReceiver = -1,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$TcpMssSender = -1,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$TcpSessionWithoutSyn,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$TimeoutSendRst,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Tos,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$TosMask,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$TosNegate,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$TrafficShaper,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$TrafficShaperReverse,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$Users,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$UtmStatus,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Uuid,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$VideofilterProfile,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$VlanCosFwd = -1,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$VlanCosRev = -1,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$VlanFilter,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$VoipProfile,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Vpntunnel,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$WafProfile,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$Wanopt,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$WanoptDetection,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$WanoptPassiveOpt,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$WanoptPeer,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$WanoptProfile,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$Wccp,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$Webcache,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$WebcacheHttps,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$WebfilterProfile,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$WebproxyForwardServer,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$WebproxyProfile,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$ZtnaEmsTag,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$ZtnaGeoTag,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$ZtnaStatus,
        [ValidateSet("Keep", "RemoveAttribute", "ClearContent")]
        [parameter(mandatory = $false, ParameterSetName = "default")]
        $NullHandler = "RemoveAttribute"
    )
    $data = @{
        '_policy_block'                     = $Policy_block
        'action'                            = "$Action"
        'anti-replay'                       = "$AntiReplay"
        'application-list'                  = "$ApplicationList"
        'auth-cert'                         = "$AuthCert"
        'auth-path'                         = "$AuthPath"
        'auth-redirect-addr'                = "$AuthRedirectAddr"
        'auto-asic-offload'                 = "$AutoAsicOffload"
        'av-profile'                        = "$AvProfile"
        'block-notification'                = "$BlockNotification"
        'captive-portal-exempt'             = "$CaptivePortalExempt"
        'capture-packet'                    = "$CapturePacket"
        'cifs-profile'                      = "$CifsProfile"
        'comments'                          = "$Comments"
        'custom-log-fields'                 = @($CustomLogFields)
        'decrypted-traffic-mirror'          = "$DecryptedTrafficMirror"
        'delay-tcp-npu-session'             = "$DelayTcpNpuSession"
        'diffserv-forward'                  = "$DiffservForward"
        'diffserv-reverse'                  = "$DiffservReverse"
        'diffservcode-forward'              = "$DiffservcodeForward"
        'diffservcode-rev'                  = "$DiffservcodeRev"
        'disclaimer'                        = "$Disclaimer"
        'dlp-profile'                       = "$DlpProfile"
        'dnsfilter-profile'                 = "$DnsfilterProfile"
        'dsri'                              = "$Dsri"
        'dstaddr'                           = @($Dstaddr)
        'dstaddr-negate'                    = "$DstaddrNegate"
        'dstaddr6'                          = @($Dstaddr6)
        'dstintf'                           = @($Dstintf)
        'dynamic-shaping'                   = "$DynamicShaping"
        'email-collect'                     = "$EmailCollect"
        'emailfilter-profile'               = "$EmailfilterProfile"
        'fec'                               = "$Fec"
        'file-filter-profile'               = "$FileFilterProfile"
        'firewall-session-dirty'            = "$FirewallSessionDirty"
        'fixedport'                         = "$Fixedport"
        'fsso-agent-for-ntlm'               = "$FssoAgentForNtlm"
        'fsso-groups'                       = @($FssoGroups)
        'geoip-anycast'                     = "$GeoipAnycast"
        'geoip-match'                       = "$GeoipMatch"
        'global-label'                      = "$GlobalLabel"
        'groups'                            = @($Groups)
        'gtp-profile'                       = "$GtpProfile"
        'http-policy-redirect'              = "$HttpPolicyRedirect"
        'icap-profile'                      = "$IcapProfile"
        'identity-based-route'              = "$IdentityBasedRoute"
        'inbound'                           = "$Inbound"
        'inspection-mode'                   = "$InspectionMode"
        'internet-service'                  = "$InternetService"
        'internet-service-custom'           = @($InternetServiceCustom)
        'internet-service-custom-group'     = @($InternetServiceCustomGroup)
        'internet-service-group'            = @($InternetServiceGroup)
        'internet-service-name'             = @($InternetServiceName)
        'internet-service-negate'           = "$InternetServiceNegate"
        'internet-service-src'              = "$InternetServiceSrc"
        'internet-service-src-custom'       = @($InternetServiceSrcCustom)
        'internet-service-src-custom-group' = @($InternetServiceSrcCustomGroup)
        'internet-service-src-group'        = @($InternetServiceSrcGroup)
        'internet-service-src-name'         = @($InternetServiceSrcName)
        'internet-service-src-negate'       = "$InternetServiceSrcNegate"
        'ippool'                            = "$Ippool"
        'ips-sensor'                        = "$IpsSensor"
        'label'                             = "$Label"
        'logtraffic'                        = "$Logtraffic"
        'logtraffic-start'                  = "$LogtrafficStart"
        'match-vip'                         = "$MatchVip"
        'match-vip-only'                    = "$MatchVipOnly"
        'name'                              = "$Name"
        'nat'                               = "$Nat"
        'nat46'                             = "$Nat46"
        'nat64'                             = "$Nat64"
        'natinbound'                        = "$Natinbound"
        'natip'                             = "$Natip"
        'natoutbound'                       = "$Natoutbound"
        'np-acceleration'                   = "$NpAcceleration"
        'ntlm'                              = "$Ntlm"
        'ntlm-enabled-browsers'             = @($NtlmEnabledBrowsers)
        'ntlm-guest'                        = "$NtlmGuest"
        'outbound'                          = "$Outbound"
        'passive-wan-health-measurement'    = "$PassiveWanHealthMeasurement"
        'per-ip-shaper'                     = "$PerIpShaper"
        'permit-any-host'                   = "$PermitAnyHost"
        'permit-stun-host'                  = "$PermitStunHost"
        'pfcp-profile'                      = "$PfcpProfile"
        'policy-expiry'                     = "$PolicyExpiry"
        'policy-expiry-date'                = "$PolicyExpiryDate"
        'policyid'                          = $Policyid
        'poolname'                          = @($Poolname)
        'poolname6'                         = @($Poolname6)
        'profile-group'                     = "$ProfileGroup"
        'profile-protocol-options'          = "$ProfileProtocolOptions"
        'profile-type'                      = "$ProfileType"
        'radius-mac-auth-bypass'            = "$RadiusMacAuthBypass"
        'redirect-url'                      = "$RedirectUrl"
        'replacemsg-override-group'         = "$ReplacemsgOverrideGroup"
        'reputation-direction'              = "$ReputationDirection"
        'reputation-minimum'                = $ReputationMinimum
        'rtp-addr'                          = @($RtpAddr)
        'rtp-nat'                           = "$RtpNat"
        'schedule'                          = "$Schedule"
        'schedule-timeout'                  = "$ScheduleTimeout"
        'scope member'                      = @($ScopeMember)
        'sctp-filter-profile'               = "$SctpFilterProfile"
        'send-deny-packet'                  = "$SendDenyPacket"
        'service'                           = @($Service)
        'service-negate'                    = "$ServiceNegate"
        'session-ttl'                       = $SessionTtl
        'sgt'                               = @($Sgt)
        'sgt-check'                         = "$SgtCheck"
        'src-vendor-mac'                    = @($SrcVendorMac)
        'srcaddr'                           = @($Srcaddr)
        'srcaddr-negate'                    = "$SrcaddrNegate"
        'srcaddr6'                          = @($Srcaddr6)
        'srcintf'                           = @($Srcintf)
        'ssh-filter-profile'                = "$SshFilterProfile"
        'ssh-policy-redirect'               = "$SshPolicyRedirect"
        'ssl-ssh-profile'                   = "$SslSshProfile"
        'status'                            = "$Status"
        'tcp-mss-receiver'                  = $TcpMssReceiver
        'tcp-mss-sender'                    = $TcpMssSender
        'tcp-session-without-syn'           = "$TcpSessionWithoutSyn"
        'timeout-send-rst'                  = "$TimeoutSendRst"
        'tos'                               = "$Tos"
        'tos-mask'                          = "$TosMask"
        'tos-negate'                        = "$TosNegate"
        'traffic-shaper'                    = "$TrafficShaper"
        'traffic-shaper-reverse'            = "$TrafficShaperReverse"
        'users'                             = @($Users)
        'utm-status'                        = "$UtmStatus"
        'uuid'                              = "$Uuid"
        'videofilter-profile'               = "$VideofilterProfile"
        'vlan-cos-fwd'                      = $VlanCosFwd
        'vlan-cos-rev'                      = $VlanCosRev
        'vlan-filter'                       = "$VlanFilter"
        'voip-profile'                      = "$VoipProfile"
        'vpntunnel'                         = "$Vpntunnel"
        'waf-profile'                       = "$WafProfile"
        'wanopt'                            = "$Wanopt"
        'wanopt-detection'                  = "$WanoptDetection"
        'wanopt-passive-opt'                = "$WanoptPassiveOpt"
        'wanopt-peer'                       = "$WanoptPeer"
        'wanopt-profile'                    = "$WanoptProfile"
        'wccp'                              = "$Wccp"
        'webcache'                          = "$Webcache"
        'webcache-https'                    = "$WebcacheHttps"
        'webfilter-profile'                 = "$WebfilterProfile"
        'webproxy-forward-server'           = "$WebproxyForwardServer"
        'webproxy-profile'                  = "$WebproxyProfile"
        'ztna-ems-tag'                      = @($ZtnaEmsTag)
        'ztna-geo-tag'                      = @($ZtnaGeoTag)
        'ztna-status'                       = "$ZtnaStatus"

    }
    return $data | Remove-FMNullValuesFromHashtable -NullHandler $NullHandler
}
