# atlas-containers

Docker to `wsl2` for general purpose use with the ATLAS software stack. This `wsl2` distro uses `cvmfs`.

## Introduction

Contains a `Dockerfile` based on AlmaLinux 9 that installs all the necessary libraries for running the ATLAS software stack. This includes `cvmfs`. This container is used to create a `wsl2` distro.

Who is this for:

* Need a general container to run ATLAS software on Windows
* Access to a high-speed, stable, internet connection: this container uses `cvmfs` for all ATLAS software. Quite a bit can be downloaded (e.g. GB's worth). While it is cached by the `cvmfs` software, who knows when the cache will expire and you'll need to re-download!

## Prerequisites

You will need to have `wsl2` and `docker` installed on your windows machine.

## Usage

Everything is orchestrated via the script `Install-ATLASwsl2.ps1`:

```Powershell
S C:\Users\gordo\Code\atlas\atlas-containers> .\Install-ATLASWsl2.ps1   
[+] Building 1.8s (17/17) FINISHED                                                                                                         docker:default
 => [internal] load build definition from Dockerfile                                                                                                 0.0s
 => => transferring dockerfile: 856B                                                                                                                 0.0s 
 => [internal] load .dockerignore                                                                                                                    0.0s 
 => => transferring context: 2B                                                                                                                      0.0s 
 => [internal] load metadata for docker.io/library/almalinux:9                                                                                       1.5s 
 => [auth] library/almalinux:pull token for registry-1.docker.io                                                                                     0.0s
 => [ 1/11] FROM docker.io/library/almalinux:9@sha256:09fdb3db0975ac4bf4610abd8f159622ab8f460950b56212472625cc47fccd5a                               0.0s
 => [internal] load build context                                                                                                                    0.0s 
 => => transferring context: 790B                                                                                                                    0.0s 
 => CACHED [ 2/11] RUN yum -y install sudo passwd                                                                                                    0.0s 
 => CACHED [ 3/11] RUN yum install -y https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm && yum install -y cvmfs         0.0s 
 => CACHED [ 4/11] RUN cvmfs_config setup                                                                                                            0.0s
 => CACHED [ 5/11] COPY default.local /etc/cvmfs/default.local                                                                                       0.0s 
 => CACHED [ 6/11] RUN mkdir /etc/atlas-cern                                                                                                         0.0s 
 => CACHED [ 7/11] COPY startup-atlas-sudo.sh /etc/atlas-cern/startup-atlas-sudo.sh                                                                  0.0s 
 => [ 8/11] COPY startup-atlas.sh /etc/profile.d                                                                                                     0.0s 
 => [ 9/11] COPY config-user.sh /etc/atlas-cern/config-user.sh                                                                                       0.0s 
 => [10/11] COPY sudoers-atlas-setup /etc/sudoers.d/sudoers-atlas-setup                                                                              0.0s 
 => [11/11] COPY wsl.conf /etc/wsl.conf                                                                                                              0.0s 
 => exporting to image                                                                                                                               0.1s 
 => => exporting layers                                                                                                                              0.1s 
 => => writing image sha256:26971012f922654a1a88d7b24d570e75b45a85fc3ed41dfbbc1ef0edad23f800                                                         0.0s 
 => => naming to docker.io/library/atlascontainers:latest                                                                                            0.0s 

What's Next?
  View a summary of image vulnerabilities and recommendations → docker scout quickview
atlas_al9
Import in progress, this may take a few minutes.   
The operation completed successfully.
Enter username: gwatts
Changing password for user gwatts.
New password:
BAD PASSWORD: The password fails the dictionary check - it is based on a dictionary word
Retype new password:
passwd: all authentication tokens updated successfully.
Adding user gwatts to group wheel
The operation completed successfully. 
PS C:\Users\gordo\Code\atlas\atlas-containers> 
PS C:\Users\gordo\Code\atlas\atlas-containers>
PS C:\Users\gordo\Code\atlas\atlas-containers> wsl -d atlas_al9
[gwatts@SurfacePhoto atlas-containers]$ 
[gwatts@SurfacePhoto atlas-containers]$
[gwatts@SurfacePhoto atlas-containers]$ ls /cvmfs/atlas.cern.ch
repo
[gwatts@SurfacePhoto atlas-containers]$ setupATLAS 
lsetup               lsetup <tool1> [ <tool2> ...] (see lsetup -h):
 lsetup asetup        (or asetup) to setup an Athena release
 lsetup astyle        ATLAS style macros
 lsetup atlantis      Atlantis: event display
 lsetup eiclient      Event Index 
 lsetup emi           EMI: grid middleware user interface 
 lsetup ganga         Ganga: job definition and management client
 lsetup lcgenv        lcgenv: setup tools from cvmfs SFT repository
 lsetup panda         Panda: Production ANd Distributed Analysis
 lsetup pyami         pyAMI: ATLAS Metadata Interface python client
 lsetup root          ROOT data processing framework
 lsetup rucio         distributed data management system client
 lsetup scikit        python data analysis ecosystem
 lsetup views         Set up a full LCG release
 lsetup xcache        XRootD local proxy cache
 lsetup xrootd        XRootD data access
advancedTools        advanced tools menu
diagnostics          diagnostic tools menu
helpMe               more help
printMenu            show this menu
showVersions         show versions of installed software

-bash: manpath: command not found
[gwatts@SurfacePhoto atlas-containers]$
```

## Tests

The following have been tested:

* `lsetup rucio` and `voms-proxy-init` and `rucio ping`
  * [x] centos7
  * [ ] AL9
* `lsetup root xxx` and `root` and then `TBrowser b` - using the default recommended version of `root` when this was last checked!
  * [ ] centos7
    * `root` runs currently in batch mode, but some X11 libraries (?) are missing and `root` isn't telling me which ones, so no windows ever pop us.
  * [ ] AL9
* `xclock` works (after installing with `yum install xclock` (this is not normally installed with these scripts).
  * [x] centos7
  * [ ] AL9
* `kinit` and `ssh lxplus.cern.ch` without password for `ssh`.
  * [x] centos7
  * [ ] AL9
* Build the DiVertAnalysisR21 image using the `gitlab` build script.
  * [x] centos07
  * Not clear this is possible on AL9 since this is R21.
