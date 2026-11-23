import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/yard_model.dart';
import '../models/crop_model.dart';
import '../models/shop_model.dart';
import '../models/user_model.dart';
import '../data/mock_data.dart';
import '../resources/resources.dart';

// Global app state, Firebase Firestore sync and data management
class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal() {
    _initData();
  }

  static const String superAdminEmail = 'hdobariya343@rku.ac.in';
  final Set<String> _adminEmails = {superAdminEmail};
  final Map<String, String> _adminPasswords = {};

  bool _isLoggedIn = true;
  bool _isAdminMode = false;
  bool _isAdminPreviewMode = false;
  String _selectedDate = AppConstants.defaultSelectedDate;
  String _selectedYardId = 'rajkot';
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
  bool get isAdminPreviewMode => _isAdminPreviewMode;
  bool get canSwitchToAdmin => _isAdminMode || _isAdminPreviewMode || isAdminEmail(_currentUser.email);
  String get selectedDate => _selectedDate;
  String get selectedYardId => _selectedYardId;
  String get searchQuery => _searchQuery;
  String get sortBy => _sortBy;
  Set<String> get selectedYardsFilter => _selectedYardsFilter;
  UserModel get currentUser => _currentUser;
  List<String> get adminEmails => _adminEmails.toList();

  void setAdminPreviewMode(bool value) {
    _isAdminPreviewMode = value;
    notifyListeners();
  }

  bool verifyAdminPassword(String email, String password) {
    final clean = email.trim().toLowerCase();
    if (!isAdminEmail(clean)) return false;
    final stored = _adminPasswords[clean];
    if (stored != null && stored.isNotEmpty) {
      return stored == password;
    }
    // If no custom password was set yet, allow any non-empty password for authorized admins
    return password.isNotEmpty;
  }

  List<YardModel> get yards => List.unmodifiable(_yards);
  List<CropRate> get crops => List.unmodifiable(_crops);
  List<ShopModel> get shops => List.unmodifiable(_shops);
  List<UserModel> get users => List.unmodifiable(_users);
  List<String> get alerts => List.unmodifiable(_alerts);

  YardModel get currentYard {
    return _yards.firstWhere(
      (y) => y.id == _selectedYardId,
      orElse: () => _yards.isNotEmpty ? _yards.first : MockData.getYards().first,
    );
  }

  void selectYard(String yardId) {
    if (_selectedYardId != yardId) {
      _selectedYardId = yardId;
      notifyListeners();
    }
  }

  List<CropRate> get cropsForSelectedYard => getCropsForYard(_selectedYardId);

  List<CropRate> getCropsForYard(String yardId) {
    final list = _crops.where((c) => c.yardId == yardId).toList();
    if (list.isNotEmpty) return list;
    return _crops
        .where((c) => c.yardId == 'rajkot')
        .map((c) => c.copyWith(
              id: '${yardId}_${c.name.toLowerCase()}',
              yardId: yardId,
            ))
        .toList();
  }

  List<CropRate> getRiseCropsForYard(String yardId) {
    final list = getCropsForYard(yardId).where((c) => c.isRise).toList();
    list.sort((a, b) => b.changePercentage.compareTo(a.changePercentage));
    return list;
  }

  List<CropRate> getFallCropsForYard(String yardId) {
    final list = getCropsForYard(yardId).where((c) => !c.isRise).toList();
    list.sort((a, b) => b.changePercentage.compareTo(a.changePercentage));
    return list;
  }

  List<ShopModel> get shopsForSelectedYard => getShopsForYard(_selectedYardId);

  List<ShopModel> getShopsForYard(String yardId) {
    return _shops.where((s) => s.yardId == yardId).toList();
  }

  int get totalUsersCount => AppConstants.baseUserCount + _users.length - 3;
  int get activeYardsCount =>
      _yards.length > 4 ? _yards.length : AppConstants.minActiveYardsCount;

  bool isAdminEmail(String? email) {
    if (email == null) return false;
    final clean = email.trim().toLowerCase();
    return clean == superAdminEmail.toLowerCase() || _adminEmails.contains(clean);
  }

  void _initData() {
    _yards = MockData.getYards();
    _crops = MockData.getCrops();
    _shops = MockData.getShops();
    _users = MockData.getUsers();
    _loadFromPreferences();
    _syncWithFirebase();
  }

  // Sync and real-time listeners with Firebase Firestore
  Future<void> _syncWithFirebase() async {
    try {
      final firestore = FirebaseFirestore.instance;

      // 1. Sync Admins
      try {
        await firestore.collection('admins').doc(superAdminEmail.toLowerCase()).set({
          'email': superAdminEmail.toLowerCase(),
          'role': 'super_admin',
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } catch (e) {
        debugPrint('Firestore super admin write: $e');
      }

      firestore.collection('admins').snapshots().listen((snap) {
        for (var doc in snap.docs) {
          final data = doc.data();
          final email = (data['email'] ?? doc.id).toString().trim().toLowerCase();
          if (email.isNotEmpty && email.contains('@')) {
            _adminEmails.add(email);
          }
        }
        _saveAdminsToPreferences();
        notifyListeners();
      }, onError: (e) {
        debugPrint('Firestore admins snapshot error: $e');
      });

      // 2. Sync Crops
      firestore.collection('crops').snapshots().listen((snap) {
        if (snap.docs.isEmpty) {
          // Seed mock crops into Firestore
          for (var c in _crops) {
            firestore.collection('crops').doc(c.id).set({
              'id': c.id,
              'yardId': c.yardId,
              'name': c.name,
              'gujaratiName': c.gujaratiName,
              'imageAsset': c.imageAsset,
              'arrivalBags': c.arrivalBags,
              'totalQuantityKg': c.totalQuantityKg,
              'minPrice': c.minPrice,
              'avgPrice': c.avgPrice,
              'maxPrice': c.maxPrice,
              'changeAmount': c.changeAmount,
              'changePercentage': c.changePercentage,
              'isRise': c.isRise,
              'lastUpdated': c.lastUpdated,
              'priceUnit': c.priceUnit,
            });
          }
        } else {
          final List<CropRate> remoteCrops = [];
          for (var doc in snap.docs) {
            final data = doc.data();
            remoteCrops.add(CropRate(
              id: data['id'] ?? doc.id,
              yardId: data['yardId'] ?? 'rajkot',
              name: data['name'] ?? '',
              gujaratiName: data['gujaratiName'] ?? '',
              imageAsset: data['imageAsset'] ?? 'assets/images/crop_wheat.png',
              arrivalBags: (data['arrivalBags'] as num?)?.toInt() ?? 500,
              totalQuantityKg: (data['totalQuantityKg'] as num?)?.toInt() ?? 10000,
              minPrice: (data['minPrice'] as num?)?.toInt() ?? 500,
              avgPrice: (data['avgPrice'] as num?)?.toInt() ?? 600,
              maxPrice: (data['maxPrice'] as num?)?.toInt() ?? 700,
              changeAmount: (data['changeAmount'] as num?)?.toInt() ?? 0,
              changePercentage: (data['changePercentage'] as num?)?.toDouble() ?? 0.0,
              isRise: data['isRise'] ?? true,
              lastUpdated: data['lastUpdated'] ?? '$_selectedDate, 08:30 AM',
              priceUnit: data['priceUnit'] ?? '20 Kg',
              history: [],
            ));
          }
          if (remoteCrops.isNotEmpty) {
            _crops = remoteCrops;
            notifyListeners();
          }
        }
      }, onError: (_) {});

      // 3. Sync Yards
      firestore.collection('yards').snapshots().listen((snap) {
        if (snap.docs.isEmpty) {
          for (var y in _yards) {
            firestore.collection('yards').doc(y.id).set({
              'id': y.id,
              'name': y.name,
              'city': y.city,
              'address': y.address,
              'contactNumber': y.contactNumber,
              'totalShops': y.totalShops,
              'establishedYear': y.establishedYear,
              'imageAsset': y.imageAsset,
            });
          }
        } else {
          final List<YardModel> remoteYards = [];
          for (var doc in snap.docs) {
            final data = doc.data();
            remoteYards.add(YardModel(
              id: data['id'] ?? doc.id,
              name: data['name'] ?? '',
              city: data['city'] ?? '',
              address: data['address'] ?? '',
              contactNumber: data['contactNumber'] ?? '',
              totalShops: data['totalShops'] ?? '',
              establishedYear: data['establishedYear'] ?? '2000',
              imageAsset: data['imageAsset'] ?? 'assets/images/yard_rajkot.png',
            ));
          }
          if (remoteYards.isNotEmpty) {
            _yards = remoteYards;
            notifyListeners();
          }
        }
      }, onError: (_) {});

      // 4. Sync Shops
      firestore.collection('shops').snapshots().listen((snap) {
        if (snap.docs.isEmpty) {
          for (var s in _shops) {
            firestore.collection('shops').doc(s.id).set({
              'id': s.id,
              'number': s.number,
              'name': s.name,
              'phoneNumber': s.phoneNumber,
              'yardId': s.yardId,
            });
          }
        } else {
          final List<ShopModel> remoteShops = [];
          for (var doc in snap.docs) {
            final data = doc.data();
            remoteShops.add(ShopModel(
              id: data['id'] ?? doc.id,
              number: (data['number'] as num?)?.toInt() ?? 1,
              name: data['name'] ?? '',
              phoneNumber: data['phoneNumber'] ?? '',
              yardId: data['yardId'] ?? 'rajkot',
            ));
          }
          if (remoteShops.isNotEmpty) {
            _shops = remoteShops;
            notifyListeners();
          }
        }
      }, onError: (_) {});

      // 5. Sync Alerts
      firestore.collection('alerts').orderBy('createdAt', descending: true).snapshots().listen((snap) {
        if (snap.docs.isNotEmpty) {
          _alerts.clear();
          for (var doc in snap.docs) {
            final msg = doc.data()['message']?.toString();
            if (msg != null && msg.isNotEmpty) {
              _alerts.add(msg);
            }
          }
          notifyListeners();
        }
      }, onError: (_) {});

      // 6. Sync Registered Users
      firestore.collection('users').snapshots().listen((snap) {
        if (snap.docs.isNotEmpty) {
          final List<UserModel> remoteUsers = [];
          for (var doc in snap.docs) {
            final data = doc.data();
            remoteUsers.add(UserModel(
              id: data['uid'] ?? doc.id,
              name: data['name'] ?? 'User',
              phoneNumber: data['phone'] ?? '',
              email: data['email'] ?? '',
            ));
          }
          if (remoteUsers.isNotEmpty) {
            _users = remoteUsers;
            notifyListeners();
          }
        }
      }, onError: (_) {});
    } catch (_) {}
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
      final savedAdmins = prefs.getStringList('saved_admin_emails');
      if (savedAdmins != null) {
        for (var e in savedAdmins) {
          final c = e.trim().toLowerCase();
          if (c.isNotEmpty) _adminEmails.add(c);
        }
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _saveAdminsToPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('saved_admin_emails', _adminEmails.toList());
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
    if (isAdminEmail(email)) {
      _isAdminMode = true;
    }
    _currentUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: email.split('@').first,
      phoneNumber: '9876543210',
      email: email,
    );
    _saveAuthToPreferences();
    notifyListeners();
  }

  void signup({required String name, required String phone, required String email, required String password}) {
    _isLoggedIn = true;
    if (isAdminEmail(email)) {
      _isAdminMode = true;
    }
    _currentUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
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

  // ── Admin Management ──────────────────────────────────────────────────────────
  Future<bool> addAdmin(String email) async {
    final clean = email.trim().toLowerCase();
    if (clean.isEmpty) return false;

    _adminEmails.add(clean);
    await _saveAdminsToPreferences();
    notifyListeners();

    try {
      final firestore = FirebaseFirestore.instance;
      // Write document with clean email as ID
      await firestore.collection('admins').doc(clean).set({
        'email': clean,
        'role': 'admin',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Also ensure super admin exists in Firestore
      await firestore.collection('admins').doc(superAdminEmail.toLowerCase()).set({
        'email': superAdminEmail.toLowerCase(),
        'role': 'super_admin',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('Admin $clean successfully stored in Firebase collection "admins"');
      return true;
    } catch (e) {
      debugPrint('Firebase addAdmin error: $e');
      return false;
    }
  }

  Future<bool> removeAdmin(String email) async {
    final clean = email.trim().toLowerCase();
    if (clean == superAdminEmail.toLowerCase()) return false;

    _adminEmails.remove(clean);
    await _saveAdminsToPreferences();
    notifyListeners();

    try {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('admins').doc(clean).delete();
      if (clean.contains('.')) {
        await firestore.collection('admins').doc(clean.replaceAll('.', '_')).delete();
      }
      debugPrint('Admin $clean removed from Firebase collection "admins"');
      return true;
    } catch (e) {
      debugPrint('Firebase removeAdmin error: $e');
      return false;
    }
  }

  // ── Crop Operations ───────────────────────────────────────────────────────────
  Future<void> addCrop(CropRate crop) async {
    _crops.add(crop);
    notifyListeners();
    try {
      await FirebaseFirestore.instance.collection('crops').doc(crop.id).set({
        'id': crop.id,
        'yardId': crop.yardId,
        'name': crop.name,
        'gujaratiName': crop.gujaratiName,
        'imageAsset': crop.imageAsset,
        'arrivalBags': crop.arrivalBags,
        'totalQuantityKg': crop.totalQuantityKg,
        'minPrice': crop.minPrice,
        'avgPrice': crop.avgPrice,
        'maxPrice': crop.maxPrice,
        'changeAmount': crop.changeAmount,
        'changePercentage': crop.changePercentage,
        'isRise': crop.isRise,
        'lastUpdated': crop.lastUpdated,
        'priceUnit': crop.priceUnit,
      });
    } catch (_) {}
  }

  Future<void> updateCrop(CropRate updated) async {
    final idx = _crops.indexWhere((c) => c.id == updated.id);
    if (idx != -1) {
      _crops[idx] = updated;
      notifyListeners();
      try {
        await FirebaseFirestore.instance.collection('crops').doc(updated.id).update({
          'yardId': updated.yardId,
          'name': updated.name,
          'gujaratiName': updated.gujaratiName,
          'arrivalBags': updated.arrivalBags,
          'minPrice': updated.minPrice,
          'avgPrice': updated.avgPrice,
          'maxPrice': updated.maxPrice,
          'changeAmount': updated.changeAmount,
          'changePercentage': updated.changePercentage,
          'isRise': updated.isRise,
          'lastUpdated': updated.lastUpdated,
        });
      } catch (_) {}
    }
  }

  Future<void> deleteCrop(String cropId) async {
    _crops.removeWhere((c) => c.id == cropId);
    notifyListeners();
    try {
      await FirebaseFirestore.instance.collection('crops').doc(cropId).delete();
    } catch (_) {}
  }

  void updateCropPrice({
    required String cropId,
    String? yardId,
    int? arrival,
    int? minPrice,
    int? avgPrice,
    int? maxPrice,
  }) {
    final targetYard = yardId ?? _selectedYardId;
    var idx = _crops.indexWhere((c) =>
        (c.id == cropId || c.id == '${targetYard}_$cropId' || c.name.toLowerCase() == cropId.toLowerCase()) &&
        c.yardId == targetYard);
    if (idx == -1) {
      idx = _crops.indexWhere((c) => c.id == cropId);
    }
    if (idx != -1) {
      final current = _crops[idx];
      final newMin = minPrice ?? current.minPrice;
      final newAvg = avgPrice ?? current.avgPrice;
      final newMax = maxPrice ?? current.maxPrice;
      final newArrival = arrival ?? current.arrivalBags;
      final newQuantity = newArrival * 20;

      final oldAvg = current.avgPrice;
      final diff = newAvg - oldAvg;
      final pct = oldAvg > 0 ? (diff.abs() / oldAvg) * 100 : 0.0;

      final updated = current.copyWith(
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
      _crops[idx] = updated;
      notifyListeners();

      try {
        FirebaseFirestore.instance.collection('crops').doc(current.id).update({
          'arrivalBags': newArrival,
          'totalQuantityKg': newQuantity,
          'minPrice': newMin,
          'avgPrice': newAvg,
          'maxPrice': newMax,
          'changeAmount': diff,
          'changePercentage': double.parse(pct.toStringAsFixed(2)),
          'isRise': diff >= 0,
          'lastUpdated': updated.lastUpdated,
        });
      } catch (_) {}
    }
  }

  // ── Yard Operations ───────────────────────────────────────────────────────────
  Future<void> addYard(YardModel yard) async {
    _yards.add(yard);
    notifyListeners();
    try {
      await FirebaseFirestore.instance.collection('yards').doc(yard.id).set({
        'id': yard.id,
        'name': yard.name,
        'city': yard.city,
        'address': yard.address,
        'contactNumber': yard.contactNumber,
        'totalShops': yard.totalShops,
        'establishedYear': yard.establishedYear,
        'imageAsset': yard.imageAsset,
      });
    } catch (_) {}
  }

  Future<void> updateYard(YardModel updated) async {
    final idx = _yards.indexWhere((y) => y.id == updated.id);
    if (idx != -1) {
      _yards[idx] = updated;
      notifyListeners();
      try {
        await FirebaseFirestore.instance.collection('yards').doc(updated.id).update({
          'name': updated.name,
          'city': updated.city,
          'address': updated.address,
          'contactNumber': updated.contactNumber,
          'totalShops': updated.totalShops,
        });
      } catch (_) {}
    }
  }

  Future<void> deleteYard(String yardId) async {
    _yards.removeWhere((y) => y.id == yardId);
    notifyListeners();
    try {
      await FirebaseFirestore.instance.collection('yards').doc(yardId).delete();
    } catch (_) {}
  }

  // ── Shop Operations ───────────────────────────────────────────────────────────
  Future<void> addShop(ShopModel shop) async {
    _shops.add(shop);
    notifyListeners();
    try {
      await FirebaseFirestore.instance.collection('shops').doc(shop.id).set({
        'id': shop.id,
        'number': shop.number,
        'name': shop.name,
        'phoneNumber': shop.phoneNumber,
        'yardId': shop.yardId,
      });
    } catch (_) {}
  }

  Future<void> updateShop(ShopModel updated) async {
    final idx = _shops.indexWhere((s) => s.id == updated.id);
    if (idx != -1) {
      _shops[idx] = updated;
      notifyListeners();
      try {
        await FirebaseFirestore.instance.collection('shops').doc(updated.id).update({
          'number': updated.number,
          'name': updated.name,
          'phoneNumber': updated.phoneNumber,
          'yardId': updated.yardId,
        });
      } catch (_) {}
    }
  }

  Future<void> deleteShop(String shopId) async {
    _shops.removeWhere((s) => s.id == shopId);
    notifyListeners();
    try {
      await FirebaseFirestore.instance.collection('shops').doc(shopId).delete();
    } catch (_) {}
  }

  // ── Push Alerts ───────────────────────────────────────────────────────────────
  Future<void> sendPushAlert(String message) async {
    if (message.trim().isNotEmpty) {
      _alerts.insert(0, message.trim());
      notifyListeners();
      try {
        await FirebaseFirestore.instance.collection('alerts').add({
          'message': message.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      } catch (_) {}
    }
  }

  void toggleUserBlock(String userId) {
    final idx = _users.indexWhere((u) => u.id == userId);
    if (idx != -1) {
      _users[idx].isBlocked = !_users[idx].isBlocked;
      _users[idx].isActive = !_users[idx].isBlocked;
      notifyListeners();
      try {
        FirebaseFirestore.instance.collection('users').doc(userId).update({
          'isBlocked': _users[idx].isBlocked,
        });
      } catch (_) {}
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

