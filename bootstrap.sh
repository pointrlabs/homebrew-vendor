#!/bin/bash
# Bootstrap for the Pointr Homebrew helpers. Installs or upgrades the ptr-brew
# formula, removing the legacy rc-file helpers if present. Safe to re-run.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/pointrlabs/homebrew-vendor/develop/bootstrap.sh | bash
#   curl -fsSL .../bootstrap.sh | bash -s -- <github-user> <github-token>
#
# With credentials supplied, ptr-setup runs non-interactively at the end.
#
# This file is deliberately minimal: it is fetched from an unpinned branch, so
# all logic that changes should live in bin/* which is versioned by the formula.
set -euo pipefail

TAP="pointrlabs/vendor"
TAP_URL="https://github.com/pointrlabs/homebrew-vendor.git"
FORMULA="$TAP/ptr-brew"

MARKER_START="# Pointr Homebrew helpers"
MARKER_END="# End Pointr Homebrew helpers"

GH_USER="${1:-}"
GH_TOKEN="${2:-}"

if ! command -v brew &>/dev/null; then
  echo "Homebrew is required. Install it first: https://brew.sh" >&2
  exit 1
fi

# --- Remove legacy shell helpers -------------------------------------------
# The previous installer appended a marker-delimited block of shell functions to
# an rc file. Those functions shadow the executables this formula installs, so
# they must go. Done before installing: if the install fails, the user is left
# with a clear error rather than neither implementation.
#
# All four rc files are checked, not just the current shell's — the old script
# picked its target from $SHELL, which is not always the shell that ran it.
legacy_removed=0
for rc in "$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.bash_profile" "$HOME/.profile"; do
  [ -f "$rc" ] || continue
  grep -q "$MARKER_START" "$rc" || continue

  cp "$rc" "${rc}.ptr-backup-$(date +%Y%m%d%H%M%S)"
  # -i.bak then delete the backup: portable across BSD and GNU sed.
  sed -i.bak "/$MARKER_START/,/$MARKER_END/d" "$rc"
  rm -f "${rc}.bak"
  echo "Removed legacy helpers from $rc (backup saved alongside it)."
  legacy_removed=1
done

# --- Install or upgrade -----------------------------------------------------
# Public tap, so no credentials in the remote.
brew tap "$TAP" "$TAP_URL" 2>/dev/null || true

if brew list "$FORMULA" &>/dev/null; then
  brew update
  if [ -n "$(brew outdated "$FORMULA")" ]; then
    echo "Upgrading ptr-brew..."
    brew upgrade "$FORMULA"
  else
    echo "ptr-brew is already up to date."
  fi
else
  echo "Installing ptr-brew..."
  # Fully-qualified name: Homebrew auto-trusts it, so no trust prompt.
  brew install "$FORMULA"
fi

# --- Hand off to ptr-setup --------------------------------------------------
if [ -n "$GH_USER" ] && [ -n "$GH_TOKEN" ]; then
  echo
  "$(brew --prefix)/bin/ptr-setup" --user "$GH_USER" --token "$GH_TOKEN"
else
  echo
  echo "Installed. Next step:"
  echo "  ptr-setup"
fi

# The rc block is gone from disk, but functions already loaded into the calling
# shell persist until it restarts — a child process cannot unset them.
if [ "$legacy_removed" -eq 1 ]; then
  echo
  echo "⚠  The old helpers were removed, but they are still active in THIS terminal."
  echo "   Run:  unset -f ptr-brew ptr-setup ptr-trust-taps"
  echo "   (or simply open a new terminal)"
fi
