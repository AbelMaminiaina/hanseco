import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;

class EnvConfig {
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? 'http://localhost:8000/api';
  static String get googleClientId => dotenv.env['GOOGLE_CLIENT_ID'] ?? '';
  static String get facebookAppId => dotenv.env['FACEBOOK_APP_ID'] ?? '';

  /// Injecte le Google Client ID dans le DOM pour Flutter Web
  static void injectGoogleClientIdToDOM() {
    if (kIsWeb && googleClientId.isNotEmpty) {
      try {
        final metaTag = html.document.querySelector('meta[name="google-signin-client_id"]');
        if (metaTag != null) {
          metaTag.setAttribute('content', googleClientId);
          print('✅ Google Client ID injected into DOM: ${googleClientId.substring(0, 20)}...');
        } else {
          print('⚠️ Meta tag google-signin-client_id not found in DOM');
        }
      } catch (e) {
        print('❌ Error injecting Google Client ID: $e');
      }
    }
  }
}
