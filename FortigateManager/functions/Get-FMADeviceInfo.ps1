function Get-FMADeviceInfo {
    <#
    .SYNOPSIS
    Retrieves device information from a FortiAnalyzer instance.

    .DESCRIPTION
    The Get-FMADeviceInfo function retrieves information about devices from a FortiAnalyzer instance.
    It allows querying device information such as hostname, IP address, version, status, etc.
    This function is part of the existing Fortigate Manager module.

    .PARAMETER Connection
    Specifies the connection to the FortiAnalyzer instance. If not specified, it uses the last connection
    to an Analyzer obtained by Get-FMLastConnection.

    .PARAMETER ADOM
    Specifies the administrative domain (ADOM) from which to retrieve device information.

    .PARAMETER EnableException
    Indicates whether exceptions should be enabled or not. By default, exceptions are enabled.

    .PARAMETER ExpandMember
    Specifies the member to expand. This parameter is used to expand specific members of the device information.

    .PARAMETER Fields
    Specifies the fields to include in the returned device information. Use ValidateSet attribute to choose
    from available fields.

    .PARAMETER Filter
    Specifies the filter to apply when querying device information.

    .PARAMETER Loadsub
    Specifies the load suboption.

    .PARAMETER MetaFields
    Specifies the meta fields to include in the returned device information.

    .PARAMETER Option
    Specifies additional options for querying device information.

    .PARAMETER Range
    Specifies the range of device information to retrieve.

    .PARAMETER Sortings
    Specifies the sorting order of the returned device information.

    .PARAMETER NoADOM
    Indicates whether to bypass ADOM specification.

    .EXAMPLE
    Get-FMADeviceInfo -ADOM "root"

    Retrieves device information from the root administrative domain of the FortiAnalyzer instance.

    .EXAMPLE
    Get-FMADeviceInfo -Connection $Connection -Fields "hostname", "ip" -Filter "version -eq '6.4.0'"

    Retrieves device information including hostname and IP address filtering devices with version 6.4.0.
    #>


    [CmdletBinding()]
    param (
        [parameter(Mandatory = $false)]
        $Connection = (Get-FMLastConnection -Type Analyzer),
        [string]$ADOM,
        [bool]$EnableException = $true,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$ExpandMember,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet('adm_pass', 'adm_usr', 'app_ver', 'av_ver', 'beta', 'branch_pt', 'build', 'checksum', 'conf_status', 'conn_mode', 'conn_status', 'db_status', 'desc', 'dev_status', 'eip', 'fap_cnt', 'faz.full_act', 'faz.perm', 'faz.quota', 'faz.used', 'fex_cnt', 'first_tunnel_up', 'flags', 'foslic_cpu', 'foslic_dr_site', 'foslic_inst_time', 'foslic_last_sync', 'foslic_ram', 'foslic_type', 'foslic_utm', 'fsw_cnt', 'ha_group_id', 'ha_group_name', 'ha_mode', 'hdisk_size', 'hostname', 'hw_generation', 'hw_rev_major', 'hw_rev_minor', 'hyperscale', 'ip', 'ips_ext', 'ips_ver', 'last_checked', 'last_resync', 'latitude', 'lic_flags', 'lic_region', 'location_from', 'logdisk_size', 'longitude', 'maxvdom', 'mgmt_if', 'mgmt_mode', 'mgmt_uuid', 'mgt_vdom', 'module_sn', 'mr', 'name', 'nsxt_service_name', 'os_type', 'os_ver', 'patch', 'platform_str', 'prefer_img_ver', 'prio', 'private_key', 'private_key_status', 'psk', 'role', 'sn', 'version', 'vm_cpu', 'vm_cpu_limit', 'vm_lic_expire', 'vm_lic_overdue_since', 'vm_mem', 'vm_mem_limit', 'vm_status')]
        [String[]]$Fields,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string[]]$Filter,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$Loadsub = -1,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string[]]$MetaFields,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet('count', 'object', 'member', 'syntax')]
        [string]$Option,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$Range,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string[]]$Sortings,
        [switch]$NoADOM
    )
    $Parameter = @{
        'expand member' = "$ExpandMember"
        'fields'        = @($Fields)
        'filter'        = ($Filter | ConvertTo-FMFilterArray)
        'loadsub'       = $Loadsub
        'meta fields'   = @($MetaFields)
        'option'        = "$Option"
        'range'         = @($Range)
        'sortings'      = @($Sortings)
    } | Remove-FMNullValuesFromHashtable -NullHandler "RemoveAttribute"
    $explicitADOM = Resolve-FMAdom -Connection $Connection -Adom $ADOM -EnableException $EnableException
    $apiCallParameter = @{
        EnableException     = $EnableException
        Connection          = $Connection
        LoggingAction       = "Get-FMADeviceInfo"
        LoggingActionValues = $explicitADOM
        method              = "get"
        Parameter           = $Parameter
        Path                = "/dvmdb/adom/$explicitADOM/device"
    }
    if ($NoADOM) {
        $apiCallParameter.Path = "/dvmdb/adom"
        $apiCallParameter.LoggingActionValues = "noAdom"
    }
    $result = Invoke-FMAPI @apiCallParameter
    Write-PSFMessage "Result-Status: $($result.result.status)"
    return $result.result.data
}
