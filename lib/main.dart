import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homescreen.dart';
import 'constants/form_constants.dart' as form_constants;

void main() {
  runApp(const MyApp());
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startSplash();
  }

  void _startSplash() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const FormOrHomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'MEMENTO MORI',
              style: GoogleFonts.cinzelDecorative(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
                letterSpacing: 4.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Text(
              'Remember that you must die',
              style: GoogleFonts.cinzel(
                color: Colors.grey[400],
                fontSize: 18,
                letterSpacing: 2.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[400]!),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FormOrHomeScreen extends StatefulWidget {
  const FormOrHomeScreen({super.key});

  @override
  State<FormOrHomeScreen> createState() => _FormOrHomeScreenState();
}

class _FormOrHomeScreenState extends State<FormOrHomeScreen> {
  bool _isLoading = true;
  bool _hasCompletedForm = false;
  int _lastCompletedStep = -1;

  @override
  void initState() {
    super.initState();
    _checkFormStatus();
  }

  Future<void> _checkFormStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final hasCompleted = prefs.getBool('form_completed') ?? false;
    final lastStep = prefs.getInt('last_completed_step') ?? -1;
    
    setState(() {
      _hasCompletedForm = hasCompleted;
      _lastCompletedStep = lastStep;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );
    }

    if (_hasCompletedForm) {
      return const HomeScreen();
    } else {
      return MultiStepForm(initialStep: _lastCompletedStep + 1);
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memento Mori',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class MultiStepForm extends StatefulWidget {
  final int initialStep;
  
  const MultiStepForm({super.key, this.initialStep = 0});

  @override
  State<MultiStepForm> createState() => _MultiStepFormState();
}

class _MultiStepFormState extends State<MultiStepForm> {
  int _currentStep = 0;
  
  // Form data
  DateTime? _birthDate;
  String? _country;
  String? _countryCode;
  String? _gender;
  double? _height;
  double? _weight;
  String? _smokingStatus;
  String? _exerciseFrequency;
  String? _alcoholConsumption;
  double? _sleepHours;
  
  // Unit preferences
  String _heightUnit = 'cm';
  String _weightUnit = 'kg';

  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialStep;
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load birth date
    final birthDateString = prefs.getString('birth_date');
    if (birthDateString != null) {
      _birthDate = DateTime.parse(birthDateString);
    }
    
    // Load other data
    _country = prefs.getString('country');
    _countryCode = prefs.getString('country_code');
    _gender = prefs.getString('gender');
    _height = prefs.getDouble('height');
    _weight = prefs.getDouble('weight');
    _smokingStatus = prefs.getString('smoking_status');
    _exerciseFrequency = prefs.getString('exercise_frequency');
    _alcoholConsumption = prefs.getString('alcohol_consumption');
    _sleepHours = prefs.getDouble('sleep_hours');
    
    setState(() {});
  }

  Future<void> _saveCurrentStep() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_completed_step', _currentStep);
  }

  Future<void> _saveFormData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Save birth date
    if (_birthDate != null) {
      await prefs.setString('birth_date', _birthDate!.toIso8601String());
    }
    
    // Save other data
    if (_country != null) await prefs.setString('country', _country!);
    if (_countryCode != null) await prefs.setString('country_code', _countryCode!);
    if (_gender != null) await prefs.setString('gender', _gender!);
    if (_height != null) await prefs.setDouble('height', _height!);
    if (_weight != null) await prefs.setDouble('weight', _weight!);
    if (_smokingStatus != null) await prefs.setString('smoking_status', _smokingStatus!);
    if (_exerciseFrequency != null) await prefs.setString('exercise_frequency', _exerciseFrequency!);
    if (_alcoholConsumption != null) await prefs.setString('alcohol_consumption', _alcoholConsumption!);
    if (_sleepHours != null) await prefs.setDouble('sleep_hours', _sleepHours!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'MEMENTO MORI',
          style: GoogleFonts.cinzelDecorative(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            // Progress indicator
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: List.generate(9, (index) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: index <= _currentStep ? Colors.white : Colors.grey[800],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            
            // Step title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                _getStepTitle(_currentStep),
                style: GoogleFonts.cinzel(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            // Form content
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(30),
                child: _buildStepContent(),
              ),
            ),
            
            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 0)
                    IconButton(
                      onPressed: _previousStep,
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 30,
                      ),
                    )
                  else
                    const SizedBox(width: 60),
                  
                  IconButton(
                    onPressed: _nextStep,
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildBirthDateStep();
      case 1:
        return _buildCountryStep();
      case 2:
        return _buildGenderStep();
      case 3:
        return _buildHeightStep();
      case 4:
        return _buildWeightStep();
      case 5:
        return _buildSmokingStep();
      case 6:
        return _buildExerciseStep();
      case 7:
        return _buildAlcoholStep();
      case 8:
        return _buildSleepStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildBirthDateStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.cake,
          size: 80,
          color: Colors.grey[400],
        ),
        const SizedBox(height: 30),
        Text(
          'When were you born?',
          style: GoogleFonts.cinzel(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        if (_birthDate != null)
          Text(
            'Selected: ${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}',
            style: GoogleFonts.cinzel(
              color: Colors.grey[300],
              fontSize: 16,
            ),
          ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.dark(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      surface: Colors.grey,
                      onSurface: Colors.white,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (date != null) {
              setState(() {
                _birthDate = date;
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            'Select Birth Date',
            style: GoogleFonts.cinzel(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCountryStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.public,
          size: 80,
          color: Colors.grey[400],
        ),
        const SizedBox(height: 30),
        Text(
          'Where do you live?',
          style: GoogleFonts.cinzel(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _country,
              hint: Text(
                'Select your country',
                style: GoogleFonts.cinzel(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              dropdownColor: Colors.black,
              style: GoogleFonts.cinzel(
                color: Colors.white,
                fontSize: 16,
              ),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              isExpanded: true,
              items: form_constants.countries.map((form_constants.CountryData country) {
                return DropdownMenuItem<String>(
                  value: country.name,
                  child: Text(
                    country.name,
                    style: const TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _country = newValue;
                  if (newValue != null) {
                    final countryData = form_constants.countries.firstWhere(
                      (country) => country.name == newValue,
                      orElse: () => const form_constants.CountryData('Global', 'Global'),
                    );
                    _countryCode = countryData.code;
                  }
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.person,
          size: 80,
          color: Colors.grey[400],
        ),
        const SizedBox(height: 30),
        Text(
          'What is your gender assigned at birth?',
          style: GoogleFonts.cinzel(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        ...(form_constants.genders.map((gender) => Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 15),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _gender = gender;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _gender == gender ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: Colors.white,
                  width: 1,
                ),
              ),
            ),
            child: Text(
              gender,
              style: GoogleFonts.cinzel(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )).toList()),
      ],
    );
  }

  Widget _buildHeightStep() {
    // Always store _height in cm
    double displayValue;
    double minValue;
    double maxValue;
    if (_heightUnit == 'ft') {
      displayValue = _height != null ? _height! / 30.48 : 5.58; // cm to ft
      minValue = 3.28; // 100 cm in ft
      maxValue = 8.20; // 250 cm in ft
    } else {
      displayValue = _height ?? 170.0;
      minValue = 100.0;
      maxValue = 250.0;
    }
    // Clamp display value
    displayValue = displayValue.clamp(minValue, maxValue);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.height,
          size: 80,
          color: Colors.grey[400],
        ),
        const SizedBox(height: 30),
        Text(
          'What is your height?',
          style: GoogleFonts.cinzel(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        // Unit selection
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                if (_heightUnit != 'cm') {
                  setState(() {
                    _heightUnit = 'cm';
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _heightUnit == 'cm' ? Colors.white : Colors.transparent,
                foregroundColor: _heightUnit == 'cm' ? Colors.black : Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.white),
                ),
              ),
              child: Text(
                'cm',
                style: GoogleFonts.cinzel(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                if (_heightUnit != 'ft') {
                  setState(() {
                    _heightUnit = 'ft';
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _heightUnit == 'ft' ? Colors.white : Colors.transparent,
                foregroundColor: _heightUnit == 'ft' ? Colors.black : Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.white),
                ),
              ),
              child: Text(
                'ft',
                style: GoogleFonts.cinzel(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          _heightUnit == 'ft'
              ? '${displayValue.toStringAsFixed(2)} ft'
              : '${displayValue.toStringAsFixed(1)} cm',
          style: GoogleFonts.cinzel(
            color: Colors.grey[300],
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        Slider(
          value: displayValue,
          min: minValue,
          max: maxValue,
          divisions: 150,
          activeColor: Colors.white,
          inactiveColor: Colors.grey[700],
          onChanged: (value) {
            setState(() {
              // Convert back to cm for storage
              if (_heightUnit == 'ft') {
                _height = value * 30.48; // ft to cm
              } else {
                _height = value;
              }
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _heightUnit == 'ft'
                  ? '${minValue.toStringAsFixed(2)} ft'
                  : '${minValue.toStringAsFixed(1)} cm',
              style: GoogleFonts.cinzel(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
            Text(
              _heightUnit == 'ft'
                  ? '${maxValue.toStringAsFixed(2)} ft'
                  : '${maxValue.toStringAsFixed(1)} cm',
              style: GoogleFonts.cinzel(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeightStep() {
    // Always store _weight in kg
    double displayValue;
    double minValue;
    double maxValue;
    if (_weightUnit == 'lbs') {
      displayValue = _weight != null ? _weight! * 2.20462 : 154.32; // kg to lbs
      minValue = 66.14; // 30 kg in lbs
      maxValue = 440.92; // 200 kg in lbs
    } else {
      displayValue = _weight ?? 70.0;
      minValue = 30.0;
      maxValue = 200.0;
    }
    // Clamp display value
    displayValue = displayValue.clamp(minValue, maxValue);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.monitor_weight,
          size: 80,
          color: Colors.grey[400],
        ),
        const SizedBox(height: 30),
        Text(
          'What is your weight?',
          style: GoogleFonts.cinzel(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        // Unit selection
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                if (_weightUnit != 'kg') {
                  setState(() {
                    _weightUnit = 'kg';
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _weightUnit == 'kg' ? Colors.white : Colors.transparent,
                foregroundColor: _weightUnit == 'kg' ? Colors.black : Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.white),
                ),
              ),
              child: Text(
                'kg',
                style: GoogleFonts.cinzel(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                if (_weightUnit != 'lbs') {
                  setState(() {
                    _weightUnit = 'lbs';
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _weightUnit == 'lbs' ? Colors.white : Colors.transparent,
                foregroundColor: _weightUnit == 'lbs' ? Colors.black : Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.white),
                ),
              ),
              child: Text(
                'lbs',
                style: GoogleFonts.cinzel(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          _weightUnit == 'lbs'
              ? '${displayValue.toStringAsFixed(1)} lbs'
              : '${displayValue.toStringAsFixed(1)} kg',
          style: GoogleFonts.cinzel(
            color: Colors.grey[300],
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        Slider(
          value: displayValue,
          min: minValue,
          max: maxValue,
          divisions: 170,
          activeColor: Colors.white,
          inactiveColor: Colors.grey[700],
          onChanged: (value) {
            setState(() {
              // Convert back to kg for storage
              if (_weightUnit == 'lbs') {
                _weight = value / 2.20462; // lbs to kg
              } else {
                _weight = value;
              }
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _weightUnit == 'lbs'
                  ? '${minValue.toStringAsFixed(1)} lbs'
                  : '${minValue.toStringAsFixed(1)} kg',
              style: GoogleFonts.cinzel(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
            Text(
              _weightUnit == 'lbs'
                  ? '${maxValue.toStringAsFixed(1)} lbs'
                  : '${maxValue.toStringAsFixed(1)} kg',
              style: GoogleFonts.cinzel(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSmokingStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.smoking_rooms,
          size: 80,
          color: Colors.grey[400],
        ),
        const SizedBox(height: 30),
        Text(
          'What is your smoking status?',
          style: GoogleFonts.cinzel(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        ...(form_constants.smokingOptions.map((option) => Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 15),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _smokingStatus = option;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _smokingStatus == option ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: Colors.white,
                  width: 1,
                ),
              ),
            ),
            child: Text(
              option,
              style: GoogleFonts.cinzel(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )).toList()),
      ],
    );
  }

  Widget _buildExerciseStep() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 30),
          Text(
            'How often do you exercise?',
            style: GoogleFonts.cinzel(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ...(form_constants.exerciseOptions.map((option) => Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 15),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _exerciseFrequency = option;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _exerciseFrequency == option ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
              ),
              child: Text(
                option,
                style: GoogleFonts.cinzel(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )).toList()),
        ],
      ),
    );
  }

  Widget _buildAlcoholStep() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_bar,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 30),
          Text(
            'How often do you consume alcohol?',
            style: GoogleFonts.cinzel(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ...(form_constants.alcoholOptions.map((option) => Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 15),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _alcoholConsumption = option;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _alcoholConsumption == option ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
              ),
              child: Text(
                option,
                style: GoogleFonts.cinzel(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )).toList()),
        ],
      ),
    );
  }

  Widget _buildSleepStep() {
    return Column(
          mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.bedtime,
          size: 80,
          color: Colors.grey[400],
        ),
        const SizedBox(height: 30),
        Text(
          'How many hours do you sleep per night?',
          style: GoogleFonts.cinzel(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Text(
          '${_sleepHours?.toStringAsFixed(1) ?? "0.0"} hours',
          style: GoogleFonts.cinzel(
            color: Colors.grey[300],
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        Slider(
          value: _sleepHours ?? 7.0,
          min: 3.0,
          max: 12.0,
          divisions: 18,
          activeColor: Colors.white,
          inactiveColor: Colors.grey[700],
          onChanged: (value) {
            setState(() {
              _sleepHours = value;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '3 hours',
              style: GoogleFonts.cinzel(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
            Text(
              '12 hours',
              style: GoogleFonts.cinzel(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'Birth Date';
      case 1:
        return 'Country';
      case 2:
        return 'Gender';
      case 3:
        return 'Height';
      case 4:
        return 'Weight';
      case 5:
        return 'Smoking Status';
      case 6:
        return 'Exercise Frequency';
      case 7:
        return 'Alcohol Consumption';
      case 8:
        return 'Sleep Hours';
      default:
        return '';
    }
  }

  void _nextStep() async {
    // Save current step data
    await _saveFormData();
    await _saveCurrentStep();
    
    if (_currentStep < 8) {
      setState(() {
        _currentStep++;
      });
    } else {
      // Instead of showing a dialog, navigate to the summary screen
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => SummaryScreen(
              birthDate: _birthDate,
              country: _country,
              gender: _gender,
              height: _height,
              weight: _weight,
              smokingStatus: _smokingStatus,
              exerciseFrequency: _exerciseFrequency,
              alcoholConsumption: _alcoholConsumption,
              sleepHours: _sleepHours,
            ),
          ),
        );
      }
    }
  }

  void _previousStep() async {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      await _saveCurrentStep();
    }
  }
}

class SummaryScreen extends StatelessWidget {
  final DateTime? birthDate;
  final String? country;
  final String? gender;
  final double? height;
  final double? weight;
  final String? smokingStatus;
  final String? exerciseFrequency;
  final String? alcoholConsumption;
  final double? sleepHours;

  const SummaryScreen({
    super.key,
    this.birthDate,
    this.country,
    this.gender,
    this.height,
    this.weight,
    this.smokingStatus,
    this.exerciseFrequency,
    this.alcoholConsumption,
    this.sleepHours,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Summary',
          style: GoogleFonts.cinzelDecorative(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryRow('Birth Date', birthDate != null ? '${birthDate!.day}/${birthDate!.month}/${birthDate!.year}' : 'Not set'),
            _buildSummaryRow('Country', country ?? 'Not set'),
            _buildSummaryRow('Gender', gender ?? 'Not set'),
            _buildSummaryRow('Height', height != null ? '${height!.toStringAsFixed(1)} cm' : 'Not set'),
            _buildSummaryRow('Weight', weight != null ? '${weight!.toStringAsFixed(1)} kg' : 'Not set'),
            _buildSummaryRow('Smoking Status', smokingStatus ?? 'Not set'),
            _buildSummaryRow('Exercise Frequency', exerciseFrequency ?? 'Not set'),
            _buildSummaryRow('Alcohol Consumption', alcoholConsumption ?? 'Not set'),
            _buildSummaryRow('Sleep Hours', sleepHours != null ? '${sleepHours!.toStringAsFixed(1)} hours' : 'Not set'),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('form_completed', true);
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Done',
                  style: GoogleFonts.cinzel(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.cinzel(
                color: Colors.grey[300],
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: GoogleFonts.cinzel(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

