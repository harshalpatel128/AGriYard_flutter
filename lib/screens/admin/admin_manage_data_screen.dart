import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../services/app_state.dart';
import '../../models/yard_model.dart';
import '../../models/crop_model.dart';
import '../../models/shop_model.dart';
import '../../widgets/custom_button.dart';

class AdminManageDataScreen extends StatefulWidget {
  const AdminManageDataScreen({super.key});

  @override
  State<AdminManageDataScreen> createState() => _AdminManageDataScreenState();
}

class _AdminManageDataScreenState extends State<AdminManageDataScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  void _showAddCropDialog(BuildContext context, [CropRate? existing]) {
    final nameController = TextEditingController(text: existing?.name ?? '');
    final gujController = TextEditingController(text: existing?.gujaratiName ?? '');
    final minController = TextEditingController(text: existing != null ? existing.minPrice.toString() : '500');
    final avgController = TextEditingController(text: existing != null ? existing.avgPrice.toString() : '650');
    final maxController = TextEditingController(text: existing != null ? existing.maxPrice.toString() : '800');
    final arrivalController = TextEditingController(text: existing != null ? existing.arrivalBags.toString() : '500');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(existing == null ? 'Add New Crop' : 'Edit Crop Price & Info', style: const TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (existing == null) ...[
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Crop Name (English)')),
                const SizedBox(height: 10),
                TextField(controller: gujController, decoration: const InputDecoration(labelText: 'Crop Name (Gujarati)')),
                const SizedBox(height: 10),
              ],
              TextField(controller: minController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Min Price (₹ / 20 Kg)')),
              const SizedBox(height: 10),
              TextField(controller: avgController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Avg Price (₹ / 20 Kg)')),
              const SizedBox(height: 10),
              TextField(controller: maxController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Max Price (₹ / 20 Kg)')),
              const SizedBox(height: 10),
              TextField(controller: arrivalController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Arrival Bags')),
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
              final min = int.tryParse(minController.text.trim()) ?? 0;
              final avg = int.tryParse(avgController.text.trim()) ?? 0;
              final max = int.tryParse(maxController.text.trim()) ?? 0;
              final arr = int.tryParse(arrivalController.text.trim()) ?? 0;
              if (existing != null) {
                AppState().updateCropPrice(
                  cropId: existing.id,
                  minPrice: min,
                  avgPrice: avg,
                  maxPrice: max,
                  arrival: arr,
                );
              } else if (nameController.text.trim().isNotEmpty) {
                final newCrop = CropRate(
                  id: 'crop_${DateTime.now().millisecondsSinceEpoch}',
                  name: nameController.text.trim(),
                  gujaratiName: gujController.text.trim().isNotEmpty ? gujController.text.trim() : nameController.text.trim(),
                  imageAsset: 'assets/images/crop_wheat.png',
                  arrivalBags: arr > 0 ? arr : 300,
                  totalQuantityKg: (arr > 0 ? arr : 300) * 20,
                  minPrice: min > 0 ? min : 500,
                  avgPrice: avg > 0 ? avg : 600,
                  maxPrice: max > 0 ? max : 700,
                  changeAmount: 10,
                  changePercentage: 1.5,
                  isRise: true,
                  lastUpdated: '${AppState().selectedDate}, 08:30 AM',
                  history: const [],
                );
                AppState().addCrop(newCrop);
              }
              Navigator.pop(ctx);
            },
            child: Text(existing == null ? 'Add' : 'Save', style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddShopDialog(BuildContext context, [ShopModel? existing]) {
    final numController = TextEditingController(text: existing != null ? existing.number.toString() : '101');
    final nameController = TextEditingController(text: existing?.name ?? '');
    final phoneController = TextEditingController(text: existing?.phoneNumber ?? '0281 2450000');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(existing == null ? 'Add New Shop' : 'Edit Shop', style: const TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: numController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Shop Number (e.g. 101)')),
              const SizedBox(height: 10),
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Shop / Firm Name')),
              const SizedBox(height: 10),
              TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone Number')),
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
                final shopNum = int.tryParse(numController.text.trim()) ?? (existing?.number ?? 101);
                if (existing == null) {
                  final newShop = ShopModel(
                    id: 'shop_${DateTime.now().millisecondsSinceEpoch}',
                    name: nameController.text.trim(),
                    number: shopNum,
                    phoneNumber: phoneController.text.trim(),
                    yardId: 'rajkot',
                  );
                  AppState().addShop(newShop);
                } else {
                  AppState().deleteShop(existing.id);
                  final updated = ShopModel(
                    id: existing.id,
                    name: nameController.text.trim(),
                    number: shopNum,
                    phoneNumber: phoneController.text.trim(),
                    yardId: existing.yardId,
                  );
                  AppState().addShop(updated);
                }
              }
              Navigator.pop(ctx);
            },
            child: Text(existing == null ? 'Add' : 'Save', style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddYardDialog(BuildContext context, [YardModel? existing]) {
    final nameController = TextEditingController(text: existing?.name ?? '');
    final cityController = TextEditingController(text: existing?.city ?? '');
    final shopsController = TextEditingController(text: existing?.totalShops ?? '100+ Shops');
    final phoneController = TextEditingController(text: existing?.contactNumber ?? '0281 2400000');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(existing == null ? 'Add New Yard' : 'Edit Yard', style: const TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Yard Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(labelText: 'City / District'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: shopsController,
                decoration: const InputDecoration(labelText: 'Total Shops'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Contact Phone'),
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
                if (existing == null) {
                  final newYard = YardModel(
                    id: 'yard_${DateTime.now().millisecondsSinceEpoch}',
                    name: nameController.text.trim(),
                    city: cityController.text.trim(),
                    address: '${cityController.text.trim()} Main Road, Gujarat',
                    contactNumber: phoneController.text.trim(),
                    totalShops: shopsController.text.trim(),
                    establishedYear: '2000',
                    imageAsset: 'assets/images/yard_rajkot.png',
                  );
                  AppState().addYard(newYard);
                } else {
                  final updated = existing.copyWith(
                    name: nameController.text.trim(),
                    city: cityController.text.trim(),
                    totalShops: shopsController.text.trim(),
                    contactNumber: phoneController.text.trim(),
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
            Navigator.pop(context);
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
        actions: const [
          Padding(
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
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            // Yards Tab
            _buildYardsTab(),
            // Crops Tab
            _buildCropsTab(),
            // Shops Tab
            _buildShopsTab(),
          ],
        ),
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
              // + Add New Yard Button
              CustomPrimaryButton(
                text: '+ Add New Yard',
                onPressed: () => _showAddYardDialog(context),
              ),
              const SizedBox(height: 20),

              // Yards List
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
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Building Icon
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.domain_rounded, color: AppColors.textMedium, size: 22),
                        ),
                        const SizedBox(width: 14),
                        // Title & Shops
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
                        // Edit Icon
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: AppColors.primaryGreen, size: 22),
                          onPressed: () => _showAddYardDialog(context, yard),
                        ),
                        // Delete Icon
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
        final crops = AppState().crops;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              CustomPrimaryButton(
                text: '+ Add New Crop',
                onPressed: () => _showAddCropDialog(context),
              ),
              const SizedBox(height: 20),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: crops.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final crop = crops[index];
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
                              Text(crop.displayName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              Text('Avg: ₹${crop.avgPrice} • ${crop.arrivalBags} Bags', style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
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
        final shops = AppState().shops;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              CustomPrimaryButton(
                text: '+ Add New Shop',
                onPressed: () => _showAddShopDialog(context),
              ),
              const SizedBox(height: 20),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: shops.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final shop = shops[index];
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
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.storefront_rounded, color: AppColors.textMedium, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(shop.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              Text('${shop.number} • ${shop.phoneNumber}', style: const TextStyle(fontSize: 12, color: AppColors.textMedium)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: AppColors.primaryGreen, size: 22),
                          onPressed: () => _showAddShopDialog(context, shop),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: AppColors.priceFallRed, size: 22),
                          onPressed: () => AppState().deleteShop(shop.id),
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
}
