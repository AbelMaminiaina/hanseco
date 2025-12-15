import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/auth/oauth_service.dart';
import '../../../../core/auth/token_manager.dart';

// Dio Provider for OAuth
final _dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: 'http://localhost:8000/api',
      connectTimeout: const Duration(milliseconds: 30000),
      receiveTimeout: const Duration(milliseconds: 30000),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
});

// OAuth Service Provider
final oauthServiceProvider = Provider<OAuthService>((ref) {
  final dio = ref.watch(_dioProvider);
  return OAuthService(dio);
});

// Token Manager Provider
final tokenManagerProvider = Provider<TokenManager>((ref) {
  return TokenManager();
});

// OAuth State
class OAuthState {
  final bool isLoading;
  final String? error;
  final Map<String, dynamic>? user;
  final bool isAuthenticated;

  OAuthState({
    this.isLoading = false,
    this.error,
    this.user,
    this.isAuthenticated = false,
  });

  OAuthState copyWith({
    bool? isLoading,
    String? error,
    Map<String, dynamic>? user,
    bool? isAuthenticated,
  }) {
    return OAuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

// OAuth Notifier
class OAuthNotifier extends StateNotifier<OAuthState> {
  final OAuthService _oauthService;
  final TokenManager _tokenManager;

  OAuthNotifier(this._oauthService, this._tokenManager) : super(OAuthState());

  // Check if user is already authenticated
  Future<void> checkAuthStatus() async {
    final isLoggedIn = await _tokenManager.isLoggedIn();
    if (isLoggedIn) {
      final user = await _tokenManager.decodeToken();
      state = state.copyWith(
        isAuthenticated: true,
        user: user,
      );
    }
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _oauthService.signInWithGoogle();

      if (result != null) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          user: result['user'],
        );
      } else {
        // User cancelled
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Sign in with Facebook
  Future<void> signInWithFacebook() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _oauthService.signInWithFacebook();

      if (result != null) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          user: result['user'],
        );
      } else {
        // User cancelled
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Sign out
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);

    try {
      await _oauthService.signOut();
      state = OAuthState(); // Reset to initial state
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Refresh token
  Future<bool> refreshToken() async {
    try {
      return await _oauthService.refreshAccessToken();
    } catch (e) {
      return false;
    }
  }
}

// OAuth Provider
final oauthNotifierProvider =
    StateNotifierProvider<OAuthNotifier, OAuthState>((ref) {
  final oauthService = ref.watch(oauthServiceProvider);
  final tokenManager = ref.watch(tokenManagerProvider);
  return OAuthNotifier(oauthService, tokenManager);
});

// Helper provider to check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final oauthState = ref.watch(oauthNotifierProvider);
  return oauthState.isAuthenticated;
});

// Helper provider to get current user
final currentUserProvider = Provider<Map<String, dynamic>?>((ref) {
  final oauthState = ref.watch(oauthNotifierProvider);
  return oauthState.user;
});
