import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;

import 'token_manager.dart';
import '../config/env_config.dart';

class OAuthService {
  final TokenManager _tokenManager = TokenManager();
  final Dio _dio;

  GoogleSignIn? _googleSignIn;
  FacebookAuth? _facebookAuth;

  OAuthService(this._dio);

  // Lazy initialization for Google Sign In
  GoogleSignIn get googleSignIn {
    if (_googleSignIn == null) {
      final clientId = EnvConfig.googleClientId;
      // Only set clientId if it's a valid one (not placeholder)
      _googleSignIn = GoogleSignIn(
        clientId: (clientId.isNotEmpty && !clientId.contains('YOUR_GOOGLE'))
            ? clientId
            : null,
        scopes: [
          'email',
          'profile',
        ],
      );
    }
    return _googleSignIn!;
  }

  // Lazy initialization for Facebook Auth
  FacebookAuth get facebookAuth {
    _facebookAuth ??= FacebookAuth.instance;
    return _facebookAuth!;
  }

  // ========== GOOGLE SIGN IN ==========

  /// Sign in with Google
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      // Trigger Google Sign In
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // Obtain auth details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Get the ID token (preferred) or access token (fallback for web)
      final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;

      // On web, idToken may be null, use accessToken instead
      final String? authToken = idToken ?? accessToken;

      if (authToken == null) {
        throw Exception('Failed to get Google authentication token');
      }

      // Send to backend
      return await _authenticateWithBackend(
        provider: 'google',
        authToken: authToken,
      );
    } catch (e) {
      debugPrint('Google Sign In Error: $e');
      rethrow;
    }
  }

  /// Sign out from Google
  Future<void> signOutGoogle() async {
    if (_googleSignIn != null) {
      await _googleSignIn!.signOut();
    }
  }

  // ========== FACEBOOK SIGN IN ==========

  /// Sign in with Facebook
  Future<Map<String, dynamic>?> signInWithFacebook() async {
    try {
      // Trigger Facebook Login
      final LoginResult result = await facebookAuth.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        // Get access token
        final AccessToken? accessToken = result.accessToken;

        if (accessToken == null) {
          throw Exception('Failed to get Facebook access token');
        }

        // Send to backend
        return await _authenticateWithBackend(
          provider: 'facebook',
          authToken: accessToken.tokenString,
        );
      } else if (result.status == LoginStatus.cancelled) {
        // User canceled the login
        return null;
      } else {
        throw Exception('Facebook login failed: ${result.status}');
      }
    } catch (e) {
      debugPrint('Facebook Sign In Error: $e');
      rethrow;
    }
  }

  /// Sign out from Facebook
  Future<void> signOutFacebook() async {
    if (_facebookAuth != null) {
      await _facebookAuth!.logOut();
    }
  }

  // ========== BACKEND AUTHENTICATION ==========

  /// Authenticate with backend using OAuth token
  Future<Map<String, dynamic>> _authenticateWithBackend({
    required String provider,
    required String authToken,
  }) async {
    try {
      final baseUrl = EnvConfig.apiBaseUrl;
      final response = await _dio.post(
        '$baseUrl/oauth/$provider/',
        data: {
          'auth_token': authToken,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Save tokens
        await _tokenManager.saveTokens(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
        );

        // Save user info
        final user = data['user'];
        await _tokenManager.saveUserInfo(
          userId: user['id'].toString(),
          email: user['email'],
        );

        return data;
      } else {
        throw Exception('Backend authentication failed');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['error'] ?? 'Authentication failed');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  // ========== TOKEN REFRESH ==========

  /// Refresh access token using refresh token
  Future<bool> refreshAccessToken() async {
    try {
      final refreshToken = await _tokenManager.getRefreshToken();

      if (refreshToken == null) {
        return false;
      }

      final baseUrl = EnvConfig.apiBaseUrl;
      final response = await _dio.post(
        '$baseUrl/oauth/token/refresh/',
        data: {
          'refresh': refreshToken,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Save new access token
        await _tokenManager.saveTokens(
          accessToken: data['access'],
          refreshToken: refreshToken, // Keep the same refresh token
        );

        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('Token refresh error: $e');
      return false;
    }
  }

  // ========== SIGN OUT ==========

  /// Complete sign out from all providers
  Future<void> signOut() async {
    // Sign out from Google
    try {
      await signOutGoogle();
    } catch (e) {
      debugPrint('Google sign out error: $e');
    }

    // Sign out from Facebook
    try {
      await signOutFacebook();
    } catch (e) {
      debugPrint('Facebook sign out error: $e');
    }

    // Clear tokens
    await _tokenManager.clearTokens();
  }

  // ========== HELPER METHODS ==========

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    return await _tokenManager.isLoggedIn();
  }

  /// Get current user info from token
  Future<Map<String, dynamic>?> getCurrentUser() async {
    return await _tokenManager.decodeToken();
  }
}
