import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agriyard/screens/home/search_results_screen.dart';
import 'package:agriyard/screens/yards/yard_detail_screen.dart';
import 'package:agriyard/screens/market/crop_detail_screen.dart';
import 'package:agriyard/screens/profile/change_password_screen.dart';
import 'package:agriyard/screens/profile/contact_help_screen.dart';
import 'package:agriyard/screens/admin/admin_navigation_screen.dart';
import 'package:agriyard/services/app_state.dart';

void main() {
  testWidgets('1. Search Results & Filter Screen', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: SearchResultsScreen(initialQuery: 'Garlic')));
    await tester.pumpAndSettle();
    expect(find.text('Results for "Garlic"'), findsOneWidget);
    expect(find.text('Garlic (Lasan)'), findsWidgets);
    expect(find.text('Rajkot Marketing Yard'), findsWidgets);
    expect(find.text('₹1020'), findsOneWidget);

    // Open Filter & Sort
    await tester.tap(find.byIcon(Icons.tune_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Filter & Sort'), findsOneWidget);
    expect(find.text('Price: High to Low'), findsOneWidget);
    expect(find.text('Apply Filters'), findsOneWidget);
    await tester.tap(find.text('Apply Filters'));
    await tester.pumpAndSettle();
  });

  testWidgets('2. Yard Detail Screen', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final yard = AppState().yards.first;
    await tester.pumpWidget(MaterialApp(home: YardDetailScreen(yard: yard)));
    await tester.pumpAndSettle();
    expect(find.text('Rajkot Marketing Yard'), findsOneWidget);
    expect(find.text('150ft Ring Road, Rajkot, Gujarat 360005'), findsOneWidget);
    expect(find.text('0281 2456789'), findsOneWidget);
    expect(find.text('250+ Shops'), findsOneWidget);
    expect(find.text('1985'), findsOneWidget);
    expect(find.text("Today's Rates"), findsOneWidget);
    expect(find.text('Shop List'), findsOneWidget);
  });

  testWidgets('3. Crop Detail & Chart Screen', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final crop = AppState().crops.first;
    await tester.pumpWidget(MaterialApp(home: CropDetailScreen(crop: crop)));
    await tester.pumpAndSettle();
    expect(find.text('Wheat (Ghau)'), findsOneWidget);
    expect(find.text("Today's Summary (20 Kg)"), findsOneWidget);
    expect(find.text('980 Bags'), findsOneWidget);
    expect(find.text('₹620'), findsOneWidget);
    expect(find.text('₹670'), findsOneWidget);
    expect(find.text('₹720'), findsOneWidget);
    expect(find.text('Previous 7 Days Prices (20 Kg)'), findsOneWidget);

    // Navigate to CropHistoryChartScreen
    await tester.tap(find.text('View 7-Day Price Chart & Analytics →'));
    await tester.pumpAndSettle();
    expect(find.text('Wheat (Ghau) - Last 7 Days'), findsOneWidget);
    expect(find.text('Min Price'), findsOneWidget);
    expect(find.text('Avg Price'), findsOneWidget);
    expect(find.text('Max Price'), findsOneWidget);
  });

  testWidgets('4. Profile, Password & Help Screens', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: ChangePasswordScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Change Password'), findsOneWidget);
    expect(find.text('Save Changes'), findsOneWidget);

    await tester.pumpWidget(const MaterialApp(home: ContactHelpScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Contact & Help'), findsOneWidget);
    expect(find.text('Helpline Number'), findsOneWidget);
    expect(find.text('+919624042246'), findsOneWidget);
    expect(find.text('support@agriyard.com'), findsOneWidget);
    expect(find.text('Frequently Asked Questions'), findsOneWidget);
    expect(find.text('Send Feedback'), findsOneWidget);
  });

  testWidgets('5. Admin Navigation & Operations Suite', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: AdminNavigationScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Dashboard'), findsWidgets);
    expect(find.text('Total Users'), findsOneWidget);
    expect(find.text('Quick Price Update'), findsOneWidget);

    // Test Quick Price Update in Admin
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump();
    expect(find.text('Market prices updated successfully!'), findsOneWidget);

    // Switch to Manage tab
    await tester.tap(find.text('Manage'));
    await tester.pumpAndSettle();
    expect(find.text('Manage Data'), findsOneWidget);
    expect(find.text('Yards'), findsOneWidget);
    expect(find.text('Crops'), findsOneWidget);
    expect(find.text('Shops'), findsOneWidget);

    // Switch to Users tab
    await tester.tap(find.text('Users'));
    await tester.pumpAndSettle();
    expect(find.text('Users & Alerts'), findsOneWidget);
    expect(find.text('Send Push Notification'), findsOneWidget);
    expect(find.text('Ramesh Patel'), findsOneWidget);
    expect(find.text('Active'), findsWidgets);

    // Switch to Settings tab
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Change Admin Password'), findsOneWidget);
    expect(find.text('Update Helpline Number'), findsOneWidget);
    expect(find.text('Force App Update / Version'), findsOneWidget);
    expect(find.text('Logout from Admin'), findsOneWidget);
  });
}
