# Parameters (eventually the command line)
# $containerName = "atlas_al9"
$containerName = "atlas_centos7"
$wsl_distro = $containerName
# $os = "al9"
$os = "centos7"

# Make sure we are ready to go!
$wsl_distro_exists = (wsl -l | Where-Object { $_ -eq $wsl_distro } | Measure-Object -Line).Lines
if ($wsl_distro_exists -ge 1) {
    Write-Host "Error: WSL2 distro $wsl_distro exists. Unregister with: wsl --unregister $wsl_distro"
    exit 1
}

# Build the docker image
docker build --pull --rm -f "$os/Dockerfile" -t ${containerName}:latest "."

# Run the docker image with a container name "atlas_al9" and execute a simple "ls":
$containerExists = (docker ps -a -f name=$containerName | Measure-Object -Line).Lines
if ($containerExists -gt 1) {
    docker rm $containerName
}
docker run --name $containerName ${containerName}:latest

# Export this do the user's Downloads folder
docker export $containerName -o $env:USERPROFILE\Downloads\$wsl_distro.tar

# Delete the container
docker rm $containerName

# Now import this into wsl as a distro
wsl --import  --version 2 $wsl_distro $env:USERPROFILE\AppData\Local\Programs\$wsl_distro $env:USERPROFILE\Downloads\$wsl_distro.tar

# Finally, configure the user (username/password)
wsl -d $wsl_distro --exec bash -c "/etc/atlas-cern/config-user.sh"

# And shut down so it restarts with the new `wsl.conf`
wsl -t $wsl_distro