import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../services/app_state.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String _selectedYard = 'Rajkot Marketing Yard';
  final _wheatArrivalController = TextEditingController(text: '980');
  final _wheatMinController = TextEditingController(text: '620');
  final _wheatAvgController = TextEditingController(text: '670');
  final _wheatMaxController = TextEditingController(text: '720');

  final _soyaArrivalController = TextEditingController(text: '860');
  final _soyaMinController = TextEditingController(text: '600');
  final _soyaAvgController = TextEditingController(text: '650');
  final _soyaMaxController = TextEditingController(text: '700');

  @override
  void dispose() {
    _wheatArrivalController.dispose();
    _wheatMinController.dispose();
    _wheatAvgController.dispose();
    _wheatMaxController.dispose();
    _soyaArrivalController.dispose();
    _soyaMinController.dispose();
    _soyaAvgController.dispose();
    _soyaMaxController.dispose();
    super.dispose();
  }

  void _saveQuickUpdate() {
    AppState().updateCropPrice(
      cropId: 'wheat',
      arrival: int.tryParse(_wheatArrivalController.text),
      minPrice: int.tryParse(_wheatMinController.text),
      avgPrice: int.tryParse(_wheatAvgController.text),
      maxPrice: int.tryParse(_wheatMaxController.text),
    );

    AppState().updateCropPrice(
      cropId: 'soyabean',
      arrival: int.tryParse(_soyaArrivalController.text),
      minPrice: int.tryParse(_soyaMinController.text),
      avgPrice: int.tryParse(_soyaAvgController.text),
      maxPrice: int.tryParse(_soyaMaxController.text),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Market prices updated successfully!'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          'Dashboard',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: const AssetImage('assets/images/admin_avatar.png'),
              backgroundColor: AppColors.mintLight,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryGreen,
        onPressed: _saveQuickUpdate,
        child: const Icon(Icons.check, color: Colors.white, size: 28),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stat Cards (Total Users & Active Yards)
              ListenableBuilder(
                listenable: AppState(),
                builder: (context, _) {
                  return Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          title: 'Total Users',
                          value: '14,520',
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _buildMetricCard(
                          title: 'Active Yards',
                          value: '${AppState().activeYardsCount}',
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),

              // Section: Quick Price Update
              const Text(
                'Quick Price Update',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 16),

              // Select Yard Dropdown
              const Text('Select Yard', style: TextStyle(fontSize: 13, color: AppColors.textLight)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedYard,
                    items: [
                      'Rajkot Marketing Yard',
                      'Junagadh Marketing Yard',
                      'Gondal Marketing Yard',
                      'Mendarda Marketing Yard',
                    ].map((y) => DropdownMenuItem(value: y, child: Text(y, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedYard = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Date input
              const Text('Date', style: TextStyle(fontSize: 13, color: AppColors.textLight)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  '${AppState().selectedDate} (Today)',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
                ),
              ),
              const SizedBox(height: 20),

              // Wheat (Ghau) Inputs
              const Text(
                'Wheat (Ghau)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildSmallField('Arrival:', _wheatArrivalController),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSmallField('Min ₹:', _wheatMinController),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildSmallField('Avg ₹:', _wheatAvgController),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSmallField('Max ₹:', _wheatMaxController),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Soyabean Inputs
              const Text(
                'Soyabean',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildSmallField('Arrival:', _soyaArrivalController),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSmallField('Min ₹:', _soyaMinController),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildSmallField('Avg ₹:', _soyaAvgController),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSmallField('Max ₹:', _soyaMaxController),
                  ),
                ],
              ),

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard({required String title, required String value}) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, color: AppColors.textLight)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallField(String prefix, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Text(prefix, style: const TextStyle(fontSize: 13, color: AppColors.textLight)),
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
