import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agriyard/main.dart';
import 'package:agriyard/screens/main_navigation_screen.dart';

void main() {
  testWidgets('AgriYard main tabs navigation test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Directly test MainNavigationScreen
    await tester.pumpWidget(const MaterialApp(home: MainNavigationScreen()));
    await tester.pumpAndSettle();

    // Home Tab
    expect(find.text('Good Morning! ☀️'), findsOneWidget);
    expect(find.text('Marketing Yards'), findsOneWidget);
    expect(find.text('Rajkot'), findsOneWidget);

    // Rates Tab
    await tester.tap(find.byIcon(Icons.article_outlined));
    await tester.pumpAndSettle();
    expect(find.text("Today's Market Rates"), findsOneWidget);
    expect(find.text('Wheat (Ghau)'), findsOneWidget);

    // Rise Tab
    await tester.tap(find.byIcon(Icons.trending_up_rounded).first);
    await tester.pumpAndSettle();
    expect(find.text('Price Rise'), findsOneWidget);
    expect(find.text('Top Gainers Today'), findsOneWidget);

    // Fall Tab
    await tester.tap(find.byIcon(Icons.trending_down_rounded).first);
    await tester.pumpAndSettle();
    expect(find.text('Price Fall'), findsOneWidget);
    expect(find.text('Top Losers Today'), findsOneWidget);

    // Shops Tab
    await tester.tap(find.byIcon(Icons.storefront_outlined).first);
    await tester.pumpAndSettle();
    expect(find.text('Shop List'), findsOneWidget);
    expect(find.text('Ramdev Trading'), findsOneWidget);

    // Profile Tab
    await tester.tap(find.byIcon(Icons.person_outline_rounded).first);
    await tester.pumpAndSettle();
    expect(find.text('Harshal Dobariya'), findsOneWidget);
    expect(find.text('Personal Information'), findsOneWidget);
    expect(find.text('Change Password'), findsOneWidget);
    expect(find.text('Help & Support'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });
}
