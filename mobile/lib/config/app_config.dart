/// Central place for the backend API base URL.
///
/// The app talks to four endpoints (`/login`, `/business`, `/insights`,
/// `/reviews`). Switching between local development and the deployed Render
/// backend is a one-line change here.
class AppConfig {
  AppConfig._();

  /// Flip to `false` to point the app at the deployed Render backend.
  ///
  /// Kept `true` during development so the app talks to a backend running
  /// locally (see [localBaseUrl]).
  static const bool useLocalApi = true;

  /// Local development backend.
  ///
  /// Android emulators reach the host machine's `localhost` at `10.0.2.2`, so
  /// that is the default. When running on a **physical device**, replace this
  /// with your computer's LAN IP (e.g. `http://192.168.1.5:5000`) and make sure
  /// the phone is on the same Wi-Fi network. Cleartext (HTTP) traffic to these
  /// hosts is permitted via
  /// `android/app/src/main/res/xml/network_security_config.xml`.
  static const String localBaseUrl = 'http://10.0.2.2:5000';

  /// Deployed backend on Render (HTTPS).
  ///
  /// TODO: replace with the real Render URL after deploying the backend, then
  /// set [useLocalApi] to `false` and rebuild the release APK.
  static const String prodBaseUrl = 'https://your-service-name.onrender.com';

  /// The base URL the app actually uses, chosen by [useLocalApi].
  static String get baseUrl => useLocalApi ? localBaseUrl : prodBaseUrl;
}
