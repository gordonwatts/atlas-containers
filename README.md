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
PS> .\Install-ATLASWsl2.ps1 -?    
Install-ATLASWsl2.ps1 [-containerName] <string> [[-os] <string>] [<CommonParameters>]
```

An example:

```Powershell
PS C:\Users\gordo\Code\atlas\atlas-containers> .\Install-ATLASWsl2.ps1 atlas_centos7 centos7
[+] Building 257.1s (21/21) FINISHED                                                                                                       docker:default
 => [internal] load .dockerignore                                                                                                                    0.0s
 => => transferring context: 2B                                                                                                                      0.0s 
 => [internal] load build definition from Dockerfile                                                                                                 0.1s 
 => => transferring dockerfile: 1.84kB                                                                                                               0.0s 
 => [internal] load metadata for docker.io/library/centos:7                                                                                          0.5s 
 => [ 1/16] FROM docker.io/library/centos:7@sha256:be65f488b7764ad3638f236b7b515b3678369a5124c47b8d32916d6487418ea4                                  0.0s
 => [internal] load build context                                                                                                                    0.0s 
 => => transferring context: 211B                                                                                                                    0.0s 
 => CACHED [ 2/16] RUN yum -y install sudo passwd yum-utils krb5-workstation openssl man-db deltarpm xdg-utils libXft libSM patch cmake make g++ uu  0.0s 
 => CACHED [ 3/16] RUN yum -y install epel-release python2-pip && yum clean all                                                                      0.0s 
 => [ 4/16] RUN yum-config-manager --add-repo https://download.opensuse.org/repositories/home:/wslutilities/RHEL_7/home:wslutilities.repo && yum i  26.8s 
 => [ 5/16] RUN yum install -y https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm && yum install -y cvmfs && yum clean  44.5s
 => [ 6/16] RUN cvmfs_config setup                                                                                                                   0.6s 
 => [ 7/16] COPY default.local /etc/cvmfs/default.local                                                                                              0.0s 
 => [ 8/16] RUN yum install -y https://linuxsoft.cern.ch/wlcg/centos7/x86_64/wlcg-repo-1.0.0-1.el7.noarch.rpm && yum clean all                       3.1s 
 => [ 9/16] RUN yum install -y --skip-broken HEP_OSlibs glibc-langpack && yum clean all                                                            123.4s 
 => [10/16] RUN mkdir /etc/atlas-cern                                                                                                                0.7s 
 => [11/16] COPY startup-atlas-sudo.sh /etc/atlas-cern/startup-atlas-sudo.sh                                                                         0.0s 
 => [12/16] COPY startup-atlas.sh /etc/profile.d                                                                                                     0.0s 
 => [13/16] COPY config-user.sh /etc/atlas-cern/config-user.sh                                                                                       0.0s 
 => [14/16] COPY sudoers-atlas-setup /etc/sudoers.d/sudoers-atlas-setup                                                                              0.0s 
 => [15/16] COPY wsl.conf /etc/wsl.conf                                                                                                              0.0s 
 => [16/16] RUN yum update -y && yum clean all && yum update -y                                                                                     53.0s 
 => exporting to image                                                                                                                               4.1s 
 => => exporting layers                                                                                                                              4.1s 
 => => writing image sha256:94a23c9c47e153a08d9d8ca195672717dbaceab10a2b837e60983c5ef39b45f2                                                         0.0s 
 => => naming to docker.io/library/atlas_centos7:latest                                                                                              0.0s 

What's Next?
  View a summary of image vulnerabilities and recommendations → docker scout quickview
atlas_centos7
atlas_centos7
Import in progress, this may take a few minutes.   
The operation completed successfully.
Enter username: gwatts
You will be prompted to enter a password for gwatts.
Changing password for user gwatts.
New password: 
Retype new password:
passwd: all authentication tokens updated successfully.
Adding user gwatts to group wheel
The operation completed successfully. 
PS C:\Users\gordo\Code\atlas\atlas-containers> C:\Users\gordo\OneDrive\Documents2\WindowsPowerShell\Scripts\atlas-scripts\Copy-LinuxFiles.ps1 atlas_centos7
Installing Globus certificates. You'll be prompted for the pass phrase for your p12 file
and then a pass phrase for the userkey.pem file.
Enter Import Password:
MAC verified OK
Enter PEM pass phrase:
Verifying - Enter PEM pass phrase:
And again for the p12 file to generate the usercert.pem
Enter Import Password:
MAC verified OK
```

## Tests

The following have been tested:

* `lsetup rucio` and `voms-proxy-init` and `rucio ping`
  * [x] centos7
  * [x] AL9
* `lsetup root xxx` and `root` and then `TBrowser b` - using the default recommended version of `root` when this was last checked!
  * [x] centos7
    * The X Windows just works with no further config (note you must start current version of `root` with `root --web=off` for this to work, otherwise it tries to use the new interface).
    * The web browser seems version starts ok, though `wslutils` gives a syntax error ([bug report](https://github.com/wslutilities/wslu/issues/294)).
  * [x] AL9
    * Same caveats as above.
    * The browser window was slow to open - it took 15 seconds on AL9. Much faster on CENTOS7.
* `xclock` works (after installing with `yum install xorg-x11-apps` (this is not normally installed with this configuration).
  * [x] centos7
    * First you must run `sudo yum install xclock`
  * [x] AL9
    * First you must run `sudo dnf --enablerepo=crb install -y xorg-x11-apps`
    * The web pages talking about this are incorrect. I cannot find `xclock` for AL9. However, given the X-Windows version of `root` `TBrowser` works, I think the x-windowing system, wslg, is working just fine.
* `kinit` and `ssh lxplus.cern.ch` without password for `ssh`.
  * [x] centos7
  * [x] AL9
* Build the DiVertAnalysisR21 image using the `gitlab` build script.
  * [x] centos07
  * Not clear this is possible on AL9 since this is R21.
