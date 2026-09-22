# Local and Store Deployment

The app identifier is `com.tac.contractor`. Flutter version `1.0.4+10` is the
current release version.

## One-time macOS setup

Install the full Xcode application from the App Store, open it once, accept the
license, and then run:

```sh
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
sudo xcodebuild -license accept
```

Install CocoaPods and verify the project:

```sh
export PATH="/opt/homebrew/bin:$PATH"
brew install cocoapods
pod --version
flutter doctor
flutter pub get
cd ios && pod install && cd ..
```

Homebrew is installed at `/opt/homebrew` on Apple Silicon. Add the `export`
line to `~/.zshrc` to make `brew` and `pod` available in every new terminal.

Because this Mac currently selects Command Line Tools instead of Xcode, run
this once in a terminal and enter your macOS password when prompted:

```sh
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
```

You can use Xcode without changing the system selection temporarily with:

```sh
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer flutter doctor
```

Create an iPhone simulator in Xcode (`Window > Devices and Simulators`) or use
an existing one, then run:

```sh
open -a Simulator
flutter devices
flutter run -d <simulator-id>
```

Open `ios/Runner.xcworkspace` in Xcode, select the `Runner` target, and select
the Apple development team under `Signing & Capabilities`. Automatic signing
must be enabled for the `com.tac.contractor` bundle identifier.

## Google Maps iOS setup

The iOS Maps key is shared with the Firebase iOS configuration in
`ios/Runner/GoogleService-Info.plist`. In Google Cloud Console, select the
`taccontractor-f77ef` project and verify all of the following:

- Billing is enabled for the project.
- Maps SDK for iOS is enabled under APIs and Services.
- The key is allowed to use Maps SDK for iOS.
- If the key has iOS app restrictions, its bundle ID is `com.tac.contractor`.

The simulator showed a blank map because Google rejected the previous key with
HTTP 400 during API-key validation. After changing the key restrictions or
enabling the API, rebuild the app:

```sh
flutter clean
flutter pub get
cd ios && pod install && cd ..
flutter run -d <simulator-id>
```

## Google Play release

Create a private upload keystore once. Keep the passwords out of git:

```sh
keytool -genkeypair -v -keystore android/app/contractor.jks \
  -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 \
  -alias contractor
```

Create `android/keystore.properties` (this file is git-ignored):

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=contractor
storeFile=app/contractor.jks
```

Register the keystore's SHA-1/SHA-256 certificates with Firebase and any APIs
that use Google sign-in or Maps. Build the Play artifact with:

```sh
flutter build appbundle --release
```

Upload `build/app/outputs/bundle/release/app-release.aab` to the Play Console.
The first Play Console upload also requires creating the app, completing its
store listing, content declarations, data safety form, and Play App Signing.

## Apple App Store release

In Xcode, open `ios/Runner.xcworkspace`, select the `Runner` target, choose the
correct Apple Developer team, and verify that the App ID
`com.tac.contractor` has Push Notifications, Sign in with Apple, and the needed
Maps/location capabilities. Use `Product > Archive`, then distribute the
archive through Organizer to App Store Connect.

For a command-line archive after signing is configured:

```sh
flutter build ipa --release
```

Create or update the matching App Store Connect app before uploading. Push
notifications require a production APNs key/certificate and the Firebase iOS
APNs key configured in Firebase Console.