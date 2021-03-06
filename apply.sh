#!/bin/bash

unset SUCCESS
on_exit() {
  if [ -z "$SUCCESS" ]; then
    echo "ERROR: $0 failed.  Please fix the above error."
    exit 1
  else
    echo "SUCCESS: $0 has completed."
    exit 0
  fi
}
trap on_exit EXIT

http_patch() {
  PATCHNAME=$(basename $1)
  curl -L -o $PATCHNAME -O -L $1
  cat $PATCHNAME |patch -p1
  rm $PATCHNAME
}

# Change directory verbose
cdv() {
  echo
  echo "*****************************"
  echo "Current Directory: $1"
  echo "*****************************"
  cd $BASEDIR/$1
}

# Change back to base directory
cdb() {
  cd $BASEDIR
}

# Sanity check
if [ -d ../.repo ]; then
  cd ..
fi
if [ ! -d .repo ]; then
  echo "ERROR: Must run this script from the base of the repo."
  SUCCESS=true
  exit 255
fi

# Save Base Directory
BASEDIR=$(pwd)

# Abandon auto topic branch
repo abandon auto
set -e

################ Apply Patches Below ####################

repo start auto bootable/recovery
echo "### patch CWM to backup android_secure on internal and external"
cdv bootable/recovery
git reset --hard
http_patch http://chris41g.devphone.org/patches/nandroid.patch
cdb

repo start auto packages/apps/Phone
echo "### fix ringtones"
cdv packages/apps/Phone
git reset --hard
http_patch http://chris41g.devphone.org/patches/ringer.patch
cdb

repo start auto system/core
echo "### storage"
cdv system/core
git reset --hard
git fetch https://github.com/CyanogenMod/android_system_core refs/heads/jellybean
git cherry-pick be5bb1d4aa98e066c44e5ee8a54a9bf92b17aa37
http_patch http://chris41g.devphone.org/patches/steve.patch
cdb
##### SUCCESS ####
SUCCESS=true
exit 0
