# Make sure we are ready to go!
$wsl_distro = "atlas_al9"
$wsl_distro_exists = (wsl -l | Where-Object { $_ -eq $wsl_distro } | Measure-Object -Line).Lines
if ($wsl_distro_exists -ge 1) {
    Write-Host "Error: WSL2 distro $wsl_distro exists. Unregister with: wsl --unregister $wsl_distro"
    exit 1
}

# Build the docker image
docker build --pull --rm -f "Dockerfile" -t atlascontainers:latest "."

# Run the docker image with a container name "atlas_al9" and execute a simple "ls":
$containerName = "atlas_al9"
$containerExists = (docker ps -a -f name=$containerName | Measure-Object -Line).Lines
if ($containerExists -gt 1) {
    docker rm $containerName
}
docker run --name $containerName atlascontainers:latest bash ls

# Export this do the user's Downloads folder
docker export atlas_al9 -o $env:USERPROFILE\Downloads\atlas_al9.tar

# Delete the container
docker rm $containerName

# Now import this into wsl as a distro "atlas_al9", placing
# the distro in c:\Users\<username>\AppData\Local\Programs\atlas_al9.
wsl --import  --version 2 $wsl_distro $env:USERPROFILE\AppData\Local\Programs\atlas_al9 $env:USERPROFILE\Downloads\atlas_al9.tar

# Finally, configure the user (username/password)
wsl -d $wsl_distro --exec bash -c "/etc/atlas-cern/config-user.sh"

# And shut down so it restarts with the new `wsl.conf`
wsl -t $wsl_distro