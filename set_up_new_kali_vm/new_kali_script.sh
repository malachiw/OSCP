#!/usr/bin/env bash
# Silon: Robust installer script (refactor)
# - Idempotent where possible
# - Continues on errors and logs failures (doesn't "break")
# - Uses best practices: functions, checks, minimal side effects
# - Adjust package lists & paths as needed before running

set -o pipefail

# --- Configuration ---
# List of apt packages to install (add or remove as needed)
APT_PACKAGES=(pipx git feroxbuster ncat chisel neo4j bloodhound crackmapexec shellter wine veil)

# List of pipx packages to install (add or remove as needed)
PIPX_PACKAGES=(name-that-hash dirsearch "git+https://github.com/Pennyw0rth/NetExec")

# List of pip3 packages to install (add or remove as needed)
PIP3_PACKAGES=(wsgidav)  # This will be installed with --break-system-packages

# Path to Veil setup script (change if needed)
VEIL_SETUP="/var/share/veil/config/setup.sh"

# Array to track failed installations (so we can report them later)
FAILURES=()

# --- Helper Functions ---
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

# Check if a command exists
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

# Install pip3 packages with --break-system-packages for wsgidav
install_pip3_packages() {
  if ! has_cmd pip3; then
    warn "pip3 not found; skipping pip3 installs"
    record_failure "pip3 missing for: ${PIP3_PACKAGES[*]}"
    return 1
  fi

  for pkg in "${PIP3_PACKAGES[@]}"; do
    # Specifically install wsgidav with --break-system-packages
    if [ "$pkg" == "wsgidav" ]; then
      try "pip3 install $pkg (with --break-system-packages)" sudo pip3 install "$pkg" --break-system-packages || true
    else
      # Normal install for other packages
      try "pip3 install $pkg" pip3 install --user "$pkg" || {
        warn "pip3 --user install failed for $pkg; trying global with --break-system-packages"
        try "pip3 install $pkg (fallback, may use --break-system-packages)" sudo pip3 install "$pkg" --break-system-packages || true
      }
    fi
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

# Install add_creds to /usr/bin
install_add_creds() {
    local target="/usr/bin/add_creds"
    local tmpfile

    echo "Creating add_creds utility at $target ..."

    # Try to create a temporary file safely
    tmpfile=$(mktemp) || {
        echo "Failed to create temporary file."
        return 1
    }

    # Write the script into the temp file
    cat > "$tmpfile" <<"EOF"
#!/bin/zsh

# Ensure two arguments are passed
if [[ "$#" -ge 3 ]]; then
    echo "Usage: add_creds <username> <password> <path> <notes (optional)>"
    exit 1
fi

# Ensure the destination file exists or can be created
if ! touch "$3" 2>/dev/null; then
    echo "Error: Cannot write to $2"
    exit 1
fi

# Append creds to cred file
if [[ "$#" == 3 ]]; then
  echo "$1:$2" >> "$3"
else
   echo "$1:$2 $4" >> "$3"
echo "Credentials added to $2"
EOF

    # Move to /usr/bin
    if ! sudo mv "$tmpfile" "$target" 2>/dev/null; then
        echo "Failed to move script to $target (need sudo?)."
        rm -f "$tmpfile"
        return 1
    fi

    # Make executable
    if ! sudo chmod +x "$target" 2>/dev/null; then
        echo "Failed to make $target executable."
        return 1
    fi

    echo "Installed $target successfully."
    return 0
}

# --- Main ---
info "Starting Silon installer $(date)"

# Install apt packages
install_apt_packages

# Ensure i386 architecture and install wine32 if needed
ensure_i386_and_wine32

# Run Veil setup
run_veil_setup

# Ensure pipx is available, install if needed
ensure_pipx

# Install pipx packages
install_pipx_packages

# Install pip3 packages
install_pip3_packages

# Initialize msfdb if available
maybe_init_msfdb

# Enable postgresql service if available
enable_postgresql

# Install add_creds
install_add_creds

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
