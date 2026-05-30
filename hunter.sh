#!/data/data/com.termux/files/usr/bin/bash

# ─── Colors ─────────────────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

clear

echo -e "${PURPLE}${BOLD}"
echo "╔═══════════════════════════════════════════════════╗"
echo "║     HunterIsLive — Termux Setup Script v1.1      ║"
echo "╠═══════════════════════════════════════════════════╣"
echo "║  YouTube : @HunterIsLive                         ║"
echo "║  GitHub  : github.com/HunterisLive-1             ║"
echo "║  Website : getmaya.online                        ║"
echo "╚═══════════════════════════════════════════════════╝"
echo -e "${NC}"
sleep 1

# ─── Banner Name ─────────────────────────────────────────────────────
echo -e "${CYAN}${BOLD}Apna naam/handle enter karo (figlet banner ke liye):${NC}"
echo -e "${YELLOW}Example: Hunter  |  Rahul  |  Dev  (space mat use karna)${NC}"
echo ""
printf "➜ Your Name: "
read USER_BANNER_NAME
[ -z "$USER_BANNER_NAME" ] && USER_BANNER_NAME="Hunter"

# Save for Ubuntu script
mkdir -p /sdcard 2>/dev/null
echo "$USER_BANNER_NAME" > /sdcard/hunter_config.txt

echo ""
echo -e "${GREEN}✓ Banner set: ${BOLD}${USER_BANNER_NAME}${NC}"
echo -e "${GREEN}✓ Config saved to /sdcard/hunter_config.txt${NC}"
echo ""
sleep 1

# ─── Step 1: Storage ─────────────────────────────────────────────────
echo -e "${CYAN}${BOLD}[1/9] Storage access setup...${NC}"
termux-setup-storage
sleep 3

# ─── Step 2: System Update ───────────────────────────────────────────
echo -e "${CYAN}${BOLD}[2/9] System update & upgrade...${NC}"
pkg update -y && pkg upgrade -y

# ─── Step 3: Core Packages ───────────────────────────────────────────
echo -e "${CYAN}${BOLD}[3/9] Core packages install ho rahe hain...${NC}"
pkg install -y git curl wget zip unzip tar nano vim figlet ruby zsh python nodejs proot-distro openssh

echo -e "${CYAN}      lolcat install ho raha hai...${NC}"
gem install lolcat

# ─── Step 4: Python Tools ────────────────────────────────────────────
# Note: fastapi/pydantic-core skip — Rust chahiye jo Termux mein nahi
# Woh Ubuntu mein install honge
echo -e "${CYAN}${BOLD}[4/9] Python tools install ho rahe hain...${NC}"
pip install requests httpx flask uvicorn python-dotenv rich

# uv — SAHI tarika: install script se (pip se nahi, Rust build fail hota)
echo -e "${CYAN}      uv (fast pip alternative) install ho raha hai...${NC}"
if command -v curl &>/dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh 2>/dev/null \
        && echo -e "${GREEN}      ✓ uv installed via curl${NC}" \
        || echo -e "${YELLOW}      uv skip — baad mein: wget -qO- https://astral.sh/uv/install.sh | sh${NC}"
else
    wget -qO- https://astral.sh/uv/install.sh | sh 2>/dev/null \
        && echo -e "${GREEN}      ✓ uv installed via wget${NC}" \
        || echo -e "${YELLOW}      uv skip — ignore karo${NC}"
fi

# ─── Step 5: Node.js Global Tools ────────────────────────────────────
echo -e "${CYAN}${BOLD}[5/9] Node.js global tools install ho rahe hain...${NC}"
npm install -g nodemon pm2 serve 2>/dev/null || true

# ─── Step 6: Nerd Font — P10k ke liye ZAROORI ────────────────────────
echo -e "${CYAN}${BOLD}[6/9] Nerd Font install ho raha hai (P10k icons ke liye)...${NC}"
mkdir -p ~/.termux
wget -q -O ~/.termux/font.ttf \
  "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" \
  && echo -e "${GREEN}      ✓ MesloLGS Nerd Font installed${NC}" \
  || echo -e "${YELLOW}      Font download failed — baad mein manually karo${NC}"

# ─── Step 7: Oh My Zsh ───────────────────────────────────────────────
echo -e "${CYAN}${BOLD}[7/9] Oh My Zsh + Powerlevel10k + Plugins...${NC}"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
    || sh -c "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo -e "${YELLOW}      Oh My Zsh already installed — skip${NC}"
fi

P10K_DIR="${HOME}/.oh-my-zsh/custom/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
    echo -e "${YELLOW}      Powerlevel10k already installed — skip${NC}"
fi

AS_DIR="${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
if [ ! -d "$AS_DIR" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$AS_DIR"
else
    echo -e "${YELLOW}      zsh-autosuggestions already installed — skip${NC}"
fi

# ─── Step 8: Configure .zshrc ────────────────────────────────────────
echo -e "${CYAN}${BOLD}[8/9] .zshrc configure ho raha hai...${NC}"
rm -f ~/.cache/p10k-instant-prompt-*.zsh 2>/dev/null

# Static part — quoted heredoc (no variable expansion)
cat > ~/.zshrc << 'STATIC_ZSHRC'
# ═══════════════════════════════════════════════════
#  HunterIsLive — Termux ZSH Config v1.1
#  YouTube : @HunterIsLive | getmaya.online
# ═══════════════════════════════════════════════════

# MUST BE FIRST — P10k warning fix
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

# Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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
STATIC_ZSHRC

# Dynamic part — $USER_BANNER_NAME expands here
cat >> ~/.zshrc << DYNAMIC_ZSHRC

# ===== HUNTER BANNER =====
echo -e "\e[1;32m"
figlet -c -f big "$USER_BANNER_NAME" | lolcat
echo -e "\e[0m"
# =========================

# P10k config (p10k configure se generate hoti hai)
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
DYNAMIC_ZSHRC

# ─── Step 9: Final Setup ─────────────────────────────────────────────
echo -e "${CYAN}${BOLD}[9/9] Final setup...${NC}"

touch ~/.hushlogin
echo -e "${GREEN}      ✓ MOTD disabled${NC}"

chsh -s zsh 2>/dev/null && echo -e "${GREEN}      ✓ ZSH default shell${NC}" || true

termux-reload-settings 2>/dev/null && echo -e "${GREEN}      ✓ Font applied${NC}" || true

# Ubuntu install
proot-distro install ubuntu 2>/dev/null \
  && echo -e "${GREEN}      ✓ Ubuntu installed${NC}" \
  || echo -e "${YELLOW}      Ubuntu already installed${NC}"

# ubuntuhunter.sh copy to sdcard
if [ -f "$(dirname $0)/ubuntuhunter.sh" ]; then
    cp "$(dirname $0)/ubuntuhunter.sh" /sdcard/ubuntuhunter.sh
    echo -e "${GREEN}      ✓ ubuntuhunter.sh → /sdcard/${NC}"
fi

# ─── Done! ───────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}"
echo "╔═══════════════════════════════════════════════════╗"
echo "║   ✅  TERMUX SETUP COMPLETE!                      ║"
echo "╠═══════════════════════════════════════════════════╣"
echo "║                                                   ║"
echo "║   Ab ye karo (important!):                       ║"
echo "║                                                   ║"
echo "║   1. Termux restart karo                         ║"
echo "║   2. ZSH open hone par: p10k configure           ║"
echo "║   3. Wizard mein style choose karo               ║"
echo "║                                                   ║"
echo "║   Ubuntu Setup:                                  ║"
echo "║   → proot-distro login ubuntu                    ║"
echo "║   → bash /storage/emulated/0/ubuntuhunter.sh     ║"
echo "║                                                   ║"
echo "║   YouTube : @HunterIsLive                        ║"
echo "║   Website : getmaya.online                       ║"
echo "╚═══════════════════════════════════════════════════╝"
echo -e "${NC}"
echo -e "${YELLOW}${BOLD}Termux restart karo, phir 'p10k configure' run karo! 🔥${NC}"
