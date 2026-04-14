#
# ~/.zshrc (Ubuntu)
# Interactive shell config: aliases, functions, prompt hooks, completion.
#

# ----------------------------
# Prezto (optional)
# ----------------------------
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# ----------------------------
# Shell behavior (sane defaults)
# ----------------------------
setopt AUTO_CD
setopt EXTENDED_GLOB
setopt INTERACTIVE_COMMENTS
setopt NO_BEEP

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt INC_APPEND_HISTORY
setopt HIST_REDUCE_BLANKS

# ----------------------------
# Convenience: editor shortcut
# ----------------------------
# Prefer code, then atom, then vim, then nano
if command -v code >/dev/null 2>&1; then
  alias e='code'
elif command -v atom >/dev/null 2>&1; then
  alias e='atom'
elif command -v vim >/dev/null 2>&1; then
  alias e='vim'
else
  alias e='nano'
fi

alias zcr='e ~/.zshrc'
alias zcp='e ~/.zprofile'
alias src='exec /usr/bin/zsh -l'  # restart as login shell

# ----------------------------
# Safer core utils
# ----------------------------
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -i'

# GNU grep supports --color; Ubuntu grep is GNU by default
alias grep='grep --color=auto -in'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias c='clear'
alias t='todo.sh'

# ls (Ubuntu/GNU coreutils)
alias ll='ls -lah --group-directories-first --color=auto'
alias la='ls -a1 --color=auto'
alias ls='ls -1 --color=auto'

# Keep your vagrant shortcut
alias v='vagrant'

# ----------------------------
# Docker
# ----------------------------
alias d='docker'
alias dp='docker ps'
alias dpa='docker ps -a'
alias di='docker images'
alias dport='docker container ls --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}" -a | grep -E ":"'

# Prefer modern `docker compose` plugin; fall back to docker-compose binary
if docker compose version >/dev/null 2>&1; then
  alias dc='docker compose'
  alias dcb='docker compose build && docker compose up -d'
  alias dcbc='docker compose build --no-cache --pull && docker compose up -d'
else
  alias dc='docker-compose'
  alias dcb='docker-compose build && docker-compose up -d'
  alias dcbc='docker-compose build --force-rm --no-cache && docker-compose up -d'
fi

# Rector container (fixed flags + quoting)
alias rector='docker run --rm -t -v "$(pwd):/project" rector/rector:latest'

# ----------------------------
# Gitignore helper
# ----------------------------
# Note: gitignore.io has been unreliable in recent years, but keep it if you use it.
function gi() { curl -fsSL "https://www.gitignore.io/api/$*"; }

# ----------------------------
# Completion (once)
# ----------------------------
# Only add dirs that exist
fpath=(
  "$HOME/.zsh/completion"
  /usr/local/share/zsh/site-functions
  /usr/share/zsh/vendor-completions
  /usr/share/zsh/functions/Completion
  $fpath
)

autoload -Uz compinit
compinit -i

# ----------------------------
# Dotfiles repo (Linux zsh config)
# ----------------------------
alias zdots='git --git-dir="$HOME/.zdotfiles_linux/" --work-tree="$HOME"'

# ----------------------------
# Secret checking for zdots commits
# ----------------------------
zdots-secret-check() {
  local patterns='PRIVATE KEY|OPENAI_API_KEY|ANTHROPIC_API_KEY|GEMINI_API_KEY|API[_-]?KEY|TOKEN|SECRET|PASSWORD|AWS_ACCESS_KEY_ID|AWS_SECRET_ACCESS_KEY|BEGIN RSA|BEGIN OPENSSH|BEGIN EC'
  echo "Checking staged zdots diff for obvious secrets..."
  if zdots diff --cached | grep -E -i "$patterns"; then
    echo
    echo "⚠️  Possible secret-like content found in staged changes."
    echo "Review before commit/push."
    return 1
  else
    echo "✅ No obvious secret patterns found in staged changes."
  fi
}

# ----------------------------
# Local overrides (optional)
# ----------------------------
# Put host-specific stuff here (work VPN env vars, private tokens, etc.)
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"