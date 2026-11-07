# 📱 Phone pe Android App banao — Termux + OpenCode

> **by The Hunter Ai**  
> **YouTube:** [@TheHunter-AI](https://youtube.com/@TheHunter-AI)  
> **Website:** [getmaya.online](https://getmaya.online)  
> **GitHub:** [HunterisLive-1](https://github.com/HunterisLive-1)

Bina laptop, sirf phone se: **OpenCode (AI) se app likhwao aur phone pe hi APK banao.**
Ek script, sirf Termux — koi Ubuntu nahi.

**Zaroorat:** Android 7+, 6 GB+ RAM wala phone, ~4 GB khali jagah, WiFi (~1 GB download).

---

## Step 0: Termux Install Karo

> ⚠️ **Play Store wala mat lena — outdated hai!**

** Termux Yaha se install karo **👇 
. [Download Termux](https://github.com/HunterisLive-1/Turmux-setup/releases/download/V1.1/Termux.apk)

** Code editor install **
 [Download Code-editor](https://github.com/HunterisLive-1/Turmux-setup/releases/download/V1.1/Code.Editor.apk)

---

## Step 1: Setup Script Chalao

Termux kholo aur ye do command chalao:

```bash
curl -LO https://raw.githubusercontent.com/HunterisLive-1/Turmux-setup/main/hunter.sh
```

```bash
bash hunter.sh
```

- Naam poochega → banner ke liye (jaise: Hunter)
- Storage ka popup aayega → **Allow**
- Time: ~10-15 min. Beech mein koi sawaal nahi aata.
- Kuch fail hua to script naam ke saath batata hai — `bash hunter.sh` dobara chalao, jo ho chuka hai wo skip hoga.

Ye install karta hai:

| Kya | Kyun |
|:----|:-----|
| OpenCode (+ glibc-runner) | AI se code likhwane ke liye (free models bhi) |
| Java 17 + Gradle | APK build ke liye |
| Android SDK 35 | Android ki library |
| aapt2, apksigner (phone wale) | Google wale phone pe nahi chalte |
| zsh + p10k + rainbow banner | Sundar terminal |

Aakhir mein ek test app banta hai: **Download/hello-hunter.apk** — Files app se kholo, install karo. Screen pe likha aayega: *"Ye app phone pe hi bana hai!"*

**Ho jaane ke baad Termux band karke kholo.**

---

## Step 2: OpenCode se App Banwao

Test project mein OpenCode kholo:

```bash
cd ~/hello-hunter
```

```bash
opencode
```

Pehli baar `/models` likho aur koi **free** model chuno (naam ke aakhir mein `-free`, jaise `deepseek-v4.1-flash-free`) — API key nahi chahiye. Apni key lagani ho to bahar `opencode auth login`. Phir OpenCode ko bolo, jaise:

```
Is project mein ek simple calculator app bana do. Sirf MainActivity.kt badlo, koi nayi library mat jodna.
```

---

## Step 3: APK Banao aur Install Karo

OpenCode se bahar aake:

```bash
./gradlew assembleDebug
```

```bash
cp app/build/outputs/apk/debug/app-debug.apk /sdcard/Download/
```

Files app → Download → **app-debug.apk** → Install.

**Naya project?** Uske folder mein `gradlew` daalne ke liye:

```bash
addwrapper
```

---

## Sirf APK Banane Ka Setup (bina zsh / OpenCode)

Sirf Java + Android SDK chahiye (jaise Maya se app banwane ke liye)? Ye ek command, koi sawaal nahi poochti:

```bash
curl -sL https://raw.githubusercontent.com/HunterisLive-1/Turmux-setup/main/android-setup.sh | bash
```

Aakhir mein `ANDROID_SETUP_OK` aaye to ready.

---

## 🎨 Look Badalna Ho

Script The Hunter Ai wala p10k look lagata hai. Apna look chuno:

```bash
p10k configure
```

---

## ⚡ Aliases

| Alias | Kaam |
|:------|:-----|
| `c` | Screen saaf |
| `update` | Sab update karo |
| `coding` | `/sdcard/coding` folder |
| `addwrapper` | Project mein `gradlew` daalo |

---

## 🔧 Troubleshooting

### ❌ Termux kholte hi upar lamba peela "instant prompt" warning

Naya `hunter.sh` ise khud band karta hai. Purana setup ho to:

```bash
echo 'typeset -g POWERLEVEL9K_INSTANT_PROMPT=off' >> ~/.zshrc
```

Phir Termux band karke kholo.

### ❌ pkg update pe "File has unexpected size ... Mirror sync in progress?"

`hunter.sh` khud default mirror lagata hai. Haath se:

```bash
termux-change-repo
```

"Single mirror" → "default" chuno.

### ❌ Gradle: "AAPT2 ... Daemon startup failed"

Gradle PC wala aapt2 download karta hai jo phone pe nahi chalta. Check karo:

```bash
cat ~/.gradle/gradle.properties
```

Isme `android.aapt2FromMavenOverride=` wali line honi chahiye. Na ho to `bash hunter.sh` dobara chalao.

### ❌ `./gradlew: No such file or directory`

Project mein `gradlew` nahi hai. Project folder mein:

```bash
addwrapper
```

### ❌ Build bahut slow / phone garam

Pehla build 3-5 min normal hai (sab download hota hai). Baaki apps band rakho. 6 GB+ RAM best.

### ❌ P10k icons broken dikhte hain

Termux band karke kholo (font lagta hai). Phir bhi ho to `p10k configure` mein icons ke liye "No" chuno.

---

## 🔗 Links

| | |
|:--|:--|
| **YouTube** | [@TheHunter-AI](https://youtube.com/@TheHunter-AI) |
| **Website / Products** | [getmaya.online](https://getmaya.online) |
| **GitHub** | [HunterisLive-1](https://github.com/HunterisLive-1) |
| **Termux** | [termux.dev](https://termux.dev) |
| **OpenCode** | [opencode.ai](https://opencode.ai) |
| **Powerlevel10k** | [github.com/romkatv/powerlevel10k](https://github.com/romkatv/powerlevel10k) |

---

> 💜 **Agar ye helpful laga — like, subscribe, aur share zaroor karna!**
> Channel link: **youtube.com/@TheHunter-AI**
