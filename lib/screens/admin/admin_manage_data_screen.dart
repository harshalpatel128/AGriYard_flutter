import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../services/app_state.dart';
import '../../models/yard_model.dart';
import '../../models/crop_model.dart';
import '../../models/shop_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/yard_selector_bar.dart';
import '../../widgets/yard_image_view.dart';
import '../auth/login_screen.dart';
import '../main_navigation_screen.dart';

class AdminManageDataScreen extends StatefulWidget {
  const AdminManageDataScreen({super.key});

  @override
  State<AdminManageDataScreen> createState() => _AdminManageDataScreenState();
}

class _AdminManageDataScreenState extends State<AdminManageDataScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _cropYardFilter = 'all';
  String _shopYardFilter = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── Yard Dialog ─────────────────────────────────────────────────────────────
  void _showAddYardDialog(BuildContext context, [YardModel? existing]) {
    final nameController = TextEditingController(text: existing?.name ?? '');
    final cityController = TextEditingController(text: existing?.city ?? '');
    final shopsController = TextEditingController(text: existing?.totalShops ?? '100+ Shops');
    final phoneController = TextEditingController(text: existing?.contactNumber ?? '0281 2400000');
    final imageController = TextEditingController(text: existing?.imageAsset ?? '');

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(existing == null ? 'Add New Yard' : 'Edit Yard', style: const TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Yard Name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: cityController,
                  decoration: const InputDecoration(labelText: 'City (e.g. Rajkot, Gondal)'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: shopsController,
                  decoration: const InputDecoration(labelText: 'Total Shops (e.g. 150+ Shops)'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Contact Phone'),
                ),
                const SizedBox(height: 14),
                const Text('Yard Photo / Image (Optional)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                const SizedBox(height: 4),
                TextField(
                  controller: imageController,
                  onChanged: (_) => setDialogState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Paste Image URL or leave empty for blank',
                    suffixIcon: imageController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              imageController.clear();
                              setDialogState(() {});
                            },
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    ActionChip(
                      label: const Text('Blank (No Image)', style: TextStyle(fontSize: 11)),
                      avatar: const Icon(Icons.image_not_supported_outlined, size: 14),
                      onPressed: () {
                        imageController.clear();
                        setDialogState(() {});
                      },
                    ),
                    ActionChip(
                      label: const Text('Rajkot photo', style: TextStyle(fontSize: 11)),
                      onPressed: () {
                        imageController.text = 'assets/images/yard_rajkot.png';
                        setDialogState(() {});
                      },
                    ),
                    ActionChip(
                      label: const Text('Gondal photo', style: TextStyle(fontSize: 11)),
                      onPressed: () {
                        imageController.text = 'assets/images/yard_gondal.png';
                        setDialogState(() {});
                      },
                    ),
                    ActionChip(
                      label: const Text('Junagadh photo', style: TextStyle(fontSize: 11)),
                      onPressed: () {
                        imageController.text = 'assets/images/yard_junagadh.png';
                        setDialogState(() {});
                      },
                    ),
                  ],
                ),
                if (imageController.text.trim().isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    height: 80,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: YardImageView(
                      imagePath: imageController.text.trim(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textMedium)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  final imgPath = imageController.text.trim();
                  if (existing == null) {
                    final newYard = YardModel(
                      id: 'yard_${DateTime.now().millisecondsSinceEpoch}',
                      name: nameController.text.trim(),
                      city: cityController.text.trim(),
                      address: '${cityController.text.trim()} Main Road, Gujarat',
                      contactNumber: phoneController.text.trim(),
                      totalShops: shopsController.text.trim(),
                      establishedYear: '2000',
                      imageAsset: imgPath,
                    );
                    AppState().addYard(newYard);
                  } else {
                    final updated = existing.copyWith(
                      name: nameController.text.trim(),
                      city: cityController.text.trim(),
                      totalShops: shopsController.text.trim(),
                      contactNumber: phoneController.text.trim(),
                      imageAsset: imgPath,
                    );
                    AppState().updateYard(updated);
                  }
                }
                Navigator.pop(ctx);
              },
              child: Text(existing == null ? 'Add' : 'Save', style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // ── Crop Dialog ─────────────────────────────────────────────────────────────
  void _showAddCropDialog(BuildContext context, [CropRate? existing]) {
    final nameController = TextEditingController(text: existing?.name ?? '');
    final gujController = TextEditingController(text: existing?.gujaratiName ?? '');
    final arrivalController = TextEditingController(text: existing != null ? '${existing.arrivalBags}' : '500');
    final minController = TextEditingController(text: existing != null ? '${existing.minPrice}' : '600');
    final avgController = TextEditingController(text: existing != null ? '${existing.avgPrice}' : '650');
    final maxController = TextEditingController(text: existing != null ? '${existing.maxPrice}' : '700');
    String selectedYardId = existing?.yardId ?? (_cropYardFilter != 'all' ? _cropYardFilter : (AppState().yards.isNotEmpty ? AppState().yards.first.id : 'rajkot'));

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(existing == null ? 'Add New Crop' : 'Edit Crop Prices', style: const TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('APMC Yard', style: TextStyle(fontSize: 12, color: AppColors.textLight)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedYardId,
                      items: AppState().yards.map((y) => DropdownMenuItem(
                        value: y.id,
                        child: Text(y.name, style: const TextStyle(fontSize: 14)),
                      )).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() => selectedYardId = val);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Crop Name (e.g. Cotton)'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: gujController,
                  decoration: const InputDecoration(labelText: 'Gujarati Name (e.g. Kapas)'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: arrivalController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Arrival Bags'),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: minController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Min ₹'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: avgController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Avg ₹'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: maxController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Max ₹'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textMedium)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  final minP = int.tryParse(minController.text) ?? 500;
                  final avgP = int.tryParse(avgController.text) ?? 600;
                  final maxP = int.tryParse(maxController.text) ?? 700;
                  final arrB = int.tryParse(arrivalController.text) ?? 500;

                  if (existing == null) {
                    final newCrop = CropRate(
                      id: '${selectedYardId}_${nameController.text.trim().toLowerCase().replaceAll(' ', '_')}',
                      yardId: selectedYardId,
                      name: nameController.text.trim(),
                      gujaratiName: gujController.text.trim(),
                      imageAsset: 'assets/images/crop_wheat.png',
                      arrivalBags: arrB,
                      totalQuantityKg: arrB * 20,
                      minPrice: minP,
                      avgPrice: avgP,
                      maxPrice: maxP,
                      changeAmount: 0,
                      changePercentage: 0.0,
                      isRise: true,
                      lastUpdated: '${AppState().selectedDate}, 08:30 AM',
                      priceUnit: '20 Kg',
                      history: [],
                    );
                    AppState().addCrop(newCrop);
                  } else {
                    final diff = avgP - existing.avgPrice;
                    final pct = existing.avgPrice > 0 ? (diff.abs() / existing.avgPrice) * 100 : 0.0;
                    final updated = existing.copyWith(
                      yardId: selectedYardId,
                      name: nameController.text.trim(),
                      gujaratiName: gujController.text.trim(),
                      arrivalBags: arrB,
                      totalQuantityKg: arrB * 20,
                      minPrice: minP,
                      avgPrice: avgP,
                      maxPrice: maxP,
                      changeAmount: diff,
                      changePercentage: double.parse(pct.toStringAsFixed(2)),
                      isRise: diff >= 0,
                    );
                    AppState().updateCrop(updated);
                  }
                }
                Navigator.pop(ctx);
              },
              child: Text(existing == null ? 'Add' : 'Save', style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // ── Shop Dialog ─────────────────────────────────────────────────────────────
  void _showAddShopDialog(BuildContext context, [ShopModel? existing]) {
    final numberController = TextEditingController(text: existing != null ? '${existing.number}' : '101');
    final nameController = TextEditingController(text: existing?.name ?? '');
    final phoneController = TextEditingController(text: existing?.phoneNumber ?? '98765 43210');
    String selectedYardId = existing?.yardId ?? (_shopYardFilter != 'all' ? _shopYardFilter : (AppState().yards.isNotEmpty ? AppState().yards.first.id : 'rajkot'));

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(existing == null ? 'Add New Shop' : 'Edit Shop', style: const TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: numberController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Shop / Stall Number'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Trader / Shop Name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: selectedYardId,
                  decoration: const InputDecoration(labelText: 'Market Yard'),
                  items: AppState().yards.map((y) {
                    return DropdownMenuItem(value: y.id, child: Text(y.name, overflow: TextOverflow.ellipsis));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() => selectedYardId = val);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textMedium)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  final numVal = int.tryParse(numberController.text) ?? 1;
                  if (existing == null) {
                    final newShop = ShopModel(
                      id: 'shop_${DateTime.now().millisecondsSinceEpoch}',
                      number: numVal,
                      name: nameController.text.trim(),
                      phoneNumber: phoneController.text.trim(),
                      yardId: selectedYardId,
                    );
                    AppState().addShop(newShop);
                  } else {
                    final updated = existing.copyWith(
                      number: numVal,
                      name: nameController.text.trim(),
                      phoneNumber: phoneController.text.trim(),
                      yardId: selectedYardId,
                    );
                    AppState().updateShop(updated);
                  }
                }
                Navigator.pop(ctx);
              },
              child: Text(existing == null ? 'Add' : 'Save', style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppColors.textDark),
          onPressed: () {
            AppState().setAdminMode(false);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          },
        ),
        title: const Text(
          'Manage Data',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              AppState().setAdminPreviewMode(true);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF7EE),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primaryGreen, width: 1.2),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.visibility_rounded, size: 16, color: AppColors.primaryGreen),
                  SizedBox(width: 4),
                  Text(
                    'User View',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/images/admin_avatar.png'),
              backgroundColor: AppColors.mintLight,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryGreen,
          indicatorWeight: 3,
          labelColor: AppColors.primaryGreen,
          unselectedLabelColor: AppColors.textMedium,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          tabs: const [
            Tab(text: 'Yards'),
            Tab(text: 'Crops'),
            Tab(text: 'Shops'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildYardsTab(),
          _buildCropsTab(),
          _buildShopsTab(),
        ],
      ),
    );
  }

  Widget _buildYardsTab() {
    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, _) {
        final yards = AppState().yards;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              CustomPrimaryButton(
                text: '+ Add New Yard',
                onPressed: () => _showAddYardDialog(context),
              ),
              const SizedBox(height: 20),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: yards.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final yard = yards[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Row(
                      children: [
                        YardImageView(
                          imagePath: yard.imageAsset,
                          width: 44,
                          height: 44,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                yard.name,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${yard.totalShops} • ${yard.city}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: AppColors.primaryGreen, size: 22),
                          onPressed: () => _showAddYardDialog(context, yard),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: AppColors.priceFallRed, size: 22),
                          onPressed: () => AppState().deleteYard(yard.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCropsTab() {
    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, _) {
        final crops = _cropYardFilter == 'all'
            ? AppState().crops
            : AppState().getCropsForYard(_cropYardFilter);

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              YardSelectorBar(
                showAllOption: true,
                selectedYardId: _cropYardFilter,
                onYardSelected: (id) {
                  setState(() {
                    _cropYardFilter = id;
                  });
                },
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CustomPrimaryButton(
                  text: '+ Add New Crop',
                  onPressed: () => _showAddCropDialog(context),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: crops.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final crop = crops[index];
                    final yardName = AppState().yards.firstWhere(
                      (y) => y.id == crop.yardId,
                      orElse: () => AppState().yards.first,
                    ).name;

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Row(
                        children: [
                          Image.asset(crop.imageAsset, width: 34, height: 34, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.eco, color: AppColors.primaryGreen)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(crop.displayName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.mintLight,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        yardName.replaceAll(' Marketing Yard', '').replaceAll(' APMC', ''),
                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '₹${crop.minPrice} - ₹${crop.maxPrice} (Avg ₹${crop.avgPrice})',
                                  style: const TextStyle(fontSize: 13, color: AppColors.primaryGreen, fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  'Arrival: ${crop.arrivalBags} Bags • ${crop.priceUnit}',
                                  style: const TextStyle(fontSize: 12, color: AppColors.textLight),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, color: AppColors.primaryGreen, size: 22),
                            onPressed: () => _showAddCropDialog(context, crop),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.priceFallRed, size: 22),
                            onPressed: () => AppState().deleteCrop(crop.id),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShopsTab() {
    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, _) {
        final shops = _shopYardFilter == 'all'
            ? AppState().shops
            : AppState().getShopsForYard(_shopYardFilter);

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              YardSelectorBar(
                showAllOption: true,
                selectedYardId: _shopYardFilter,
                onYardSelected: (id) {
                  setState(() {
                    _shopYardFilter = id;
                  });
                },
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CustomPrimaryButton(
                  text: '+ Add New Shop',
                  onPressed: () => _showAddShopDialog(context),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: shops.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final shop = shops[index];
                    final yardName = AppState().yards.firstWhere(
                      (y) => y.id == shop.yardId,
                      orElse: () => AppState().yards.first,
                    ).name;

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF7EE),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text('#${shop.number}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(shop.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                Text(shop.phoneNumber, style: const TextStyle(fontSize: 13, color: AppColors.textMedium)),
                                Text(yardName, style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, color: AppColors.primaryGreen, size: 20),
                            onPressed: () => _showAddShopDialog(context, shop),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: AppColors.priceFallRed, size: 20),
                            onPressed: () => AppState().deleteShop(shop.id),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
