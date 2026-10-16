/// Centralized app-wide constants for AgriYard
/// Route names, durations, limits, and other config values
class AppConstants {
  AppConstants._();

  // ── Named Routes ────────────────────────────────────────────────────────────
  static const String routeSplash = '/';
  static const String routeOnboarding = '/onboarding';
  static const String routeLogin = '/login';
  static const String routeSignup = '/signup';
  static const String routeForgotPassword = '/forgot_password';
  static const String routeMain = '/main';
  static const String routeAdmin = '/admin';

  // ── Durations ───────────────────────────────────────────────────────────────
  static const Duration splashDuration = Duration(milliseconds: 2500);
  static const Duration snackBarDuration = Duration(seconds: 3);
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // ── Date Defaults ───────────────────────────────────────────────────────────
  static const String defaultSelectedDate = '21 May 2025';
  static const List<String> monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  // ── Filter Defaults ─────────────────────────────────────────────────────────
  static const String defaultSortBy = 'Price: High to Low';
  static const List<String> sortOptions = [
    'Price: High to Low',
    'Price: Low to High',
    'Latest Updated First',
  ];
  static const Set<String> defaultYardFilter = {'rajkot', 'junagadh'};

  // ── User Defaults ───────────────────────────────────────────────────────────
  static const String defaultUserName = 'Harshal Dobariya';
  static const String defaultUserPhone = '+91 98765 43210';
  static const String defaultUserEmail = 'harshal.dobariya@example.com';
  static const String defaultUserId = 'current_user';

  // ── Admin Credentials (demo only) ───────────────────────────────────────────
  static const String adminDemoEmail = 'admin@agriyard.com';
  static const String adminDemoPassword = 'admin123';

  // ── Shared Preferences Keys ─────────────────────────────────────────────────
  static const String prefIsLoggedIn = 'isLoggedIn';
  static const String prefIsAdminMode = 'isAdminMode';
  static const String prefUserName = 'userName';
  static const String prefUserPhone = 'userPhone';
  static const String prefUserEmail = 'userEmail';

  // ── Stats ───────────────────────────────────────────────────────────────────
  static const int baseUserCount = 14520;
  static const int minActiveYardsCount = 24;

  // ── Limits ──────────────────────────────────────────────────────────────────
  static const int homeYardsGridCount = 4;
  static const int passwordMinLength = 6;
  static const int mobileMinLength = 10;

  // ── Price / Quantity Constants ───────────────────────────────────────────────
  static const int kgPerBag = 20;
  static const String currencySymbol = '₹';
  static const String weightUnit = 'Kg';
  static const String arrivalUnit = 'Bags';

  // ── Social Contact ──────────────────────────────────────────────────────────
  static const String supportPhone = '+91 9876543210';
  static const String supportEmail = 'support@agriyard.com';
  static const String supportAddress = 'AgriYard HQ, Rajkot, Gujarat 360001';

  // ── Default Alerts ──────────────────────────────────────────────────────────
  static const List<String> defaultAlerts = [
    'Welcome to AgriYard! Daily market rates updated.',
    'Rajkot APMC: Wheat arrivals increased today.',
  ];
}
