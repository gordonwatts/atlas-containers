# Make sure cvmfs is up and going
sudo /etc/atlas-cern/startup-atlas-sudo.sh

# define the setupATLAS command
export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
alias setupATLAS='source ${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh'
