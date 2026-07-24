/// Central place for the backend API base URL.
///
/// The app talks to four endpoints (`/login`, `/business`, `/insights`,
/// `/reviews`). Switching between local development and the deployed Render
/// backend is a one-line change here.
class AppConfig {
  AppConfig._();

  /// Flip to `true` to point the app at a backend running locally.
  ///
  /// Kept `false` so the app (and the release APK) talks to the deployed
  /// Render backend — see [prodBaseUrl].
  static const bool useLocalApi = false;

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
  /// No trailing slash — endpoint paths are appended directly.
  ///
  /// Note: on Render's free tier the service sleeps after inactivity, so the
  /// first request after an idle period can take 30–60s to wake it. The API
  /// client's timeout accounts for this.
  static const String prodBaseUrl =
      'https://business-insights-app-vpfx.onrender.com';

  /// The base URL the app actually uses, chosen by [useLocalApi].
  static String get baseUrl => useLocalApi ? localBaseUrl : prodBaseUrl;
}
