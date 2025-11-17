# Play Store Deployment Checklist

This document outlines the steps and requirements for deploying the Whisp app to the Google Play Store.

## ✅ Completed Configuration

1. **Code Obfuscation & Shrinking**
   - ✅ ProGuard/R8 enabled for release builds
   - ✅ ProGuard rules file created (`android/app/proguard-rules.pro`)
   - ✅ Code shrinking and resource shrinking enabled

2. **Permissions**
   - ✅ Updated permissions for Android 13+ (API 33+)
   - ✅ Scoped storage permissions configured
   - ✅ POST_NOTIFICATIONS permission added for Android 13+

3. **Security**
   - ✅ Network security configuration added
   - ✅ Cleartext traffic disabled
   - ✅ Legacy external storage disabled

## ⚠️ Action Items Before Publishing

### 1. App Signing Key
- [x] ✅ Keystore file created at `android/app/upload-keystore.jks`
- [x] ✅ `android/key.properties` file created
- [ ] **IMPORTANT**: Change the default passwords in `android/key.properties` for security
  - Current passwords: `whisp2024` (change these!)
  - Update both `storePassword` and `keyPassword` with strong, unique passwords
  - **CRITICAL**: Keep your keystore file and passwords secure. You'll need them for all future updates.
  - Store a backup of the keystore file in a secure location (if you lose it, you cannot update your app!)

### 2. AdMob Configuration
- [ ] Replace the test AdMob App ID in `android/app/src/main/AndroidManifest.xml`
- [ ] Current test ID: `ca-app-pub-3940256099942544~3347511713`
- [ ] Get your production AdMob App ID from [AdMob Console](https://apps.admob.com/)
- [ ] Update the `APPLICATION_ID` meta-data in AndroidManifest.xml

### 3. Firebase Configuration
- [ ] Update `google-services.json` with the new package name `com.roxy.whisp`
- [ ] Add Android app with package name `com.roxy.whisp` in Firebase Console
- [ ] Download the new `google-services.json` and replace the existing one
- [ ] Update iOS bundle ID in Firebase Console to `com.roxy.whisp`

### 4. App Versioning
- [ ] Update version in `pubspec.yaml` (currently `1.0.0+1`)
- [ ] Format: `version: MAJOR.MINOR.PATCH+BUILD_NUMBER`
- [ ] Increment `BUILD_NUMBER` for each Play Store upload

### 5. App Icons and Assets
- [ ] Verify app icon is set correctly (currently using `assets/images/app_logo_main.png`)
- [ ] Run `flutter pub run flutter_launcher_icons` to generate icons
- [ ] Ensure all required icon sizes are present

### 6. Privacy Policy & Data Safety
- [ ] Create a privacy policy URL (required by Play Store)
- [ ] Complete Data Safety section in Play Console
- [ ] Declare all data collection and usage practices
- [ ] List all permissions and explain why they're needed

### 7. Content Rating
- [ ] Complete content rating questionnaire in Play Console
- [ ] Get rating certificate

### 8. Store Listing
- [ ] Prepare app screenshots (at least 2, recommended 8)
- [ ] Prepare feature graphic (1024 x 500 pixels)
- [ ] Write app description
- [ ] Write short description (80 characters max)
- [ ] Add app category
- [ ] Add contact email and website (if applicable)

### 9. Testing
- [ ] Test release build on physical devices
- [ ] Test all features with ProGuard enabled
- [ ] Test on different Android versions (especially Android 13+)
- [ ] Test app with restricted permissions
- [ ] Verify Firebase services work correctly
- [ ] Test AdMob integration (with production ad units)

### 10. Build Release Bundle
```bash
# Clean the project
flutter clean

# Get dependencies
flutter pub get

# Build the app bundle (recommended for Play Store)
flutter build appbundle --release

# Or build APK for testing
flutter build apk --release
```

The app bundle will be located at:
`build/app/outputs/bundle/release/app-release.aab`

### 11. Upload to Play Console
- [ ] Create app in Google Play Console
- [ ] Upload the `.aab` file
- [ ] Complete all required sections
- [ ] Submit for review

## Important Notes

1. **Target SDK**: Ensure your app targets Android 13 (API 33) or higher. The current configuration uses Flutter's default target SDK.

2. **64-bit Support**: Google Play requires 64-bit support. Flutter apps include this by default.

3. **App Bundle**: Always upload `.aab` (Android App Bundle) instead of `.apk` for better optimization.

4. **Version Code**: Each upload must have a higher version code than the previous one.

5. **Testing**: Use Internal Testing track first, then Alpha, Beta, and finally Production.

## Common Issues

### ProGuard Issues
If you encounter runtime errors after enabling ProGuard, add keep rules to `proguard-rules.pro` for the affected classes.

### Permission Issues
If permissions aren't working on Android 13+, ensure you're requesting them at runtime using `permission_handler` package.

### Firebase Issues
If Firebase services don't work, verify:
- `google-services.json` has the correct package name
- Firebase project has the app registered with correct package name
- SHA-1 and SHA-256 certificates are added in Firebase Console

## Support

For issues or questions, refer to:
- [Flutter Deployment Guide](https://docs.flutter.dev/deployment/android)
- [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- [Android App Bundle Guide](https://developer.android.com/guide/app-bundle)

