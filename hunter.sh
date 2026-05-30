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
echo "║     HunterIsLive — Termux Setup Script v1.0      ║"
echo "╠═══════════════════════════════════════════════════╣"
echo "║  YouTube : @HunterIsLive                         ║"
echo "║  GitHub  : github.com/HunterisLive-1             ║"
echo "║  Website : getmaya.online                        ║"
echo "╚═══════════════════════════════════════════════════╝"
echo -e "${NC}"
sleep 1

# ─── Banner Name ─────────────────────────────────────────────────────
echo -e "${CYAN}${BOLD}Ek kaam karo — apna naam/handle enter karo:${NC}"
echo -e "${YELLOW}(Figlet banner mein ye naam dikhega, space mat use karna)${NC}"
echo -e "${YELLOW}Example: Hunter  |  Rahul  |  Dev${NC}"
echo ""
printf "➜ Your Name: "
read USER_BANNER_NAME
[ -z "$USER_BANNER_NAME" ] && USER_BANNER_NAME="Hunter"

# Save name to sdcard so ubuntuhunter.sh can reuse it
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
echo -e "${YELLOW}      (Thoda time lagega, Enter dabaate raho agar koi prompt aaye)${NC}"
pkg update -y && pkg upgrade -y

# ─── Step 3: Core Packages ───────────────────────────────────────────
echo -e "${CYAN}${BOLD}[3/9] Core packages install ho rahe hain...${NC}"
pkg install -y git curl wget zip unzip tar nano vim figlet ruby zsh python nodejs proot-distro openssh

echo -e "${CYAN}      lolcat install ho raha hai (ruby gem)...${NC}"
gem install lolcat

# ─── Step 4: Python Tools ────────────────────────────────────────────
echo -e "${CYAN}${BOLD}[4/9] Python tools install ho rahe hain...${NC}"
pip install --upgrade pip setuptools wheel
pip install requests httpx flask fastapi uvicorn python-dotenv rich

echo -e "${CYAN}      uv (ultra-fast pip alternative) install ho raha hai...${NC}"
curl -LsSf https://astral.sh/uv/install.sh | sh 2>/dev/null || pip install uv

# ─── Step 5: Node.js Global Tools ────────────────────────────────────
echo -e "${CYAN}${BOLD}[5/9] Node.js global tools install ho rahe hain...${NC}"
npm install -g nodemon pm2 yarn serve

# ─── Step 6: Oh My Zsh ───────────────────────────────────────────────
echo -e "${CYAN}${BOLD}[6/9] Oh My Zsh install ho raha hai...${NC}"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo -e "${YELLOW}      Oh My Zsh already installed — skip${NC}"
fi

# ─── Step 7: Powerlevel10k + AutoSuggestions ─────────────────────────
echo -e "${CYAN}${BOLD}[7/9] Powerlevel10k theme install ho raha hai...${NC}"
P10K_DIR="${HOME}/.oh-my-zsh/custom/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
    echo -e "${YELLOW}      Powerlevel10k already installed — skip${NC}"
fi

echo -e "${CYAN}      zsh-autosuggestions plugin install ho raha hai...${NC}"
AS_DIR="${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
if [ ! -d "$AS_DIR" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$AS_DIR"
else
    echo -e "${YELLOW}      zsh-autosuggestions already installed — skip${NC}"
fi

# ─── Step 8: Configure .zshrc ────────────────────────────────────────
echo -e "${CYAN}${BOLD}[8/9] .zshrc configure ho raha hai...${NC}"

# Old P10k cache hatao (warning fix)
rm -f ~/.cache/p10k-instant-prompt-*.zsh 2>/dev/null

# Static part — quoted heredoc (no variable expansion here)
# $HOME, $ZSH etc. will expand when .zshrc is sourced later
cat > ~/.zshrc << 'STATIC_ZSHRC'
# ═══════════════════════════════════════════════════
#  HunterIsLive — Termux ZSH Config
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

# ===== ALIASES — TERMUX =====
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

# Dynamic part — unquoted heredoc ($USER_BANNER_NAME expands here)
cat >> ~/.zshrc << DYNAMIC_ZSHRC

# ===== HUNTER BANNER =====
echo -e "\e[1;32m"
figlet -c -f big "$USER_BANNER_NAME" | lolcat
echo -e "\e[0m"
# =========================

# P10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
DYNAMIC_ZSHRC

# ─── Step 9: Final Setup ─────────────────────────────────────────────
echo -e "${CYAN}${BOLD}[9/9] Final setup...${NC}"

# MOTD hatao (Welcome to Termux message band)
touch ~/.hushlogin
echo -e "${GREEN}      ✓ MOTD disabled (Welcome to Termux band)${NC}"

# Default shell ZSH
chsh -s zsh 2>/dev/null && echo -e "${GREEN}      ✓ ZSH default shell set${NC}" || true

# Ubuntu install
echo -e "${CYAN}      Ubuntu container install ho raha hai...${NC}"
echo -e "${YELLOW}      (~300-500MB download, time lagega)${NC}"
proot-distro install ubuntu 2>/dev/null \
  && echo -e "${GREEN}      ✓ Ubuntu installed${NC}" \
  || echo -e "${YELLOW}      Ubuntu already installed ya skip karo${NC}"

# Copy ubuntuhunter.sh to sdcard if it exists
if [ -f "$(dirname $0)/ubuntuhunter.sh" ]; then
    cp "$(dirname $0)/ubuntuhunter.sh" /sdcard/ubuntuhunter.sh
    echo -e "${GREEN}      ✓ ubuntuhunter.sh copied to /sdcard/${NC}"
fi

# ─── Done! ───────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}"
echo "╔═══════════════════════════════════════════════════╗"
echo "║   ✅  TERMUX SETUP COMPLETE!                      ║"
echo "╠═══════════════════════════════════════════════════╣"
echo "║                                                   ║"
echo -e "║   Banner Name : ${BOLD}${USER_BANNER_NAME}${NC}${GREEN}"
echo "║                                                   ║"
echo "║   Next — Ubuntu Setup karo:                      ║"
echo "║   1.  proot-distro login ubuntu                  ║"
echo "║   2.  apt update && apt install curl -y          ║"
echo "║   3.  bash /storage/emulated/0/ubuntuhunter.sh   ║"
echo "║                                                   ║"
echo "║   YouTube : @HunterIsLive                        ║"
echo "║   Website : getmaya.online                       ║"
echo "╚═══════════════════════════════════════════════════╝"
echo -e "${NC}"
echo -e "${YELLOW}${BOLD}Ab Termux restart karo — enjoy! 🔥${NC}"

