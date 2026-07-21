#!/usr/bin/env bash
SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE:-$0});pwd)
BASE_DIR=$(cd ${SCRIPT_DIR}/..;pwd)
set -o errexit
set -o errtrace
set -o nounset
set -o pipefail
#set -o xtrace

tar zcf ~/dotconfig-$(date +%F-%H%M%S).tar.gz \
  ~/.config \
  ~/.local \
  ~/.nix-* \
  /nix/

# vim: set ft=sh ts=2 sw=2 et:
