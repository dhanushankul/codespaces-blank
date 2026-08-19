# Android Development Setup in GitHub Codespaces

This guide explains how to configure a GitHub Codespace for building Android and Flutter applications.

## Prerequisites

- GitHub Codespaces
- Ubuntu-based environment
- Internet connection
- sudo access

---

# Step 1: Verify or Install OpenJDK 17

```bash
cd workspaces
```

Check the installed Java version.

```bash
java -version
```

Expected output:

```
openjdk version "17.x.x"
```

If Java 17 is not installed:

```bash
sudo apt update
sudo apt install openjdk-17-jdk -y
```

Configure Java environment variables.

```bash
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64' >> ~/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

Verify:

```bash
echo $JAVA_HOME
java -version
```

---

# Step 2: Install Android SDK Command Line Tools

Navigate to the home directory.

```bash
cd ~
```

Create the SDK directory.

```bash
mkdir -p Android/Sdk/cmdline-tools
cd Android/Sdk
```

Download the latest Android Command Line Tools.

```bash
wget https://dl.google.com/android/repository/commandlinetools-linux-13114758_latest.zip
```

Extract the archive.

```bash
unzip commandlinetools-linux-13114758_latest.zip
```

Create the required directory structure.

```bash
mkdir -p cmdline-tools/latest
mv cmdline-tools/* cmdline-tools/latest/
```

Verify installation.

```bash
ls ~/Android/Sdk/cmdline-tools/latest/bin
```

Expected output includes:

```
sdkmanager
avdmanager
```

---

# Step 3: Configure Android SDK Environment Variables

Append the following variables to `~/.bashrc`.

```bash
echo 'export ANDROID_HOME=$HOME/Android/Sdk' >> ~/.bashrc

echo 'export ANDROID_SDK_ROOT=$ANDROID_HOME' >> ~/.bashrc

echo 'export PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.bashrc

echo 'export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin' >> ~/.bashrc

echo 'export PATH=$PATH:$ANDROID_HOME/emulator' >> ~/.bashrc

source ~/.bashrc
```

Verify:

```bash
sdkmanager --version
```

---

# Step 4: Install Android SDK Components

Accept Android SDK licenses.

```bash
yes | sdkmanager --licenses
```

Install the required SDK packages.

```bash
sdkmanager \
"platform-tools" \
"platforms;android-35" \
"build-tools;35.0.0"
```

Verify Platform Tools.

```bash
adb version
```

---

# Step 5: Install Flutter

Only required for Flutter projects.

Navigate to the home directory.

```bash
cd ~
```

Clone Flutter.

```bash
git clone https://github.com/flutter/flutter.git
```

Add Flutter to your PATH.

```bash
echo 'export PATH=$HOME/flutter/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

Verify the folder list

```
Android  flutter  java  nvm
```


Verify Flutter installation.

```bash
flutter doctor
```

Accept Android licenses.

```bash
flutter doctor --android-licenses
```

Verify again.

```bash
flutter doctor
```

---

# Step 6: Build the Project

Assume the project exists at:

```
/workspaces/KaamDekhoFrontend
```

Navigate to the project.

```bash
cd /workspaces/KaamDekhoFrontend
```

---

## Flutter Project

Download project dependencies.

```bash
flutter pub get
```

Build the APK.

```bash
flutter build apk
```

Or

```bash
flutter build apk --android-skip-build-dependency-validation
```

Generated APK:

```
build/app/outputs/flutter-apk/app-release.apk
```

---

## `.gradlew` Issue

``gradlew` may not have issue executing due to permission problems. If you encounter an error, run the following commands:

```bash
flutter clean
./gradlew clean
flutter build apk
  
```

## Run Flutter web server:

```
flutter run -d web-server --web-hostname=0.0.0.0 --web-port 3000
```

---

---

## (Optional) Get dependencies:

```
flutter pub get
```

## Free a port

```
sudo fuser -k 8080/tcp
```

## Clean the package

```
flutter clean

rm -rf android/.gradle
rm -rf android/app/build
rm -rf build
rm -rf .dart_tool

flutter pub get
```

## Add the package
```
flutter pub add screen_protector

```

Happy Coding):# transportbuddy
