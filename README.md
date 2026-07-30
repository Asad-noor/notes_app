# notes_app

A Flutter learning/sandbox project. Despite the name, the app currently is a
small "My Coffee" demo app plus a networking demo screen — there is no notes
feature yet.

## App overview

### Screens / widgets

- **`lib/main.dart`** — App entry point. Runs a `MaterialApp` whose home is
  `Home`. Also contains an unused `SandBox` widget (scratch/demo widget, not
  wired into navigation).
- **`lib/home.dart`** (`Home`) — The home screen.
  - Shows a "My Coffee" `AppBar`.
  - Embeds `CoffeePrefs` (coffee strength/sugar picker).
  - Shows a coffee background image (`assets/imgs/coffee_bg.jpg`).
  - Has a `FloatingActionButton` that navigates to `PostsScreen` to
    demonstrate an API call.
- **`lib/coffee_prefs.dart`** (`CoffeePrefs`) — Stateful widget with two
  counters (`strength`, `sugar`), each wrapping 0-5 with a button, rendered as
  rows of bean/sugar-cube icons (`assets/imgs/coffee_bean.png`,
  `assets/imgs/sugar_cube.png`).
- **`lib/posts_screen.dart`** (`PostsScreen`) — Networking demo screen.
  - Uses `dio` to `GET https://jsonplaceholder.typicode.com/posts` (free
    public test API, no auth needed).
  - Parses the JSON response into a list of `Post` (`id`, `title`, `body`).
  - Renders the list with `ListView.separated` + `FutureBuilder`.
  - Handles loading (spinner), error (message + retry button), and
    pull-to-refresh (`RefreshIndicator`).

### Navigation flow

```
Home (FAB) --> PostsScreen
```

### Dependencies

- `dio` — HTTP client, used in `PostsScreen` to fetch posts.
- `cupertino_icons` — default Flutter icon set.

### Assets

- `assets/imgs/coffee_bean.png`
- `assets/imgs/coffee_bg.jpg`
- `assets/imgs/sugar_cube.png`

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
