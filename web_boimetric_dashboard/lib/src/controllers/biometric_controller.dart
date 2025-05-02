import 'package:flutter/material.dart';
import '../models/biometric_data.dart';
import '../services/biometric_service.dart';

class BiometricController extends ChangeNotifier {
  // Service reference (mutable for proxy provider)
  late BiometricService _service;
  
  // Chart interaction state
  late DateTimeRange _visibleRange;
  DateTime? _selectedDate;
  String _selectedRange = '30d';
  
  // Time range options
  static const Map<String, int> timeRanges = {
    '7d': 7,
    '30d': 30,
    '90d': 90,
  };
  
  BiometricController(BiometricService service) : _service = service {
    _visibleRange = _calculateDateRange('30d');
    _service.addListener(_onServiceUpdate);
  }
  
  // Create a new instance with the updated service
  void updateService(BiometricService service) {
    _service.removeListener(_onServiceUpdate);
    _service = service;
    _service.addListener(_onServiceUpdate);
    _onServiceUpdate();
  }
  
  @override
  void dispose() {
    _service.removeListener(_onServiceUpdate);
    super.dispose();
  }
  
  // Getters
  bool get isLoading => _service.isLoading;
  bool get hasError => _service.hasError;
  String? get errorMessage => _service.errorMessage;
  BiometricDataSet? get data => _service.data;
  DateTimeRange get visibleRange => _visibleRange;
  String get selectedRange => _selectedRange;
  DateTime? get selectedDate => _selectedDate;
  
  // Update time range
  void updateTimeRange(String range) {
    _selectedRange = range;
    _visibleRange = _calculateDateRange(range);
    _selectedDate = null; // Reset selected date when range changes
    notifyListeners();
  }
  
  // Handle date selection from chart interaction
  void selectDate(DateTime? date) {
    _selectedDate = date;
    notifyListeners();
  }
  
  // Calculate date range based on selection
  static DateTimeRange _calculateDateRange(String range) {
    final days = timeRanges[range] ?? 30;
    final end = DateTime.now();
    final start = end.subtract(Duration(days: days - 1));
    return DateTimeRange(start: start, end: end);
  }
  
  // Handle service updates
  void _onServiceUpdate() {
    // If we have new data, update the visible range
    if (data != null) {
      _visibleRange = _calculateDateRange(_selectedRange);
    }
    notifyListeners();
  }
  
  // Get data for the current visible range
  BiometricDataSet? get visibleData {
    if (data == null) return null;
    return data!.dateRange(_visibleRange.start, _visibleRange.end);
  }
  
  // Get selected data point if any
  BiometricDataPoint? get selectedDataPoint {
    if (_selectedDate == null || data == null) return null;
    
    // Find the closest data point to the selected date
    BiometricDataPoint? closest;
    var minDiff = double.maxFinite;
    
    for (final point in data!.dataPoints) {
      final diff = (point.timestamp.difference(_selectedDate!).inMinutes).abs();
      if (diff < minDiff) {
        minDiff = diff.toDouble();
        closest = point;
      }
    }
    
    return closest;
  }
  
  // Get mood emoji for a given rating (1-5)
  static String getMoodEmoji(int rating) {
    return ['😔', '🙁', '😐', '🙂', '😊'][rating - 1];
  }
  
  // Load data from service
  Future<void> loadData() => _service.loadData();
}
// Auto-generated comment for commit - 1763734969
// Auto-generated comment for commit - 1763734970
// Auto-generated comment for commit - 1763734972
// Auto-generated comment for commit - 1763734983
// Auto-generated comment for commit - 1763734989
// Auto-generated comment for commit - 1763734992
// Auto-generated comment for commit - 1763735003
