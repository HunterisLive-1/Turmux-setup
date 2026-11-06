#!/data/data/com.termux/files/usr/bin/bash

# ─── Colors ─────────────────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

# Jo step fail hua uska naam yahan jaata hai; end me sach bataenge
FAILS=()
ok()   { echo -e "${GREEN}      ✓ $1${NC}"; }
fail() { FAILS+=("$1"); echo -e "${RED}      ✗ $1 fail hua${NC}"; }

# Phone ki screen ~40 column chaudi hoti hai, isliye box 40 ka
box() {
    local bar; bar=$(printf '═%.0s' $(seq 38))
    echo "╔${bar}╗"
    for line in "$@"; do
        if [ "$line" = "--" ]; then echo "╠${bar}╣"; else printf "║ %-36s ║\n" "$line"; fi
    done
    echo "╚${bar}╝"
}

clear

echo -e "${PURPLE}${BOLD}"
box "The Hunter Ai - Termux Setup v1.2" -- "YouTube : @TheHunter-AI" "GitHub  : HunterisLive-1" "Website : getmaya.online"
echo -e "${NC}"
sleep 1

# ─── Banner Name ─────────────────────────────────────────────────────
echo -e "${CYAN}${BOLD}Apna naam likho (banner ke liye):${NC}"
echo -e "${YELLOW}Jaise: Hunter, Rahul, Dev (bina space)${NC}"
echo ""
printf "➜ Your Name: "
read USER_BANNER_NAME
USER_BANNER_NAME="${USER_BANNER_NAME// /}"
[ -z "$USER_BANNER_NAME" ] && USER_BANNER_NAME="Hunter"
# Pehle Termux ke andar save (yahan permission nahi chahiye)
echo "$USER_BANNER_NAME" > ~/.hunter_name
ok "Banner set: ${USER_BANNER_NAME}"
echo ""
sleep 1

# ─── Step 1: Storage ─────────────────────────────────────────────────
echo -e "${CYAN}${BOLD}[1/9] Storage access setup...${NC}"
can_write_sdcard() { touch /sdcard/.hunter_probe 2>/dev/null && rm -f /sdcard/.hunter_probe; }
STORAGE_OK=0
if can_write_sdcard && [ -d ~/storage ]; then
    STORAGE_OK=1    # script dobara chal raha hai: permission pehle se hai, sawaal mat poochho
else
    echo -e "${YELLOW}      Popup aayega → Allow dabao${NC}"
    termux-setup-storage
    # Allow dabane tak ruko (60 second tak)
    for i in $(seq 1 60); do
        if can_write_sdcard; then STORAGE_OK=1; break; fi
        sleep 1
    done
fi
if [ "$STORAGE_OK" = 1 ]; then
    echo "$USER_BANNER_NAME" > /sdcard/hunter_config.txt && ok "Storage mil gaya, naam /sdcard/hunter_config.txt me save"
else
    fail "Storage permission (baad me: termux-setup-storage)"
fi

# ─── Step 2: System Update ───────────────────────────────────────────
# Upgrade ke beech config file wale sawaal (openssl.cnf, bash.bashrc...) aate hain;
# confdef+confold = wahi jo Enter dabane pe hota hai, bas script rukta nahi
echo -e "${CYAN}${BOLD}[2/9] System update & upgrade...${NC}"
# Termux khud koi bhi random mirror chunta hai; jo mirror us waqt sync ho raha ho
# us pe "File has unexpected size" aata hai aur update fail. User ne khud mirror
# nahi chuna ho (termux-change-repo) to default wala lagao — Cloudflare, sabse stable.
# (pkg pehle se chuna mirror kuch ghante tak nahi badalta, isliye sources.list bhi seedha likhte hain)
TM="$PREFIX/etc/termux"
if [ ! -e "$TM/chosen_mirrors" ] && [ -f "$TM/mirrors/default" ]; then
    MAIN_URL=$(sed -n 's/^MAIN="\(.*\)"$/\1/p' "$TM/mirrors/default")
    ln -sf "$TM/mirrors/default" "$TM/chosen_mirrors"
    if [ -n "$MAIN_URL" ]; then
        echo "deb $MAIN_URL stable main" > "$PREFIX/etc/apt/sources.list" && ok "Mirror: $MAIN_URL"
    fi
fi
pkg update -y || { sleep 3; pkg update -y; } || fail "pkg update"
apt-get -y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold full-upgrade \
    && ok "System upgrade" || fail "System upgrade"

# ─── Step 3: Core Packages ───────────────────────────────────────────
echo -e "${CYAN}${BOLD}[3/9] Core packages install ho rahe hain...${NC}"
pkg install -y git curl wget zip unzip tar nano vim figlet ruby zsh python python-pip nodejs proot-distro openssh uv \
    && ok "Core packages" || fail "Core packages"

echo -e "${CYAN}      lolcat install ho raha hai...${NC}"
gem install lolcat && ok "lolcat" || fail "lolcat"

# ─── Step 4: Python Tools ────────────────────────────────────────────
# Note: fastapi/pydantic-core skip — Rust chahiye jo Termux mein nahi
# Woh Ubuntu mein install honge
echo -e "${CYAN}${BOLD}[4/9] Python tools install ho rahe hain...${NC}"
pip install requests httpx flask uvicorn python-dotenv rich && ok "Python tools" || fail "Python tools"
# uv Termux ke apne package se aata hai (step 3); astral wala installer Android pe nahi chalta
command -v uv >/dev/null && ok "uv $(uv --version 2>/dev/null | cut -d' ' -f2)" || fail "uv"

# ─── Step 5: Node.js Global Tools ────────────────────────────────────
echo -e "${CYAN}${BOLD}[5/9] Node.js global tools install ho rahe hain...${NC}"
npm install -g nodemon pm2 serve yarn && ok "nodemon pm2 serve yarn" || fail "Node tools"

# ─── Step 6: Nerd Font — P10k ke liye ZAROORI ────────────────────────
echo -e "${CYAN}${BOLD}[6/9] Nerd Font install ho raha hai (P10k icons ke liye)...${NC}"
mkdir -p ~/.termux
wget -q -O ~/.termux/font.ttf \
  "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" \
  && ok "MesloLGS Nerd Font" || fail "Font"

# ─── Step 7: Oh My Zsh ───────────────────────────────────────────────
echo -e "${CYAN}${BOLD}[7/9] Oh My Zsh + Powerlevel10k + Plugins...${NC}"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
    || sh -c "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo -e "${YELLOW}      Oh My Zsh already installed — skip${NC}"
fi
[ -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ] && ok "Oh My Zsh" || fail "Oh My Zsh"

P10K_DIR="${HOME}/.oh-my-zsh/custom/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR" && ok "Powerlevel10k" || fail "Powerlevel10k"
else
    echo -e "${YELLOW}      Powerlevel10k already installed — skip${NC}"
fi

AS_DIR="${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
if [ ! -d "$AS_DIR" ]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$AS_DIR" && ok "zsh-autosuggestions" || fail "zsh-autosuggestions"
else
    echo -e "${YELLOW}      zsh-autosuggestions already installed — skip${NC}"
fi

# ─── Step 8: Configure .zshrc ────────────────────────────────────────
echo -e "${CYAN}${BOLD}[8/9] .zshrc configure ho raha hai...${NC}"
rm -f ~/.cache/p10k-instant-prompt-*.zsh 2>/dev/null

cat > ~/.zshrc << 'STATIC_ZSHRC'
# ═══════════════════════════════════════════════════
#  The Hunter Ai — Termux ZSH Config v1.2
#  YouTube : @TheHunter-AI | getmaya.online
# ═══════════════════════════════════════════════════

# MUST BE FIRST — P10k warning fix
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# ===== ALIASES =====
alias c='clear'
alias update='pkg update && pkg upgrade'
alias py='python'
alias coding='cd /sdcard/coding'
alias ubntu='proot-distro login ubuntu'
alias ubntu-code='proot-distro login ubuntu --work-dir /sdcard/coding'

# PATH
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH=/data/data/com.termux/files/home/.opencode/bin:$PATH

# ===== HUNTER BANNER =====
# Phone pe screen patli hai: 60 column se kam ho to chhota font, warna banner toot jaata hai
_hb_font=big; [ "${COLUMNS:-80}" -lt 60 ] && _hb_font=small
echo -e "\e[1;32m"
figlet -c -w "${COLUMNS:-80}" -f "$_hb_font" "$(cat ~/.hunter_name 2>/dev/null || echo Hunter)" | lolcat
echo -e "\e[0m"
unset _hb_font
# =========================

# P10k config (p10k configure se generate hoti hai)
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
STATIC_ZSHRC
ok ".zshrc"

# ─── Step 9: Final Setup ─────────────────────────────────────────────
echo -e "${CYAN}${BOLD}[9/9] Final setup...${NC}"

touch ~/.hushlogin
ok "MOTD disabled"

chsh -s zsh 2>/dev/null && ok "ZSH default shell" || fail "ZSH default shell"

termux-reload-settings 2>/dev/null && ok "Font applied" || true

# Ubuntu install — pehle dekho hai ya nahi, phir install; fail hua to sach batao
if proot-distro list -q 2>/dev/null | grep -qx ubuntu; then
    echo -e "${YELLOW}      Ubuntu already installed — skip${NC}"
else
    proot-distro install ubuntu && ok "Ubuntu installed" || fail "Ubuntu install"
fi

# Baaki do scripts: saath me download kiye hon to wahi, warna GitHub se
# ubuntuhunter.sh → /sdcard (Ubuntu ke andar se dikhta hai), androidhunter.sh → Termux home
BASE_URL="${HUNTER_BASE:-https://raw.githubusercontent.com/HunterisLive-1/Turmux-setup/main}"
HERE="$(cd "$(dirname "$0")" && pwd)"
get_script() {   # $1 = naam, $2 = kahan rakhna — hamesha naya wala (purana version na reh jaaye)
    if [ -f "$HERE/$1" ] && [ "$HERE/$1" != "$2" ]; then
        cp "$HERE/$1" "$2" && ok "$1 → $2" || fail "$1 copy"
    elif wget -q -O "$2.new" "$BASE_URL/$1" && [ -s "$2.new" ]; then
        mv -f "$2.new" "$2" && ok "$1 → $2"
    else
        rm -f "$2.new"; fail "$1 download"
    fi
}
[ "$STORAGE_OK" = 1 ] && get_script ubuntuhunter.sh /sdcard/ubuntuhunter.sh
get_script androidhunter.sh "$HOME/androidhunter.sh"

# ─── Done! ───────────────────────────────────────────────────────────
echo ""
if [ ${#FAILS[@]} -eq 0 ]; then
    echo -e "${GREEN}${BOLD}"
    box "TERMUX SETUP COMPLETE!" -- \
        "Ab ye karo:" \
        "1. Termux band karke khol do" \
        "2. Phir chalao: p10k configure" \
        "" \
        "Ubuntu setup:" \
        "-> proot-distro login ubuntu" \
        "-> bash /sdcard/ubuntuhunter.sh" \
        "" \
        "App banane ka setup (Termux me):" \
        "-> bash ~/androidhunter.sh"
    echo -e "${NC}"
    echo -e "${YELLOW}${BOLD}Termux restart karo, phir 'p10k configure' run karo! 🔥${NC}"
else
    echo -e "${RED}${BOLD}Setup poora nahi hua. Ye fail hue:${NC}"
    for f in "${FAILS[@]}"; do echo -e "${RED}  ✗ $f${NC}"; done
    echo -e "${YELLOW}Internet check karo aur 'bash hunter.sh' dobara chalao — jo ho chuka hai wo skip hoga.${NC}"
fi
