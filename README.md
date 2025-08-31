# Raja C Flutter Employees

A take home assignment to demonstrate employee management system built with Flutter 3.9, supporting Android & Web platforms.

## Features
- Employee CRUD (Create, Read, Update, Delete)
- Custom form widgets with validation
- Modern UI with Material 3 and theming
- Date and role selectors
- Sticky headers, swipe-to-delete, and more
- Responsive design for web and mobile

## Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.9 or later)
- Dart 3.0 or later

### Run Locally
```bash
flutter pub get
flutter run
```

### Run on Web
```bash
flutter run -d chrome
```

## Deploy to Netlify (Web)
This project is ready for Netlify static hosting. The `netlify.toml` is preconfigured.

### Steps:
1. Push your code to GitHub: https://github.com/chakravartiraj/raja_c_flutter_employees
2. Go to [Netlify](https://app.netlify.com/) and create a new site from GitHub
3. Select your repo and use these settings:
   - **Build command:** `flutter build web --release`
   - **Publish directory:** `build/web`
4. Netlify will auto-detect the `netlify.toml` and handle SPA routing

## Project Structure
- `lib/` - Main source code
  - `features/employees/` - Employee domain, presentation, widgets
  - `core/` - Utilities, theming, DI, etc.
- `web/` - Web entrypoint (auto-generated)
- `netlify.toml` - Netlify deployment config

## Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](LICENSE)
