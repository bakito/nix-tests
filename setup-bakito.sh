#!/bin/bash

sh <(curl -L https://nixos.org/nix/install) --no-daemon

. /home/bakito/.nix-profile/etc/profile.d/nix.sh

nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

nix-shell '<home-manager>' -A install

cp /tmp/home.nix /home/bakito/.config/home-manager/home.nix

home-manager switch -b backup