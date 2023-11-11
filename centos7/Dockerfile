# Goal: An CENTOS7 image that can be used for ATLAS development
# work and has CVMFS access to the ATLAS software stack.

# Start from the latest Alma Linux 9 base image
FROM centos:7

# Get libraries and utilties installed to run ATLAS software
RUN yum -y install sudo passwd yum-utils krb5-workstation openssl man-db deltarpm xdg-utils libXft libSM patch cmake make g++ uuid python3 libcap pkg-config valgrind unzip nano && yum clean all

# Some missing python libraries
RUN yum -y install epel-release python2-pip && yum clean all
# RUN pip2 install argcomplete

# # Add wsl utilities
RUN yum-config-manager --add-repo https://download.opensuse.org/repositories/home:/wslutilities/RHEL_7/home:wslutilities.repo && yum install -y wslu && yum clean all

# # Get CVMFS installed
RUN yum install -y https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm && yum install -y cvmfs && yum clean all
RUN cvmfs_config setup
COPY default.local /etc/cvmfs/default.local

# # Libraries, etc., needed for ATLAS software
RUN yum install -y https://linuxsoft.cern.ch/wlcg/centos7/x86_64/wlcg-repo-1.0.0-1.el7.noarch.rpm && yum clean all
# Lots of bad dependencies here, so skip them. Will have to add back in as we see what is missing.
RUN yum install -y --skip-broken HEP_OSlibs glibc-langpack && yum clean all


# # Get the startup scripts for ATLAS defined
RUN mkdir /etc/atlas-cern
COPY startup-atlas-sudo.sh /etc/atlas-cern/startup-atlas-sudo.sh
COPY startup-atlas.sh /etc/profile.d
COPY config-user.sh /etc/atlas-cern/config-user.sh
COPY sudoers-atlas-setup /etc/sudoers.d/sudoers-atlas-setup

# # And WSL config
COPY wsl.conf /etc/wsl.conf

# Finally, get it all up to date, clean everything, and get fresh copies of the mirror data
RUN yum update -y && yum clean all && yum update -y
