# Business Insights — Mobile (Flutter)

The Flutter client for the Business Insights app. See the
[root README](../README.md) for full setup, run, and APK build instructions, and
[docs/ARCHITECTURE.md](../docs/ARCHITECTURE.md) for the API contract.

## Quick start

```bash
flutter pub get
flutter run
```

The backend API URL is configured in one place: [lib/config/app_config.dart](lib/config/app_config.dart).
State management follows an intentional split — **GetX** for navigation and simple UI
state, **BLoC/Cubit** for the data layer (one Cubit per feature). Details are in the
root README.
