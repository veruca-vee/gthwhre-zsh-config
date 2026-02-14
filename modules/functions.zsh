unalias zushy 2>/dev/null

function zushy() {
    local target="$1"
    case $target in
        a|alias|aliases) micro ~/.zsh/modules/aliases.zsh; return ;;
        f|func|functions) micro ~/.zsh/modules/functions.zsh; return ;;
        p|prompt|theme)   micro ~/.zsh/modules/prompt.zsh; return ;;
        s|sec|secrets)    micro ~/.zsh/secrets.zsh; return ;;
        m|main|rc)        micro ~/.zshrc; return ;;
    esac
    echo -e "\n\033[1;35m🛠️  ZSH CONFIGURATION CENTER\033[0m"
    echo "1) 🎮 Aliases     (aliases.zsh)"
    echo "2) ⚙️  Functions   (functions.zsh)"
    echo "3) 🎨 Prompt      (prompt.zsh)"
    echo "4) 🔐 Secrets     (secrets.zsh)"
    echo "5) 🧠 Main Loader (.zshrc)"
    echo "6) 🔄 Reload Shell"
    echo "0) ❌ Cancel"
    read "choice?👉 Select module: "
    case $choice in
        1) micro ~/.zsh/modules/aliases.zsh ;;
        2) micro ~/.zsh/modules/functions.zsh ;;
        3) micro ~/.zsh/modules/prompt.zsh ;;
        4) micro ~/.zsh/secrets.zsh ;;
        5) micro ~/.zshrc ;;
        6) reload ;;
        *) echo "Aborted." ;;
    esac
}

function sysup() {
    local c_pink="\033[1;35m"
    local c_blue="\033[1;36m"
    local c_reset="\033[0m"

    echo -e "\n${c_pink}╔══════════════════════════════════════╗${c_reset}"
    echo -e "${c_pink}║      EMPIRE SYSTEM UPGRADE v3.1      ║${c_reset}"
    echo -e "${c_pink}╚══════════════════════════════════════╝${c_reset}"

    # 1. Permission & Manager Detection
    local _sudo=""
    # Only use sudo if we are NOT root and sudo exists (Standard Linux behavior)
    if [ "$EUID" -ne 0 ] && command -v sudo &> /dev/null; then
        _sudo="sudo"
    fi

    local package_manager=""
    local update_cmd=""

    # --- PRIORITY CHECK: Termux First ---
    if [ -n "$TERMUX_VERSION" ]; then
        package_manager="Termux (pkg)"
        update_cmd="pkg update -y && pkg upgrade -y && pkg autoclean"
    # --- Secondary Checks: Distros ---
    elif (( $+commands[dnf] )); then
        package_manager="Fedora (dnf)"
        update_cmd="$_sudo dnf upgrade --refresh -y"
    elif (( $+commands[pacman] )); then
        package_manager="Arch (pacman)"
        update_cmd="$_sudo pacman -Syu --noconfirm"
    elif (( $+commands[apt] )); then
        package_manager="Debian/Pop!_OS (apt)"
        update_cmd="$_sudo apt update && $_sudo apt full-upgrade -y"
    elif (( $+commands[apk] )); then
        package_manager="Alpine (apk)"
        update_cmd="apk update && apk upgrade"
    elif (( $+commands[xbps-install] )); then
        package_manager="Void (xbps)"
        update_cmd="$_sudo xbps-install -Su"
    else
        echo "❌ Unknown Empire Territory. No known package manager found."
        return 1
    fi

    # 2. Execute System Update
    echo -e "\n${c_blue}[1] 📦 Updating $package_manager...${c_reset}"
    eval $update_cmd

    # 3. Shell Plugins (Antidote)
    echo -e "\n${c_blue}[2] 💉 Updating Antidote...${c_reset}"
    if command -v antidote &> /dev/null; then
        antidote update
    else
        echo "Antidote missing."
    fi

    # 4. Python Tools (Empire Utilities)
    echo -e "\n${c_blue}[3] 🐍 Updating Python Tools...${c_reset}"
    if command -v pip &> /dev/null; then
        pip install -U "yt-dlp[default]" gallery-dl openai --break-system-packages 2>/dev/null
    else
        echo "Pip not found. Skipping python tools."
    fi

    echo -e "\n${c_pink}✅ UNIVERSAL SYNC COMPLETE.${c_reset}"
}

function install() {
    local packages=("$@")
    if [ ${#packages[@]} -eq 0 ]; then echo "Usage: install <package>"; return 1; fi
    local _sudo=""
    command -v sudo &> /dev/null && _sudo="sudo"

    if [ -f /etc/arch-release ]; then
        echo -e "🏹 \033[1;36mArch Linux Detected.\033[0m"
        $_sudo pacman -S --noconfirm "${packages[@]}"
    elif [ -f /etc/debian_version ]; then
        echo -e "🐧 \033[1;36mDebian/Ubuntu Detected.\033[0m"
        $_sudo apt update && $_sudo apt install -y "${packages[@]}"
    elif command -v pkg &> /dev/null; then
        echo -e "📱 \033[1;36mTermux Detected.\033[0m"
        pkg install -y "${packages[@]}"
    elif command -v dnf &> /dev/null; then
        echo -e "🤠 \033[1;36mFedora Detected.\033[0m"
        $_sudo dnf install -y "${packages[@]}"
    else
        echo "❌ No known package manager found."
        return 1
    fi
}

function sysinfo() {
    echo -e "\033[1;35m╔══════════════════════════════════════╗\033[0m"
    echo -e "\033[1;35m║     CYBER-SOVEREIGN SYSTEM INFO      ║\033[0m"
    echo -e "\033[1;35m╚══════════════════════════════════════╝\033[0m"
    echo -e "\033[1;36mUser:\033[0m \033[1;35mVeruca\033[0m@\033[1;36mVelharin\033[0m"
    local os_name=$(uname -o 2>/dev/null || uname -s)
    if [ -f /etc/arch-release ]; then os_name="Arch Linux"; fi
    echo -e "\033[1;36mOS:\033[0m   $os_name"
    echo -e "\033[1;36mShell:\033[0m ${SHELL##*/}" 
    echo -e "\033[1;36mTime:\033[0m  $(date +%T)"
    echo ""
}

function radio() {
    if ! command -v mpv &> /dev/null; then echo "❌ mpv not installed."; return 1; fi
    echo "🎧 Available stations:"
    echo "1) metal (SomaFM) 2) riot (Punk) 3) grunge 4) rap90 5) somafm (Indie) 6) kexp 7) stop"
    read "choice?Select: "
    case $choice in
        1) mpv http://ice1.somafm.com/metal-128-mp3 ;;
        2) mpv http://air.realpunkradio.com:8000/stream ;;
        3) mpv http://streams.90s90s.de/grunge/mp3-128/ ;;
        4) mpv http://streams.90s90s.de/hiphop/mp3-128/ ;;
        5) mpv http://ice1.somafm.com/indiepop-128-mp3 ;;
        6) mpv http://live-aacplus-64.kexp.org/kexp64.aac ;;
        7) killall mpd mpv 2>/dev/null && echo "🎵 Stopped" ;;
        *) echo "Invalid." ;;
    esac
}

function ref() {
    echo -e "\n\033[1;35m🏳️‍⚧️  CYBER-SOVEREIGN v8.1 REFERENCE\033[0m"
    cat ~/.zshrc ~/.zsh/modules/*.zsh | \
    awk '/^alias / { split($0, a, "="); sub(/alias /, "", a[1]); print a[1] } /^function / { sub(/function /, "", $2); sub(/\(\).*/, "", $2); print $2 }' | sort | column
}

function freezelove() {
    echo "🥶 Freezing dating apps..."
    local packages=("com.grindrapp.android" "com.takimi.android" "us.personals")
    for pkg in $packages; do adb shell pm disable-user --user 0 $pkg >/dev/null 2>&1; done
    echo "✅ Apps frozen."
}

function heatlove() {
    echo "🔥 Thawing dating apps..."
    local packages=("com.grindrapp.android" "com.takimi.android" "us.personals")
    for pkg in $packages; do adb shell pm enable $pkg >/dev/null 2>&1; done
    echo "✅ Apps active."
}
# LOG-WORK: Appends hours to the corporate ledger
# Usage: log-work
function log-work() {
    local DB="$HOME/Empire_Holdings/timesheet.csv"
    
    # 1. Initialize Database if missing
    # We check via SSH if the file exists on the PC
    empire "if [ ! -f ~/Empire_Holdings/timesheet.csv ]; then echo 'Date,Person,Category,Hours,Notes' > ~/Empire_Holdings/timesheet.csv; fi"
    
    echo "⏱️  Empire Time Clock"
    echo "---------------------"
    
    # 2. Gather Data
    echo "Who is this for?"
    select PERSON in "Winter" "Veruca"; do
        [ -n "$PERSON" ] && break
    done
    
    echo ""
    echo "Category?"
    select CAT in "Art_Creation" "Management" "Photo_Session" "Admin"; do
        [ -n "$CAT" ] && break
    done
    
    echo ""
    read "HOURS?Enter Hours (e.g. 1.5): "
    read "NOTES?Description: "
    
    # 3. Timestamp
    local TODAY=$(date +%Y-%m-%d)
    
    # 4. Commit to Mainframe
    # We append the line directly to the remote CSV
    empire "echo '$TODAY,$PERSON,$CAT,$HOURS,$NOTES' >> ~/Empire_Holdings/timesheet.csv"
    
    echo "✅ Logged: $PERSON | $CAT | $HOURS hrs"
}

# LEDGER: View the timesheet
function ledger() {
    # Pulls the CSV and formats it into a neat table
    empire "cat ~/Empire_Holdings/timesheet.csv" | column -t -s ","
}
function talk() {
    # Source secrets just in case they aren't loaded
    if [ -f "$HOME/.zsh/secrets.zsh" ]; then
        source "$HOME/.zsh/secrets.zsh"
    fi
    
    # Check if the script exists
    if [ -f "$HOME/scripts/vel_chat.py" ]; then
        python "$HOME/scripts/vel_chat.py"
    else
        echo "Error: Chat script not found at ~/scripts/vel_chat.py"
    fi
}
# --- Empire Intelligence Logging ---
# Usage: log-intel "Notes about the thing"
function log-intel() {
    # Define the Vault Inbox Path
    local vault_inbox="$HOME/Empire_Holdings/Intelligence_Vault/00_Inbox/Quick_Capture.md"
    
    # Check if the directory exists (sanity check)
    if [[ ! -d "$(dirname "$vault_inbox")" ]]; then
        echo "Error: Intelligence Vault not found at $(dirname "$vault_inbox")"
        return 1
    fi

    # Append the note with a timestamp
    echo "- [ ] $(date '+%Y-%m-%d %H:%M') - $*" >> "$vault_inbox"
    
    # Confirm
    echo "Entry logged to Intelligence Vault."
}
