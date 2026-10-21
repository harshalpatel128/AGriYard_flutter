// Global constants and configuration values for the app
class AppConstants {
  AppConstants._();

  // Navigation routes
  static const String routeSplash = '/';
  static const String routeOnboarding = '/onboarding';
  static const String routeLogin = '/login';
  static const String routeSignup = '/signup';
  static const String routeForgotPassword = '/forgot_password';
  static const String routeMain = '/main';
  static const String routeAdmin = '/admin';

  // Durations
  static const Duration splashDuration = Duration(milliseconds: 2500);
  static const Duration snackBarDuration = Duration(seconds: 3);
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Date values
  static const String defaultSelectedDate = '21 May 2025';
  static const List<String> monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  // Filter options
  static const String defaultSortBy = 'Price: High to Low';
  static const List<String> sortOptions = [
    'Price: High to Low',
    'Price: Low to High',
    'Latest Updated First',
  ];
  static const Set<String> defaultYardFilter = {'rajkot', 'junagadh'};

  // User defaults
  static const String defaultUserName = 'Harshal Dobariya';
  static const String defaultUserPhone = '+91 98765 43210';
  static const String defaultUserEmail = 'harshal.dobariya@example.com';
  static const String defaultUserId = 'current_user';

  // Demo admin credentials
  static const String adminDemoEmail = 'admin@agriyard.com';
  static const String adminDemoPassword = 'admin123';

  // Storage keys
  static const String prefIsLoggedIn = 'isLoggedIn';
  static const String prefIsAdminMode = 'isAdminMode';
  static const String prefUserName = 'userName';
  static const String prefUserPhone = 'userPhone';
  static const String prefUserEmail = 'userEmail';

  // Stats and limits
  static const int baseUserCount = 14520;
  static const int minActiveYardsCount = 24;
  static const int homeYardsGridCount = 4;
  static const int passwordMinLength = 6;
  static const int mobileMinLength = 10;

  // Units
  static const int kgPerBag = 20;
  static const String currencySymbol = '₹';
  static const String weightUnit = 'Kg';
  static const String arrivalUnit = 'Bags';

  // Support contact
  static const String supportPhone = '+91 9876543210';
  static const String supportEmail = 'support@agriyard.com';
  static const String supportAddress = 'AgriYard HQ, Rajkot, Gujarat 360001';

  // Sample alerts
  static const List<String> defaultAlerts = [
    'Welcome to AgriYard! Daily market rates updated.',
    'Rajkot APMC: Wheat arrivals increased today.',
  ];
}
