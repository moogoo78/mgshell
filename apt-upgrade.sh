#!/usr/bin/env bash
# Update package lists and upgrade all packages in one shot.
# Usage: ./apt-upgrade.sh [-y] [--full] [--clean]
#   -y       non-interactive (assume yes)
#   --full   use full-upgrade (allows removing/installing deps)
#   --clean  run autoremove + autoclean afterwards
set -euo pipefail

YES=""
UPGRADE_CMD="upgrade"
CLEAN=0

for arg in "$@"; do
  case "$arg" in
    -y|--yes) YES="-y" ;;
    --full)   UPGRADE_CMD="full-upgrade" ;;
    --clean)  CLEAN=1 ;;
    -h|--help) sed -n '2,6p' "$0"; exit 0 ;;
    *) echo "Unknown option: $arg" >&2; exit 1 ;;
  esac
done

SUDO=""
[[ $EUID -ne 0 ]] && SUDO="sudo"

echo "==> apt update"
$SUDO apt update

echo "==> apt $UPGRADE_CMD"
$SUDO apt $UPGRADE_CMD $YES

if [[ $CLEAN -eq 1 ]]; then
  echo "==> apt autoremove && autoclean"
  $SUDO apt autoremove $YES
  $SUDO apt autoclean
fi

if [[ -f /var/run/reboot-required ]]; then
  echo "!! Reboot required."
fi

echo "==> Done."
