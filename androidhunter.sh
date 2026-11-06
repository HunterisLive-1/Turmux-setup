#!/data/data/com.termux/files/usr/bin/bash
# The Hunter Ai — Android App Build Setup (Termux)
# Phone pe hi APK banane ka saaman: Java 17, Gradle, Android SDK, aapt2, apksigner
# Aakhir me ek chhota test app bana ke dikhata hai ki sab chal raha hai.

# ─── Colors ─────────────────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

FAILS=()
ok()   { echo -e "${GREEN}      ✓ $1${NC}"; }
fail() { FAILS+=("$1"); echo -e "${RED}      ✗ $1 fail hua${NC}"; }

box() {
    local bar; bar=$(printf '═%.0s' $(seq 38))
    echo "╔${bar}╗"
    for line in "$@"; do
        if [ "$line" = "--" ]; then echo "╠${bar}╣"; else printf "║ %-36s ║\n" "$line"; fi
    done
    echo "╚${bar}╝"
}

# Versions — ek saath test kiye hue, inko alag alag mat badalna
SDK_DIR="$HOME/android-sdk"
CMDLINE_ZIP="commandlinetools-linux-11076708_latest.zip"
PLATFORM="android-35"
BUILD_TOOLS="35.0.0"
GRADLE_VER="8.9"
AGP_VER="8.7.3"
KOTLIN_VER="2.0.21"

START=$(date +%s)
clear
echo -e "${PURPLE}${BOLD}"
box "The Hunter Ai - Android Build Setup" -- "Java 17, Gradle, Android SDK" "aapt2, apksigner + test APK" "Internet ~1 GB, time 5-20 min"
echo -e "${NC}"

if [ -z "$TERMUX_VERSION" ] && [ ! -d /data/data/com.termux/files/usr ]; then
    echo -e "${RED}Ye script Termux me chalao, Ubuntu ke andar nahi (pehle 'exit').${NC}"; exit 1
fi
if [ -n "$PROOT_DISTRO_NAME" ] || grep -qi ubuntu /etc/os-release 2>/dev/null; then
    echo -e "${RED}Ye script Termux me chalao, Ubuntu ke andar nahi (pehle 'exit').${NC}"; exit 1
fi

# ─── Step 1: Packages ────────────────────────────────────────────────
echo -e "${CYAN}${BOLD}[1/6] Java 17, Gradle, aapt2, apksigner...${NC}"
pkg install -y openjdk-17 gradle aapt aapt2 apksigner unzip wget \
    && ok "Packages" || fail "Packages"
export JAVA_HOME="$PREFIX/lib/jvm/java-17-openjdk"
java -version 2>&1 | head -1

# ─── Step 2: Android SDK (command line tools) ───────────────────────
echo -e "${CYAN}${BOLD}[2/6] Android SDK download...${NC}"
mkdir -p "$SDK_DIR/cmdline-tools"
if [ ! -x "$SDK_DIR/cmdline-tools/latest/bin/sdkmanager" ]; then
    cd "$TMPDIR" && wget -q --show-progress -O cmdline.zip "https://dl.google.com/android/repository/$CMDLINE_ZIP" \
      && rm -rf cmdline-tools && unzip -q cmdline.zip && rm -rf "$SDK_DIR/cmdline-tools/latest" \
      && mv cmdline-tools "$SDK_DIR/cmdline-tools/latest" && rm -f cmdline.zip \
      && ok "Command line tools" || fail "Command line tools"
    cd "$HOME"
else
    echo -e "${YELLOW}      Command line tools pehle se hain — skip${NC}"
fi
SDKM="$SDK_DIR/cmdline-tools/latest/bin/sdkmanager"

# ─── Step 3: Platform + build tools ─────────────────────────────────
echo -e "${CYAN}${BOLD}[3/6] Android $PLATFORM + build-tools $BUILD_TOOLS...${NC}"
yes | "$SDKM" --sdk_root="$SDK_DIR" --licenses >/dev/null 2>&1
# sdkmanager ki progress bar phone ki patli screen pe sau line ka kachra banati hai, isliye chhupao
echo -e "${YELLOW}      ~200 MB download + unzip, 2-5 min — ruko...${NC}"
( set -o pipefail
  "$SDKM" --sdk_root="$SDK_DIR" "platforms;$PLATFORM" "build-tools;$BUILD_TOOLS" 2>&1 \
    | grep --line-buffered -vE 'Downloading|Unzipping|^[[:space:]]*$' ) \
    && ok "SDK platform + build-tools" || fail "SDK platform + build-tools"
# Google ke build-tools PC (x86) ke liye hain; phone (ARM) pe Termux wale tools lagao
BT="$SDK_DIR/build-tools/$BUILD_TOOLS"
for t in aapt aapt2 aidl zipalign apksigner; do
    if [ -e "$BT/$t" ] && command -v "$t" >/dev/null; then ln -sf "$(command -v $t)" "$BT/$t"; fi
done
[ -f "$SDK_DIR/platforms/$PLATFORM/android.jar" ] && ok "android.jar mila" || fail "android.jar"

# ─── Step 4: Gradle settings + env ──────────────────────────────────
echo -e "${CYAN}${BOLD}[4/6] Gradle settings + environment...${NC}"
mkdir -p ~/.gradle
GP=~/.gradle/gradle.properties
touch "$GP"
sed -i '/^android.aapt2FromMavenOverride=/d;/^org.gradle.jvmargs=/d;/^org.gradle.vfs.watch=/d;/^kotlin.daemon.jvmargs=/d' "$GP"
cat >> "$GP" << EOF
android.aapt2FromMavenOverride=$PREFIX/bin/aapt2
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
org.gradle.vfs.watch=false
kotlin.daemon.jvmargs=-Xmx1024m
EOF
ok "~/.gradle/gradle.properties (aapt2 = Termux wala)"

ENV_BLOCK='# ===== ANDROID BUILD (The Hunter Ai) =====
export JAVA_HOME=$PREFIX/lib/jvm/java-17-openjdk
export ANDROID_HOME=$HOME/android-sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH
# ========================================'
for rc in ~/.zshrc ~/.bashrc; do
    touch "$rc"
    grep -q "ANDROID BUILD (The Hunter Ai)" "$rc" || printf '\n%s\n' "$ENV_BLOCK" >> "$rc"
done
export ANDROID_HOME="$SDK_DIR" ANDROID_SDK_ROOT="$SDK_DIR"
ok "ANDROID_HOME + JAVA_HOME (.zshrc / .bashrc)"

# ─── Step 5: Test app ───────────────────────────────────────────────
echo -e "${CYAN}${BOLD}[5/6] Test app bana rahe hain (pehli baar 5-10 min)...${NC}"
APP="$HOME/hello-hunter"
rm -rf "$APP"; mkdir -p "$APP/app/src/main/java/com/hunter/hello"
cat > "$APP/settings.gradle" << 'EOF'
pluginManagement { repositories { google(); mavenCentral(); gradlePluginPortal() } }
dependencyResolutionManagement { repositories { google(); mavenCentral() } }
rootProject.name = "HelloHunter"
include(":app")
EOF
cat > "$APP/build.gradle" << EOF
plugins {
    id 'com.android.application' version '$AGP_VER' apply false
    id 'org.jetbrains.kotlin.android' version '$KOTLIN_VER' apply false
}
EOF
cat > "$APP/app/build.gradle" << 'EOF'
plugins {
    id 'com.android.application'
    id 'org.jetbrains.kotlin.android'
}
android {
    namespace 'com.hunter.hello'
    compileSdk 35
    defaultConfig {
        applicationId 'com.hunter.hello'
        minSdk 24
        targetSdk 35
        versionCode 1
        versionName '1.0'
    }
    compileOptions { sourceCompatibility JavaVersion.VERSION_17; targetCompatibility JavaVersion.VERSION_17 }
    kotlinOptions { jvmTarget = '17' }
}
EOF
cat > "$APP/app/src/main/AndroidManifest.xml" << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application android:label="Hello Hunter" android:theme="@android:style/Theme.Material">
        <activity android:name=".MainActivity" android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
EOF
cat > "$APP/app/src/main/java/com/hunter/hello/MainActivity.kt" << 'EOF'
package com.hunter.hello

import android.app.Activity
import android.os.Bundle
import android.view.Gravity
import android.widget.TextView

class MainActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(TextView(this).apply {
            text = "Ye app phone pe hi bana hai!"
            textSize = 26f
            gravity = Gravity.CENTER
        })
    }
}
EOF
# Gradle wrapper: khali folder me banao (system gradle naya hai, project purane AGP wala)
WR="$TMPDIR/wrapper-gen"; rm -rf "$WR"; mkdir -p "$WR" && cd "$WR" && touch settings.gradle \
  && gradle -q wrapper --gradle-version "$GRADLE_VER" && cp -r gradlew gradle "$APP/" \
  && ok "Gradle wrapper $GRADLE_VER" || fail "Gradle wrapper"
cd "$APP"
T0=$(date +%s)
if ./gradlew assembleDebug --no-daemon; then
    APK="$APP/app/build/outputs/apk/debug/app-debug.apk"
    ok "APK bana: $(du -h "$APK" | cut -f1) in $(( $(date +%s) - T0 )) s"
    if cp "$APK" /sdcard/Download/hello-hunter.apk 2>/dev/null; then
        ok "Copy: Download/hello-hunter.apk (Files app se kholo, install karo)"
    fi
else
    fail "Test APK build"
fi
cd "$HOME"

# ─── Step 6: Done ───────────────────────────────────────────────────
echo -e "${CYAN}${BOLD}[6/6] Ho gaya — total $(( ($(date +%s) - START) / 60 )) min${NC}"
echo ""
if [ ${#FAILS[@]} -eq 0 ]; then
    echo -e "${GREEN}${BOLD}"
    box "ANDROID BUILD SETUP COMPLETE!" -- \
        "Test app: ~/hello-hunter" \
        "Naya build:" \
        "  cd ~/hello-hunter" \
        "  ./gradlew assembleDebug" \
        "APK: Download/hello-hunter.apk"
    echo -e "${NC}"
    echo -e "${YELLOW}${BOLD}Termux band karke kholo (ANDROID_HOME set ho jayega) 🔥${NC}"
else
    echo -e "${RED}${BOLD}Setup poora nahi hua. Ye fail hue:${NC}"
    for f in "${FAILS[@]}"; do echo -e "${RED}  ✗ $f${NC}"; done
    echo -e "${YELLOW}Internet check karo aur 'bash androidhunter.sh' dobara chalao.${NC}"
fi
