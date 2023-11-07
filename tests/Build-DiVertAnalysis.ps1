param(
    [string]$DistributionName = 'atlas_centos7'
)

# Get the location of this script
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Convert it to a wsl2 path
$wslScriptDir = "/mnt/" + ($ScriptDir -replace '\\', '/').ToLower().Replace(':', '')
$wslBuildPath = "$wslScriptDir/build_divert.sh"

# Run it!
wsl -d $DistributionName bash -i $wslBuildPath
