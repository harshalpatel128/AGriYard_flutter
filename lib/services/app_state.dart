import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/yard_model.dart';
import '../models/crop_model.dart';
import '../models/shop_model.dart';
import '../models/user_model.dart';
import '../data/mock_data.dart';
import '../resources/resources.dart';

// Global app state and mock data management
class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal() {
    _initData();
  }

  bool _isLoggedIn = true;
  bool _isAdminMode = false;
  String _selectedDate = AppConstants.defaultSelectedDate;
  String _searchQuery = '';
  
  // Filter settings
  String _sortBy = AppConstants.defaultSortBy;
  Set<String> _selectedYardsFilter = Set.from(AppConstants.defaultYardFilter);

  UserModel _currentUser = UserModel(
    id: AppConstants.defaultUserId,
    name: AppConstants.defaultUserName,
    phoneNumber: AppConstants.defaultUserPhone,
    email: AppConstants.defaultUserEmail,
  );

  List<YardModel> _yards = [];
  List<CropRate> _crops = [];
  List<ShopModel> _shops = [];
  List<UserModel> _users = [];
  final List<String> _alerts = List.from(AppConstants.defaultAlerts);

  bool get isLoggedIn => _isLoggedIn;
  bool get isAdminMode => _isAdminMode;
  String get selectedDate => _selectedDate;
  String get searchQuery => _searchQuery;
  String get sortBy => _sortBy;
  Set<String> get selectedYardsFilter => _selectedYardsFilter;
  UserModel get currentUser => _currentUser;

  List<YardModel> get yards => List.unmodifiable(_yards);
  List<CropRate> get crops => List.unmodifiable(_crops);
  List<ShopModel> get shops => List.unmodifiable(_shops);
  List<UserModel> get users => List.unmodifiable(_users);
  List<String> get alerts => List.unmodifiable(_alerts);

  int get totalUsersCount => AppConstants.baseUserCount + _users.length - 3;
  int get activeYardsCount =>
      _yards.length > 4 ? _yards.length : AppConstants.minActiveYardsCount;

  void _initData() {
    _yards = MockData.getYards();
    _crops = MockData.getCrops();
    _shops = MockData.getShops();
    _users = MockData.getUsers();
    _loadFromPreferences();
  }

  Future<void> _loadFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isLoggedIn = prefs.getBool(AppConstants.prefIsLoggedIn) ?? true;
      _isAdminMode = prefs.getBool(AppConstants.prefIsAdminMode) ?? false;
      final savedName = prefs.getString(AppConstants.prefUserName);
      if (savedName != null && savedName.isNotEmpty) {
        _currentUser = UserModel(
          id: AppConstants.defaultUserId,
          name: savedName,
          phoneNumber: prefs.getString(AppConstants.prefUserPhone) ??
              AppConstants.defaultUserPhone,
          email: prefs.getString(AppConstants.prefUserEmail) ??
              AppConstants.defaultUserEmail,
        );
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _saveAuthToPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.prefIsLoggedIn, _isLoggedIn);
      await prefs.setBool(AppConstants.prefIsAdminMode, _isAdminMode);
      await prefs.setString(AppConstants.prefUserName, _currentUser.name);
      await prefs.setString(AppConstants.prefUserPhone, _currentUser.phoneNumber);
      await prefs.setString(AppConstants.prefUserEmail, _currentUser.email);
    } catch (_) {}
  }

  void setAdminMode(bool admin) {
    _isAdminMode = admin;
    _saveAuthToPreferences();
    notifyListeners();
  }

  void setSelectedDate(String date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilterSort({required String sortBy, required Set<String> yards}) {
    _sortBy = sortBy;
    _selectedYardsFilter = Set.from(yards);
    notifyListeners();
  }

  void clearFilters() {
    _sortBy = AppConstants.defaultSortBy;
    _selectedYardsFilter = Set.from(AppConstants.defaultYardFilter);
    notifyListeners();
  }

  void login({required String email, required String password}) {
    _isLoggedIn = true;
    _saveAuthToPreferences();
    notifyListeners();
  }

  void signup({required String name, required String phone, required String email, required String password}) {
    _isLoggedIn = true;
    _currentUser = UserModel(
      id: 'user_',
      name: name,
      phoneNumber: phone,
      email: email,
    );
    _saveAuthToPreferences();
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _isAdminMode = false;
    _saveAuthToPreferences();
    notifyListeners();
  }

  void logoutAdmin() {
    _isAdminMode = false;
    _saveAuthToPreferences();
    notifyListeners();
  }

  void toggleFavoriteYard(String yardId) {
    final idx = _yards.indexWhere((y) => y.id == yardId);
    if (idx != -1) {
      _yards[idx].isFavorite = !_yards[idx].isFavorite;
      notifyListeners();
    }
  }

  void toggleFavoriteCrop(String cropId) {
    final idx = _crops.indexWhere((c) => c.id == cropId);
    if (idx != -1) {
      _crops[idx].isFavorite = !_crops[idx].isFavorite;
      notifyListeners();
    }
  }

  void updateCropPrice({
    required String cropId,
    int? arrival,
    int? minPrice,
    int? avgPrice,
    int? maxPrice,
  }) {
    final idx = _crops.indexWhere((c) => c.id == cropId);
    if (idx != -1) {
      final current = _crops[idx];
      final newMin = minPrice ?? current.minPrice;
      final newAvg = avgPrice ?? current.avgPrice;
      final newMax = maxPrice ?? current.maxPrice;
      final newArrival = arrival ?? current.arrivalBags;
      final newQuantity = newArrival * 20;

      // recalculate rise/fall
      final oldAvg = current.avgPrice;
      final diff = newAvg - oldAvg;
      final pct = oldAvg > 0 ? (diff.abs() / oldAvg) * 100 : 0.0;

      _crops[idx] = current.copyWith(
        arrivalBags: newArrival,
        totalQuantityKg: newQuantity,
        minPrice: newMin,
        avgPrice: newAvg,
        maxPrice: newMax,
        changeAmount: diff,
        changePercentage: double.parse(pct.toStringAsFixed(2)),
        isRise: diff >= 0,
        lastUpdated: '$_selectedDate, 08:30 AM',
      );
      notifyListeners();
    }
  }

  void addYard(YardModel yard) {
    _yards.add(yard);
    notifyListeners();
  }

  void updateYard(YardModel updated) {
    final idx = _yards.indexWhere((y) => y.id == updated.id);
    if (idx != -1) {
      _yards[idx] = updated;
      notifyListeners();
    }
  }

  void deleteYard(String yardId) {
    _yards.removeWhere((y) => y.id == yardId);
    notifyListeners();
  }

  void addShop(ShopModel shop) {
    _shops.add(shop);
    notifyListeners();
  }

  void deleteShop(String shopId) {
    _shops.removeWhere((s) => s.id == shopId);
    notifyListeners();
  }

  void sendPushAlert(String message) {
    if (message.trim().isNotEmpty) {
      _alerts.insert(0, message.trim());
      notifyListeners();
    }
  }

  void toggleUserBlock(String userId) {
    final idx = _users.indexWhere((u) => u.id == userId);
    if (idx != -1) {
      _users[idx].isBlocked = !_users[idx].isBlocked;
      _users[idx].isActive = !_users[idx].isBlocked;
      notifyListeners();
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final cleaned = phoneNumber.replaceAll(' ', '');
    final uri = Uri.parse('tel:$cleaned');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (_) {}
  }

  Future<void> sendEmail(String email) async {
    final uri = Uri.parse('mailto:$email');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (_) {}
  }
}
