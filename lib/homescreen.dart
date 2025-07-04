import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
import 'services/lifespan_calculator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LifespanResult? _lifespanResult;
  bool _isLoading = true;
  String? _quote;
  String? _quoteAuthor;
  bool _isLoadingQuote = true;

  @override
  void initState() {
    super.initState();
    _loadLifespanData();
    _loadQuote();
  }

  Future<void> _loadLifespanData() async {
    final prefs = await SharedPreferences.getInstance();
    
    final birthDateString = prefs.getString('birth_date');
    final countryCode = prefs.getString('country_code');
    final gender = prefs.getString('gender');
    final height = prefs.getDouble('height');
    final weight = prefs.getDouble('weight');
    final smokingStatus = prefs.getString('smoking_status');
    final exerciseFrequency = prefs.getString('exercise_frequency');
    final alcoholConsumption = prefs.getString('alcohol_consumption');
    final sleepHours = prefs.getDouble('sleep_hours');

    if (birthDateString != null && 
        countryCode != null && 
        gender != null && 
        height != null && 
        weight != null && 
        smokingStatus != null && 
        exerciseFrequency != null && 
        alcoholConsumption != null && 
        sleepHours != null) {
      
      final birthDate = DateTime.parse(birthDateString);
      
      final result = LifespanCalculator.calculateLifespan(
        birthDate: birthDate,
        country: countryCode,
        gender: gender,
        height: height,
        weight: weight,
        smoking: smokingStatus,
        exercise: exerciseFrequency,
        alcohol: alcoholConsumption,
        sleepHours: sleepHours,
      );
      
      setState(() {
        _lifespanResult = result;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadQuote() async {
    try {
      final response = await http.get(Uri.parse('https://stoic-quotes.com/api/quote'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _quote = data['text'];
          _quoteAuthor = data['author'];
          _isLoadingQuote = false;
        });
      } else {
        setState(() {
          _quote = "The best revenge is not to be like your enemy.";
          _quoteAuthor = "Marcus Aurelius";
          _isLoadingQuote = false;
        });
      }
    } catch (e) {
      setState(() {
        _quote = "The best revenge is not to be like your enemy.";
        _quoteAuthor = "Marcus Aurelius";
        _isLoadingQuote = false;
      });
    }
  }

  Future<void> _resetData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Instead of clearing everything, just reset the form completion flag
    await prefs.setBool('form_completed', false);
    await prefs.setInt('last_completed_step', -1);
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const FormOrHomeScreen()),
      );
    }
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _resetData,
            tooltip: 'Reset Form',
          ),
        ],
      ),
      body: _isLoading 
        ? const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                // Lifespan percentage display
                if (_lifespanResult != null) ...[
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 8,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: CircularProgressIndicator(
                            value: _lifespanResult!.percentageComplete / 100,
                            strokeWidth: 8,
                            backgroundColor: Colors.grey[800],
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${_lifespanResult!.percentageComplete.toStringAsFixed(1)}%',
                              style: GoogleFonts.cinzelDecorative(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Complete',
                              style: GoogleFonts.cinzel(
                                color: Colors.grey[300],
                                fontSize: 12,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Prediction text
                  Text(
                    'Predicted: ${_lifespanResult!.predictedLifespan.toStringAsFixed(1)} years',
                    style: GoogleFonts.cinzel(
                      color: Colors.grey[300],
                      fontSize: 18,
                      letterSpacing: 1.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'More or less, but you might die today so know this',
                    style: GoogleFonts.cinzel(
                      color: Colors.grey[400],
                      fontSize: 14,
                      letterSpacing: 1.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  
                  // Quote section
                  if (!_isLoadingQuote && _quote != null) ...[
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            '"' + (_quote ?? '') + '"',
                            style: GoogleFonts.cinzel(
                              color: Colors.white,
                              fontSize: 16,
                              letterSpacing: 0.5,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            '- $_quoteAuthor',
                            style: GoogleFonts.cinzel(
                              color: Colors.grey[400],
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              letterSpacing: 1.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.grey[700]!,
                          width: 1,
                        ),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
                  ],
                ] else ...[
                  Text(
                    'Your journey has begun',
                    style: GoogleFonts.cinzel(
                      color: Colors.grey[300],
                      fontSize: 16,
                      letterSpacing: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                
                const SizedBox(height: 50),
              ],
            ),
          ),
    );
  }
} 

