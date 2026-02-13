alias zushy="micro ~/.zshrc" # Fallback if function fails
alias reload='source ~/.zshrc && echo "🩷🖤 Reloaded."'
alias gg="python ~/geminionium.py"
alias gask="~/data/data/com.termux/files/home/geminionium.sh"
alias ds="python ~/deepseek_cli.py"
alias ..='cd ..'
alias 1='cd -'
alias 2='cd -2'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias dl="cd ~/Downloads 2>/dev/null || cd ~/storage/downloads"
#alias cdm='cd ~ && cd .. && cd'
if command -v eza &> /dev/null; then
    alias ls='eza --git --group-directories-first'
    alias ll='eza -la --icons --git --group-directories-first'
else
    alias ls='ls --color=auto'
    alias ll='ls -la --color=auto'
fi
if command -v bat &> /dev/null; then alias cat='bat --style=plain --paging=never'; fi
if command -v termux-clipboard-set &> /dev/null; then
    alias clipcopy='termux-clipboard-set'
    alias clippaste='termux-clipboard-get'
fi
alias music="ncmpcpp"
alias shufmusic="mpv --shuffle **/*.(mp3|flac|m4a)"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias ports='netstat -tulanp 2>/dev/null || ss -tulanp'
alias myip="curl -s ifconfig.me"
alias rainbow='echo -e "\033[31mR\033[33mA\033[32mI\033[36mN\033[34mB\033[35mO\033[37mW"'
alias flag='echo -e "\033[1;35mP\033[1;36mI\033[1;37mN\033[1;35mK\033[0m \033[1;36mB\033[1;37mL\033[1;35mU\033[1;36mE\033[0m \033[1;37mW\033[1;35mH\033[1;36mI\033[1;37mT\033[1;35mE\033[0m"'
alias c="clear"
alias empire="ssh vel@vvpop.tail845007.ts.net"
alias clock="tty-clock -c -C 5"
alias gayclock="tty-clock -c | lolcat"
alias rish='$HOME/.rish/rish'
