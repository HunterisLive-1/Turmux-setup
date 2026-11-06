# 📱 Termux Ultimate Setup Guide — by The Hunter Ai

> **YouTube:** [@TheHunter-AI](https://youtube.com/@TheHunter-AI)  
> **Website:** [getmaya.online](https://getmaya.online)  
> **GitHub:** [HunterisLive-1](https://github.com/HunterisLive-1)

---

## 🚀 TL;DR — Do it fast (3 scripts, done)

```
hunter.sh        →  Termux mein run karo  (ZSH + P10k + Python + Node + Ubuntu install)
ubuntuhunter.sh  →  Ubuntu ke andar run karo  (Same setup Ubuntu ke liye)
androidhunter.sh →  Termux mein run karo  (Java + Gradle + Android SDK → phone pe hi APK)
```

---

## 📋 Table of Contents

1. [Termux Install karo](#step-0-termux-install-karo)
2. [Script Download karo](#step-1-script-download-karo)
3. [hunter.sh run karo](#step-2-huntersh-run-karo-termux-setup)
4. [Ubuntu Setup](#step-3-ubuntuhuntersh-run-karo-ubuntu-setup)
5. [Android App Setup](#step-4-androidhuntersh-run-karo-app-banane-ka-setup)
6. [Kya Kya Install Hota Hai](#-kya-kya-install-hota-hai)
7. [Aliases Reference](#-aliases-reference)
8. [Manual Commands](#-manual-commands-reference)
9. [Troubleshooting](#-troubleshooting)

---

## Step 0: Termux Install Karo

> ⚠️ **Play Store wala mat lena — outdated hai!**
>
> 📦 Teeno scripts milake phone me **~6 GB khali jagah** chahiye (Termux + Ubuntu ~4 GB, Android SDK + Gradle ~1.5 GB). 6 GB+ RAM wala phone best.


** Termux Yaha se install karo **👇 
. [Download Termux](https://github.com/HunterisLive-1/Turmux-setup/releases/download/V1.1/Termux.apk)

** Code editor install **
 [Download Code-editor](https://github.com/HunterisLive-1/Turmux-setup/releases/download/V1.1/Code.Editor.apk)

---

## Step 1: Script Download Karo

```bash
# Termux open karo, ye paste karo:
curl -LO https://raw.githubusercontent.com/HunterisLive-1/Turmux-setup/main/hunter.sh
```

> Pehle `apt update` / `pkg upgrade` chalane ki zaroorat **nahi** — script khud karta hai, bina koi sawaal pooche.
> Baaki do scripts (`ubuntuhunter.sh`, `androidhunter.sh`) bhi hunter.sh khud download kar leta hai.

---

## Step 2: hunter.sh Run Karo (Termux Setup)

```bash
bash hunter.sh
```

**Script kya karta hai step by step:**

```
[1/9]  Storage access (popup aayega → Allow)
[2/9]  Stable mirror + system update & upgrade (bina sawaal)
[3/9]  Core packages: git curl wget nano vim figlet ruby zsh python nodejs
       proot-distro openssh uv + lolcat
[4/9]  Python tools: requests httpx flask uvicorn python-dotenv rich
[5/9]  Node.js global: nodemon pm2 serve yarn
[6/9]  Nerd Font (P10k icons ke liye)
[7/9]  Oh My Zsh + Powerlevel10k + zsh-autosuggestions
[8/9]  .zshrc configure (theme + aliases + banner)
[9/9]  ZSH default shell + Ubuntu install + baaki 2 scripts download
```

**Script ke beech mein:**
- Tumhara naam puchha jayega → banner ke liye (example: Hunter)
- Storage ka popup aayega → **Allow** dabao
- Ubuntu ab chhota download hai (kuch MB), jaldi ho jaata hai
- Kul time: ~5-10 min (internet pe depend)

**Aakhir mein** script sach batata hai: sab theek hua to `TERMUX SETUP COMPLETE!`, kuch fail hua to uska naam dikhata hai. Fail ho to internet check karke `bash hunter.sh` dobara chalao — jo ho chuka hai wo skip hoga.

**Complete hone ke baad Termux band karke kholo, phir `p10k configure` chalao.**

---

## Step 3: ubuntuhunter.sh Run Karo (Ubuntu Setup)

```bash
# Termux mein Ubuntu mein jao:
proot-distro login ubuntu

# Script run karo:
bash /sdcard/ubuntuhunter.sh
```

**Script kya karta hai:**

```
[1/8]  apt update & upgrade
[2/8]  Core packages: git curl figlet ruby zsh python3 python3-venv
       build-essential tzdata + lolcat + phone wala time zone
[3/8]  Python tools ~/venv mein: requests httpx flask fastapi uvicorn rich + uv
[4/8]  Node.js LTS (nvm) + nodemon pm2 serve yarn
[5/8]  Oh My Zsh + Powerlevel10k + zsh-autosuggestions
[6/8]  Ubuntu .zshrc (venv apne aap chalu, banner)
[7/8]  .p10k.zsh pehle se ready (wizard nahi)
[8/8]  .bashrc mein auto ZSH launch
```

Kul time: ~10 min.

> **Python note:** Ubuntu 24.04+ system Python mein `pip install` mana karta hai (externally-managed-environment).
> Isliye sab `~/venv` mein jaata hai, aur Ubuntu khulte hi `~/venv` chalu hota hai — `pip install naam` seedha chalega.

**Complete hone ke baad:**
```bash
exit          # Ubuntu se bahar aao
ubntu         # Wapas Ubuntu mein jao (pehli baar ~1 min lagta hai)
              # ✅ Sirf Ubuntu banner dikhega, clean!
```

---

## Step 4: androidhunter.sh Run Karo (App Banane Ka Setup)

Phone pe hi Android app (APK) banane ka saaman. **Ye Termux mein chalta hai, Ubuntu ke andar nahi.**

```bash
exit                      # Ubuntu mein ho to pehle bahar aao
bash ~/androidhunter.sh
```

**Script kya karta hai:**

```
[1/6]  Java 17 (openjdk-17), Gradle, aapt2, apksigner
[2/6]  Android command line tools (Google)
[3/6]  Android 35 platform + build-tools 35
       (PC wale tools phone pe nahi chalte → Termux wale aapt2 lagta hai)
[4/6]  ~/.gradle/gradle.properties (aapt2 + memory) + ANDROID_HOME / JAVA_HOME
[5/6]  Test app ~/hello-hunter banake APK build karta hai
[6/6]  Report
```

- Internet: ~1 GB, phone me jagah: ~1.5 GB, time: 5-20 min (internet pe depend)
- Test APK: **Download/hello-hunter.apk** — Files app se kholo, install karo. Screen pe likha aayega: *"Ye app phone pe hi bana hai!"*
- Pehla build 3-5 min leta hai (Gradle sab download karta hai), uske baad ka build jaldi

**Apna koi bhi project build karna:**
```bash
cd ~/mera-app
./gradlew assembleDebug
# APK: app/build/outputs/apk/debug/app-debug.apk
```

---

## 📦 Kya Kya Install Hota Hai

### Termux (hunter.sh)

| Category | Tools |
|:---------|:------|
| Shell | ZSH, Oh My Zsh, Powerlevel10k, zsh-autosuggestions |
| Core | git, curl, wget, zip, unzip, tar, nano, vim, ssh |
| Python | python, pip, uv, flask, requests, httpx, uvicorn, rich (fastapi Ubuntu mein) |
| Node.js | nodejs, npm, nodemon, pm2, yarn, serve |
| Visual | figlet, lolcat (rainbow banner) |
| Container | proot-distro, ubuntu |

### Ubuntu (ubuntuhunter.sh)

| Category | Tools |
|:---------|:------|
| Shell | ZSH, Oh My Zsh, Powerlevel10k, zsh-autosuggestions |
| Core | git, curl, wget, nano, vim, build-essential |
| Python | python3, ~/venv (apne aap chalu), uv, flask, fastapi, requests |
| Node.js | nodejs (nvm LTS), npm, nodemon, pm2, yarn |
| Visual | figlet, lolcat |

### Android build (androidhunter.sh)

| Category | Tools |
|:---------|:------|
| Java | openjdk-17 |
| Build | Gradle (+ project mein Gradle 8.9 wrapper), Android Gradle Plugin 8.7, Kotlin 2.0 |
| SDK | Android 35 platform, build-tools 35 (`~/android-sdk`) |
| Phone tools | aapt2, apksigner (Termux wale, ARM ke liye) |

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
| `py` | `python` | Python (~/venv wala) |
| `storage` | `cd /storage/emulated/0` | Internal storage |
| `coding` | `cd /storage/emulated/0/coding` | Coding folder |
| `activate` | `source ~/venv/bin/activate` | Virtual env activate (waise apne aap hota hai) |

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

### ❌ pkg update pe "File has unexpected size ... Mirror sync in progress?"

**Cause:** Termux ne koi aisa mirror chuna jo us waqt update ho raha tha.
`hunter.sh` ab khud default (Cloudflare) mirror lagata hai. Haath se theek karna ho to:
```bash
termux-change-repo
# "Single mirror" → "default" chuno
pkg update && pkg upgrade -y
```

### ❌ Upgrade ke beech "openssl.cnf / bash.bashrc ... (Y/I/N/O/D/Z)" sawaal

`hunter.sh` mein ab ye sawaal nahi aata. Haath se upgrade karte waqt aaye to bas **Enter** dabao.

### ❌ Ubuntu mein pip: "externally-managed-environment"

Ubuntu 24.04+ system Python mein seedha `pip install` mana hai. `~/venv` use karo:
```bash
source ~/venv/bin/activate   # ubuntuhunter.sh ke baad ye apne aap hota hai
pip install naam
```

### ❌ Banner toota hua / do lines mein bikhra dikhta hai

Phone ki screen ~40 column ki hai aur bada font ~50 ka. Naya `.zshrc` patli screen pe chhota font lagata hai.
Purana setup hai to `bash hunter.sh` (aur Ubuntu mein `bash /sdcard/ubuntuhunter.sh`) dobara chalao.

### ❌ Gradle: "AAPT2 ... Daemon startup failed" / aapt2 error

Gradle PC wala aapt2 download karta hai jo phone pe nahi chalta. Check karo:
```bash
cat ~/.gradle/gradle.properties   # isme android.aapt2FromMavenOverride=... line honi chahiye
bash ~/androidhunter.sh           # na ho to dobara chalao
```

### ❌ Gradle build bahut slow / phone garam

Pehla build 3-5 min normal hai (sab download hota hai). 6 GB+ RAM wala phone best hai. Build ke time baaki apps band rakho.

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
| **YouTube** | [@TheHunter-AI](https://youtube.com/@TheHunter-AI) |
| **Website / Products** | [getmaya.online](https://getmaya.online) |
| **GitHub** | [HunterisLive-1](https://github.com/HunterisLive-1) |
| **Termux** | [termux.dev](https://termux.dev) |
| **Oh My Zsh** | [ohmyz.sh](https://ohmyz.sh) |
| **Powerlevel10k** | [github.com/romkatv/powerlevel10k](https://github.com/romkatv/powerlevel10k) |
| **uv (Python)** | [docs.astral.sh/uv](https://docs.astral.sh/uv) |

---

> 💜 **Agar ye helpful laga — like, subscribe, aur share zaroor karna!**
> Channel link: **youtube.com/@TheHunter-AI**
> 
