#! /usr/bin/env -S bash

# shellcheck disable=SC2034
APP_NAME="Vivaldi"

# Jeigu nėra pagalbinio failo, paleisti skriptą pagalbiniams failams įkelti
# Įkelti pagalbines funkcijas
../../utils/install_helpers/_set_helpers.sh ../
. ../_helpers_.sh

echo ""

if ! install_missing_package gpg wget; then
  exit 1
fi

# Pagal https://askubuntu.com/questions/1532966/vivaldi-wont-load-on-xubuntu-noble-24-04

wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub \
| sudo gpg --dearmor -o /usr/share/keyrings/vivaldi-stable.gpg

sudo tee /etc/apt/sources.list.d/vivaldi.sources <<SOURCES
Types: deb
Architectures: amd64
URIs: https://repo.vivaldi.com/stable/deb/
Suites: stable
Components: main
Signed-By: /usr/share/keyrings/vivaldi-stable.gpg
SOURCES

sudo apt update
sudo apt install vivaldi-stable
