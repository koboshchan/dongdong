dongdong is a native SwiftUI iOS app that shows your OS version, system build, and whether they match the iOS 27.0 developer beta 1–4 compatibility policy.

Injection is intentionally not implemented. The “Replace file” button is permanently disabled, its action does nothing, and `inject()` is an empty function with no callers. This app cannot replace files.

The checker requires exactly iOS 27.0.0 and one of these task-specified builds. Beta 1 uses `24A5355q`, beta 2 uses `24A5370h`, beta 3 uses `24A5380h`, and beta 4 uses `24A5390f`. These identifiers define the requested allowlist; they are not independently verified Apple release metadata. “Supported” means the version and build match, not that injection or any other device capability works.

The app reads the version through `ProcessInfo` and the build through read-only `kern.osversion` queries. Unknown, malformed, or unreadable builds fail closed. There is no file picker, payload, private-framework bridge, network request, or special entitlement.

To build the app, use a Mac with Xcode and an iOS 26 SDK or newer, Swift 6.0 or newer, and XcodeGen. The deployment target is iOS 26.0 so unsupported versions can still show a result. The core checker also builds and runs its tests on Linux with Swift 6.0 or newer.

Clone the repository and generate the Xcode project.

```sh
git clone https://github.com/koboshchan/dongdong.git
cd dongdong
brew install xcodegen
xcodegen generate
open Dongdong.xcodeproj
```

Choose the Dongdong scheme and an iOS simulator, then run it in Xcode. For a physical device, select your own signing team under Signing & Capabilities, choose your connected device, and run. No signing credentials or prebuilt installation package are included.

For a compile-only simulator check without signing or launching a simulator, run this from the repository root.

```sh
xcodebuild -project Dongdong.xcodeproj -scheme Dongdong \
  -sdk iphonesimulator -configuration Debug \
  -destination 'generic/platform=iOS Simulator' \
  CODE_SIGNING_ALLOWED=NO build
```

Run the checker tests and release build on macOS or Linux.

```sh
swift test
swift build -c release
```

The tests cover every allowlisted build, exact-version matching, unknown and unreadable builds, malformed build decoding, snapshot values, and Linux fail-closed behavior. GitHub Actions runs the package tests and Linux release build, plus package tests and a native iOS simulator compile on macOS. There is no dedicated iOS UI or runtime test target.

`App/` contains the SwiftUI app, compatibility screen, and empty injection placeholder. `Sources/CompatibilityCore/` holds the compatibility policy and system readers. `Tests/CompatibilityCoreTests/` holds the checker tests. `project.yml` defines the XcodeGen project, and `.github/workflows/checks.yml` defines CI.

Created by Lucas ([koboshchan](https://github.com/koboshchan)). Licensed under the [MIT license](LICENSE).
