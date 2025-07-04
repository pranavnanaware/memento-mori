class LifespanResult {
  final double predictedLifespan;
  final int currentAge;
  final double yearsRemaining;
  final double percentageComplete;
  final Map<String, double> breakdown;
  final double bmi;

  LifespanResult({
    required this.predictedLifespan,
    required this.currentAge,
    required this.yearsRemaining,
    required this.percentageComplete,
    required this.breakdown,
    required this.bmi,
  });
}

class LifespanCalculator {
  // Base life expectancy by country and gender (2024 data)
  static const Map<String, Map<String, double>> baseLifeExpectancy = {
    'US': {'male': 73.5, 'female': 79.3},
    'Canada': {'male': 79.8, 'female': 84.1},
    'UK': {'male': 79.4, 'female': 83.2},
    'Australia': {'male': 81.2, 'female': 85.4},
    'Germany': {'male': 78.6, 'female': 83.4},
    'France': {'male': 79.7, 'female': 85.6},
    'Japan': {'male': 81.5, 'female': 87.6},
    'South Korea': {'male': 79.7, 'female': 85.7},
    'China': {'male': 75.0, 'female': 80.5},
    'India': {'male': 67.4, 'female': 70.0},
    'Brazil': {'male': 72.8, 'female': 79.9},
    'Mexico': {'male': 72.9, 'female': 78.1},
    'Russia': {'male': 68.2, 'female': 78.5},
    'Nigeria': {'male': 53.4, 'female': 55.7},
    'Egypt': {'male': 70.2, 'female': 74.1},
    'South Africa': {'male': 62.3, 'female': 68.5},
    'Italy': {'male': 80.5, 'female': 85.2},
    'Spain': {'male': 80.1, 'female': 85.8},
    'Netherlands': {'male': 79.8, 'female': 83.2},
    'Sweden': {'male': 80.7, 'female': 84.0},
    'Norway': {'male': 81.0, 'female': 84.4},
    'Denmark': {'male': 79.4, 'female': 83.1},
    'Finland': {'male': 78.9, 'female': 84.2},
    'Switzerland': {'male': 81.9, 'female': 85.6},
    'Austria': {'male': 79.1, 'female': 83.9},
    'Belgium': {'male': 79.2, 'female': 84.0},
    'Ireland': {'male': 80.4, 'female': 84.4},
    'New Zealand': {'male': 80.5, 'female': 84.0},
    'Singapore': {'male': 81.1, 'female': 85.9},
    'Hong Kong': {'male': 82.3, 'female': 87.7},
    'Taiwan': {'male': 77.3, 'female': 83.8},
    'Thailand': {'male': 72.8, 'female': 79.4},
    'Vietnam': {'male': 71.3, 'female': 80.7},
    'Malaysia': {'male': 72.5, 'female': 77.7},
    'Indonesia': {'male': 69.8, 'female': 73.8},
    'Philippines': {'male': 66.9, 'female': 73.6},
    'Pakistan': {'male': 66.1, 'female': 67.0},
    'Bangladesh': {'male': 71.1, 'female': 74.2},
    'Sri Lanka': {'male': 72.5, 'female': 78.9},
    'Nepal': {'male': 68.4, 'female': 70.3},
    'Myanmar': {'male': 64.6, 'female': 68.8},
    'Cambodia': {'male': 66.8, 'female': 70.9},
    'Laos': {'male': 64.6, 'female': 67.9},
    'Mongolia': {'male': 66.8, 'female': 76.3},
    'Kazakhstan': {'male': 67.4, 'female': 76.3},
    'Uzbekistan': {'male': 70.7, 'female': 76.0},
    'Kyrgyzstan': {'male': 67.4, 'female': 75.6},
    'Tajikistan': {'male': 69.6, 'female': 75.6},
    'Turkmenistan': {'male': 65.6, 'female': 72.0},
    'Azerbaijan': {'male': 69.4, 'female': 76.7},
    'Georgia': {'male': 69.5, 'female': 78.6},
    'Armenia': {'male': 72.0, 'female': 79.0},
    'Ukraine': {'male': 66.3, 'female': 76.1},
    'Belarus': {'male': 69.4, 'female': 79.0},
    'Moldova': {'male': 67.8, 'female': 75.9},
    'Romania': {'male': 71.6, 'female': 78.8},
    'Bulgaria': {'male': 71.8, 'female': 78.8},
    'Serbia': {'male': 73.5, 'female': 78.5},
    'Croatia': {'male': 74.7, 'female': 81.1},
    'Slovenia': {'male': 78.2, 'female': 84.3},
    'Slovakia': {'male': 73.9, 'female': 80.8},
    'Czech Republic': {'male': 76.1, 'female': 82.0},
    'Poland': {'male': 73.6, 'female': 81.6},
    'Hungary': {'male': 72.3, 'female': 79.1},
    'Estonia': {'male': 73.8, 'female': 82.3},
    'Latvia': {'male': 69.8, 'female': 79.7},
    'Lithuania': {'male': 69.5, 'female': 80.1},
    'Greece': {'male': 78.2, 'female': 83.6},
    'Portugal': {'male': 77.7, 'female': 83.8},
    'Turkey': {'male': 72.9, 'female': 78.9},
    'Israel': {'male': 80.6, 'female': 84.3},
    'Lebanon': {'male': 78.9, 'female': 81.8},
    'Jordan': {'male': 74.5, 'female': 77.8},
    'Syria': {'male': 69.8, 'female': 75.9},
    'Iraq': {'male': 69.4, 'female': 75.6},
    'Iran': {'male': 74.2, 'female': 77.7},
    'Afghanistan': {'male': 62.8, 'female': 66.2},
    'Brunei': {'male': 75.9, 'female': 79.5},
    'East Timor': {'male': 67.5, 'female': 70.2},
    'Papua New Guinea': {'male': 64.5, 'female': 68.6},
    'Fiji': {'male': 67.4, 'female': 71.3},
    'Vanuatu': {'male': 70.4, 'female': 75.0},
    'Solomon Islands': {'male': 73.0, 'female': 76.8},
    'New Caledonia': {'male': 74.3, 'female': 80.9},
    'French Polynesia': {'male': 74.8, 'female': 80.2},
    'Samoa': {'male': 72.8, 'female': 78.5},
    'Tonga': {'male': 70.9, 'female': 76.8},
    'Kiribati': {'male': 66.2, 'female': 71.6},
    'Tuvalu': {'male': 65.8, 'female': 69.9},
    'Nauru': {'male': 64.5, 'female': 68.5},
    'Marshall Islands': {'male': 67.5, 'female': 71.3},
    'Micronesia': {'male': 68.5, 'female': 72.8},
    'Palau': {'male': 73.6, 'female': 80.3},
    'Guam': {'male': 75.5, 'female': 81.1},
    'Northern Mariana Islands': {'male': 74.8, 'female': 80.2},
    'American Samoa': {'male': 72.8, 'female': 78.5},
    'Cook Islands': {'male': 74.3, 'female': 80.9},
    'Niue': {'male': 72.8, 'female': 78.5},
    'Tokelau': {'male': 67.5, 'female': 71.3},
    'Wallis and Futuna': {'male': 74.8, 'female': 80.2},
    'Pitcairn': {'male': 74.3, 'female': 80.9},
    'Global': {'male': 70.8, 'female': 75.9}, // fallback
  };

  static LifespanResult calculateLifespan({
    required DateTime birthDate,
    required String country,
    required String gender,
    required double height,
    required double weight,
    required String smoking,
    required String exercise,
    required String alcohol,
    required double sleepHours,
  }) {
    // Calculate current age and BMI
    final now = DateTime.now();
    final currentAge = now.year - birthDate.year;
    final heightM = height / 100; // convert cm to meters
    final bmi = weight / (heightM * heightM);

    // Get base life expectancy
    final countryData = baseLifeExpectancy[country] ?? baseLifeExpectancy['Global']!;
    final genderKey = gender.toLowerCase();
    double lifespan = countryData[genderKey] ?? countryData['male']!;

    // BMI Impact (strong evidence)
    double bmiAdjustment = 0;
    if (bmi < 18.5) {
      bmiAdjustment = -3.5; // Underweight
    } else if (bmi >= 18.5 && bmi < 25) {
      bmiAdjustment = 0; // Normal weight
    } else if (bmi >= 25 && bmi < 30) {
      bmiAdjustment = -1.5; // Overweight
    } else if (bmi >= 30 && bmi < 35) {
      bmiAdjustment = -4.2; // Obese Class I
    } else if (bmi >= 35 && bmi < 40) {
      bmiAdjustment = -6.1; // Obese Class II
    } else {
      bmiAdjustment = -8.7; // Obese Class III (40+)
    }

    // Smoking Impact (very strong evidence)
    double smokingAdjustment = 0;
    switch (smoking.toLowerCase()) {
      case 'never smoked':
        smokingAdjustment = 0;
        break;
      case 'former smoker':
        smokingAdjustment = -2.5; // Depends on when quit, using average
        break;
      case 'occasional smoker':
        smokingAdjustment = -5.0; // Light smoking
        break;
      case 'current smoker':
        smokingAdjustment = -11.5; // Heavy smoking average
        break;
    }

    // Exercise Impact (strong evidence)
    double exerciseAdjustment = 0;
    switch (exercise.toLowerCase()) {
      case 'sedentary (no exercise)':
        exerciseAdjustment = -3.5;
        break;
      case 'light (1-2 days/week)':
        exerciseAdjustment = -1.5;
        break;
      case 'moderate (3-4 days/week)':
        exerciseAdjustment = 0; // baseline
        break;
      case 'active (5-6 days/week)':
        exerciseAdjustment = 1.8;
        break;
      case 'very active (daily exercise)':
        exerciseAdjustment = 2.8;
        break;
    }

    // Alcohol Impact (J-shaped curve)
    double alcoholAdjustment = 0;
    switch (alcohol.toLowerCase()) {
      case 'never':
        alcoholAdjustment = -0.5; // Slight negative (no protective effect)
        break;
      case 'rarely (1-2 times/month)':
        alcoholAdjustment = 0.5; // Very light, slight protective
        break;
      case 'occasionally (1-2 times/week)':
        alcoholAdjustment = 1.2; // 1-7 drinks per week, cardioprotective
        break;
      case 'regularly (3-4 times/week)':
        alcoholAdjustment = -0.8; // 8-14 drinks per week
        break;
      case 'frequently (daily)':
        alcoholAdjustment = -4.6; // 15+ drinks per week
        break;
    }

    // Sleep Impact (U-shaped curve)
    double sleepAdjustment = 0;
    if (sleepHours < 6) {
      sleepAdjustment = -2.1; // Too little sleep
    } else if (sleepHours >= 6 && sleepHours <= 8) {
      sleepAdjustment = 0; // Optimal sleep
    } else if (sleepHours > 8 && sleepHours <= 9) {
      sleepAdjustment = -0.8; // Slightly too much
    } else {
      sleepAdjustment = -1.9; // Way too much sleep (9+ hours)
    }

    // Age-based adjustment (older people have survived selection effects)
    double ageAdjustment = 0;
    if (currentAge >= 65) {
      ageAdjustment = 2.0; // Survival bias bonus
    } else if (currentAge >= 50) {
      ageAdjustment = 1.0;
    }

    // Calculate final lifespan
    final totalAdjustment = bmiAdjustment + smokingAdjustment + exerciseAdjustment + 
                           alcoholAdjustment + sleepAdjustment + ageAdjustment;
    
    final predictedLifespan = (lifespan + totalAdjustment).clamp(40.0, 120.0); // Minimum 40, maximum 120 years
    
    final yearsRemaining = (predictedLifespan - currentAge).clamp(0.0, 100.0);
    final percentageComplete = ((currentAge / predictedLifespan) * 100).clamp(0.0, 100.0);
    
    return LifespanResult(
      predictedLifespan: (predictedLifespan * 10).round() / 10,
      currentAge: currentAge,
      yearsRemaining: (yearsRemaining * 10).round() / 10,
      percentageComplete: (percentageComplete * 10).round() / 10,
      breakdown: {
        'baseLifeExpectancy': lifespan,
        'bmiImpact': bmiAdjustment,
        'smokingImpact': smokingAdjustment,
        'exerciseImpact': exerciseAdjustment,
        'alcoholImpact': alcoholAdjustment,
        'sleepImpact': sleepAdjustment,
        'ageBonus': ageAdjustment,
        'totalAdjustment': totalAdjustment
      },
      bmi: (bmi * 10).round() / 10,
    );
  }
} 