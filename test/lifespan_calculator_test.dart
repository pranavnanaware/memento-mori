import 'package:flutter_test/flutter_test.dart';
import 'package:memento_mori/services/lifespan_calculator.dart';

void main() {
  group('LifespanCalculator Tests', () {
    test('should calculate lifespan for male in USA', () {
      final result = LifespanCalculator.calculateLifespan(
        birthDate: DateTime(1990, 1, 1),
        country: 'USA',
        gender: 'Male',
        height: 175.0,
        weight: 70.0,
        smoking: 'Never smoked',
        exercise: 'Regular exercise',
        alcohol: 'Moderate',
        sleepHours: 7.5,
      );

      expect(result.currentAge, greaterThan(0));
      expect(result.predictedLifespan, greaterThan(result.currentAge));
      expect(result.yearsRemaining, greaterThan(0));
      expect(result.percentageComplete, greaterThan(0));
      expect(result.percentageComplete, lessThan(100));
    });

    test('should calculate lifespan for female in Japan', () {
      final result = LifespanCalculator.calculateLifespan(
        birthDate: DateTime(1985, 6, 15),
        country: 'Japan',
        gender: 'Female',
        height: 160.0,
        weight: 55.0,
        smoking: 'Never smoked',
        exercise: 'Regular exercise',
        alcohol: 'Rarely',
        sleepHours: 8.0,
      );

      expect(result.currentAge, greaterThan(0));
      expect(result.predictedLifespan, greaterThan(result.currentAge));
      expect(result.yearsRemaining, greaterThan(0));
      expect(result.percentageComplete, greaterThan(0));
      expect(result.percentageComplete, lessThan(100));
    });

    test('should handle different countries', () {
      final usa = LifespanCalculator.calculateLifespan(
        birthDate: DateTime(1990, 1, 1),
        country: 'USA',
        gender: 'Male',
        height: 175.0,
        weight: 70.0,
        smoking: 'Never smoked',
        exercise: 'Regular exercise',
        alcohol: 'Moderate',
        sleepHours: 7.5,
      );

      final japan = LifespanCalculator.calculateLifespan(
        birthDate: DateTime(1990, 1, 1),
        country: 'Japan',
        gender: 'Male',
        height: 175.0,
        weight: 70.0,
        smoking: 'Never smoked',
        exercise: 'Regular exercise',
        alcohol: 'Moderate',
        sleepHours: 7.5,
      );

      // Both should return valid results
      expect(usa.predictedLifespan, greaterThan(0));
      expect(japan.predictedLifespan, greaterThan(0));
    });

    test('should handle different genders', () {
      final male = LifespanCalculator.calculateLifespan(
        birthDate: DateTime(1990, 1, 1),
        country: 'USA',
        gender: 'Male',
        height: 175.0,
        weight: 70.0,
        smoking: 'Never smoked',
        exercise: 'Regular exercise',
        alcohol: 'Moderate',
        sleepHours: 7.5,
      );

      final female = LifespanCalculator.calculateLifespan(
        birthDate: DateTime(1990, 1, 1),
        country: 'USA',
        gender: 'Female',
        height: 175.0,
        weight: 70.0,
        smoking: 'Never smoked',
        exercise: 'Regular exercise',
        alcohol: 'Moderate',
        sleepHours: 7.5,
      );

      // Both should return valid results
      expect(male.predictedLifespan, greaterThan(0));
      expect(female.predictedLifespan, greaterThan(0));
    });

    test('should handle different age ranges', () {
      final young = LifespanCalculator.calculateLifespan(
        birthDate: DateTime(2020, 1, 1),
        country: 'USA',
        gender: 'Male',
        height: 175.0,
        weight: 70.0,
        smoking: 'Never smoked',
        exercise: 'Regular exercise',
        alcohol: 'Moderate',
        sleepHours: 7.5,
      );

      final old = LifespanCalculator.calculateLifespan(
        birthDate: DateTime(1920, 1, 1),
        country: 'USA',
        gender: 'Male',
        height: 175.0,
        weight: 70.0,
        smoking: 'Never smoked',
        exercise: 'Regular exercise',
        alcohol: 'Moderate',
        sleepHours: 7.5,
      );

      // Both should return valid results
      expect(young.predictedLifespan, greaterThan(0));
      expect(old.predictedLifespan, greaterThan(0));
      
      // Young person should have lower percentage complete
      expect(young.percentageComplete, lessThan(old.percentageComplete));
    });

    test('should handle different lifestyle factors', () {
      final healthy = LifespanCalculator.calculateLifespan(
        birthDate: DateTime(1990, 1, 1),
        country: 'USA',
        gender: 'Male',
        height: 175.0,
        weight: 70.0,
        smoking: 'Never smoked',
        exercise: 'Regular exercise',
        alcohol: 'Moderate',
        sleepHours: 8.0,
      );

      final unhealthy = LifespanCalculator.calculateLifespan(
        birthDate: DateTime(1990, 1, 1),
        country: 'USA',
        gender: 'Male',
        height: 175.0,
        weight: 100.0,
        smoking: 'Current smoker',
        exercise: 'Sedentary',
        alcohol: 'Heavy drinker',
        sleepHours: 5.0,
      );

      // Both should return valid results
      expect(healthy.predictedLifespan, greaterThan(0));
      expect(unhealthy.predictedLifespan, greaterThan(0));
    });

    test('should handle edge cases with very young birth date', () {
      final result = LifespanCalculator.calculateLifespan(
        birthDate: DateTime(2020, 1, 1),
        country: 'USA',
        gender: 'Male',
        height: 175.0,
        weight: 70.0,
        smoking: 'Never smoked',
        exercise: 'Regular exercise',
        alcohol: 'Moderate',
        sleepHours: 7.5,
      );

      expect(result.currentAge, greaterThan(0));
      expect(result.percentageComplete, lessThan(10));
      expect(result.yearsRemaining, greaterThan(50));
    });

    test('should handle edge cases with very old birth date', () {
      final result = LifespanCalculator.calculateLifespan(
        birthDate: DateTime(1920, 1, 1),
        country: 'USA',
        gender: 'Male',
        height: 175.0,
        weight: 70.0,
        smoking: 'Never smoked',
        exercise: 'Regular exercise',
        alcohol: 'Moderate',
        sleepHours: 7.5,
      );

      expect(result.currentAge, greaterThan(100));
      expect(result.percentageComplete, greaterThan(80));
      expect(result.yearsRemaining, greaterThanOrEqualTo(0));
    });

    test('should handle missing country data', () {
      final result = LifespanCalculator.calculateLifespan(
        birthDate: DateTime(1990, 1, 1),
        country: 'UnknownCountry',
        gender: 'Male',
        height: 175.0,
        weight: 70.0,
        smoking: 'Never smoked',
        exercise: 'Regular exercise',
        alcohol: 'Moderate',
        sleepHours: 7.5,
      );

      // Should still return valid results using global average
      expect(result.currentAge, greaterThan(0));
      expect(result.predictedLifespan, greaterThan(result.currentAge));
      expect(result.yearsRemaining, greaterThan(0));
    });
  });
} 