#!/usr/bin/env bash
# Silon: Robust installer script (refactor)
# - Idempotent where possible
# - Continues on errors and logs failures (doesn't "break")
# - Uses best practices: functions, checks, minimal side effects
# - Adjust package lists & paths as needed before running

set -o pipefail

# --- Configuration ---
APT_PACKAGES=(pipx git feroxbuster ncat chisel neo4j bloodhound crackmapexec shellter wine veil)
PIPX_PACKAGES=(name-that-hash dirsearch "git+https://github.com/Pennyw0rth/NetExec")
PIP3_PACKAGES=(wsgidav)           # note: original used --break-system-packages
VEIL_SETUP="/var/share/veil/config/setup.sh"
FAILURES=()

# --- Helpers ---
log()    { printf '%s\n' "$*"; }
info()   { printf '\033[1;34m[INFO]\033[0m %s\n' "$*"; }
warn()   { printf '\033[1;33m[WARN]\033[0m %s\n' "$*"; }
err()    { printf '\033[1;31m[ERROR]\033[0m %s\n' "$*"; }
record_failure() { FAILURES+=("$*"); }

# Run a command but never exit on failure. Records failure with a message.
try() {
  local desc="$1"; shift
  info "$desc"
  if "$@"; then
    info "OK: $desc"
    return 0
  else
    err "FAILED: $desc"
    record_failure "$desc"
    return 1
  fi
}

# Check command exists
has_cmd() { command -v "$1" >/dev/null 2>&1; }

# Prompt-safety for noninteractive apt installs
APT_OPTS=(-y --no-install-recommends)
export DEBIAN_FRONTEND=noninteractive

# Ensure we run apt update before installs (but do it only once)
apt_update_if_needed() {
  if [ ! -f /var/lib/apt/periodic/update-success-stamp ] || \
     [ "$(find /var/lib/apt/periodic/update-success-stamp -mtime -1 2>/dev/null)" = "" ]; then
    try "apt-get update" sudo apt-get update
  else
    info "apt-get update recently run; skipping"
  fi
}

# Install apt packages that are not already installed
install_apt_packages() {
  apt_update_if_needed
  local to_install=()
  for pkg in "${APT_PACKAGES[@]}"; do
    if dpkg -s "$pkg" >/dev/null 2>&1; then
      info "Package already installed: $pkg"
    else
      to_install+=("$pkg")
    fi
  done
  if [ "${#to_install[@]}" -gt 0 ]; then
    try "install apt packages: ${to_install[*]}" sudo apt-get install "${APT_OPTS[@]}" "${to_install[@]}"
  else
    info "No apt packages to install"
  fi
}

# Add i386 architecture if missing and install wine32
ensure_i386_and_wine32() {
  if ! dpkg --print-foreign-architectures | grep -qw i386; then
    try "add i386 architecture" sudo dpkg --add-architecture i386
    try "apt-get update after adding i386" sudo apt-get update
  else
    info "i386 architecture already present"
  fi
  if ! dpkg -s wine32 >/dev/null 2>&1; then
    try "install wine32" sudo apt-get install "${APT_OPTS[@]}" wine32
  else
    info "wine32 already installed"
  fi
}

# Ensure pipx is available; install via python3 -m pip if missing
ensure_pipx() {
  if has_cmd pipx; then
    info "pipx already available"
  else
    if has_cmd python3 && has_cmd pip3; then
      try "install pipx via python3 -m pip" sudo python3 -m pip install --upgrade pipx
      # ensure pipx bin path is added (pipx provides `pipx ensurepath`)
      if has_cmd pipx; then
        try "pipx ensurepath" pipx ensurepath || true
      fi
    else
      warn "python3/pip3 missing; cannot install pipx automatically"
      record_failure "pipx install: python3/pip3 missing"
    fi
  fi
}

# Install pipx packages idempotently
install_pipx_packages() {
  for pkg in "${PIPX_PACKAGES[@]}"; do
    if pipx list 2>/dev/null | grep -qF "$pkg"; then
      info "pipx package already installed: $pkg"
    else
      try "pipx install $pkg" pipx install "$pkg" || true
    fi
  done
}

# Install pip3 packages (non-fatal). Respect original --break-system-packages usage only if needed.
install_pip3_packages() {
  if ! has_cmd pip3; then
    warn "pip3 not found; skipping pip3 installs"
    record_failure "pip3 missing for: ${PIP3_PACKAGES[*]}"
    return 1
  fi

  for pkg in "${PIP3_PACKAGES[@]}"; do
    # try without breaking system packages first
    try "pip3 install $pkg" pip3 install --user "$pkg" || {
      warn "pip3 --user install failed for $pkg; trying global with --break-system-packages"
      try "pip3 install $pkg (fallback, may use --break-system-packages)" sudo pip3 install "$pkg" --break-system-packages || true
    }
  done
}

# Run veil setup if script exists
run_veil_setup() {
  if [ -x "$VEIL_SETUP" ]; then
    try "run veil setup (silent, force)" sudo "$VEIL_SETUP" --silent --force
  else
    warn "Veil setup not found or not executable at $VEIL_SETUP; skipping"
    record_failure "Veil setup missing: $VEIL_SETUP"
  fi
}

# Initialize msfdb if available
maybe_init_msfdb() {
  if has_cmd msfdb; then
    try "msfdb init" sudo msfdb init || true
  else
    warn "msfdb command not found; skipping msfdb init"
    record_failure "msfdb missing"
  fi
}

# Enable postgresql service if systemd present
enable_postgresql() {
  if has_cmd systemctl; then
    try "enable postgresql service" sudo systemctl enable postgresql || true
  else
    warn "systemctl not found; cannot enable postgresql"
    record_failure "systemctl missing (postgresql not enabled)"
  fi
}

# --- Main ---
info "Starting Silon installer $(date)"

install_apt_packages
ensure_i386_and_wine32
run_veil_setup

ensure_pipx
install_pipx_packages
install_pip3_packages

maybe_init_msfdb
enable_postgresql

# --- Summary ---
if [ "${#FAILURES[@]}" -gt 0 ]; then
  warn "One or more operations failed (script continued). Summary:"
  for f in "${FAILURES[@]}"; do
    printf ' - %s\n' "$f"
  done
  info "Please review the failures above. The script did NOT abort automatically."
else
  info "All operations reported OK (or were already satisfied)."
fi

info "Silon installer finished at $(date)"
# Intentionally exit 0 so callers/users don't consider the run 'crashed'.
exit 0
