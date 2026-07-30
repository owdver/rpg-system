# Build and Release Guide

This document provides comprehensive instructions for building and releasing the RPG System Android application.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Local Development Setup](#local-development-setup)
- [Building Locally](#building-locally)
- [Code Generation](#code-generation)
- [Testing](#testing)
- [GitHub Actions Release Process](#github-actions-release-process)
- [Play Store Release Steps](#play-store-release-steps)
- [Signing Configuration](#signing-configuration)
- [Required GitHub Secrets](#required-github-secrets)
- [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Required Tools

- **Flutter SDK** 3.44.0 (compatible with Dart 3.6.0)
- **Dart SDK** 3.6.0
- **Android SDK** (latest stable)
- **Java Development Kit (JDK)** 17 or higher

### Environment Variables

Ensure the following are in your PATH:
- `flutter`
- `dart`
- `java` (or JAVA_HOME is set)

### Verify Installation

```bash
flutter --version
dart --version
flutter doctor
```

---

## Local Development Setup

### 1. Clone the Repository

```bash
git clone https://github.com/owdver/rpg-system.git
cd rpg-system
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run Code Generation

This project uses code generation for models and providers:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Configure Firebase (Optional for Development)

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Add Android and iOS apps to your project
3. Download configuration files:
   - `android/app/google-services.json` for Android
   - `ios/Runner/GoogleService-Info.plist` for iOS
4. Enable Authentication, Firestore, Cloud Messaging, and Storage

### 5. Configure Signing (For Release Builds)

Create `android/key.properties`:

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=YOUR_KEY_ALIAS
storeFile=release.jks
```

Place your keystore file (`release.jks`) in the `android/app/` directory.

---

## Building Locally

### Debug Build (APK)

```bash
flutter build apk --debug
```

Output: `build/app/outputs/flutter-apk/app-debug.apk`

### Release Build (APK)

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Release Build (App Bundle for Play Store)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### Web Build

```bash
flutter build web --release
```

Output: `build/web/`

---

## Code Generation

This project uses code generation for:
- **Freezed** - Immutable data classes
- **Riverpod** - State management providers
- **JSON Serialization** - JSON parsing
- **Drift** - Local database

### Run Code Generation

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Watch Mode (Development)

```bash
dart run build_runner watch --delete-conflicting-outputs
```

### Check for Stale Generated Files

```bash
dart run build_runner build --delete-conflicting-outputs
git diff --exit-code || echo "Generated files need updating"
```

---

## Testing

### Run All Tests

```bash
flutter test
```

### Run Tests with Coverage

```bash
flutter test --coverage
```

Coverage report is generated at `coverage/lcov.info`.

### Run Specific Test File

```bash
flutter test test/game_engine_test.dart
```

### Run Tests by Tag

```bash
flutter test --tag unit
flutter test --tag integration
```

---

## GitHub Actions Release Process

### Workflows

| Workflow | File | Description |
|----------|------|-------------|
| CI | `ci.yml` | Runs on every push and PR |
| Android Release | `android-release.yml` | Builds release APK and AAB |
| CodeQL | `codeql.yml` | Security analysis |

### Triggering the Release Workflow

#### Automatic (Push to main)

The release workflow automatically triggers on push to the `main` branch.

#### Manual (workflow_dispatch)

1. Go to the repository's **Actions** tab on GitHub
2. Select **Android Release Build**
3. Click **Run workflow**
4. Choose build type: `release` or `preview`
5. Click **Run workflow**

### Workflow Steps

1. **Pre-flight Checks** - Code generation verification
2. **Analyze** - Flutter static analysis (fails on errors)
3. **Test** - Unit and widget tests
4. **Build APK** - Release APK build
5. **Build AAB** - App Bundle for Play Store

### Workflow Features

- **Caching**: Flutter packages and Gradle caches are preserved
- **Code Signing**: Automatically configured when secrets are available
- **Parallel Builds**: APK and AAB built simultaneously after validation

### Downloading Artifacts

1. Go to the workflow run in GitHub Actions
2. Click on the job (e.g., "Build Release APK")
3. Scroll to "Artifacts" section
4. Download the artifact

### Artifact Names

| Artifact | Name | Retention |
|----------|------|-----------|
| Release APK | `rpg-system-release-apk` | 30 days |
| Release AAB | `rpg-system-release-aab` | 30 days |
| Preview APK | `rpg-system-preview-apk` | 7 days |

---

## Play Store Release Steps

### 1. Build the App Bundle

```bash
flutter build appbundle --release
```

### 2. Test with Internal Testing Track

1. Go to [Google Play Console](https://play.google.com/console)
2. Select your app
3. Go to **Testing > Internal testing**
4. Upload the AAB file
5. Add testers and send for testing

### 3. Promote to Production

1. After internal testing, go to **Testing > Closed** or **Open**
2. Run through testing tracks
3. When ready, click **Review and publish**
4. Submit for Google review

### 4. Version Management

Update version in `pubspec.yaml`:

```yaml
version: 1.0.0+1  # major.minor.patch+build_number
```

Or use:

```bash
flutter version bump
flutter version bump patch
flutter version bump minor
flutter version bump build
```

---

## Signing Configuration

### Creating a New Keystore

If you don't have a keystore, create one:

```bash
keytool -genkey -v -storetype JKS \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -keystore android/app/release.jks \
  -alias rpg-system \
  -keypass YOUR_KEY_PASSWORD \
  -storepass YOUR_STORE_PASSWORD \
  -dname "CN=Your Name, O=Your Organization, C=US"
```

### Converting Keystore to Base64 (for GitHub Secrets)

```bash
base64 -w 0 android/app/release.jks
```

### Key Properties File

Create `android/key.properties`:

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=rpg-system
storeFile=release.jks
```

### Keep Your Keystore Safe

- Never commit the keystore or `key.properties` to version control
- Store them securely (e.g., password manager, secure cloud storage)
- If lost, you'll need to create a new keystore and lose Play Store updates

### Important Notes

- **App Bundle signing**: AAB files for Play Store require special signing configuration
- **Update existing app**: You must use the same keystore as previous releases
- **Lost keystore**: Cannot update published apps; must create new listing

---

## Required GitHub Secrets

Configure these secrets in your GitHub repository under **Settings > Secrets and variables > Actions**.

### Android Signing Secrets

| Secret Name | Description | Required |
|-------------|-------------|----------|
| `ANDROID_KEYSTORE_BASE64` | Base64-encoded keystore file | For signed release |
| `ANDROID_KEYSTORE_PASSWORD` | Password for the keystore | For signed release |
| `ANDROID_KEY_ALIAS` | Alias name of the signing key | For signed release |
| `ANDROID_KEY_PASSWORD` | Password for the signing key | For signed release |

### iOS Signing Secrets (for CI only)

| Secret Name | Description | Required |
|-------------|-------------|----------|
| `IOS_P12_BASE64` | Base64-encoded iOS signing certificate | For iOS |
| `IOS_P12_PASSWORD` | Password for iOS certificate | For iOS |
| `IOS_PROVISIONING_PROFILE` | Base64-encoded provisioning profile | For iOS |

### Adding Secrets to GitHub

1. Go to repository **Settings**
2. Navigate to **Secrets and variables > Actions**
3. Click **New repository secret**
4. Enter name and value
5. Click **Add secret**

### Without Signing Secrets

The workflow is configured to fall back to debug signing when secrets are not configured. This produces:
- Unsigned APK/AAB for testing
- Debug-signed builds (not suitable for Play Store)

This is useful for:
- Testing CI/CD pipeline
- Development builds
- Pull request verification

---

## Troubleshooting

### Build Failures

#### "flutter pub get" fails

```bash
# Clear pub cache
flutter pub cache repair

# Re-fetch dependencies
flutter pub get --offline
flutter pub get
```

#### Code generation produces changes

```bash
dart run build_runner build --delete-conflicting-outputs
git diff  # Review changes
git add .
git commit -m "Update generated files"
```

#### Missing Google services configuration

```
Error: google-services.json is missing or invalid
```

1. Download from Firebase Console
2. Place at `android/app/google-services.json`
3. Ensure `google-services` plugin is applied

### Analysis Failures

#### Deprecated warnings

```bash
# Update dependencies
flutter pub upgrade

# Run analyzer
flutter analyze
```

#### Missing imports

```bash
flutter pub get
dart run build_runner build
```

### Test Failures

#### Firebase not initialized

Mock Firebase in tests or use `flutter_test` with proper setup.

#### Missing platform channels

Use conditional imports or mock platform channels in tests.

### Signing Failures

#### "Keystore not found"

```
Error: Keystore file 'release.jks' not found
```

1. Check file exists at `android/app/release.jks`
2. Verify `key.properties` has correct path
3. Ensure base64 decoding produced valid keystore

#### "Alias not found"

```
Error: key associated with alias 'your-alias' not found
```

1. List keystore contents: `keytool -list -keystore release.jks`
2. Verify alias matches `key.properties`

### Workflow Failures

#### Runner issues

```bash
# Check runner logs in GitHub Actions
# Try re-running the job
```

#### Cache issues

1. Go to **Actions** tab
2. Click on **Workflows**
3. Select **Manage caches**
4. Delete relevant cache entries

### Performance Issues

#### Slow builds

```properties
# In gradle.properties
org.gradle.caching=true
org.gradle.parallel=true
org.gradle.configureondemand=true
```

#### Out of memory

```properties
# In gradle.properties
org.gradle.jvmargs=-Xmx8G -XX:MaxMetaspaceSize=4G
```

---

## Project Configuration Summary

### Android Configuration

| Setting | Value |
|---------|-------|
| Application ID | `com.rpgsystem.rpg_system` |
| Min SDK | 26 (Android 8.0) |
| Target SDK | Latest Flutter default |
| Code Shrinking | R8 (full mode) |
| ProGuard | Enabled for release |

### Build Artifacts

| Type | Path |
|------|------|
| Debug APK | `build/app/outputs/flutter-apk/app-debug.apk` |
| Release APK | `build/app/outputs/flutter-apk/app-release.apk` |
| App Bundle | `build/app/outputs/bundle/release/app-release.aab` |
| Keystore | `android/app/release.jks` |
| Key properties | `android/key.properties` |
| ProGuard rules | `android/app/proguard-rules.pro` |

---

## Quick Reference

### Common Commands

```bash
# Setup
flutter pub get
dart run build_runner build

# Development
flutter run

# Build
flutter build apk --debug
flutter build apk --release
flutter build appbundle --release

# Test
flutter test
flutter analyze

# Format
dart format .
```

### Environment

| Variable | Value |
|----------|-------|
| Flutter Version | 3.44.0 |
| Dart Version | 3.6.0 |
| Java Version | 17 |
| Min Android SDK | 26 |

---

## Support

For issues with:
- **GitHub Actions**: Check workflow run logs
- **Build errors**: Run `flutter doctor`
- **Signing issues**: Verify keystore configuration
- **Play Store**: Contact Google Play support
