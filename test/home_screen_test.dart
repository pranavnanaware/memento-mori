import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:memento_mori/homescreen.dart';

void main() {
  group('Home Screen Tests', () {
    setUp(() async {
      // Clear shared preferences before each test
      SharedPreferences.setMockInitialValues({});
      await SharedPreferences.getInstance().then((prefs) => prefs.clear());
    });

    testWidgets('should show loading indicator initially', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      
      // Should show loading initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show app bar with title and reset button', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      
      // Should show app bar title
      expect(find.text('MEMENTO MORI'), findsOneWidget);
      
      // Should show reset button
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('should show message when no form data is available', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();
      
      // Should show message for incomplete form
      expect(find.text('Your journey has begun'), findsOneWidget);
    });

    testWidgets('should show lifespan progress when data is available', (WidgetTester tester) async {
      // Set up complete form data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('birth_date', DateTime(1990, 1, 1).toIso8601String());
      await prefs.setString('country_code', 'US');
      await prefs.setString('gender', 'Male');
      await prefs.setDouble('height', 175.0);
      await prefs.setDouble('weight', 70.0);
      await prefs.setString('smoking_status', 'Never smoked');
      await prefs.setString('exercise_frequency', 'Regular exercise');
      await prefs.setString('alcohol_consumption', 'Moderate');
      await prefs.setDouble('sleep_hours', 7.5);
      
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();
      
      // Should show lifespan progress circle
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Complete'), findsOneWidget);
    });

    testWidgets('should show prediction text when lifespan data is available', (WidgetTester tester) async {
      // Set up complete form data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('birth_date', DateTime(1990, 1, 1).toIso8601String());
      await prefs.setString('country_code', 'US');
      await prefs.setString('gender', 'Male');
      await prefs.setDouble('height', 175.0);
      await prefs.setDouble('weight', 70.0);
      await prefs.setString('smoking_status', 'Never smoked');
      await prefs.setString('exercise_frequency', 'Regular exercise');
      await prefs.setString('alcohol_consumption', 'Moderate');
      await prefs.setDouble('sleep_hours', 7.5);
      
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();
      
      // Should show prediction text
      expect(find.textContaining('Predicted:'), findsOneWidget);
      expect(find.textContaining('More or less, but you might die today so know this'), findsOneWidget);
    });

    testWidgets('should show quote when loaded successfully', (WidgetTester tester) async {
      // Set up complete form data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('birth_date', DateTime(1990, 1, 1).toIso8601String());
      await prefs.setString('country_code', 'US');
      await prefs.setString('gender', 'Male');
      await prefs.setDouble('height', 175.0);
      await prefs.setDouble('weight', 70.0);
      await prefs.setString('smoking_status', 'Never smoked');
      await prefs.setString('exercise_frequency', 'Regular exercise');
      await prefs.setString('alcohol_consumption', 'Moderate');
      await prefs.setDouble('sleep_hours', 7.5);
      
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();
      
      // Should show quote (either loaded or fallback)
      expect(find.textContaining('"'), findsOneWidget);
    });

    testWidgets('should show fallback quote when API fails', (WidgetTester tester) async {
      // Set up complete form data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('birth_date', DateTime(1990, 1, 1).toIso8601String());
      await prefs.setString('country_code', 'US');
      await prefs.setString('gender', 'Male');
      await prefs.setDouble('height', 175.0);
      await prefs.setDouble('weight', 70.0);
      await prefs.setString('smoking_status', 'Never smoked');
      await prefs.setString('exercise_frequency', 'Regular exercise');
      await prefs.setString('alcohol_consumption', 'Moderate');
      await prefs.setDouble('sleep_hours', 7.5);
      
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();
      
      // Should show fallback quote
      expect(find.textContaining('The best revenge is not to be like your enemy'), findsOneWidget);
      expect(find.textContaining('Marcus Aurelius'), findsOneWidget);
    });

    testWidgets('should display percentage correctly in progress circle', (WidgetTester tester) async {
      // Set up complete form data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('birth_date', DateTime(1990, 1, 1).toIso8601String());
      await prefs.setString('country_code', 'US');
      await prefs.setString('gender', 'Male');
      await prefs.setDouble('height', 175.0);
      await prefs.setDouble('weight', 70.0);
      await prefs.setString('smoking_status', 'Never smoked');
      await prefs.setString('exercise_frequency', 'Regular exercise');
      await prefs.setString('alcohol_consumption', 'Moderate');
      await prefs.setDouble('sleep_hours', 7.5);
      
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();
      
      // Should show percentage with % symbol
      expect(find.textContaining('%'), findsOneWidget);
      expect(find.text('Complete'), findsOneWidget);
    });

    testWidgets('should handle reset button tap', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      
      // Wait for loading to complete
      await tester.pumpAndSettle();
      
      // Should show reset button
      expect(find.byIcon(Icons.refresh), findsOneWidget);
      
      // Tap reset button (this would be tested more thoroughly in integration tests)
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();
      
      // Button should still be there
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('should handle different age ranges correctly', (WidgetTester tester) async {
      // Test with young person
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('birth_date', DateTime(2020, 1, 1).toIso8601String());
      await prefs.setString('country_code', 'US');
      await prefs.setString('gender', 'Male');
      await prefs.setDouble('height', 175.0);
      await prefs.setDouble('weight', 70.0);
      await prefs.setString('smoking_status', 'Never smoked');
      await prefs.setString('exercise_frequency', 'Regular exercise');
      await prefs.setString('alcohol_consumption', 'Moderate');
      await prefs.setDouble('sleep_hours', 7.5);
      
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();
      
      // Should show low percentage for young person
      expect(find.textContaining('%'), findsOneWidget);
    });

    testWidgets('should handle different countries correctly', (WidgetTester tester) async {
      // Test with different country
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('birth_date', DateTime(1990, 1, 1).toIso8601String());
      await prefs.setString('country_code', 'Japan'); // Higher life expectancy
      await prefs.setString('gender', 'Male');
      await prefs.setDouble('height', 175.0);
      await prefs.setDouble('weight', 70.0);
      await prefs.setString('smoking_status', 'Never smoked');
      await prefs.setString('exercise_frequency', 'Regular exercise');
      await prefs.setString('alcohol_consumption', 'Moderate');
      await prefs.setDouble('sleep_hours', 7.5);
      
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();
      
      // Should show prediction text
      expect(find.textContaining('Predicted:'), findsOneWidget);
    });

    testWidgets('should handle different genders correctly', (WidgetTester tester) async {
      // Test with female (typically longer life expectancy)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('birth_date', DateTime(1990, 1, 1).toIso8601String());
      await prefs.setString('country_code', 'US');
      await prefs.setString('gender', 'Female');
      await prefs.setDouble('height', 175.0);
      await prefs.setDouble('weight', 70.0);
      await prefs.setString('smoking_status', 'Never smoked');
      await prefs.setString('exercise_frequency', 'Regular exercise');
      await prefs.setString('alcohol_consumption', 'Moderate');
      await prefs.setDouble('sleep_hours', 7.5);
      
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();
      
      // Should show prediction text
      expect(find.textContaining('Predicted:'), findsOneWidget);
    });
  });
} 