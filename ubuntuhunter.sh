#!/bin/bash

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
echo "║    HunterIsLive — Ubuntu Setup Script v1.0       ║"
echo "╠═══════════════════════════════════════════════════╣"
echo "║  YouTube : @HunterIsLive                         ║"
echo "║  GitHub  : github.com/HunterisLive-1             ║"
echo "║  Website : getmaya.online                        ║"
echo "╚═══════════════════════════════════════════════════╝"
echo -e "${NC}"
sleep 1

# ─── Banner Name ─────────────────────────────────────────────────────
# Termux wale hunter.sh se save kiya hua name read karo
CONFIG_FILE="/storage/emulated/0/hunter_config.txt"
if [ -f "$CONFIG_FILE" ]; then
    USER_BANNER_NAME=$(cat "$CONFIG_FILE")
    echo -e "${GREEN}✓ Banner name Termux se mila: ${BOLD}${USER_BANNER_NAME}${NC}"
else
    echo -e "${CYAN}${BOLD}Apna naam/handle enter karo (figlet banner ke liye):${NC}"
    echo -e "${YELLOW}Example: Hunter  |  Rahul  |  Dev  (space mat use karna)${NC}"
    printf "➜ Your Name: "
    read USER_BANNER_NAME
    [ -z "$USER_BANNER_NAME" ] && USER_BANNER_NAME="Hunter"
fi
echo ""
sleep 1

# ─── Step 1: System Update ───────────────────────────────────────────
echo -e "${CYAN}${BOLD}[1/8] Ubuntu packages update & upgrade...${NC}"
echo -e "${YELLOW}      (Pehli baar kaafi time lagega)${NC}"
export DEBIAN_FRONTEND=noninteractive
apt update -y && apt upgrade -y

# ─── Step 2: Core Packages ───────────────────────────────────────────
echo -e "${CYAN}${BOLD}[2/8] Core packages install ho rahe hain...${NC}"
apt install -y \
    git curl wget zip unzip tar \
    nano vim \
    figlet ruby \
    zsh \
    python3 python3-pip python3-venv \
    nodejs npm \
    build-essential \
    ca-certificates gnupg

echo -e "${CYAN}      lolcat install ho raha hai...${NC}"
gem install lolcat

# ─── Step 3: Python Tools ────────────────────────────────────────────
echo -e "${CYAN}${BOLD}[3/8] Python tools install ho rahe hain...${NC}"
pip3 install --upgrade pip setuptools wheel
pip3 install requests httpx flask fastapi uvicorn python-dotenv rich

echo -e "${CYAN}      uv (ultra-fast pip alternative) install ho raha hai...${NC}"
curl -LsSf https://astral.sh/uv/install.sh | sh 2>/dev/null || pip3 install uv

# ─── Step 4: Node.js Global Tools ────────────────────────────────────
echo -e "${CYAN}${BOLD}[4/8] Node.js global tools install ho rahe hain...${NC}"
npm install -g nodemon pm2 yarn serve 2>/dev/null || true

# ─── Step 5: Oh My Zsh ───────────────────────────────────────────────
echo -e "${CYAN}${BOLD}[5/8] Oh My Zsh install ho raha hai...${NC}"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo -e "${YELLOW}      Oh My Zsh already installed — skip${NC}"
fi

# ─── Step 6: Powerlevel10k + AutoSuggestions ─────────────────────────
echo -e "${CYAN}${BOLD}[6/8] Powerlevel10k theme install ho raha hai...${NC}"
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

# ─── Step 7: Configure .zshrc ────────────────────────────────────────
echo -e "${CYAN}${BOLD}[7/8] Ubuntu .zshrc configure ho raha hai...${NC}"

# Old P10k cache hatao (warning fix)
rm -f ~/.cache/p10k-instant-prompt-*.zsh 2>/dev/null

# Static part — quoted heredoc (variables preserve karo for .zshrc use)
cat > ~/.zshrc << 'UBUNTU_STATIC'
# ═══════════════════════════════════════════════════
#  HunterIsLive — Ubuntu (proot) ZSH Config
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

# ===== ALIASES — UBUNTU =====
alias c='clear'
alias update='apt update && apt upgrade -y'
alias py='python3'
alias pip='pip3'
alias storage='cd /storage/emulated/0'
alias coding='cd /storage/emulated/0/coding'
alias activate='source ~/venv/bin/activate'

# PATH
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
UBUNTU_STATIC

# Dynamic part — USER_BANNER_NAME expands here
# clear added so Termux banner saaf ho jaye, sirf Ubuntu wala dikhe
cat >> ~/.zshrc << UBUNTU_DYNAMIC

# ===== UBUNTU BANNER =====
clear
echo -e "\e[1;35m"
figlet -c -f big "$USER_BANNER_NAME" | lolcat
echo -e "\e[1;33m      [ Ubuntu Container ]\e[0m"
echo -e "\e[0m"
# =========================

# P10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
UBUNTU_DYNAMIC

# ─── Step 8: Auto-launch ZSH on Ubuntu login ─────────────────────────
echo -e "${CYAN}${BOLD}[8/8] Auto ZSH launch on Ubuntu login set ho raha hai...${NC}"

# .bashrc mein add karo agar pehle se nahi hai
if ! grep -q "exec zsh" ~/.bashrc 2>/dev/null; then
    echo '' >> ~/.bashrc
    echo '# Auto-launch ZSH (HunterIsLive Setup)' >> ~/.bashrc
    echo '[ -z "$ZSH_VERSION" ] && exec zsh' >> ~/.bashrc
    echo -e "${GREEN}      ✓ Auto ZSH launch set in .bashrc${NC}"
else
    echo -e "${YELLOW}      Auto ZSH already set — skip${NC}"
fi

# ─── Done! ───────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}"
echo "╔═══════════════════════════════════════════════════╗"
echo "║   ✅  UBUNTU SETUP COMPLETE!                      ║"
echo "╠═══════════════════════════════════════════════════╣"
echo "║                                                   ║"
echo -e "║   Banner Name : ${BOLD}${USER_BANNER_NAME}${NC}${GREEN}"
echo "║                                                   ║"
echo "║   Ab type karo:  exit                            ║"
echo "║   Phir:          ubntu                           ║"
echo "║   Tumhara Ubuntu banner dikhega!                 ║"
echo "║                                                   ║"
echo "║   YouTube : @HunterIsLive                        ║"
echo "║   Website : getmaya.online                       ║"
echo "╚═══════════════════════════════════════════════════╝"
echo -e "${NC}"
echo -e "${YELLOW}${BOLD}Type karo 'exit' → Termux mein jao → 'ubntu' → enjoy! 🔥${NC}"
