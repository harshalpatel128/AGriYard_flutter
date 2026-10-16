/// App-wide string constants for AgriYard
/// Centralizes all text content to avoid hardcoded strings
class AppStrings {
  AppStrings._();

  // App Identity
  static const String appName = 'AgriYard';
  static const String appTagline = 'Daily Market Rates at Your Fingertips';
  static const String appSubtitle = 'Your smart partner for agricultural market updates';
  static const String appVersion = 'v1.0.0';

  // Developer / Student Info
  static const String developerName = 'Payal';
  static const String projectTitle = 'Agricultural Yard Management System';
  static const String projectSubject = 'Flutter Mobile Application Development';
  static const String collegeName = 'Gujarat University';
  static const String academicYear = '2024-25';

  // Splash Screen
  static const String splashLoading = 'Loading...';
  static const String splashSubtitle = 'Preparing the best market data for you';

  // Onboarding
  static const String onboardingWelcome = 'Welcome to';
  static const String onboardingGetStarted = 'Get Started';
  static const String feature1Title = 'Daily Market Rates';
  static const String feature1Subtitle = 'Get latest crop prices from all yards';
  static const String feature2Title = 'Price Rise & Price Fall';
  static const String feature2Subtitle = 'Track market movements daily';
  static const String feature3Title = 'Trusted Shop Directory';
  static const String feature3Subtitle = 'Find reliable shop contacts near you';

  // Auth - Login
  static const String loginTitle = 'Welcome Back!';
  static const String loginSubtitle = 'Login to your AgriYard account';
  static const String loginBtn = 'Login';
  static const String loginWithGoogle = 'Continue with Google';
  static const String loginWithApple = 'Continue with Apple';
  static const String orContinueWith = 'or continue with';
  static const String noAccountText = "Don't have an account? ";
  static const String signUpLink = 'Sign Up';
  static const String forgotPassword = 'Forgot Password?';
  static const String adminLabel = 'Admin';

  // Auth - Signup
  static const String signupTitle = 'Create Account';
  static const String signupSubtitle = 'Fill in the details to get started';
  static const String signupBtn = 'Create Account';
  static const String alreadyAccountText = 'Already have an account? ';
  static const String loginLink = 'Login';

  // Auth - Forgot Password
  static const String forgotPasswordTitle = 'Forgot Password';
  static const String forgotPasswordSubtitle = 'Enter your registered email to reset password';
  static const String sendOtpBtn = 'Send OTP';
  static const String resetPasswordBtn = 'Reset Password';

  // Form Labels & Hints
  static const String labelEmail = 'Email';
  static const String hintEmail = 'Enter your email address';
  static const String labelPassword = 'Password';
  static const String hintPassword = 'Enter your password';
  static const String labelFullName = 'Full Name';
  static const String hintFullName = 'Enter your full name';
  static const String labelMobile = 'Mobile Number';
  static const String hintMobile = 'Enter your 10-digit mobile number';
  static const String labelConfirmPassword = 'Confirm Password';
  static const String hintConfirmPassword = 'Re-enter your password';
  static const String labelOtp = 'OTP Code';
  static const String hintOtp = 'Enter 6-digit OTP';
  static const String labelNewPassword = 'New Password';
  static const String hintNewPassword = 'Enter new password';

  // Validation Messages
  static const String validEmail = 'Please enter your email';
  static const String validInvalidEmail = 'Please enter a valid email';
  static const String validPassword = 'Please enter your password';
  static const String validPasswordLength = 'Password must be at least 6 characters';
  static const String validFullName = 'Please enter your full name';
  static const String validMobile = 'Please enter your mobile number';
  static const String validConfirmPassword = 'Please confirm your password';
  static const String validPasswordMatch = 'Passwords do not match';
  static const String validOtp = 'Please enter OTP';
  static const String validNewPassword = 'Please enter a new password';

  // Home Screen
  static const String homeGreeting = 'Good Morning! ☀️';
  static const String homeSubGreeting = "Check today's market rates";
  static const String homeSearchHint = 'Search yard or crop...';
  static const String homeMarketingYards = 'Marketing Yards';
  static const String homePriceRise = 'Price Rise';
  static const String homePriceRiseSubtitle = 'Top Gainers Today';
  static const String homePriceFall = 'Price Fall';
  static const String homePriceFallSubtitle = 'Top Losers Today';
  static const String homeGujaratSuffix = ', Gujarat';

  // Market Rates
  static const String marketRatesTitle = "Today's Market Rates";
  static const String marketRatesUnit = 'Prices are for 20 Kg';
  static const String marketRatesDisclaimer = '* Prices are subject to change';
  static const String marketViewDetails = 'View\nDetails';
  static const String marketArrival = 'Arrival';
  static const String marketMin = 'Min';
  static const String marketAvg = 'Avg';
  static const String marketMax = 'Max';

  // Price Rise / Fall
  static const String priceRiseTitle = 'Price Rise';
  static const String priceRiseSubtitle = 'Top Gainers Today';
  static const String priceFallTitle = 'Price Fall';
  static const String priceFallSubtitle = 'Top Losers Today';
  static const String priceFallDisclaimer = '* Prices are for 20 Kg';

  // Crop Detail
  static const String cropTotalArrival = 'Total Arrival';
  static const String cropTotalQuantity = 'Total Quantity';
  static const String cropMinPrice = 'Minimum Price';
  static const String cropAvgPrice = 'Average Price';
  static const String cropMaxPrice = 'Highest Price';
  static const String cropLastUpdated = 'Last Updated: ';
  static const String cropViewChart = 'View 7-Day Price Chart & Analytics →';
  static const String cropHistoryTitle = 'Previous 7 Days Prices';
  static const String cropTodaySummary = "Today's Summary";

  // Yard Detail
  static const String yardAddress = 'Address';
  static const String yardContact = 'Contact Number';
  static const String yardTotalShops = 'Total Shops';
  static const String yardEstablished = 'Established';
  static const String yardTodayRates = "Today's Rates";
  static const String yardShopList = 'Shop List';

  // Shop List
  static const String shopListTitle = 'Shop List';
  static const String shopSearchHint = 'Search shop name...';

  // Profile
  static const String profilePersonalInfo = 'Personal Information';
  static const String profileChangePassword = 'Change Password';
  static const String profileHelpSupport = 'Help & Support';
  static const String profileLogout = 'Logout';
  static const String profileLogoutConfirm = 'Are you sure you want to logout from AgriYard?';
  static const String profileLogoutTitle = 'Logout';
  static const String profileCancelBtn = 'Cancel';
  static const String profileRoleFarmer = 'Registered Farmer / Trader';
  static const String profileName = 'Name';
  static const String profileMobile = 'Mobile';
  static const String profileEmail = 'Email';
  static const String profileRole = 'Role';

  // Change Password
  static const String changePasswordTitle = 'Change Password';
  static const String changePasswordBtn = 'Update Password';

  // Contact / Help
  static const String contactTitle = 'Help & Support';
  static const String contactCallUs = 'Call Us';
  static const String contactEmailUs = 'Email Us';
  static const String contactAddress = 'Our Office';

  // Admin Panel
  static const String adminDashboard = 'Dashboard';
  static const String adminManageData = 'Manage Data';
  static const String adminUsers = 'Users & Alerts';
  static const String adminSettings = 'Settings';
  static const String adminLogout = 'Admin Logout';
  static const String adminPanel = 'Admin Panel';

  // Notifications
  static const String notificationsTitle = 'Notifications';
  static const String noNotifications = 'No new notifications today.';
  static const String closeBtn = 'Close';

  // Bottom Navigation
  static const String navHome = 'Home';
  static const String navRates = 'Rates';
  static const String navRise = 'Rise';
  static const String navFall = 'Fall';
  static const String navShops = 'Shops';
  static const String navProfile = 'Profile';

  // Drawer
  static const String drawerHome = 'Home';
  static const String drawerMarketRates = "Today's Market Rates";
  static const String drawerShopDirectory = 'Shop List';
  static const String drawerAdminPanel = 'Admin Panel';

  // Error / Empty States
  static const String errorNoData = 'No data available';
  static const String errorNoResults = 'No results found';
  static const String errorNoShops = 'No shops found';
  static const String errorGeneral = 'Something went wrong. Please try again.';

  // Misc
  static const String bags = 'Bags';
  static const String kg = 'Kg';
  static const String today = 'Today';
  static const String priceUnit = '₹ per 20 Kg';
  static const String okBtn = 'OK';
  static const String cancelBtn = 'Cancel';
}
