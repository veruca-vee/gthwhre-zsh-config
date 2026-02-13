# ==========================================
# 🏳️‍⚧️ CYBER-SOVEREIGN UNIVERSAL v8.1 (Fortified)
# User: Veruca (Velharin)
# ==========================================

# --- 1. PLUGIN MANAGER (ANTIDOTE) ---
[[ -d ${ZDOTDIR:-~}/.antidote ]] || git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load

# --- 2. PERFORMANCE (COMPINIT CACHING) ---
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
setopt INTERACTIVE_COMMENTS

# --- 3. ENVIRONMENT ---
export EDITOR='micro'
export PATH="$HOME/.local/bin:$PATH"
export MPD_HOST="127.0.0.1"
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_USE_ASYNC=1

# --- 4. LOAD MODULES ---
if [[ -f ~/.zsh/secrets.zsh ]]; then source ~/.zsh/secrets.zsh; fi
for module in ~/.zsh/modules/*.zsh; do source "$module"; done

# --- 5. HISTORY ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt INC_APPEND_HISTORY
