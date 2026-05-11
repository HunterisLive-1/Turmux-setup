# 📱 Termux Ultimate Setup Guide — by HunterIsLive

> **YouTube:** [@HunterIsLive](https://youtube.com/@hunterislive-18?si=jljtXcqEKoIRb-53)  
> **Website:** [getmaya.online](https://getmaya.online)  
> **GitHub:** [HunterisLive-1](https://github.com/HunterisLive-1)

---

> ⚠️ **Note for viewers:** Ye README video ke saath-saath follow karna hai. Har step number video ke section se match karta hai. Agar video multi-part hai toh Part number mention kiya hua hai.

---

## 📋 Table of Contents

1. [Prerequisites — Phone Setup](#-part-1--prerequisites--phone-setup)
2. [Termux Install & First Launch](#-step-1-termux-install--first-launch)
3. [Initial System Prep](#-step-2-initial-system-prep-sabse-pehle-ye-karo)
4. [Core Packages Install](#-step-3-core-packages-install)
5. [ZSH Shell Setup](#-step-4-zsh-shell-setup-bash-se-upgrade)
6. [Oh My Zsh Install](#-step-5-oh-my-zsh-install)
7. [Powerlevel10k Theme](#-step-6-powerlevel10k-theme-terminal-ko-swag-do)
8. [Zsh-AutoSuggestions Plugin](#-step-7-zsh-autosuggestions-plugin)
9. [Banner Setup — figlet + lolcat](#-step-8-banner-setup--figlet--lolcat)
10. [Aliases Setup — Termux](#-step-9-aliases-setup--termux)
11. [Final .zshrc File](#-step-10-final-zshrc-file-termux)
12. [Python Setup](#-part-2--python-setup)
13. [Node.js Setup](#-nodejs--npm-setup)
14. [Ubuntu via proot-distro](#-part-3--ubuntu-setup-via-proot-distro)
15. [Ubuntu — ZSH + Banner + Aliases](#-ubuntu-ke-andar-zsh--banner--aliases-setup)
16. [Storage Access from Ubuntu](#-storage-access-from-ubuntu)
17. [Advanced Aliases (Real ones from my setup)](#-advanced-aliases-mere-real-setup-se)
18. [One-Click Recovery Script](#-part-4--one-click-recovery-script)
19. [Useful Termux Commands Cheatsheet](#-useful-termux-commands-cheatsheet)
20. [Troubleshooting](#-troubleshooting)

---

## 🎬 PART 1 — Prerequisites & Phone Setup

### Kya Chahiye?
- Android phone (Android 7+)
- Minimum 3GB free storage
- Internet connection
- **F-Droid app** (ya GitHub se direct APK)

### ⚠️ Play Store wala Termux mat use karna!
Play Store wala Termux outdated hai aur packages properly install nahi hote.

**Sahi jagah se install karo:**

```
F-Droid se: https://f-droid.org
Ya direct GitHub se: https://github.com/termux/termux-app/releases
```

**F-Droid mein jaake "Termux" search karo aur install karo.**

---

## 🚀 Step 1: Termux Install & First Launch

Termux install hone ke baad pehli baar open karo. Ek black screen aayegi — yahi hamara terminal hai.

**Pehla command jo dikhega:**
```
Welcome to Termux!
```

Kuch seconds wait karo — bootstrap packages download honge automatically.

---

## 🛠️ Step 2: Initial System Prep (Sabse Pehle Ye Karo!)

### 2.1 — Storage Permission

Termux ko tumhare phone ki internal storage access dena zaroori hai taaki `/sdcard` folder accessible ho:

```bash
termux-setup-storage
```

> ✅ Ek popup aayega — **Allow** karo.

### 2.2 — Package List Update & Upgrade

```bash
pkg update && pkg upgrade -y
```

> ⏳ Thoda time lagega — packages download aur update honge. Kabhi kabhi koi prompt aayega, bas **Enter** dabao.

### 2.3 — Termux ke Repositories Check Karo

Agar `pkg update` pe error aaye toh:
```bash
termux-change-repo
```
Mirror list aayegi — **Grimler** ya **A-Sums** select karo. Phir dobara update karo.

---

## 📦 Step 3: Core Packages Install

Ye ek command mein sab essential tools install ho jayenge:

```bash
pkg install git curl wget zip unzip tar nano vim figlet ruby -y
```

**Kya install hua aur kyun:**

| Package | Kaam |
|:--------|:-----|
| `git` | Version control — GitHub se clone karne ke liye |
| `curl` | URLs se data fetch karna (scripts download etc.) |
| `wget` | Files download karna |
| `zip/unzip` | Archives banane aur kholne ke liye |
| `tar` | .tar.gz files handle karna |
| `nano` | Simple text editor (beginners ke liye best) |
| `vim` | Advanced text editor |
| `figlet` | ASCII art text (banner ke liye) |
| `ruby` | `lolcat` install karne ke liye zaroori hai |

### lolcat Install (Ruby gem):
```bash
gem install lolcat
```
> ⏳ Thodi der lagegi. Ye terminal output ko rainbow colors mein dikhaata hai.

---

## 🐚 Step 4: ZSH Shell Setup (Bash se Upgrade!)

By default Termux bash shell use karta hai. ZSH bahut zyada powerful aur customizable hai.

### Install ZSH:
```bash
pkg install zsh -y
```

### ZSH ko Default Shell Banao:
```bash
chsh -s zsh
```

### Verify karo:
```bash
echo $SHELL
```
Output aana chahiye: `/data/data/com.termux/files/usr/bin/zsh`

> 💡 Termux restart karo — ab ZSH as default chalega.

---

## ✨ Step 5: Oh My Zsh Install

Oh My Zsh ek framework hai jo ZSH ko manage karta hai — themes, plugins, aur shortcuts ke saath.

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
```

> ✅ Iske baad `.zshrc` file automatically create ho jaayegi `~/.zshrc` pe.

---

## 🎨 Step 6: Powerlevel10k Theme (Terminal ko Swag Do!)

Powerlevel10k ek premium-looking ZSH theme hai — git status, time, icons sab dikhata hai terminal mein.

### Install:
```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

### Theme Activate Karo:

```bash
nano ~/.zshrc
```

File mein ye line dhundo:
```
ZSH_THEME="robbyrussell"
```

Isko change karo:
```
ZSH_THEME="powerlevel10k/powerlevel10k"
```

**Save karo:** `Ctrl+X` → `Y` → `Enter`

### Apply karo:
```bash
source ~/.zshrc
```

### P10k Configure karo:
Pehli baar chalega toh wizard aayega. Apni pasand ke options choose karo.

Baad mein bhi configure kar sakte ho:
```bash
p10k configure
```

---

## 💡 Step 7: Zsh-AutoSuggestions Plugin

Ye plugin tumhari purani commands ko grey text mein suggest karta hai — **arrow key → dabao** aur command complete ho jaati hai. Super useful!

### Install:
```bash
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

### Plugin Enable Karo:

```bash
nano ~/.zshrc
```

Ye line dhundo:
```
plugins=(git)
```

Isko change karo:
```
plugins=(git zsh-autosuggestions)
```

Save karo aur:
```bash
source ~/.zshrc
```

> ✅ Ab type karo koi command — grey mein suggestion aayega. `→` arrow se accept karo.

---

## 🎪 Step 8: Banner Setup — figlet + lolcat

Jab bhi Termux open karo, ek colorful "Hunter" banner dikhna chahiye. Ye cool lagta hai aur video mein bhi acha dikhta hai! 😄

### Test karo pehle:
```bash
figlet -c -f big "Hunter"
```

### Lolcat ke saath:
```bash
figlet -c -f big "Hunter" | lolcat
```

### Ab .zshrc mein add karo (automatically har baar chale):

```bash
nano ~/.zshrc
```

File ke **bilkul end** mein ye lines add karo:

```bash
# ===== HUNTER BANNER =====
echo -e "\e[1;32m"
figlet -c -f big "Hunter" | lolcat
echo -e "\e[0m"
# ==========================
```

Save karo aur `source ~/.zshrc` chalao. 🎉

### Different Figlet Fonts (Experiment karo!):

```bash
# Available fonts dekhne ke liye:
ls /data/data/com.termux/files/usr/share/figlet/

# Try different fonts:
figlet -f slant "Hunter" | lolcat
figlet -f banner "Hunter" | lolcat
figlet -f block "Hunter" | lolcat
```

---

## ⚡ Step 9: Aliases Setup — Termux

Aliases = short commands jo lambe commands ko replace karte hain.

```bash
nano ~/.zshrc
```

File ke end mein ye aliases add karo (banner ke **upar** daalo):

```bash
# ===== MY ALIASES — TERMUX =====

# Basic utilities
alias c='clear'
alias update='pkg update && pkg upgrade'
alias py='python'

# Navigation
alias coding='cd /sdcard/coding'
alias web='cd /sdcard/hunterisLive'

# Ubuntu shortcuts (proot-distro ke baad kaam karenge)
alias ubntu='proot-distro login ubuntu'
alias ubntu-code='proot-distro login ubuntu --work-dir /sdcard/coding'

# Custom project shortcuts (apne hisaab se customize karo)
# alias mybot="proot-distro login ubuntu -- bash -c \"source ~/bot_env/bin/activate && python ~/super_bot.py\""

# ================================
```

### Alias kaise kaam karta hai?

| Type karo | Asal mein kya chalta hai |
|:----------|:------------------------|
| `c` | `clear` |
| `update` | `pkg update && pkg upgrade` |
| `py` | `python` |
| `coding` | `cd /sdcard/coding` |
| `ubntu` | `proot-distro login ubuntu` |

---

## 📄 Step 10: Final .zshrc File (Termux)

Ye hai mera actual `.zshrc` file jo main use karta hu — copy-paste ready:

```bash
# ===================================================
# HunterIsLive — Termux ZSH Config
# YouTube: @HunterIsLive | getmaya.online
# ===================================================

# Powerlevel10k instant prompt (MUST be at top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh My Zsh path
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# ===== ALIASES =====
alias c='clear'
alias update='pkg update && pkg upgrade'
alias py='python'
alias coding='cd /sdcard/coding'
alias web='cd /sdcard/hunterisLive'
alias ubntu='proot-distro login ubuntu --work-dir /sdcard/coding'

# Advanced Ubuntu aliases (optional)
alias mybot="proot-distro login ubuntu -- bash -c \"source ~/bot_env/bin/activate && python ~/super_bot.py\""

# OpenCode (agar install hai toh)
export PATH=/data/data/com.termux/files/home/.opencode/bin:$PATH

# ===== HUNTER BANNER =====
echo -e "\e[1;32m"
figlet -c -f big "Hunter" | lolcat
echo -e "\e[0m"
# ==========================

# P10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
```

**Pura file replace karne ke liye:**
```bash
nano ~/.zshrc
# Sab kuch delete karo (Ctrl+K har line pe)
# Upar wala content paste karo
# Ctrl+X → Y → Enter
source ~/.zshrc
```

---

## 🐍 PART 2 — Python Setup

### Install:
```bash
pkg install python -y
```

### Verify:
```bash
python --version
pip --version
```

### Virtual Environments (Best Practice):

Har project ke liye alag environment banao — packages conflict nahi karenge.

```bash
# Environment banao
python -m venv ~/my_project_env

# Activate karo
source ~/my_project_env/bin/activate

# Ab pip install karoge toh sirf is environment mein jayega
pip install requests flask

# Deactivate karne ke liye
deactivate
```

> 💡 **Tip:** `(my_project_env)` prefix dikhega prompt mein jab environment active ho.

### Useful Python Packages (generally kaam aane wale):

```bash
pip install requests flask fastapi uvicorn httpx python-dotenv
```

---

## 🟢 Node.js & NPM Setup

### Install:
```bash
pkg install nodejs -y
```

### Verify:
```bash
node -v
npm -v
```

### Global packages install:
```bash
npm install -g nodemon pm2
```

> 💡 **Note:** npm globally installed packages Termux ke usr folder mein jaate hain, PATH automatically set hota hai.

---

## 🐧 PART 3 — Ubuntu Setup via proot-distro

Bahut saari Python libraries aur tools Termux mein directly nahi chalte (ARM compatibility issues). Ubuntu container isko solve karta hai.

### Step 1: proot-distro Install
```bash
pkg install proot-distro -y
```

### Step 2: Ubuntu Download & Install
```bash
proot-distro install ubuntu
```
> ⏳ Thoda time lagega — Ubuntu image download hoga (~300-500MB).

### Step 3: Ubuntu mein Login
```bash
proot-distro login ubuntu
```

> ✅ Ab tumhara prompt badal jayega — ab tum Ubuntu ke andar ho!

### Basic Ubuntu Setup (pehli baar karo):
```bash
# Ubuntu packages update
apt update && apt upgrade -y

# Essential tools
apt install python3 python3-pip python3-venv git curl wget nano vim figlet -y

# Ruby + lolcat for banner
apt install ruby -y
gem install lolcat

# Node.js (Ubuntu ke andar)
apt install nodejs npm -y
```

### Ubuntu se Bahar Aana:
```bash
exit
```

---

## 🖥️ Ubuntu ke Andar ZSH + Banner + Aliases Setup

Ubuntu mein bhi wahi swag setup karte hain jo Termux mein kiya!

### Ubuntu mein Login karo:
```bash
proot-distro login ubuntu
```

### Step 1: ZSH Install
```bash
apt install zsh -y
```

### Step 2: Oh My Zsh Install (Ubuntu mein)
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
```

### Step 3: Powerlevel10k (Ubuntu mein)
```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

### Step 4: Zsh-AutoSuggestions (Ubuntu mein)
```bash
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

### Step 5: Ubuntu ka .zshrc Configure Karo

```bash
nano ~/.zshrc
```

Ye complete config paste karo:

```bash
# ===================================================
# HunterIsLive — Ubuntu (proot) ZSH Config
# ===================================================

# Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# ===== UBUNTU ALIASES =====
alias c='clear'
alias update='apt update && apt upgrade -y'
alias py='python3'
alias pip='pip3'

# Storage shortcuts (Termux sdcard access)
alias storage='cd /storage/emulated/0'
alias coding='cd /storage/emulated/0/coding'

# Virtual env shortcuts
alias activate='source ~/my_env/bin/activate'

# ===========================

# ===== HUNTER BANNER (Ubuntu) =====
echo -e "\e[1;35m"
figlet -c -f big "Hunter" | lolcat
echo -e "\e[1;33m  [ Ubuntu Container ]\e[0m"
echo -e "\e[0m"
# ====================================

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
```

Save karo:
```bash
source ~/.zshrc
# ya
zsh
```

> 💡 **Tip:** Ubuntu mein banner ke niche `[ Ubuntu Container ]` text add kiya hai — pata chalega ki Termux mein ho ya Ubuntu mein!

---

## 💾 Storage Access from Ubuntu

Ubuntu container se phone ki internal storage access karna important hai.

### Termux side pe (pehle):
```bash
termux-setup-storage
```

### Ubuntu mein storage path:
```bash
# Internal storage
cd /storage/emulated/0

# Ya is path se bhi:
cd /sdcard    # (sirf agar --work-dir di hai)
```

### Ubuntu login karte waqt working directory set karna:
```bash
# Termux mein ye alias use karo:
proot-distro login ubuntu --work-dir /storage/emulated/0/coding
```

Ya apne `.zshrc` mein alias banao:
```bash
alias ubntu-coding='proot-distro login ubuntu --work-dir /storage/emulated/0/coding'
```

---

## 🔥 Advanced Aliases (Mere Real Setup Se)

Ye wahi aliases hain jo main actually use karta hu — ek command mein complete workflow!

```bash
# Ubuntu mein seedha kisi project ka server start karo
alias server='proot-distro login ubuntu -- python3 server.py'

# Bot environment activate karke script chalao
alias mybot="proot-distro login ubuntu -- bash -c \"source ~/bot_env/bin/activate && python ~/super_bot.py\""

# Marketing tool
alias mkt="proot-distro login ubuntu -- bash -c \"source ~/bot_env/bin/activate && python ~/marketing_analyst.py\""

# ClearCut web app (example custom project)
alias clearcut='proot-distro login ubuntu -- bash -c "source ~/hunter_env/bin/activate && cd /storage/emulated/0/coding/ClearCutWeb && python3 app.py"'

# Start script shortcut
alias sb='~/start.sh'
```

**Pattern samjho:**
```bash
alias shortname="proot-distro login ubuntu -- bash -c \"source ~/venv/bin/activate && python ~/script.py\""
```
Isko copy karke apne project ke liye customize karo!

---

## 🔄 PART 4 — One-Click Recovery Script

Agar kabhi Termux reinstall karna pade (ya koi aur setup kare), ye script sab kuch automatically setup kar degi.

### File banao:
```bash
nano ~/recover.sh
```

### Ye content paste karo:

```bash
#!/data/data/com.termux/files/usr/bin/bash

# =============================================
# HunterIsLive — Termux Recovery Script
# YouTube: @HunterIsLive | getmaya.online
# =============================================

echo ""
echo "╔══════════════════════════════════════╗"
echo "║   HunterIsLive Environment Setup     ║"
echo "╚══════════════════════════════════════╝"
echo ""

# Step 1: Storage Access
echo "[1/7] Setting up storage access..."
termux-setup-storage
sleep 2

# Step 2: Core System Update
echo "[2/7] Updating system..."
pkg update && pkg upgrade -y

# Step 3: Core Packages
echo "[3/7] Installing core packages..."
pkg install git curl wget zip unzip tar nano vim figlet ruby zsh python nodejs proot-distro -y
gem install lolcat

# Step 4: Oh My Zsh
echo "[4/7] Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Step 5: Powerlevel10k + Plugins
echo "[5/7] Installing Powerlevel10k theme..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

echo "[5/7] Installing zsh-autosuggestions..."
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Step 6: Writing .zshrc
echo "[6/7] Configuring .zshrc..."
cat > ~/.zshrc << 'ZSHRC_EOF'
# HunterIsLive Termux Config
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# Aliases
alias c='clear'
alias update='pkg update && pkg upgrade'
alias py='python'
alias coding='cd /sdcard/coding'
alias web='cd /sdcard/hunterisLive'
alias ubntu='proot-distro login ubuntu'
alias ubntu-code='proot-distro login ubuntu --work-dir /sdcard/coding'

# Banner
echo -e "\e[1;32m"
figlet -c -f big "Hunter" | lolcat
echo -e "\e[0m"

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
ZSHRC_EOF

# Step 7: Ubuntu Setup
echo "[7/7] Installing Ubuntu container..."
proot-distro install ubuntu

echo ""
echo "╔══════════════════════════════════════╗"
echo "║   ✅ Setup Complete!                  ║"
echo "║   Termux restart karo aur enjoy karo ║"
echo "╚══════════════════════════════════════╝"
echo ""
echo "Next step: Ubuntu ke andar setup ke liye"
echo "Run: proot-distro login ubuntu"
echo "Phir: apt update && apt install zsh python3 python3-pip git figlet ruby -y"
```

### Script ko executable banao aur run karo:
```bash
chmod +x ~/recover.sh
./recover.sh
```

---

## 📋 Useful Termux Commands Cheatsheet

### File System Navigation:
```bash
ls          # Files list karo
ls -la      # Hidden files ke saath list
pwd         # Current location batao
cd ~        # Home directory pe jao
cd /sdcard  # Internal storage pe jao
cd ..       # Ek level upar jao
mkdir naam  # Folder banao
rm file.txt # File delete karo
rm -rf folder/ # Folder delete karo (careful!)
cp src dst  # File copy karo
mv src dst  # File move/rename karo
```

### File Editing:
```bash
nano file.txt   # Nano editor (easy)
vim file.txt    # Vim editor (advanced)
cat file.txt    # File content dekhna
head -20 file   # Pehli 20 lines
tail -20 file   # Aakhri 20 lines
grep "text" file # File mein text dhundhna
```

### Package Management:
```bash
pkg install naam -y   # Package install
pkg uninstall naam    # Package remove
pkg list-installed    # Installed packages
pkg search naam       # Package dhundhna
pkg update            # Package list update
pkg upgrade           # Sab packages upgrade
```

### Process Management:
```bash
ps aux          # Running processes dekhna
kill PID        # Process band karna
Ctrl+C          # Current process stop
Ctrl+Z          # Process pause
bg              # Background mein chalao
fg              # Foreground mein lao
```

### Network:
```bash
ping google.com       # Net check karna
curl https://...      # URL fetch karna
wget URL              # File download karna
ifconfig              # IP address dekhna
```

### Git:
```bash
git clone URL           # Repo clone karo
git status              # Changes dekhna
git add .               # Sab changes stage karo
git commit -m "message" # Commit karo
git push                # GitHub pe push karo
git pull                # Latest code lao
```

### ZSH Specific:
```bash
source ~/.zshrc   # Config reload karo
alias             # Sab aliases dekhna
history           # Command history
!123              # History se command 123 chalao
!!                # Last command dobara chalao
Ctrl+R            # History search karo
```

---

## 🔧 Troubleshooting

### ❌ `pkg update` mein error aaye:
```bash
termux-change-repo
# Phir dobara:
pkg update && pkg upgrade -y
```

### ❌ Banner nahi aa raha:
```bash
# Check karo packages installed hain ya nahi:
which figlet
which lolcat

# Agar nahi hain:
pkg install figlet ruby -y
gem install lolcat

# .zshrc mein banner code hai ya nahi:
cat ~/.zshrc | grep figlet

# Agar nahi hai, add karo:
echo 'figlet -c -f big "Hunter" | lolcat' >> ~/.zshrc
source ~/.zshrc
```

### ❌ Oh My Zsh install nahi ho raha:
```bash
# Pehle curl install karo:
pkg install curl -y
# Phir dobara try karo install command
```

### ❌ proot-distro mein Ubuntu install stuck ho raha:
```bash
# Ek baar exit karo, phir:
proot-distro remove ubuntu
proot-distro install ubuntu
```

### ❌ Ubuntu mein storage nahi dikh raha:
```bash
# Termux mein pehle ye run karo (ek baar):
termux-setup-storage

# Phir Ubuntu mein:
proot-distro login ubuntu
ls /storage/emulated/0
```

### ❌ ZSH change nahi ho raha default shell:
```bash
chsh -s zsh
# Termux band karke dobara kholo
```

### ❌ `source ~/.zshrc` pe error:
```bash
# Syntax error dhundho:
zsh -n ~/.zshrc
# Kisi line pe error dikhayega
```

### ❌ P10k configure nahi ho raha Termux mein:
Termux mein Nerd Fonts automatically install nahi hote. Agar icons broken hain:
```bash
p10k configure
# Style select karte waqt "No" choose karo Unicode/icons ke liye
# Ya phone mein Nerd Font install karo aur Termux settings mein set karo
```

---

## 🔗 Resources & Links

| Resource | Link |
|:---------|:-----|
| YouTube | [@HunterIsLive](https://youtube.com/@HunterIsLive) |
| Website / Products | [getmaya.online](https://getmaya.online) |
| GitHub | [HunterisLive-1](https://github.com/HunterisLive-1) |
| Termux Official | [termux.dev](https://termux.dev) |
| Oh My Zsh | [ohmyz.sh](https://ohmyz.sh) |
| Powerlevel10k | [github.com/romkatv/powerlevel10k](https://github.com/romkatv/powerlevel10k) |
| proot-distro | [github.com/termux/proot-distro](https://github.com/termux/proot-distro) |

---

## 🎯 Quick Start Summary (TL;DR)

Agar sab kuch ek baar mein karna hai (experienced users ke liye):

```bash
# 1. Storage + Update
termux-setup-storage && pkg update && pkg upgrade -y

# 2. All packages
pkg install git curl figlet ruby zsh python nodejs proot-distro -y && gem install lolcat

# 3. Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# 4. P10k + AutoSuggestions
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# 5. .zshrc configure karo (Step 10 dekho)

# 6. Ubuntu
proot-distro install ubuntu

# Done! 🎉
```

---

> 💜 **Agar ye guide helpful lagi toh like, subscribe, aur share zaroor karna!**
> 
> **@HunterIsLive** — YouTube pe milte hain!
