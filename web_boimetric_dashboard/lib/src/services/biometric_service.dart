import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/biometric_data.dart';

class BiometricService with ChangeNotifier {
  static const _simulateLatency = true;
  static const _failureRate = 0.1; // 10% failure rate
  
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;
  
  BiometricDataSet? _data;
  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  );
  
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;
  BiometricDataSet? get data => _data;
  DateTimeRange get dateRange => _dateRange;
  
  // Simulate data loading with potential latency and failures
  Future<void> loadData() async {
    if (_isLoading) return;
    
    _isLoading = true;
    _hasError = false;
    _errorMessage = null;
    notifyListeners();
    
    try {
      // Simulate network latency
      if (_simulateLatency) {
        await Future.delayed(Duration(milliseconds: 700 + Random().nextInt(500)));
      }
      
      // Simulate random failures
      if (Random().nextDouble() < _failureRate) {
        throw Exception('Failed to load biometric data. Please try again.');
      }
      
      // Generate or load actual data
      _data = _generateMockData();
      notifyListeners();
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void updateDateRange(DateTimeRange newRange) {
    _dateRange = newRange;
    notifyListeners();
  }
  
  // Generate mock data for demonstration
  BiometricDataSet _generateMockData() {
    final random = Random(42); // Fixed seed for consistent mock data
    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 90));
    final dataPoints = <BiometricDataPoint>[];
    
    // Generate 90 days of data
    for (var i = 0; i < 90; i++) {
      final date = startDate.add(Duration(days: i));
      final isWeekend = date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
      
      // Base values with some randomness and weekly patterns
      final baseHRV = 50.0 + (isWeekend ? 5.0 : 0.0) + random.nextDouble() * 20;
      final baseRHR = 60 + (isWeekend ? -2 : 0) + random.nextInt(5);
      final baseSteps = isWeekend ? 5000 : 7000 + random.nextInt(3000);
      
      // Add some journal entries (1 in 5 days)
      String? journalEntry;
      int? mood;
      if (random.nextDouble() < 0.2) {
        mood = 1 + random.nextInt(5); // 1-5 mood rating
        final moods = ['😔', '🙁', '😐', '🙂', '😊'];
        journalEntry = '${moods[mood - 1]} ${_randomJournalEntry(random)}';
      }
      
      dataPoints.add(BiometricDataPoint(
        timestamp: date,
        hrv: baseHRV + (random.nextDouble() * 10 - 5), // Add some daily variation
        rhr: baseRHR + random.nextInt(3),
        steps: baseSteps + random.nextInt(2000) - 1000,
        journalEntry: journalEntry,
        mood: mood,
      ));
    }
    
    return BiometricDataSet(dataPoints);
  }
  
  static const _journalEntries = [
    'Bad sleep last night',
    'Great workout this morning',
    'Feeling tired',
    'Good energy today',
    'Stressed at work',
    'Relaxing weekend',
    'Ate well today',
    'Missed my workout',
    'Great run this morning',
    'Not feeling well',
  ];
  
  String _randomJournalEntry(Random random) {
    return _journalEntries[random.nextInt(_journalEntries.length)];
  }
}
// Auto-generated comment for commit - 1763734959
// Auto-generated comment for commit - 1763734962
// Auto-generated comment for commit - 1763734970
// Auto-generated comment for commit - 1763734981
// Auto-generated comment for commit - 1763734986
// Auto-generated comment for commit - 1763734988
// Auto-generated comment for commit - 1763734995
// Auto-generated comment for commit - 1763735018
// Auto-generated comment for commit - 1763735024
// Auto-generated comment for commit - 1763735055
// Auto-generated comment for commit - 1763735068
// Auto-generated comment for commit - 1763735068
// Auto-generated comment for commit - 1763735069
// Auto-generated comment for commit - 1763735072
// Auto-generated comment for commit - 1763735079
// Auto-generated comment for commit - 1763735094
// Auto-generated comment for commit - 1763735095
// Auto-generated comment for commit - 1763735104
// Auto-generated comment for commit - 1763735105
// Auto-generated comment for commit - 1763735113
// Auto-generated comment for commit - 1763735116
// Auto-generated comment for commit - 1763735120
// Auto-generated comment for commit - 1763735134
// Auto-generated comment for commit - 1763735155
// Auto-generated comment for commit - 1763735158
// Auto-generated comment for commit - 1763735160
// Auto-generated comment for commit - 1763735170
// Auto-generated comment for commit - 1780350395
// Auto-generated comment for commit - 1780350396
// Auto-generated comment for commit - 1780350400
// Auto-generated comment for commit - 1780350405
// Auto-generated comment for commit - 1780350411
// Auto-generated comment for commit - 1780350428
// Auto-generated comment for commit - 1780350435
// Auto-generated comment for commit - 1780350438
// Auto-generated comment for commit - 1780350439
// Auto-generated comment for commit - 1780350444
// Auto-generated comment for commit - 1780350452
// Auto-generated comment for commit - 1780350468
// Auto-generated comment for commit - 1780350471
// Auto-generated comment for commit - 1780350472
// Auto-generated comment for commit - 1780350488
