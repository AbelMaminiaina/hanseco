class AppConstants {
  AppConstants._();

  static const String appName = 'HansEco';
  static const String appVersion = '1.0.0';

  // API
  static const int apiTimeout = 30000;
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Pagination
  static const int pageSize = 20;

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String languageKey = 'language';
  static const String themeKey = 'theme';

  // Hive Boxes
  static const String authBox = 'auth_box';
  static const String cartBox = 'cart_box';
  static const String productBox = 'product_box';

  // Payment Providers
  static const String mvolaProvider = 'mvola';
  static const String airtelProvider = 'airtel';
  static const String orangeProvider = 'orange';
  static const String paypalProvider = 'paypal';
  static const String stripeProvider = 'stripe';
}
