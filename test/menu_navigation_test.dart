import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/main.dart';
import 'package:solo/screen/pages/menu.dart';
import 'package:solo/screen/pages/settings.dart';
import 'package:solo/screen/pages/about.dart';
import 'package:solo/screen/widgets/menu_card.dart';

void main() {
  group('Menu Navigation Tests', () {
    testWidgets('Menu page displays navigation cards correctly', (WidgetTester tester) async {
      // Build the app with Riverpod
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const MenuPage(),
          ),
        ),
      );

      // Verify menu header is displayed
      expect(find.text('メニュー'), findsOneWidget);
      expect(find.text('機能を選択してください'), findsOneWidget);

      // Verify navigation cards are present
      expect(find.text('Todo'), findsOneWidget);
      expect(find.text('タイマー'), findsOneWidget);
      expect(find.text('設定'), findsOneWidget);
      expect(find.text('このアプリについて'), findsOneWidget);

      // Verify app version is displayed
      expect(find.text('Solo v1.0.0'), findsOneWidget);

      // Verify the main menu icon
      expect(find.byIcon(Icons.dashboard_rounded), findsOneWidget);
    });

    testWidgets('MenuNavigationCard renders correctly', (WidgetTester tester) async {
      bool tapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MenuNavigationCard(
              title: 'Test Title',
              subtitle: 'Test Subtitle',
              icon: Icons.test_rounded,
              onTap: () => tapped = true,
              isHighlighted: true,
            ),
          ),
        ),
      );

      // Verify card content
      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Subtitle'), findsOneWidget);
      expect(find.byIcon(Icons.test_rounded), findsOneWidget);

      // Test tap functionality
      await tester.tap(find.byType(MenuNavigationCard));
      expect(tapped, isTrue);
    });

    testWidgets('Settings page displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const SettingsPage(),
          ),
        ),
      );

      // Verify settings page content
      expect(find.text('設定'), findsOneWidget);
      expect(find.text('設定機能'), findsOneWidget);
      expect(find.byIcon(Icons.settings_rounded), findsOneWidget);
    });

    testWidgets('About page displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const AboutPage(),
          ),
        ),
      );

      // Verify about page content
      expect(find.text('このアプリについて'), findsOneWidget);
      expect(find.text('Solo'), findsOneWidget);
      expect(find.text('バージョン 1.0.0'), findsOneWidget);
      expect(find.text('主な機能'), findsOneWidget);
      expect(find.byIcon(Icons.apps_rounded), findsOneWidget);
    });

    testWidgets('Menu cards have appropriate styling for highlighted items', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                MenuNavigationCard(
                  title: 'Highlighted',
                  subtitle: 'This is highlighted',
                  icon: Icons.star,
                  onTap: () {},
                  isHighlighted: true,
                ),
                MenuNavigationCard(
                  title: 'Regular',
                  subtitle: 'This is regular',
                  icon: Icons.circle,
                  onTap: () {},
                  isHighlighted: false,
                ),
              ],
            ),
          ),
        ),
      );

      // Both cards should be present
      expect(find.text('Highlighted'), findsOneWidget);
      expect(find.text('Regular'), findsOneWidget);
      
      // Both should be tappable
      expect(find.byType(MenuNavigationCard), findsNWidgets(2));
    });
  });
}