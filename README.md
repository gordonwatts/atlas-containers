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

```

## Tests

The following have been tested:

* `lsetup rucio` and `voms-proxy-init` and `rucio ping`
  * [x] centos7
  * [ ] AL9
* `lsetup root xxx` and `root` and then `TBrowser b` - using the default recommended version of `root` when this was last checked!
  * [x] centos7
    * The X Windows just works with no further config (note you must start current root with `root --web=off` for this to work).
    * The web browser seems version starts ok, though `wslutils` gives a syntax error ([bug report](https://github.com/wslutilities/wslu/issues/294)).
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
