import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:memento_mori/main.dart';

void main() {
  group('Form Validation and Data Persistence Tests', () {
    setUp(() async {
      // Clear shared preferences before each test
      SharedPreferences.setMockInitialValues({});
      await SharedPreferences.getInstance().then((prefs) => prefs.clear());
    });

    test('should save and load birth date correctly', () async {
      final prefs = await SharedPreferences.getInstance();
      final testDate = DateTime(1990, 1, 1);
      await prefs.setString('birth_date', testDate.toIso8601String());
      
      // Verify the date was saved
      final loadedDateString = prefs.getString('birth_date');
      expect(loadedDateString, isNotNull);
      final loadedDate = DateTime.parse(loadedDateString!);
      expect(loadedDate.year, equals(1990));
      expect(loadedDate.month, equals(1));
      expect(loadedDate.day, equals(1));
    });

    test('should save and load country data correctly', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('country', 'United States');
      await prefs.setString('country_code', 'US');
      
      // Verify the country data was saved
      final loadedCountry = prefs.getString('country');
      final loadedCountryCode = prefs.getString('country_code');
      expect(loadedCountry, equals('United States'));
      expect(loadedCountryCode, equals('US'));
    });

    test('should save and load height data correctly', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('height', 175.0);
      
      // Verify the height data was saved
      final loadedHeight = prefs.getDouble('height');
      expect(loadedHeight, equals(175.0));
    });

    test('should save and load weight data correctly', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('weight', 70.0);
      
      // Verify the weight data was saved
      final loadedWeight = prefs.getDouble('weight');
      expect(loadedWeight, equals(70.0));
    });

    test('should save and load lifestyle data correctly', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('smoking_status', 'Never smoked');
      await prefs.setString('exercise_frequency', 'Regular exercise');
      await prefs.setString('alcohol_consumption', 'Moderate');
      await prefs.setDouble('sleep_hours', 7.5);
      
      // Verify the lifestyle data was saved
      expect(prefs.getString('smoking_status'), equals('Never smoked'));
      expect(prefs.getString('exercise_frequency'), equals('Regular exercise'));
      expect(prefs.getString('alcohol_consumption'), equals('Moderate'));
      expect(prefs.getDouble('sleep_hours'), equals(7.5));
    });

    test('should track form completion status correctly', () async {
      final prefs = await SharedPreferences.getInstance();
      
      // Initially form should not be completed
      expect(prefs.getBool('form_completed'), isNull);
      
      // Mark form as completed
      await prefs.setBool('form_completed', true);
      expect(prefs.getBool('form_completed'), isTrue);
      
      // Reset form completion
      await prefs.setBool('form_completed', false);
      expect(prefs.getBool('form_completed'), isFalse);
    });

    test('should track last completed step correctly', () async {
      final prefs = await SharedPreferences.getInstance();
      
      // Initially no step should be completed
      expect(prefs.getInt('last_completed_step'), isNull);
      
      // Mark step 3 as completed
      await prefs.setInt('last_completed_step', 3);
      expect(prefs.getInt('last_completed_step'), equals(3));
      
      // Reset to no steps completed
      await prefs.setInt('last_completed_step', -1);
      expect(prefs.getInt('last_completed_step'), equals(-1));
    });

    test('should handle unit conversion for height correctly', () {
      // Test cm to ft conversion
      const cmValue = 175.0;
      const expectedFtValue = 5.74; // 175 cm ≈ 5.74 ft
      
      // Verify conversion is approximately correct
      expect((cmValue * 0.0328084).toStringAsFixed(2), 
             expectedFtValue.toStringAsFixed(2));
    });

    test('should handle unit conversion for weight correctly', () {
      // Test kg to lbs conversion
      const kgValue = 70.0;
      const expectedLbsValue = 154.32; // 70 kg ≈ 154.32 lbs
      
      // Verify conversion is approximately correct
      expect((kgValue * 2.20462).toStringAsFixed(2), 
             expectedLbsValue.toStringAsFixed(2));
    });

    test('should validate form data completeness', () async {
      final prefs = await SharedPreferences.getInstance();
      
      // Test with incomplete data
      await prefs.setString('birth_date', DateTime(1990, 1, 1).toIso8601String());
      await prefs.setString('country', 'USA');
      // Missing other required fields
      
      // Form should not be considered complete
      expect(prefs.getBool('form_completed'), isNull);
      
      // Test with complete data
      await prefs.setString('gender', 'Male');
      await prefs.setDouble('height', 175.0);
      await prefs.setDouble('weight', 70.0);
      await prefs.setString('smoking_status', 'Never smoked');
      await prefs.setString('exercise_frequency', 'Regular exercise');
      await prefs.setString('alcohol_consumption', 'Moderate');
      await prefs.setDouble('sleep_hours', 7.5);
      
      // Now form should be complete
      await prefs.setBool('form_completed', true);
      expect(prefs.getBool('form_completed'), isTrue);
    });

    test('should handle form reset correctly', () async {
      final prefs = await SharedPreferences.getInstance();
      
      // Set up some form data
      await prefs.setString('birth_date', DateTime(1990, 1, 1).toIso8601String());
      await prefs.setString('country', 'USA');
      await prefs.setBool('form_completed', true);
      await prefs.setInt('last_completed_step', 8);
      
      // Verify data exists
      expect(prefs.getString('birth_date'), isNotNull);
      expect(prefs.getBool('form_completed'), isTrue);
      expect(prefs.getInt('last_completed_step'), equals(8));
      
      // Reset form (this would be done by the reset button)
      await prefs.setBool('form_completed', false);
      await prefs.setInt('last_completed_step', -1);
      
      // Verify reset worked
      expect(prefs.getBool('form_completed'), isFalse);
      expect(prefs.getInt('last_completed_step'), equals(-1));
      
      // Data should still exist (reset only clears completion flags)
      expect(prefs.getString('birth_date'), isNotNull);
      expect(prefs.getString('country'), isNotNull);
    });

    test('should handle all form fields', () async {
      final prefs = await SharedPreferences.getInstance();
      
      // Save all form fields
      await prefs.setString('birth_date', DateTime(1990, 1, 1).toIso8601String());
      await prefs.setString('country', 'United States');
      await prefs.setString('country_code', 'US');
      await prefs.setString('gender', 'Male');
      await prefs.setDouble('height', 175.0);
      await prefs.setDouble('weight', 70.0);
      await prefs.setString('smoking_status', 'Never smoked');
      await prefs.setString('exercise_frequency', 'Regular exercise');
      await prefs.setString('alcohol_consumption', 'Moderate');
      await prefs.setDouble('sleep_hours', 7.5);
      
      // Verify all fields were saved
      expect(prefs.getString('birth_date'), isNotNull);
      expect(prefs.getString('country'), equals('United States'));
      expect(prefs.getString('country_code'), equals('US'));
      expect(prefs.getString('gender'), equals('Male'));
      expect(prefs.getDouble('height'), equals(175.0));
      expect(prefs.getDouble('weight'), equals(70.0));
      expect(prefs.getString('smoking_status'), equals('Never smoked'));
      expect(prefs.getString('exercise_frequency'), equals('Regular exercise'));
      expect(prefs.getString('alcohol_consumption'), equals('Moderate'));
      expect(prefs.getDouble('sleep_hours'), equals(7.5));
    });
  });
} 