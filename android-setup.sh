#!/data/data/com.termux/files/usr/bin/bash
# The Hunter Ai — Android App Build Setup (sirf APK banane ka saaman, koi sawaal nahi)
# Java 17, Gradle, aapt2 (phone wala), Android SDK 35, gradle wrapper + addwrapper, ImageMagick.
# Koi bhi (ya Maya) chala sakta hai:
#   curl -sL https://raw.githubusercontent.com/HunterisLive-1/Turmux-setup/main/android-setup.sh | bash
# Aakhri line hamesha: ANDROID_SETUP_OK  ya  ANDROID_SETUP_FAIL: <kya fail hua>
# Dobara chalana safe hai — jo ho chuka hai wo skip hota hai.

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; RED='\033[0;31m'; BOLD='\033[1m'; NC='\033[0m'
FAILS=()
ok()   { echo -e "${GREEN}  ✓ $1${NC}"; }
fail() { FAILS+=("$1"); echo -e "${RED}  ✗ $1 fail hua${NC}"; }

SDK_DIR="$HOME/android-sdk"
CMDLINE_ZIP="commandlinetools-linux-11076708_latest.zip"
PLATFORM="android-35"
BUILD_TOOLS="35.0.0"
GRADLE_VER="8.9"
START=$(date +%s)

echo -e "${CYAN}${BOLD}The Hunter Ai — Android build setup (~10 min, ~1 GB)${NC}"

# ─── 1. Mirror + update (bina sawaal) ───────────────────────────────
echo -e "${CYAN}[1/6] Update...${NC}"
TM="$PREFIX/etc/termux"
if [ ! -e "$TM/chosen_mirrors" ] && [ -f "$TM/mirrors/default" ]; then
    MAIN_URL=$(sed -n 's/^MAIN="\(.*\)"$/\1/p' "$TM/mirrors/default")
    ln -sf "$TM/mirrors/default" "$TM/chosen_mirrors"
    [ -n "$MAIN_URL" ] && echo "deb $MAIN_URL stable main" > "$PREFIX/etc/apt/sources.list"
fi
pkg update -y >/dev/null 2>&1 || { sleep 3; pkg update -y >/dev/null 2>&1; } || fail "pkg update"
apt-get -y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold full-upgrade >/dev/null 2>&1 \
    && ok "Update" || fail "Update"

# ─── 2. Packages ────────────────────────────────────────────────────
echo -e "${CYAN}[2/6] Java 17, Gradle, aapt2, ImageMagick...${NC}"
pkg install -y openjdk-17 gradle aapt aapt2 apksigner unzip wget imagemagick >/dev/null 2>&1 \
    && ok "Packages" || fail "Packages"
export JAVA_HOME="$PREFIX/lib/jvm/java-17-openjdk"

# ─── 3. Android SDK ─────────────────────────────────────────────────
echo -e "${CYAN}[3/6] Android SDK (platform 35 + build-tools)...${NC}"
mkdir -p "$SDK_DIR/cmdline-tools"
if [ ! -x "$SDK_DIR/cmdline-tools/latest/bin/sdkmanager" ]; then
    cd "$TMPDIR" && wget -q -O cmdline.zip "https://dl.google.com/android/repository/$CMDLINE_ZIP" \
      && rm -rf cmdline-tools && unzip -q cmdline.zip && rm -rf "$SDK_DIR/cmdline-tools/latest" \
      && mv cmdline-tools "$SDK_DIR/cmdline-tools/latest" && rm -f cmdline.zip \
      && ok "Command line tools" || fail "Command line tools"
    cd "$HOME"
fi
SDKM="$SDK_DIR/cmdline-tools/latest/bin/sdkmanager"
yes | "$SDKM" --sdk_root="$SDK_DIR" --licenses >/dev/null 2>&1
"$SDKM" --sdk_root="$SDK_DIR" "platforms;$PLATFORM" "build-tools;$BUILD_TOOLS" >/dev/null 2>&1
SDK_RC=$?
[ "$SDK_RC" = 0 ] && [ -f "$SDK_DIR/platforms/$PLATFORM/android.jar" ] \
    && ok "SDK platform + build-tools" || fail "SDK platform + build-tools"
# Google ke build-tools PC (x86) ke liye hain; phone (ARM) pe Termux wale tools lagao
BT="$SDK_DIR/build-tools/$BUILD_TOOLS"
for t in aapt aapt2 aidl zipalign apksigner; do
    if [ -e "$BT/$t" ] && command -v "$t" >/dev/null; then ln -sf "$(command -v $t)" "$BT/$t"; fi
done

# ─── 4. Gradle settings + environment ───────────────────────────────
echo -e "${CYAN}[4/6] Gradle settings...${NC}"
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
ENV_BLOCK='# ===== ANDROID BUILD (The Hunter Ai) =====
export JAVA_HOME=$PREFIX/lib/jvm/java-17-openjdk
export ANDROID_HOME=$HOME/android-sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME
# ========================================='
for rc in ~/.bashrc ~/.zshrc ~/.profile; do
    [ "$rc" = ~/.zshrc ] && [ ! -f ~/.zshrc ] && continue
    touch "$rc"
    grep -q "ANDROID BUILD (The Hunter Ai)" "$rc" || printf '\n%s\n' "$ENV_BLOCK" >> "$rc"
done
ok "gradle.properties + ANDROID_HOME"

# ─── 5. Gradle wrapper template + addwrapper ────────────────────────
echo -e "${CYAN}[5/6] Gradle wrapper $GRADLE_VER...${NC}"
WR="$TMPDIR/wrapper-gen"; rm -rf "$WR"; mkdir -p "$WR" && cd "$WR" && touch settings.gradle \
  && gradle -q wrapper --gradle-version "$GRADLE_VER" >/dev/null 2>&1 \
  && rm -rf ~/.hunter/wrapper && mkdir -p ~/.hunter/wrapper && cp -r gradlew gradle ~/.hunter/wrapper/ \
  && ok "Wrapper template (~/.hunter/wrapper)" || fail "Gradle wrapper"
cd "$HOME"; rm -rf "$WR"
cat > "$PREFIX/bin/addwrapper" << 'AW_EOF'
#!/data/data/com.termux/files/usr/bin/sh
# Android project ke folder me gradlew daalo (phir: ./gradlew assembleDebug)
if [ ! -f "$HOME/.hunter/wrapper/gradlew" ]; then echo "Wrapper nahi mila — pehle android-setup.sh chalao"; exit 1; fi
cp -r "$HOME/.hunter/wrapper/gradlew" "$HOME/.hunter/wrapper/gradle" . && chmod +x gradlew && echo "gradlew aa gaya"
AW_EOF
chmod +x "$PREFIX/bin/addwrapper" && ok "addwrapper command"

# ─── 6. Storage (APK Download me rakhne ke liye) ────────────────────
echo -e "${CYAN}[6/6] Storage...${NC}"
if touch /sdcard/.hunter_probe 2>/dev/null; then
    rm -f /sdcard/.hunter_probe; ok "Storage access hai"
else
    echo -e "${YELLOW}  Popup aayega → Allow dabao${NC}"
    termux-setup-storage
    for i in $(seq 1 60); do
        if touch /sdcard/.hunter_probe 2>/dev/null; then rm -f /sdcard/.hunter_probe; break; fi
        sleep 1
    done
    touch /sdcard/.hunter_probe 2>/dev/null && rm -f /sdcard/.hunter_probe && ok "Storage mil gaya" \
        || fail "Storage permission (termux-setup-storage chalao, Allow dabao)"
fi

echo ""
echo -e "${CYAN}Time: $(( ($(date +%s) - START) / 60 )) min${NC}"
if [ ${#FAILS[@]} -eq 0 ]; then
    echo "ANDROID_SETUP_OK"
else
    echo "ANDROID_SETUP_FAIL: ${FAILS[*]}"
    exit 1
fi
