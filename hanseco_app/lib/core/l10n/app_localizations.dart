import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'fr': {
      // Common
      'app_name': 'HansEco',
      'welcome': 'Bienvenue',
      'loading': 'Chargement...',
      'error': 'Erreur',
      'retry': 'Réessayer',
      'cancel': 'Annuler',
      'confirm': 'Confirmer',
      'save': 'Enregistrer',
      'delete': 'Supprimer',
      'search': 'Rechercher',
      'filter': 'Filtrer',

      // Auth
      'login': 'Connexion',
      'register': 'Inscription',
      'logout': 'Déconnexion',
      'email': 'Email',
      'password': 'Mot de passe',
      'forgot_password': 'Mot de passe oublié ?',
      'dont_have_account': "Vous n'avez pas de compte ?",
      'already_have_account': 'Vous avez déjà un compte ?',
      'sign_in': 'Se connecter',
      'sign_up': "S'inscrire",
      'full_name': 'Nom complet',
      'phone_number': 'Numéro de téléphone',

      // Products
      'products': 'Produits',
      'all_products': 'Tous les produits',
      'categories': 'Catégories',
      'new_arrivals': 'Nouveautés',
      'best_sellers': 'Meilleures ventes',
      'product_details': 'Détails du produit',
      'price': 'Prix',
      'in_stock': 'En stock',
      'out_of_stock': 'Rupture de stock',
      'add_to_cart': 'Ajouter au panier',
      'buy_now': 'Acheter maintenant',

      // Cart
      'cart': 'Panier',
      'my_cart': 'Mon panier',
      'cart_empty': 'Votre panier est vide',
      'cart_empty_message': 'Ajoutez des produits pour continuer',
      'browse_products': 'Parcourir les produits',
      'subtotal': 'Sous-total',
      'total': 'Total',
      'clear_cart': 'Vider le panier',
      'clear_cart_message': 'Êtes-vous sûr de vouloir vider votre panier ?',
      'item_removed': 'Article retiré du panier',
      'cart_cleared': 'Panier vidé',
      'quantity': 'Quantité',

      // Checkout & Payment
      'checkout': 'Paiement',
      'proceed_to_checkout': 'Procéder au paiement',
      'delivery_address': 'Adresse de livraison',
      'enter_address': 'Entrez votre adresse de livraison',
      'delivery_fee': 'Frais de livraison',
      'order_summary': 'Résumé de la commande',
      'payment_method': 'Méthode de paiement',
      'select_payment_method': 'Sélectionnez une méthode de paiement',
      'confirm_payment': 'Confirmer le paiement',
      'payment_processing': 'Paiement en cours...',
      'payment_success': 'Paiement réussi',
      'payment_failed': 'Échec du paiement',
      'mvola': 'MVola',
      'airtel_money': 'Airtel Money',
      'orange_money': 'Orange Money',
      'paypal': 'PayPal',
      'credit_card': 'Carte bancaire',

      // Orders
      'orders': 'Commandes',
      'my_orders': 'Mes commandes',
      'order_history': 'Historique des commandes',
      'order_number': 'Numéro de commande',
      'order_date': 'Date de commande',
      'order_status': 'Statut',
      'order_details': 'Détails de la commande',
      'status_pending': 'En attente',
      'status_paid': 'Payée',
      'status_processing': 'En traitement',
      'status_shipped': 'Expédiée',
      'status_delivered': 'Livrée',
      'status_cancelled': 'Annulée',

      // Profile
      'profile': 'Profil',
      'my_profile': 'Mon profil',
      'edit_profile': 'Modifier le profil',
      'personal_info': 'Informations personnelles',
      'settings': 'Paramètres',
      'language': 'Langue',
      'notifications': 'Notifications',
      'help': 'Aide',
      'about': 'À propos',

      // Home
      'home': 'Accueil',
      'featured_products': 'Produits en vedette',
      'shop_by_category': 'Acheter par catégorie',
      'view_all': 'Voir tout',

      // Validation
      'field_required': 'Ce champ est requis',
      'invalid_email': 'Email invalide',
      'password_too_short': 'Le mot de passe est trop court',
      'passwords_dont_match': 'Les mots de passe ne correspondent pas',

      // Messages
      'items': 'articles',
      'item': 'article',
    },
    'mg': {
      // Common
      'app_name': 'HansEco',
      'welcome': 'Tongasoa',
      'loading': 'Am-pamakiana...',
      'error': 'Tsy fetezana',
      'retry': 'Avereno',
      'cancel': 'Aoka ihany',
      'confirm': 'Hamafiso',
      'save': 'Tehirizo',
      'delete': 'Fafao',
      'search': 'Karohy',
      'filter': 'Sivana',

      // Auth
      'login': 'Hiditra',
      'register': 'Hisoratra anarana',
      'logout': 'Hivoaka',
      'email': 'Email',
      'password': 'Teny miafina',
      'forgot_password': 'Adino ny teny miafina?',
      'dont_have_account': 'Tsy manana kaonty?',
      'already_have_account': 'Efa manana kaonty?',
      'sign_in': 'Midira',
      'sign_up': 'Misoratra anarana',
      'full_name': 'Anarana feno',
      'phone_number': 'Laharana finday',

      // Products
      'products': 'Vokatra',
      'all_products': 'Vokatra rehetra',
      'categories': 'Sokajy',
      'new_arrivals': 'Vaovao',
      'best_sellers': 'Malaza indrindra',
      'product_details': 'Antsipirian\'ny vokatra',
      'price': 'Vidiny',
      'in_stock': 'Misy',
      'out_of_stock': 'Tsy misy',
      'add_to_cart': 'Apetraho ao anaty harona',
      'buy_now': 'Vidio izao',

      // Cart
      'cart': 'Harona',
      'my_cart': 'Ny haronako',
      'cart_empty': 'Foana ny haronanao',
      'cart_empty_message': 'Ampidiro vokatra mba hanohy',
      'browse_products': 'Jereo ny vokatra',
      'subtotal': 'Isa farany',
      'total': 'Totalin\'ny',
      'clear_cart': 'Fafao ny harona',
      'clear_cart_message': 'Marina ve fa hofafanao ny haronanao?',
      'item_removed': 'Nesorina tao amin\'ny harona',
      'cart_cleared': 'Voafafa ny harona',
      'quantity': 'Isa',

      // Checkout & Payment
      'checkout': 'Fandoavam-bola',
      'proceed_to_checkout': 'Mandoava vola',
      'delivery_address': 'Adiresy fanaterana',
      'enter_address': 'Soraty ny adiresinao',
      'delivery_fee': 'Saran\'ny fanaterana',
      'order_summary': 'Famintinana',
      'payment_method': 'Fomba fandoavam-bola',
      'select_payment_method': 'Safidio ny fomba fandoavam-bola',
      'confirm_payment': 'Hamafiso ny fandoavam-bola',
      'payment_processing': 'Eo am-pandoavam-bola...',
      'payment_success': 'Vita ny fandoavam-bola',
      'payment_failed': 'Tsy nahomby ny fandoavam-bola',
      'mvola': 'MVola',
      'airtel_money': 'Airtel Money',
      'orange_money': 'Orange Money',
      'paypal': 'PayPal',
      'credit_card': 'Karatra bankily',

      // Orders
      'orders': 'Baiko',
      'my_orders': 'Ny baikoko',
      'order_history': 'Tantaran\'ny baiko',
      'order_number': 'Laharan\'ny baiko',
      'order_date': 'Daty',
      'order_status': 'Sata',
      'order_details': 'Antsipirian\'ny baiko',
      'status_pending': 'Miandry',
      'status_paid': 'Voaloa',
      'status_processing': 'Eo am-pifanarahana',
      'status_shipped': 'Nalefa',
      'status_delivered': 'Tonga',
      'status_cancelled': 'Nofoanana',

      // Profile
      'profile': 'Mombamomba',
      'my_profile': 'Ny mombamombako',
      'edit_profile': 'Hanova ny mombamomba',
      'personal_info': 'Antsipirian\'ny tena',
      'settings': 'Fandrindrana',
      'language': 'Fiteny',
      'notifications': 'Fampandrenesana',
      'help': 'Fanampiana',
      'about': 'Momba',

      // Home
      'home': 'Fandraisana',
      'featured_products': 'Vokatra voafantina',
      'shop_by_category': 'Mividiana araka ny sokajy',
      'view_all': 'Jereo daholo',

      // Validation
      'field_required': 'Ilaina ity saha ity',
      'invalid_email': 'Email tsy marina',
      'password_too_short': 'Fohy loatra ny teny miafina',
      'passwords_dont_match': 'Tsy mitovy ny teny miafina',

      // Messages
      'items': 'zavatra',
      'item': 'zavatra',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  // Common
  String get appName => translate('app_name');
  String get welcome => translate('welcome');
  String get loading => translate('loading');
  String get error => translate('error');
  String get retry => translate('retry');
  String get cancel => translate('cancel');
  String get confirm => translate('confirm');
  String get save => translate('save');
  String get delete => translate('delete');
  String get search => translate('search');
  String get filter => translate('filter');

  // Auth
  String get login => translate('login');
  String get register => translate('register');
  String get logout => translate('logout');
  String get email => translate('email');
  String get password => translate('password');
  String get forgotPassword => translate('forgot_password');
  String get dontHaveAccount => translate('dont_have_account');
  String get alreadyHaveAccount => translate('already_have_account');
  String get signIn => translate('sign_in');
  String get signUp => translate('sign_up');
  String get fullName => translate('full_name');
  String get phoneNumber => translate('phone_number');

  // Products
  String get products => translate('products');
  String get allProducts => translate('all_products');
  String get categories => translate('categories');
  String get newArrivals => translate('new_arrivals');
  String get bestSellers => translate('best_sellers');
  String get productDetails => translate('product_details');
  String get price => translate('price');
  String get inStock => translate('in_stock');
  String get outOfStock => translate('out_of_stock');
  String get addToCart => translate('add_to_cart');
  String get buyNow => translate('buy_now');

  // Cart
  String get cart => translate('cart');
  String get myCart => translate('my_cart');
  String get cartEmpty => translate('cart_empty');
  String get cartEmptyMessage => translate('cart_empty_message');
  String get browseProducts => translate('browse_products');
  String get subtotal => translate('subtotal');
  String get total => translate('total');
  String get clearCart => translate('clear_cart');
  String get clearCartMessage => translate('clear_cart_message');
  String get itemRemoved => translate('item_removed');
  String get cartCleared => translate('cart_cleared');
  String get quantity => translate('quantity');

  // Checkout & Payment
  String get checkout => translate('checkout');
  String get proceedToCheckout => translate('proceed_to_checkout');
  String get deliveryAddress => translate('delivery_address');
  String get enterAddress => translate('enter_address');
  String get deliveryFee => translate('delivery_fee');
  String get orderSummary => translate('order_summary');
  String get paymentMethod => translate('payment_method');
  String get selectPaymentMethod => translate('select_payment_method');
  String get confirmPayment => translate('confirm_payment');
  String get paymentProcessing => translate('payment_processing');
  String get paymentSuccess => translate('payment_success');
  String get paymentFailed => translate('payment_failed');
  String get mvola => translate('mvola');
  String get airtelMoney => translate('airtel_money');
  String get orangeMoney => translate('orange_money');
  String get paypal => translate('paypal');
  String get creditCard => translate('credit_card');

  // Orders
  String get orders => translate('orders');
  String get myOrders => translate('my_orders');
  String get orderHistory => translate('order_history');
  String get orderNumber => translate('order_number');
  String get orderDate => translate('order_date');
  String get orderStatus => translate('order_status');
  String get orderDetails => translate('order_details');
  String get statusPending => translate('status_pending');
  String get statusPaid => translate('status_paid');
  String get statusProcessing => translate('status_processing');
  String get statusShipped => translate('status_shipped');
  String get statusDelivered => translate('status_delivered');
  String get statusCancelled => translate('status_cancelled');

  // Profile
  String get profile => translate('profile');
  String get myProfile => translate('my_profile');
  String get editProfile => translate('edit_profile');
  String get personalInfo => translate('personal_info');
  String get settings => translate('settings');
  String get language => translate('language');
  String get notifications => translate('notifications');
  String get help => translate('help');
  String get about => translate('about');

  // Home
  String get home => translate('home');
  String get featuredProducts => translate('featured_products');
  String get shopByCategory => translate('shop_by_category');
  String get viewAll => translate('view_all');

  // Validation
  String get fieldRequired => translate('field_required');
  String get invalidEmail => translate('invalid_email');
  String get passwordTooShort => translate('password_too_short');
  String get passwordsDontMatch => translate('passwords_dont_match');

  // Messages
  String get items => translate('items');
  String get item => translate('item');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['fr', 'mg'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
