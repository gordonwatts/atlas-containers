# Download And Install Instructions

Follow the below instructions to download and install the wsl2 images that are ready to use ATLAS software.

## Installation

Follow the below instructions to download, install, and configure the images.

Prerequisites:

* WSL2 is installed and working (e.g. run `wsl --update` from your command line). You should be passingly familiar with how `wsl2` works.

Step-by-step:

1. Download the image
    * [ATLAS CENTOS7](https://cernbox.cern.ch/s/uN8y5PH1BEEnvOw): Download the 400MB zipped image here
    * [ATLAS AlmaLinux 9 - x86](https://cernbox.cern.ch/s/v0IQC5x0O5hs87N): Download the 400 MB zipped image here
    * [ALTAS AlmaLinux 9 - ARM](https://cernbox.cern.ch/s/CmiF3h5y7jvFuav): Download the 400 MB zipped image here.
    * These images correspond to the v1.0 tag.
1. Unzip the image.
    * Locate the resulting unzipped `.tar` file for use in the next step.
1. In a normal terminal/console window running PowerShell, install the image in the wsl2 with `wsl --import --version 2 atlas_xxx $env:USERPROFILE\AppData\Local\Programs\atlas_xxx distro.tar`
    * Replace `atlas_xxx` with whatever you'd like to label this wsl2 distro as (e.g. `atlas_centos7``),
    * Replace `distro.tar` with whatever the unzipped downloaded file is.
    * The location of the virtual disk (`$env:USERPROFILE\AppData\Local\Programs\atlas_xxx` here) can be any valid location. If you have many disks on your system you might keep it off your system disk - it can get rather large.
1. Configure the distro with your default username using `wsl -d atlas_xxx --exec bash -c "/etc/atlas-cern/config-user.sh"`
    * Follow the instructions - you'll create a local username and password.
    * If you plan to use any GRID utilities, I suggest you keep your username the same as your CERN/GRID username - it just makes life easier.
1. You can now start the distro and type `setupATLAS` as normal by opening `terminal` or any other way you might normally interact with a wsl2 instance.
    * To start it use `wsl -d atlas_xxx`. You can also set it as the default distro (see `wsl --help`) or use the built in most-excellent `terminal` app.
    * You can also use remote development on `vscode`
1. Delete the original zipped and unzipped image you downloaded: they are no longer needed.
1. Profit!

## Other Reading

* [Introduction to WSL2](https://learn.microsoft.com/en-us/windows/wsl/about)

## Features

* Use `cvmfs` to access all releases and nightlies (note: you should be on a robust internet connection when you use these!)
* `setupATLAS` works from any interactive shell
* `kinit user@CERN.CH` works, and at that point `ssh` access to `lxplus` and other CERN machines should be transparent. However, you'll need to copy in your `.ssh` files and your `.globus` directory.
* The Dockerfile's used to build these images can be found [here](https://github.com/gordonwatts/atlas-containers). Please feel free to submit PR's or issues. PR's, obviously, are more likely to get fixed faster!
