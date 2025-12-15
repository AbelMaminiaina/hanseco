import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
// Conditional import for web-only HTML library
import 'env_config_stub.dart'
    if (dart.library.html) 'env_config_web.dart';

class EnvConfig {
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? 'http://localhost:8000/api';
  static String get googleClientId => dotenv.env['GOOGLE_CLIENT_ID'] ?? '';
  static String get facebookAppId => dotenv.env['FACEBOOK_APP_ID'] ?? '';

  /// Injecte le Google Client ID dans le DOM pour Flutter Web
  static void injectGoogleClientIdToDOM() {
    if (kIsWeb && googleClientId.isNotEmpty) {
      try {
        injectClientIdToHtml(googleClientId);
        debugPrint('✅ Google Client ID injected into DOM');
      } catch (e) {
        debugPrint('❌ Error injecting Google Client ID: $e');
      }
    }
  }
}
