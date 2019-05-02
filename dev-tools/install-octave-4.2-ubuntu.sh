#!/bin/bash
#
# This installs Octave on Ubuntu, doing what's necessary to get a newer 4.2
# Octave even if this distro's default is an older version.

if grep -i 'xenial\|trusty' /etc/lsb-release &>/dev/null; then
  echo $0: Adding apt repository ppa:octave/stable to get newer Octave 4.2
  sudo add-apt-repository ppa:octave/stable --yes
  sudo apt-get update
fi
pkgs="octave liboctave-dev"
echo $0: Installing packages: $pkgs
sudo apt-get install --yes $pkgs
