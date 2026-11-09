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

## Co-branding

Pass branding settings when starting the playground:

```bash
flutter run \
  --dart-define=BRANDING_THEME=dark \
  --dart-define='BRANDING_ACCENT_COLOR=#1A73E8' \
  --dart-define='BRANDING_LOGO_URL=https://example.com/logo.png' \
  --dart-define='BRANDING_COMPANY_NAME=Example Health'
```

| Playground setting | SDK option | Embed query parameter | Default |
| --- | --- | --- | --- |
| `BRANDING_THEME` | `brandingTheme` | `theme` | `light` |
| `BRANDING_ACCENT_COLOR` | `brandingAccentColor` | `accent-color` | Omitted |
| `BRANDING_LOGO_URL` | `brandingLogoUrl` | `logo-url` | Omitted |
| `BRANDING_COMPANY_NAME` | `brandingCompanyName` | `company-name` | Omitted |

Supply raw values; the SDK uses Dart's query-string encoder to escape `#`
and reserved characters in logo URLs. Empty optional values are omitted.
The embed accepts `light` or `dark` for the theme and falls back to `light`
for missing or unrecognized values. It expands `#RGB` accent colors to
`#RRGGBB` and ignores invalid colors. Logo URLs and company names are trimmed
by the embed; logo URLs receive no other validation. The company name appears
in the header and supplies the logo's alt text.

Branding is passed through the WebView URL independently of `sdk-mode` and
the native event bridge. Restart the app after changing these compile-time
settings.

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
