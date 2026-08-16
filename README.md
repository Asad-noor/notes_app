# notes_app

A Flutter learning/sandbox project. Despite the package name, there is no notes
feature yet — the app currently ships a small **"My Coffee"** preferences demo
plus a **networking demo** screen that lists posts from a public REST API.

- **Platforms configured:** Android, iOS
- **Dart SDK:** `^3.5.0`
- **State management:** plain `setState` (no external state library)

---

## Table of contents

- [Getting started](#getting-started)
- [Project structure](#project-structure)
- [Screens](#screens)
- [Navigation](#navigation)
- [Data layer](#data-layer)
- [Assets](#assets)
- [Dependencies](#dependencies)
- [Testing](#testing)
- [Known gaps](#known-gaps)

---

## Getting started

### Prerequisites

- Flutter SDK with Dart `^3.5.0` (Flutter 3.24 or newer)
- An Android emulator / device, or an iOS simulator / device (Xcode on macOS)

### Install and run

```bash
flutter pub get       # fetch dependencies
flutter devices       # list available targets
flutter run           # run on the connected device
```

### Common tasks

```bash
flutter analyze                 # static analysis (flutter_lints ruleset)
flutter test                    # run the test suite
flutter build apk --release     # Android release build
flutter build ios --release     # iOS release build (macOS + Xcode)
```

The posts screen calls a public API over the network, so the device or
emulator needs internet access for that screen to load.

---

## Project structure

```
lib/
├── main.dart          # entry point + unused SandBox scratch widget
├── home.dart          # Home screen ("My Coffee")
├── coffee_prefs.dart  # CoffeePrefs stateful widget (strength / sugar)
└── posts_screen.dart  # PostsScreen + Post model (dio networking demo)

assets/imgs/           # coffee_bean.png, coffee_bg.jpg, sugar_cube.png
test/widget_test.dart  # placeholder test (body commented out)
```

---

## Screens

### `main.dart` — entry point

Runs a `MaterialApp` whose `home` is `Home`. No theme, routes table, or
`title` is configured — everything is styled inline per-widget.

The file also contains a `SandBox` `StatelessWidget` (three fixed-height
coloured `Container`s in a `Row`). It is a layout scratch pad and is **not**
wired into navigation.

### `home.dart` — `Home` (StatelessWidget)

The landing screen, laid out as a stretched `Column`:

| Section | Content |
| --- | --- |
| `AppBar` | Centered bold white title "My Coffee" on `Colors.brown[700]` |
| Band 1 | `Colors.brown[200]` strip with the text "How I like my coffee?" |
| Band 2 | `Colors.brown[100]` strip wrapping the `CoffeePrefs` widget |
| Body | `Expanded` `coffee_bg.jpg`, `BoxFit.fitWidth`, bottom-aligned |
| FAB | Brown `FloatingActionButton` with a list icon → pushes `PostsScreen` |

### `coffee_prefs.dart` — `CoffeePrefs` (StatefulWidget)

Two counters held in `_CoffeePrefsState`, both starting at `1` and both
incremented by a trailing `+` button that wraps when it passes 5:

| Field | Control | Range and wrap behaviour | Rendered as |
| --- | --- | --- | --- |
| `strength` | `FilledButton` (brown fill) | 1 → 5, then wraps back to **1** | one `coffee_bean.png` per unit |
| `sugar` | `TextButton` (brown text) | 1 → 5, then wraps to **0** | one `sugar_cube.png` per unit; shows "No Sugars.." at 0 |

Icons are drawn at `width: 25` and tinted against `Colors.brown[100]` using
`colorBlendMode: BlendMode.multiply`, so they blend into the band behind them.

State is local to the widget — nothing is persisted between launches, and the
values are not read anywhere else in the app.

### `posts_screen.dart` — `PostsScreen` (StatefulWidget)

A networking demo pushed from the home FAB.

- Fetches on `initState` into a `late Future<List<Post>>`, rendered through a
  `FutureBuilder`.
- **Loading:** centered `CircularProgressIndicator`.
- **Error:** the error message plus a **Retry** button that re-runs the fetch.
- **Success:** `ListView.separated` with `Divider(height: 1)` separators, each
  row a `ListTile` with a brown `CircleAvatar` showing the post id, the title
  (1 line, ellipsized) and the body (2 lines, ellipsized).
- **Pull to refresh:** the list is wrapped in a `RefreshIndicator` bound to the
  same `_refresh` method used by the retry button.

---

## Navigation

There is no named-route table; the single transition uses an imperative push.

```
Home ──[FloatingActionButton]──> PostsScreen
                                     │
                                 [back]
                                     ▼
                                   Home
```

---

## Data layer

### Endpoint

```
GET https://jsonplaceholder.typicode.com/posts
```

[JSONPlaceholder](https://jsonplaceholder.typicode.com/) is a free public test
API — no key, token, or configuration is required.

### `Post` model

```dart
class Post {
  final int id;
  final String title;
  final String body;

  Post({required this.id, required this.title, required this.body});

  factory Post.fromJson(Map<String, dynamic> json) => ...;
}
```

`Post.fromJson` casts `id` to `int` and `title` / `body` to `String`. The
response body is cast to `List` and mapped over. A `Dio` instance is created
per `_PostsScreenState`; there is no shared client, base URL, interceptor, or
timeout configuration.

---

## Assets

Declared in `pubspec.yaml` under `flutter.assets`:

| Path | Used by |
| --- | --- |
| `assets/imgs/coffee_bean.png` | `CoffeePrefs` — strength indicator |
| `assets/imgs/sugar_cube.png` | `CoffeePrefs` — sugar indicator |
| `assets/imgs/coffee_bg.jpg` | `Home` — background image |

---

## Dependencies

**Runtime**

| Package | Version | Purpose |
| --- | --- | --- |
| `flutter` | SDK | Framework |
| `dio` | `^5.11.0` | HTTP client used by `PostsScreen` |
| `cupertino_icons` | `^1.0.8` | iOS-style icon font |

**Development**

| Package | Version | Purpose |
| --- | --- | --- |
| `flutter_test` | SDK | Widget/unit test framework |
| `flutter_lints` | `^5.0.0` | Lint ruleset wired up via `analysis_options.yaml` |

---

## Testing

`test/widget_test.dart` covers the `CoffeePrefs` counters:

- **strength counter increments and wraps at 5** — asserts the bean count grows
  per tap and wraps back to 1 after 5.
- **sugars wrap to zero and show the empty label** — asserts the "No Sugars.."
  label appears once sugars wrap past 5 to 0.

Both pass under `flutter test`. `PostsScreen` has no coverage — testing it
would need the `dio` call stubbed behind an injectable client.

---

## Known gaps

Tracked here so they are not mistaken for finished behaviour:

- No notes feature, despite the project name.
- `SandBox` in `main.dart` is dead code.
- `strength` wraps `5 → 1` while `sugar` wraps `5 → 0`; the asymmetry is
  intentional only insofar as "no sugar" is a valid choice and "no strength"
  is not.
- Coffee preferences are in-memory only — no persistence.
- No app theme; colours are repeated inline across widgets.
- No error typing or timeout handling around the `dio` call — any failure
  surfaces as a raw `toString()` of the exception.
- `PostsScreen` is untested; the `Dio` instance is constructed inside the
  state, so it cannot be stubbed without refactoring.

---

## Flutter resources

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Flutter documentation](https://docs.flutter.dev/)
