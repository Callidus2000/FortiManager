function Get-FMFirewallScope {
    <#
    .SYNOPSIS
    Queries firewall scopes for dynamic mapping etc.

    .DESCRIPTION
    Queries firewall scopes for dynamic mapping etc.
    The function returns arrays of matched scopes. Will be most usefull if each VDOM is pinned to a
    specific device. Then the VDOM name can be used to identify te full scope.

    .PARAMETER Connection
    The API connection object.

    .PARAMETER ADOM
    The (non-default) ADOM for the requests.

    .PARAMETER EnableException
    If set to True, errors will throw an exception

    .PARAMETER VDOM
    The List of VDOMs which should be matched.

    .PARAMETER DeviceName
    The List of device names which should be matched.

    .EXAMPLE
    Get-FMFirewallScope -vdom "bonn"

    Returns @(@{"name"="FW3";"vdom"="bonn"})

    .EXAMPLE
    Get-FMFirewallScope -deviceName "FW1"

    Returns @(@{"name"="FW1";"vdom"="cologne"},@{"name"="FW1";"vdom"="finance"})

    .NOTES
    The data is cached within the connection object. If a refresh is needed you have to create a fresh connection.

    Examples are based on the assumption that "Get-FMDeviceInfo" returns (shortened)
    {"object member":[{"name":"FW1","vdom":"cologne"},{"name":"FW1","vdom":"finance"},{"name":"FW2","vdom":"munich"},{"name":"FW3","vdom":"bonn"},{"name":"FW3","vdom":"finance"},{"name":"All_FortiGate"}]}
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $false)]
        $Connection = (Get-FMLastConnection),
        [string]$ADOM,
        [bool]$EnableException = $true,

        [parameter(mandatory = $false, ParameterSetName = "default")]
        [String[]]$VDOM,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [String[]]$DeviceName
    )
    if ($Connection.forti.containsKey('availableScopes')) {
        $availableScopes = $Connection.forti.availableScopes
    }
    else {
        Write-PSFMessage -Level Host "Query Device-Info once from manager, store the scopes unter '`$Connection.forti.availableScopes'"
        $devInfo = Get-FMDeviceInfo -Connection $connection -Option 'object member' -ADOM $ADOM -EnableException $EnableException
        $availableScopes = $devInfo."object member" | Where-Object { $_.vdom } | Select-Object name, vdom
        $Connection.forti.availableScopes = $availableScopes
    }


    $queryFilter = "$($null -eq $DeviceName)|$($null -eq $VDOM)"
    # Write-PSFMessage "Queryfilter=$queryFilter"
    switch ($queryFilter) {
        default { $result = $availableScopes }
        "False|False" { $result = $availableScopes | Where-Object { $_.name -in $DeviceName -and $_.VDOM -in $VDOM } }
        "False|True" { $result = $availableScopes | Where-Object { $_.name -in $DeviceName } }
        "True|False" { $result = $availableScopes | Where-Object { $_.VDOM -in $VDOM } }
    }
    # Write-PSFMessage "`$result = $($result | ConvertTo-Json -WarningAction SilentlyContinue)"
    return $result
}
