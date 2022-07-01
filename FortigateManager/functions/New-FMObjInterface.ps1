function New-FMObjInterface {
    <#
    .SYNOPSIS
    Creates a new Firewall Policy object with the given attributes.

    .DESCRIPTION
    Creates a new Firewall Policy object with the given attributes.

    .PARAMETER Color
    Parameter description

    .PARAMETER DefaultMapping
    Parameter description

    .PARAMETER DefmapIntf
    Parameter description

    .PARAMETER DefmapIntrazoneDeny
    Parameter description

    .PARAMETER DefmapZonemember
    Parameter description

    .PARAMETER Description
    Parameter description

    .PARAMETER Dynamic_mapping
    Parameter description

    .PARAMETER EgressShapingProfile
    Parameter description

    .PARAMETER IngressShapingProfile
    Parameter description

    .PARAMETER Name
    Parameter description

    .PARAMETER Platform_mapping
    Parameter description

    .PARAMETER SingleIntf
    Parameter description

    .PARAMETER Wildcard
    Parameter description

    .PARAMETER WildcardIntf
    Parameter description

    .PARAMETER ZoneOnly
    Parameter description

    .PARAMETER NullHandler
    Parameter description

    .EXAMPLE
    $newInterface = New-FMObjInterface -Name "PESTER"

    Creates a a new interface object.

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessforStateChangingFunctions', '')]
    param (
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [long]$Color = -1,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$DefaultMapping,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$DefmapIntf,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$DefmapIntrazoneDeny,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$DefmapZonemember,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$Description,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [System.Object[]]$Dynamic_mapping,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$EgressShapingProfile,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [System.Object[]]$IngressShapingProfile,
        [parameter(mandatory = $true, ParameterSetName = "default")]
        [string]$Name,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [System.Object[]]$Platform_mapping,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$SingleIntf,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$Wildcard,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [string]$WildcardIntf,
        [parameter(mandatory = $false, ParameterSetName = "default")]
        [ValidateSet("disable", "enable")]
        [string]$ZoneOnly,
        [ValidateSet("Keep", "RemoveAttribute", "ClearContent")]
        [parameter(mandatory = $false, ParameterSetName = "default")]
        $NullHandler = "RemoveAttribute"
    )
    $data = @{
        'color'                   = $Color
        'default-mapping'         = "$DefaultMapping"
        'defmap-intf'             = "$DefmapIntf"
        'defmap-intrazone-deny'   = "$DefmapIntrazoneDeny"
        'defmap-zonemember'       = @($DefmapZonemember)
        'description'             = "$Description"
        'dynamic_mapping'         = @($Dynamic_mapping)
        'egress-shaping-profile'  = @($EgressShapingProfile)
        'ingress-shaping-profile' = @($IngressShapingProfile)
        'name'                    = "$Name"
        'platform_mapping'        = @($Platform_mapping)
        'single-intf'             = "$SingleIntf"
        'wildcard'                = "$Wildcard"
        'wildcard-intf'           = "$WildcardIntf"
        'zone-only'               = "$ZoneOnly"

    }
    return $data | Remove-FMNullValuesFromHashtable -NullHandler $NullHandler
}
