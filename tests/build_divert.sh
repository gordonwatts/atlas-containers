# Go from zero to a built DiVertAnalysisR21 package, starting from the current directory.
# Supports:
#
#  - CENT0S7
#
# You must:
#  Have done kinit first or have some other way that the ssh:// protocol will work.
#
# Basic instructions come from the DiVertAnalysisR21 gitlab page:
#       https://gitlab.cern.ch/atlas-phys-exotics-llp-mscrid/fullrun2analysis/DiVertAnalysisR21

cd ~
mkdir -p Code
cd Code

# Download and extract the build file from DiVertAnalysis.
# Don't know how to do this without grabbing every file.
repo_url="ssh://git@gitlab.cern.ch:7999/atlas-phys-exotics-llp-mscrid/fullrun2analysis/DiVertAnalysisR21.git"
git clone $repo_url temp
cp temp/scripts/build_DiVertAnalysisR21.sh .
rm -rf temp

# And now do the build.
source build_DiVertAnalysisR21.sh
