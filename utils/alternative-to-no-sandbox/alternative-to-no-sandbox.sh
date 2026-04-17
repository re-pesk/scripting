# shellcheck shell=bash

restricted="$(sysctl kernel.apparmor_restrict_unprivileged_userns)"

if (( restricted == 1 )); then
  sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=0
fi

if [[ ! -f /etc/sysctl.d/60-apparmor-namespace.conf ]]; then
  echo "kernel.apparmor_restrict_unprivileged_userns=0" | sudo tee /etc/sysctl.d/60-apparmor-namespace.conf
fi
