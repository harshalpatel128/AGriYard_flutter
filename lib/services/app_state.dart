import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/yard_model.dart';
import '../models/crop_model.dart';
import '../models/shop_model.dart';
import '../models/user_model.dart';
import '../data/mock_data.dart';

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal() {
    _initData();
  }

  bool _isLoggedIn = true;
  bool _isAdminMode = false;
  String _selectedDate = '21 May 2025';
  String _searchQuery = '';
  
  // Filter settings
  String _sortBy = 'Price: High to Low'; // 'Price: High to Low', 'Price: Low to High', 'Latest Updated First'
  Set<String> _selectedYardsFilter = {'rajkot', 'junagadh'};

  UserModel _currentUser = UserModel(
    id: 'current_user',
    name: 'Harshal Dobariya',
    phoneNumber: '+91 98765 43210',
    email: 'harshal.dobariya@example.com',
  );

  List<YardModel> _yards = [];
  List<CropRate> _crops = [];
  List<ShopModel> _shops = [];
  List<UserModel> _users = [];
  final List<String> _alerts = [
    'Welcome to AgriYard! Daily market rates updated.',
    'Rajkot APMC: Wheat arrivals increased today.',
  ];

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

  int get totalUsersCount => 14520 + _users.length - 3;
  int get activeYardsCount => _yards.length > 4 ? _yards.length : 24;

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
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? true;
      _isAdminMode = prefs.getBool('isAdminMode') ?? false;
      final savedName = prefs.getString('userName');
      if (savedName != null && savedName.isNotEmpty) {
        _currentUser = UserModel(
          id: 'current_user',
          name: savedName,
          phoneNumber: prefs.getString('userPhone') ?? '+91 98765 43210',
          email: prefs.getString('userEmail') ?? 'harshal.dobariya@example.com',
        );
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _saveAuthToPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', _isLoggedIn);
      await prefs.setBool('isAdminMode', _isAdminMode);
      await prefs.setString('userName', _currentUser.name);
      await prefs.setString('userPhone', _currentUser.phoneNumber);
      await prefs.setString('userEmail', _currentUser.email);
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
    _sortBy = 'Price: High to Low';
    _selectedYardsFilter = {'rajkot', 'junagadh'};
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

  void addCrop(CropRate crop) {
    _crops.add(crop);
    notifyListeners();
  }

  void deleteCrop(String cropId) {
    _crops.removeWhere((c) => c.id == cropId);
    notifyListeners();
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
