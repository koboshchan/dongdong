dongdong is a minimal native SwiftUI iOS app that displays the detected OS version and system build. It has one permanently disabled, no-op “Replace file” placeholder. It cannot replace files.

The compatibility policy requires exactly iOS 27.0.0 and one of the task-specified developer beta builds. Beta 1 is `24A5355q`, beta 2 is `24A5370h`, beta 3 is `24A5380h`, and beta 4 is `24A5390f`. Any other version or build is unsupported. An unreadable build fails closed. “Supported” means only that the version/build tuple matches this allowlist, not that any operation or device capability has been tested.

The app reads `ProcessInfo.operatingSystemVersion` and `kern.osversion` through read-only `sysctlbyname` calls. It has no file selection, file replacement, payload, private-framework bridge, target container, network request, or special entitlement. The placeholder remains disabled even when the allowlist matches.

The source is independently written for this limited UI/checker scope. No implementation was copied from another project. The existing [MIT license](LICENSE) is unchanged.

Run the core tests with Swift 6.0 or later on Linux or macOS.

```sh
swift test
swift build -c release
```

Build the iOS app with an iOS 26 SDK or newer and [XcodeGen](https://github.com/yonaskolb/XcodeGen). The project uses Swift 6 language mode and targets iOS 26.0 or later so unsupported OS versions can still display a result.

```sh
xcodegen generate
xcodebuild -project Dongdong.xcodeproj -scheme Dongdong \
  -sdk iphonesimulator -configuration Debug \
  -destination 'generic/platform=iOS Simulator' \
  CODE_SIGNING_ALLOWED=NO build
```

Open the generated project in Xcode and choose your own signing team to run on a device. No signing credentials are included.

`Sources/CompatibilityCore` contains the allowlist and system reader. `Tests/CompatibilityCoreTests` covers each allowed build, exact-version rejection, malformed or unknown builds, unreadable builds, decoding failures, and Linux fail-closed behavior. `App` contains the SwiftUI form. GitHub Actions runs the package checks on Linux and compiles the iOS app on a hosted Mac without launching a simulator.

The reader follows Apple's [ProcessInfo documentation](https://developer.apple.com/documentation/foundation/processinfo/operatingsystemversion) and [sysctl manual](https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man3/sysctl.3.html). Build identifiers are a requested policy, not independently verified Apple release metadata.
