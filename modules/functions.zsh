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
# Function to move the last X photos to a specific session folder
function session-move() {
    local target_dir="$1"
    if [[ -z "$target_dir" ]]; then
        echo "Usage: session-move /path/to/target"
        return 1
    fi
    mkdir -p "$target_dir"
    # Moves everything from Camera to target
    mv /sdcard/DCIM/Camera/* "$target_dir/"
    echo "Session files moved to $target_dir"
}
# Session-based content watcher for Empire Operations
# Usage: capture-session
function capture-session() {
    local TARGET_DIR="$HOME/Empire_Holdings/content"
    local SOURCE_DIR="/sdcard/DCIM/Camera"

    # 1. Create directory if it doesn't exist
    if [[ ! -d "$TARGET_DIR" ]]; then
        echo "Creating session directory: $TARGET_DIR"
        mkdir -p "$TARGET_DIR"
    fi

    echo "--- EMPIRE CONTENT SIPHON ACTIVATED ---"
    echo "Source: $SOURCE_DIR"
    echo "Destination: $TARGET_DIR"
    echo "Status: Monitoring... (Press Ctrl+C to stop)"
    echo "---------------------------------------"

    # 2. Loop until interrupted (Ctrl+C)
    # Using 'zstat' or 'ls' to check for files
    while true; do
        # Check if there are any files in the source
        # (nullglob ensures the loop doesn't error if empty)
        setopt localoptions nullglob
        files=($SOURCE_DIR/*)

        if (( ${#files} > 0 )); then
            for file in "${files[@]}"; do
                # Move the file and provide a quick log
                mv "$file" "$TARGET_DIR/"
                echo "[$(date +%H:%M:%S)] Moved: ${file:t}"
            done
        fi

        # Sleep for 2 seconds to save battery/CPU while waiting
        sleep 2
    done
}
function ytdl_get() {
    # a. Validate input
    if [[ -z "$1" ]]; then
        echo "Usage: ytdl_get <URL or ytsearch1:query>"
        return 1
    fi

    local url="$1"
    local format_choice
    local custom_name
    local output_template
    local format_flags=()
    local tmp_file=$(mktemp)

    # b. Reality Check for multi-file searches
    # Using ytsearch5: downloads 5 files, which breaks the single-file portal link.
    if [[ "$url" == ytsearch[2-9]* ]] || [[ "$url" == ytsearch[1-9][0-9]* ]]; then
        echo "Reality Check: A search for multiple videos (like ytsearch5:) will download all of them."
        echo "This breaks the single custom name and portal link. Use 'ytsearch:' or 'ytsearch1:' instead."
        rm -f "$tmp_file"
        return 1
    fi

    # c. Prompt for Format
    echo -n "Format: [m]usic (mp3) or [v]ideo (mp4)? (m/v): "
    read format_choice

    if [[ "$format_choice" == "m" || "$format_choice" == "M" ]]; then
        # Forces audio extraction to mp3
        format_flags=( -x --audio-format mp3 --audio-quality 0 )
    else
        # Forces best video/audio combination merged into an mp4 container
        format_flags=( -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" --merge-output-format mp4 )
    fi

    # d. Prompt for Name
    echo -n "Name file (Leave blank for default): "
    read custom_name

    if [[ -z "$custom_name" ]]; then
        output_template="%(title)s.%(ext)s"
    else
        output_template="${custom_name}.%(ext)s"
    fi

    echo -e "\nStarting download..."

    # e. Execute yt-dlp with the new format flags
    yt-dlp "$url" -o "$output_template" "${format_flags[@]}" --quiet --progress --exec 'printf "%s\n" "{}" > '"$tmp_file"

    local downloaded_file=$(cat "$tmp_file")
    rm -f "$tmp_file"

    # f. Generate the clickable portal and launch prompt
    if [[ -n "$downloaded_file" && -f "$downloaded_file" ]]; then
        local abs_path=$(readlink -f "$downloaded_file")
        local filename=$(basename "$abs_path")

        printf "\n\033[1;32m✓ Download Complete!\033[0m\n"

        # Generates an OSC 8 hyperlink
        printf "\033]8;;file://%s\033\\🔗 [PORTAL] CLICK HERE TO OPEN: %s\033]8;;\033\\\n\n" "$abs_path" "$filename"

        echo -n "Launch file now? (y/N): "
        read start_file

        if [[ "$start_file" == "y" || "$start_file" == "Y" ]]; then
            # OS-aware execution (Termux vs Pop!_OS)
            if command -v termux-open >/dev/null 2>&1; then
                termux-open "$abs_path"
            elif command -v xdg-open >/dev/null 2>&1; then
                xdg-open "$abs_path"
            elif command -v mpv >/dev/null 2>&1; then
                mpv "$abs_path"
            else
                echo "Could not find a default application to launch the file automatically."
            fi
        fi
    else
        echo -e "\nError: Could not locate the downloaded file."
    fi
}
# DeepSeek Claude wrappers (Termux-optimized)
function deepclaude() {
  echo "🌌 Claude Code now powered by DeepSeek (deepseek-chat)"
  claude "$@"
}

function ds-chat() {  # quick one-liner test
  python3 -c "
import anthropic, sys
client = anthropic.Anthropic()
msg = client.messages.create(
    model='deepseek-chat',
    max_tokens=500,
    system='You are a helpful assistant.',
    messages=[{'role': 'user', 'content': '\$1'}]
)
print(msg.content[0].text if msg.content else 'No response')
" "\$1"
}
# Auto-Zushy Project Generator
# Usage: znew <project-name>   (example: znew my-api)
function znew() {
  if [[ $# -eq 0 ]]; then
    print -- "Usage: znew <project-name>"
    return 1
  fi

  local project_name="$1"
  local projects_root="${EMPIRE_PROJECTS:-$HOME/projects}"
  local project_dir="$projects_root/$project_name"
  local alias_file="$HOME/.zsh/modules/aliases.zsh"

  # Safety: if folder exists, ask to overwrite or abort
  if [[ -d "$project_dir" ]]; then
    if read -q "?Project '$project_name' already exists. Overwrite? (y/N) "; then
      print --
      rm -rf "$project_dir"
    else
      print -- "\nAborted."
      return 1
    fi
  fi

  # Create project directory, src, logs, and cd into it
  mkdir -p "$project_dir"/{src,logs} || return 1
  cd "$project_dir" || return 1

  # Initialize git repository
  git init --quiet
  touch .gitignore

  # Create standard README
  cat > README.md <<EOF
# $project_name

**Created:** $(date)
**Location:** $project_dir

This is how we edit at all.
EOF

  # Append project-specific aliases directly to the Fortified alias module
  cat >> "$alias_file" <<EOF

# === Auto-generated for $project_name ===
alias ${project_name}='cd $project_dir'
alias ${project_name}-logs='tail -f $project_dir/logs/*.log'
alias ${project_name}-dev='cd $project_dir/src && make dev'
EOF

  # Success message
  print -- "\n✨ Project '$project_name' successfully created!"
  print -- "📁 Directory: $project_dir"
  print -- "📝 Aliases injected into $alias_file"
  print -- "\nOpening micro to review your new aliases. Save and exit to reload shell."

  sleep 2
  micro "$alias_file"

  # Reload shell to apply new aliases
  exec zsh
}
function radio() {
    if ! command -v mpv &> /dev/null; then echo "❌ mpv not installed."; return 1; fi
    echo "🎧 Stations: 1)metal 2)punk 3)grunge 4)rock-esp 5)alt90 6)rap90 7)somafm 8)kexp 9)jackfm 10)stop"
    read "choice?Select: "
    case $choice in
        1) mpv "http://ice1.somafm.com/metal-128-mp3" ;;
        2) mpv "http://streams.radiobob.de/bob-punk/mp3-192/streams.radiobob.de/" ;;
        3) mpv "http://streams.radiobob.de/bob-grunge/mp3-192/streams.radiobob.de/" ;;
        4) mpv "http://stream.laut.fm/radio-rock-pop-espanol" ;;
        5) mpv "https://stream.starfm.de/alternat/mp3-192/iradio" ;;
        6) mpv "http://listen.181fm.com/181-oldschool_128k.mp3" ;;
        7) mpv "http://ice1.somafm.com/indiepop-128-mp3" ;;
        8) mpv "https://kexp-mp3-128.streamguys1.com/kexp128.mp3" ;;
        9) mpv "https://tunein.com/radio/947-Jack-FM-1067-s236724/" ;;
        10|stop) killall mpd mpv 2>/dev/null && echo "🎵 Stopped" ;;
        *) echo "Invalid." ;;
    esac
}
function empire-breach() {
    clear
    echo -e "\033[1;31m[!] UNAUTHORIZED ACCESS DETECTED\033[0m"
    sleep 1
    echo -e "\033[1;32m[+] INITIATING BRUTEFORCE OVERRIDE...\033[0m"
    sleep 0.5

    # Dumps 40 lines of random hex data in green text
    hexdump -v -e '1/1 "%02X "' /dev/urandom | fold -w 80 | head -n 40 | while read -r line; do
        echo -e "\033[0;32m$line\033[0m"
        sleep 0.03
    done

    echo -e "\n\033[1;31m[!] MAINFRAME DEFENSES BREACHED.\033[0m"
    sleep 0.5
    echo -e "\033[1;35m[+] WELCOME TO THE EMPIRE, VELHARIN.\033[0m\n"
}
function net-breach() {
    local ssid="$1"
    local pass="$2"

    if [[ -z "$ssid" || -z "$pass" ]]; then
        echo -e "\033[1;31m[!] SYNTAX ERROR: net-breach <TARGET_SSID> <PAYLOAD_KEY>\033[0m"
        echo -e "Usage: net-breach \"Starbucks WiFi\" \"the_actual_password\""
        return 1
    fi

    clear
    echo -e "\033[1;31m[!] INITIALIZING 802.11 EXPLOIT FRAMEWORK...\033[0m"
    sleep 1
    echo -e "\033[1;33m[*] Targeting BSSID associated with: $ssid\033[0m"
    sleep 0.5
    echo -e "\033[1;32m[*] Injecting cryptographic payload...\033[0m"

    # The visual smoke and mirrors
    hexdump -v -e '1/1 "%02X "' /dev/urandom | fold -w 60 | head -n 12 | while read -r line; do
        echo -e "\033[0;32m$line\033[0m"
        sleep 0.05
    done

    echo -e "\033[1;33m[*] Payload accepted. Forcing handshake...\033[0m"
    sleep 1

    # The actual functional command
    nmcli dev wifi connect "$ssid" password "$pass" > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo -e "\n\033[1;32m[+] ACCESS GRANTED. We are inside $ssid.\033[0m"
        echo -e "\033[1;36mNetwork interface updated. You are online.\033[0m\n"
    else
        echo -e "\n\033[1;31m[-] INJECTION FAILED. Target actively repelling (Wrong password or out of range).\033[0m\n"
    fi
}

function log-work() {
    local DB="$HOME/Empire_Holdings/timesheet.csv"

    # 1. Initialize Database if missing
    # We check via SSH if the file exists on the PC
    empire "if [ ! -f ~/Empire_Holdings/timesheet.csv ]; then echo 'Date,Person,Category,Hours,Notes' > ~/Empire_Holdings/timesheet.csv; fi"

    echo "⏱️  Empire Time Clock"
    echo "---------------------"

    # 2. Gather Data (Solo Operative)
    local PERSON="Veruca"
    echo "Logging as: $PERSON"
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
function edit-func() {
    local func_name="$1"
    if [[ -z "$func_name" ]]; then
        echo "❌ Target missing. Usage: edfu <function_name>"
        return 1
    fi
    local func_file="$HOME/.zsh/modules/functions.zsh"
    local line_num

    # Locate the line number of the target function
    line_num=$(grep -n -E "^(function )?${func_name}\(\) *\{" "$func_file" | head -n 1 | cut -d: -f1)

    if [[ -n "$line_num" ]]; then
        echo "[*] Found '$func_name' at line $line_num. Initializing micro..."
        # Launch micro and jump directly to the function's starting line
        micro "+${line_num}" "$func_file"
    else
        echo "[+] '$func_name' not found. Generating standardized block..."
        # Auto-append a clean, normalized template
        echo -e "\nfunction ${func_name}() {\n    \n}" >> "$func_file"
        line_num=$(grep -n -E "^function ${func_name}\(\) *\{" "$func_file" | tail -n 1 | cut -d: -f1)
        
        # Jump micro directly into the empty body of the new function
        micro "+$((line_num + 1))" "$func_file"
    fi

    # Automatically source upon exiting micro
    source "$func_file"
    echo -e "\n✅ '$func_name' is synced and live."
}
function normalize-funcs() {
    local func_file="$HOME/.zsh/modules/functions.zsh"

    echo -e "\033[1;36m[*] Scanning $func_file for non-standard declarations...\033[0m"

    # This sed command looks for any line starting with a name followed by () {
    # and strictly ignores lines that already start with "function "
    sed -i 's/^\([A-Za-z0-9_-]\+\)() *{/function \1() {/' "$func_file"

    echo -e "\033[1;32m[+] Codebase normalized. All functions are uniform.\033[0m"

    # Reload the file so the shell recognizes any structural changes
    source "$func_file"
}
function empire-studio() {
    echo -e "\033[1;35m[+] Initializing Empire Studio Mode...\033[0m"

    # Check if the Termux:API package is installed in the shell
    if ! command -v termux-brightness &> /dev/null; then
        echo -e "\033[1;31m❌ Termux:API CLI tools missing. Run 'pkg install termux-api'.\033[0m"
        return 1
    fi

    # 1. Maximize screen brightness for lighting and clear visibility
    echo "💡 Pushing display brightness to maximum..."
    termux-brightness 255

    # 2. Silence ringers and notifications to prevent mid-session interruptions
    echo "🔇 Silencing device ringers..."
    termux-volume ring 0
    termux-volume notification 0

    # 3. Flash a native Android toast pop-up on the screen
    termux-toast -c "#FF00FF" "Empire Studio Active. Get to work, Vel."

    # 4. Launch the default Camera app using an Android Activity Intent
    echo "📸 Launching optics..."
    am start -a android.media.action.STILL_IMAGE_CAMERA >/dev/null 2>&1

    echo -e "\033[1;32m✅ Environment prepped. You are on the clock.\033[0m"
}
function empire-standdown() {
    echo -e "\033[1;36m[-] Standing down Empire Studio Mode...\033[0m"

    # 1. Restore brightness to a comfortable baseline
    echo "💡 Normalizing display brightness..."
    termux-brightness 100

    # 2. Restore ringers and notifications to a standard volume (usually out of 7 or 15)
    echo "🔊 Restoring device audio..."
    termux-volume ring 5
    termux-volume notification 5

    # 3. Flash a native Android toast pop-up on the screen
    termux-toast -c "#00FFFF" "Studio Offline. Operations normalized."

    echo -e "\033[1;32m✅ Device parameters restored.\033[0m"
}

function empire-sideload() {
    local repo="$1"

    if [[ -z "$repo" ]]; then
        echo -e "\033[1;31m[!] SYNTAX ERROR: empire-sideload <owner/repo>\033[0m"
        echo -e "Usage: empire-sideload \"termux/termux-app\""
        return 1
    fi

    if ! command -v jq &> /dev/null; then
        echo "❌ 'jq' is missing. Run: pkg install jq"
        return 1
    fi

    echo -e "\033[1;36m[*] Probing GitHub API for $repo latest release...\033[0m"
    local api_url="https://api.github.com/repos/$repo/releases/latest"

    # Fetch the raw JSON response once to check for errors before parsing
    local response=$(curl -s "$api_url")

    # Check if GitHub threw an error (like rate limiting or a missing repo)
    local api_error=$(echo "$response" | jq -r '.message // empty')
    if [[ -n "$api_error" ]]; then
        echo -e "\033[1;31m[-] API BLOCK: GitHub responded with -> $api_error\033[0m"
        return 1
    fi

    # The '[]?' safely handles releases that don't have an assets array
    local download_url=$(echo "$response" | jq -r '.assets[]? | select(.name | endswith(".apk")) | .browser_download_url' | head -n 1)

    if [[ -z "$download_url" || "$download_url" == "null" ]]; then
        echo -e "\033[1;31m[-] INJECTION FAILED. No pre-compiled APK asset found in the latest release.\033[0m"
        echo -e "\033[1;33m[*] Target likely distributes binaries via F-Droid or Google Play instead.\033[0m"
        return 1
    fi

    local filename=$(basename "$download_url")
    echo -e "\033[1;32m[+] Payload located: $filename\033[0m"
    echo -e "\033[1;33m[*] Initiating secure download pipeline...\033[0m"

    curl -L -o "$filename" "$download_url"

    echo -e "\n\033[1;32m✅ Asset secured: $(readlink -f "$filename")\033[0m"

    if command -v termux-open &> /dev/null; then
        echo -n "Deploy payload to device now? (y/N): "
        read install_choice
        if [[ "$install_choice" == "y" || "$install_choice" == "Y" ]]; then
            termux-open "$filename"
        fi
    fi
}
function empire-share() {
    local port="${1:-8080}"

    # 1. Try to grab Tailscale IP first (tun0 is standard for Android VPN interfaces)
    local ip=$(ip -4 addr show tailscale0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    [[ -z "$ip" ]] && ip=$(ip -4 addr show tun0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

    local is_ts=1

    # 2. Fallback to local Wi-Fi (wlan0) if Tailscale is offline
    if [[ -z "$ip" ]]; then
        ip=$(ifconfig wlan0 2>/dev/null | grep -oE 'inet [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | awk '{print $2}')
        is_ts=0
    fi

    clear
    if [[ $is_ts -eq 1 ]]; then
        echo -e "\033[1;35m[+] SPINNING UP SECURE TAILSCALE RELAY...\033[0m"
        echo -e "\033[1;36m[*] Traffic is encrypted over your private mesh.\033[0m"
    else
        echo -e "\033[1;35m[+] SPINNING UP LOCAL WI-FI RELAY...\033[0m"
        echo -e "\033[1;33m[*] Warning: Unencrypted local network traffic.\033[0m"
    fi

    if [[ -n "$ip" ]]; then
        echo -e "\033[1;32m[*] Target URL: http://$ip:$port\033[0m"
    else
        echo -e "\033[1;31m[*] Network interface not found. Are you offline?\033[0m"
        return 1
    fi

    echo -e "\033[1;36m[*] Serving Directory: $(pwd)\033[0m"
    echo -e "\033[1;31m[!] Press Ctrl+C to drop the server.\033[0m\n"

    python3 -m http.server "$port"
}
# Pixel-Media Menu Controller (pixedia)
# Explicit CD + Relative Scan + mpv Backend
function pixedia() {
    # Dependency Check
    if ! command -v mpv &> /dev/null || ! command -v fzf &> /dev/null; then
        echo "[-] Missing dependencies. Run: pkg install mpv fzf"
        return 1
    fi

    # CD into storage before scanning
    if [ -d "$HOME/storage/music" ]; then
        cd "$HOME/storage/music" || return 1
    elif [ -d "$HOME/storage/shared" ]; then
        cd "$HOME/storage/shared" || return 1
    else
        echo "[-] Storage not linked. Run: termux-setup-storage"
        return 1
    fi

    local music_file
    local last_query=""
    local selected_path=""

    # Navigation Loop
    while true; do
        # Scan current directory recursively using relative paths
        music_file=$(find . -type f \
            \( -iname "*.mp3" -o -iname "*.flac" -o -iname "*.wav" -o -iname "*.m4a" \) \
            2>/dev/null | fzf \
                --header="[ pixedia-controller | ESC to quit ]" \
                --height=80% \
                --reverse \
                --query="$last_query" \
                --print-query)

        # Parse fzf output
        last_query=$(echo "$music_file" | sed -n '1p')
        selected_path=$(echo "$music_file" | sed -n '2p')

        # Break loop if no file selected
        if [[ -z "$selected_path" ]]; then
            echo "[!] Exiting pixedia."
            break
        fi

        clear
        echo "[+] Playing: ${selected_path:t}"
        echo "[!] Press 'q' in mpv to return to menu"

        # Execute playback
        mpv --no-video "$selected_path"
    done
}
function osint() { ~/tools/osint/recon_wrapper.sh "$@" }
function repurpose() {
    local source_text=$1
    local platforms=("X" "Instagram" "LinkedIn")
    
    if [[ -z "$source_text" ]]; then
        echo "Usage: repurpose '<source_text>'"
        return 1
    fi

    local current_dir=$(pwd)
    cd ~/projects/content_engine || return 1
    
    # Suppress the activation output
    source venv/bin/activate
    
    echo "Processing multi-platform pipeline via DeepSeek..."
    echo "=================================================="
    
    for platform in "${platforms[@]}"; do
        echo "[ $platform ]"
        python engine.py "$source_text" "$platform" | grep -v "Processing payload"
        echo "--------------------------------------------------"
    done

    deactivate
    cd "$current_dir"
}
