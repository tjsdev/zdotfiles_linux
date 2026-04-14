#
# ~/.zprofile (Ubuntu)
# Login-shell config: PATH + env vars that should exist before ~/.zshrc runs.
#

# ----------------------------
# Locale
# ----------------------------
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

# ----------------------------
# Default tools
# ----------------------------
export PAGER="${PAGER:-less}"

# Prefer micro if installed, otherwise nano
if command -v micro >/dev/null 2>&1; then
  export EDITOR="${EDITOR:-micro}"
  export VISUAL="${VISUAL:-micro}"
else
  export EDITOR="${EDITOR:-nano}"
  export VISUAL="${VISUAL:-nano}"
fi

# Default browser (Ubuntu)
export BROWSER="${BROWSER:-xdg-open}"

# ----------------------------
# PATH (Ubuntu-focused, no duplicates)
# ----------------------------
typeset -gU path PATH

# Helper: prepend a directory only if it exists
path_prepend() {
  [[ -d "$1" ]] && path=("$1" $path)
}

# Helper: append a directory only if it exists
path_append() {
  [[ -d "$1" ]] && path+=("$1")
}

# Your user paths first
path_prepend "$HOME/.local/bin"
path_prepend "$HOME/bin"
path_prepend "$HOME/code/bin"

# Common dev tool paths (only if present)
path_append "$HOME/.composer/vendor/bin"
path_append "$HOME/.phive/tools"
path_append "$HOME/.symfony/bin"

# System/local (Ubuntu)
path_append "/usr/local/sbin"
path_append "/usr/local/bin"
path_append "/usr/sbin"
path_append "/usr/bin"
path_append "/sbin"
path_append "/bin"

export PATH

# ----------------------------
# Less defaults (good for logs)
# ----------------------------
export LESS='-F -g -i -M -R -S -w -X -z-4'

if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

# ----------------------------
# SSH convenience
# ----------------------------
# Use full path; avoid "~" in exports (it won’t expand everywhere)
export SSH_KEY_PATH="${SSH_KEY_PATH:-$HOME/.ssh/id_rsa}"

# ----------------------------
# Composer / PHP tooling
# ----------------------------
export COMPOSER_MEMORY_LIMIT="${COMPOSER_MEMORY_LIMIT:--1}"
export PHIVE_HOME="${PHIVE_HOME:-$HOME/.phive}"

# ----------------------------
# Android SDK (Ubuntu default)
# ----------------------------
# Only set if you actually use it; keeps things tidy.
if [[ -d "$HOME/Android/Sdk" ]]; then
  export ANDROID_HOME="$HOME/Android/Sdk"
  export ANDROID_SDK_ROOT="$ANDROID_HOME"
  path_append "$ANDROID_HOME/platform-tools"
fi

# ----------------------------
# Vagrant (Ubuntu-friendly defaults)
# ----------------------------
# Do NOT force VMware Fusion on Ubuntu. If you use libvirt, this is typical:
# export VAGRANT_DEFAULT_PROVIDER="${VAGRANT_DEFAULT_PROVIDER:-libvirt}"
export VAGRANT_LOG="${VAGRANT_LOG:-error}"

# Optional per-machine overrides (keep secrets / one-offs out of git)
[[ -f "$HOME/.zprofile.local" ]] && source "$HOME/.zprofile.local"

