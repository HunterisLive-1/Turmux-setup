# 📱 Termux Ultimate Setup Guide — by HunterIsLive

> **YouTube:** [@HunterIsLive](https://youtube.com/@HunterIsLive)  
> **Website:** [getmaya.online](https://getmaya.online)  
> **GitHub:** [HunterisLive-1](https://github.com/HunterisLive-1)

---

## 🚀 TL;DR — Do it fast (2 scripts, done)

```
hunter.sh       →  Termux mein run karo  (ZSH + P10k + Python + Node + Ubuntu install)
ubuntuhunter.sh →  Ubuntu ke andar run karo  (Same setup Ubuntu ke liye)
```

---

## 📋 Table of Contents

1. [Termux Install karo](#step-0-termux-install-karo)
2. [Scripts Download karo](#step-1-scripts-download-karo)
3. [hunter.sh run karo](#step-2-huntersh-run-karo-termux-setup)
4. [Ubuntu Setup](#step-3-ubuntuhuntersh-run-karo-ubuntu-setup)
5. [Kya Kya Install Hota Hai](#-kya-kya-install-hota-hai)
6. [Aliases Reference](#-aliases-reference)
7. [Manual Commands](#-manual-commands-reference)
8. [Troubleshooting](#-troubleshooting)

---

## Step 0: Termux Install Karo

> ⚠️ **Play Store wala mat lena — outdated hai!**

**F-Droid se install karo:**
```
https://f-droid.org → "Termux" search karo → Install
```
Ya GitHub Releases se direct APK:
```
https://github.com/termux/termux-app/releases
```

---

## Step 1: Scripts Download Karo

**Option A — GitHub se (recommended):**
```bash
# Termux open karo, ye paste karo:
pkg install curl -y

curl -O https://raw.githubusercontent.com/HunterisLive-1/termux-setup/main/hunter.sh
curl -O https://raw.githubusercontent.com/HunterisLive-1/termux-setup/main/ubuntuhunter.sh
```

**Option B — Manual:**
- `hunter.sh` aur `ubuntuhunter.sh` dono files `/sdcard/` mein copy karo

---

## Step 2: hunter.sh Run Karo (Termux Setup)

```bash
chmod +x hunter.sh
bash hunter.sh
```

**Script kya karta hai step by step:**

```
[1/9]  Storage access (termux-setup-storage)
[2/9]  System update & upgrade
[3/9]  Core packages: git curl wget nano vim figlet ruby zsh python nodejs proot-distro
       + lolcat (gem install)
[4/9]  Python tools: pip uv requests flask fastapi uvicorn python-dotenv rich
[5/9]  Node.js global: nodemon pm2 yarn serve
[6/9]  Oh My Zsh install
[7/9]  Powerlevel10k theme + zsh-autosuggestions plugin
[8/9]  .zshrc configure (theme + plugins + aliases + banner)
[9/9]  MOTD disable + ZSH default shell + Ubuntu install
```

**Script ke beech mein:**
- Tumhara naam puchha jayega → banner ke liye (example: Hunter)
- `/sdcard/` pe ek permission popup aayega → Allow karo
- Ubuntu download hoga (~300-500MB) — time lagega

**Complete hone ke baad Termux restart karo.**

---

## Step 3: ubuntuhunter.sh Run Karo (Ubuntu Setup)

```bash
# Termux mein Ubuntu mein jao:
proot-distro login ubuntu

# Package manager update karo pehle:
apt update && apt install curl bash -y

# Script run karo:
bash /storage/emulated/0/ubuntuhunter.sh
```

**Script kya karta hai:**

```
[1/8]  apt update & upgrade
[2/8]  Core packages: git curl figlet ruby zsh python3 python3-pip nodejs npm
       + lolcat
[3/8]  Python tools: uv requests flask fastapi uvicorn rich
[4/8]  Node.js global: nodemon pm2 yarn serve
[5/8]  Oh My Zsh install
[6/8]  Powerlevel10k + zsh-autosuggestions
[7/8]  Ubuntu .zshrc configure (banner mein clear → sirf Ubuntu banner dikhe)
[8/8]  .bashrc mein auto ZSH launch set
```

**Complete hone ke baad:**
```bash
exit          # Ubuntu se bahar aao
ubntu         # Wapas Ubuntu mein jao
              # ✅ Sirf Ubuntu banner dikhega, clean!
```

---

## 📦 Kya Kya Install Hota Hai

### Termux (hunter.sh)

| Category | Tools |
|:---------|:------|
| Shell | ZSH, Oh My Zsh, Powerlevel10k, zsh-autosuggestions |
| Core | git, curl, wget, zip, unzip, tar, nano, vim |
| Python | python3, pip, uv, flask, fastapi, requests, rich |
| Node.js | nodejs, npm, nodemon, pm2, yarn, serve |
| Visual | figlet, lolcat (rainbow banner) |
| Container | proot-distro, ubuntu |

### Ubuntu (ubuntuhunter.sh)

| Category | Tools |
|:---------|:------|
| Shell | ZSH, Oh My Zsh, Powerlevel10k, zsh-autosuggestions |
| Core | git, curl, wget, nano, vim, build-essential |
| Python | python3, pip3, uv, venv, flask, fastapi, requests |
| Node.js | nodejs, npm, nodemon, pm2, yarn |
| Visual | figlet, lolcat |

---

## ⚡ Aliases Reference

### Termux Aliases

| Alias | Command | Kaam |
|:------|:--------|:-----|
| `c` | `clear` | Screen saaf karo |
| `update` | `pkg update && pkg upgrade` | Sab update karo |
| `py` | `python` | Python start karo |
| `coding` | `cd /sdcard/coding` | Coding folder |
| `ubntu` | `proot-distro login ubuntu` | Ubuntu mein jao |
| `ubntu-code` | `proot-distro login ubuntu --work-dir /sdcard/coding` | Ubuntu + coding dir |

### Ubuntu Aliases

| Alias | Command | Kaam |
|:------|:--------|:-----|
| `c` | `clear` | Screen saaf karo |
| `update` | `apt update && apt upgrade -y` | Ubuntu update |
| `py` | `python3` | Python |
| `pip` | `pip3` | Pip |
| `storage` | `cd /storage/emulated/0` | Internal storage |
| `coding` | `cd /storage/emulated/0/coding` | Coding folder |
| `activate` | `source ~/venv/bin/activate` | Virtual env activate |

---

## 📖 Manual Commands Reference

### File System

```bash
ls          # Files list
ls -la      # Hidden files ke saath
pwd         # Current location
cd ~        # Home pe jao
mkdir naam  # Folder banao
rm file     # File delete
cp src dst  # Copy
mv src dst  # Move/Rename
cat file    # Content dekhna
nano file   # Edit karna
```

### Package Management

```bash
# Termux
pkg install naam -y
pkg update && pkg upgrade
pkg search naam
pkg list-installed

# Ubuntu
apt install naam -y
apt update && apt upgrade -y
apt search naam
apt list --installed

# Python
pip install naam          # Termux
pip3 install naam         # Ubuntu
uv pip install naam       # Ultra-fast (dono jagah)
uv venv && source .venv/bin/activate   # Virtual env

# Node.js
npm install naam          # Local
npm install -g naam       # Global
```

### Git Commands

```bash
git clone URL
git status
git add .
git commit -m "message"
git push
git pull
```

### ZSH Shortcuts

```bash
source ~/.zshrc   # Config reload
alias             # Sab aliases dekhna
history           # Command history
Ctrl+R            # History search
→ (arrow key)     # AutoSuggestion accept karo
```

### Python Virtual Environments

```bash
python -m venv ~/myenv       # Create
source ~/myenv/bin/activate  # Activate
pip install package          # Install in env
deactivate                   # Exit env

# uv se (faster):
uv venv ~/myenv
source ~/myenv/bin/activate
uv pip install package
```

### Flask App Run Karna

```bash
# Termux ya Ubuntu mein
pip install flask
python app.py     # localhost:5000 pe run hoga

# Browser mein:
# Phone: http://localhost:5000
# Same WiFi pe: http://192.168.x.x:5000
```

---

## 🔧 Troubleshooting

### ❌ P10k Warning: Console output during zsh initialization

**Cause:** Banner (figlet) P10k se pehle run ho raha hai.

**Fix:**
```bash
# .zshrc ki BILKUL PEHLI LINE ye honi chahiye:
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

# Phir cache bhi hatao:
rm -f ~/.cache/p10k-instant-prompt-*.zsh
source ~/.zshrc
```

### ❌ Welcome to Termux message aata hai

**Fix:**
```bash
touch ~/.hushlogin
# Termux restart karo
```

### ❌ Ubuntu mein ZSH restart pe chala jaata hai

**Cause:** Default shell bash hai, ZSH manually type karna padta hai.

**Fix:**
```bash
# Ubuntu ke andar:
echo '[ -z "$ZSH_VERSION" ] && exec zsh' >> ~/.bashrc
```

### ❌ Ubuntu mein dono banners dikhte hain (Termux + Ubuntu)

**Cause:** Ubuntu ke .zshrc mein `clear` nahi hai banner se pehle.

**Fix — Ubuntu ke andar:**
```bash
nano ~/.zshrc
# Banner se theek pehle 'clear' add karo
```

```bash
# Sahi order:
clear                              # ← Ye add karo
echo -e "\e[1;35m"
figlet -c -f big "YourName" | lolcat
echo -e "\e[1;33m  [ Ubuntu Container ]\e[0m"
```

### ❌ pkg update pe error / mirror issue

```bash
termux-change-repo
# Grimler ya A-Sums select karo
pkg update && pkg upgrade -y
```

### ❌ CPU 32-bit warning in Ubuntu

```
Warning: CPU doesn't support 32-bit instructions
```
**Ye ignore karo** — sirf warning hai, kuch affect nahi karta. ARM64 phones pe normal hai.

### ❌ lolcat install nahi ho raha

```bash
pkg install ruby -y
gem install lolcat
```

### ❌ P10k icons broken dikhte hain

Font issue hai. Ya toh phone mein Nerd Font install karo, ya configure karo:
```bash
p10k configure
# Style select karte waqt icons ke liye "No" choose karo
```

### ❌ figlet font "big" nahi mila

```bash
# Available fonts dekhne ke liye:
ls /data/data/com.termux/files/usr/share/figlet/

# Alternatives:
figlet -f slant "YourName" | lolcat
figlet -f banner "YourName" | lolcat
```

---

## 🔗 Links

| | |
|:--|:--|
| **YouTube** | [@HunterIsLive](https://youtube.com/@HunterIsLive) |
| **Website / Products** | [getmaya.online](https://getmaya.online) |
| **GitHub** | [HunterisLive-1](https://github.com/HunterisLive-1) |
| **Termux** | [termux.dev](https://termux.dev) |
| **Oh My Zsh** | [ohmyz.sh](https://ohmyz.sh) |
| **Powerlevel10k** | [github.com/romkatv/powerlevel10k](https://github.com/romkatv/powerlevel10k) |
| **uv (Python)** | [docs.astral.sh/uv](https://docs.astral.sh/uv) |

---

> 💜 **Agar ye helpful laga — like, subscribe, aur share zaroor karna!**
> Channel link: **youtube.com/@HunterIsLive**
> 
