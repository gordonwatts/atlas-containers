# Goal: An AL9 image that can be used for ATLAS development
# work and has CVMFS access to the ATLAS software stack.

# Start from the latest Alma Linux 9 base image
FROM almalinux:9

# Get libraries and utilties installed to run ATLAS software
RUN yum -y install sudo passwd

# Get CVMFS installed
RUN yum install -y https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm && yum install -y cvmfs
RUN cvmfs_config setup
COPY default.local /etc/cvmfs/default.local

# Get the startup scripts for ATLAS defined
RUN mkdir /etc/atlas-cern
COPY startup-atlas-sudo.sh /etc/atlas-cern/startup-atlas-sudo.sh
COPY startup-atlas.sh /etc/profile.d
COPY config-user.sh /etc/atlas-cern/config-user.sh
COPY sudoers-atlas-setup /etc/sudoers.d/sudoers-atlas-setup

# And WSL config
COPY wsl.conf /etc/wsl.conf