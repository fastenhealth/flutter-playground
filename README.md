# Flutter Playground

A minimal Flutter playground for the local
`fasten_stitch_element_flutter` package. It mirrors the React Native
playground by rendering `FastenStitchElement` full-screen with debug logging
enabled.

## Setup

This repository depends on the sibling SDK checkout:

```yaml
fasten_stitch_element_flutter:
  path: ../fasten-stitch-element-flutter
```

With Flutter installed, generate any missing platform folders and run the app:

```bash
flutter create .
flutter pub get
flutter run
```

On macOS, restart the app after entitlement changes. Hot reload will not
re-sign the running app with updated sandbox permissions.

The app uses the same test public ID as `/Users/jason/repos/react-native-playground`
and logs event bus messages with:

```text
[FastenStitchElement onEventBus] message ...
```

### Running on IOS

```bash
$ flutter devices
$ flutter emulators

Found 3 connected devices:
  iPhone 17 (mobile) • F8740797-17FA-4394-87D3-DDF6A82D8105 • ios            • com.apple.CoreSimulator.SimRuntime.iOS-26-5
  (simulator)
  macOS (desktop)    • macos                                • darwin-arm64   • macOS 26.4.1 25E253 darwin-arm64

# Run on the iPhone 17 simulator
$ flutter run -d F8740797-17FA-4394-87D3-DDF6A82D8105
```
