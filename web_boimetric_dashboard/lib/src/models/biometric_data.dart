import 'package:intl/intl.dart';

class BiometricDataPoint {
  final DateTime timestamp;
  final double? hrv;
  final int? rhr;
  final int? steps;
  final String? journalEntry;
  final int? mood;

  BiometricDataPoint({
    required this.timestamp,
    this.hrv,
    this.rhr,
    this.steps,
    this.journalEntry,
    this.mood,
  });

  factory BiometricDataPoint.fromJson(Map<String, dynamic> json) {
    return BiometricDataPoint(
      timestamp: DateTime.parse(json['timestamp'] as String),
      hrv: json['hrv']?.toDouble(),
      rhr: json['rhr'] as int?,
      steps: json['steps'] as int?,
      journalEntry: json['journalEntry'] as String?,
      mood: json['mood'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      if (hrv != null) 'hrv': hrv,
      if (rhr != null) 'rhr': rhr,
      if (steps != null) 'steps': steps,
      if (journalEntry != null) 'journalEntry': journalEntry,
      if (mood != null) 'mood': mood,
    };
  }

  String get formattedDate => DateFormat('MMM d, y').format(timestamp);
  String get timeAgo => _timeAgo(timestamp);

  String _timeAgo(DateTime d) {
    final now = DateTime.now();
    final difference = now.difference(d);
    
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }
}

class BiometricDataSet {
  final List<BiometricDataPoint> dataPoints;
  
  BiometricDataSet(this.dataPoints);
  
  // Get data for a specific date range
  BiometricDataSet dateRange(DateTime start, DateTime end) {
    return BiometricDataSet(
      dataPoints.where((point) => 
        point.timestamp.isAfter(start) && 
        point.timestamp.isBefore(end.add(const Duration(days: 1)))
      ).toList(),
    );
  }
  
  // Calculate 7-day rolling average for HRV
  Map<DateTime, double> getRollingAverage() {
    if (dataPoints.isEmpty) return {};
    
    final result = <DateTime, double>{};
    final window = <double>[];
    
    for (var i = 0; i < dataPoints.length; i++) {
      final point = dataPoints[i];
      if (point.hrv != null) {
        window.add(point.hrv!);
        
        // Keep only last 7 days
        while (window.length > 7) {
          window.removeAt(0);
        }
        
        if (window.isNotEmpty) {
          final avg = window.reduce((a, b) => a + b) / window.length;
          result[point.timestamp] = avg;
        }
      }
    }
    
    return result;
  }
  
  // Calculate standard deviation for HRV
  Map<DateTime, double> getStandardDeviation() {
    if (dataPoints.isEmpty) return {};
    
    final result = <DateTime, double>{};
    final window = <double>[];
    
    for (var i = 0; i < dataPoints.length; i++) {
      final point = dataPoints[i];
      if (point.hrv != null) {
        window.add(point.hrv!);
        
        // Keep only last 7 days
        while (window.length > 7) {
          window.removeAt(0);
        }
        
        if (window.isNotEmpty) {
          final avg = window.reduce((a, b) => a + b) / window.length;
          final variance = window.map((x) => (x - avg) * (x - avg))
              .reduce((a, b) => a + b) / window.length;
          result[point.timestamp] = variance;
        }
      }
    }
    
    return result;
  }
  
  // Get journal entries with their positions
  List<MapEntry<DateTime, String>> getJournalEntries() {
    return dataPoints
        .where((point) => point.journalEntry != null && point.journalEntry!.isNotEmpty)
        .map((point) => MapEntry(point.timestamp, point.journalEntry!))
        .toList();
  }
  
  // Get mood data points
  List<MapEntry<DateTime, int>> getMoodData() {
    return dataPoints
        .where((point) => point.mood != null)
        .map((point) => MapEntry(point.timestamp, point.mood!))
        .toList();
  }
}
// Auto-generated comment for commit - 1763734976
// Auto-generated comment for commit - 1763734979
// Auto-generated comment for commit - 1763734982
// Auto-generated comment for commit - 1763734982
// Auto-generated comment for commit - 1763734993
// Auto-generated comment for commit - 1763735002
// Auto-generated comment for commit - 1763735004
// Auto-generated comment for commit - 1763735017
// Auto-generated comment for commit - 1763735020
// Auto-generated comment for commit - 1763735024
// Auto-generated comment for commit - 1763735026
// Auto-generated comment for commit - 1763735051
// Auto-generated comment for commit - 1763735077
// Auto-generated comment for commit - 1763735092
// Auto-generated comment for commit - 1763735096
// Auto-generated comment for commit - 1763735097
// Auto-generated comment for commit - 1763735100
// Auto-generated comment for commit - 1763735102
// Auto-generated comment for commit - 1763735112
// Auto-generated comment for commit - 1763735114
// Auto-generated comment for commit - 1763735126
// Auto-generated comment for commit - 1763735127
// Auto-generated comment for commit - 1763735131
// Auto-generated comment for commit - 1763735138
// Auto-generated comment for commit - 1763735139
// Auto-generated comment for commit - 1763735142
// Auto-generated comment for commit - 1763735153
// Auto-generated comment for commit - 1763735170
// Auto-generated comment for commit - 1763735178
// Auto-generated comment for commit - 1763735180
// Auto-generated comment for commit - 1763735184
// Auto-generated comment for commit - 1780350422
// Auto-generated comment for commit - 1780350428
// Auto-generated comment for commit - 1780350438
// Auto-generated comment for commit - 1780350441
// Auto-generated comment for commit - 1780350444
// Auto-generated comment for commit - 1780350448
// Auto-generated comment for commit - 1780350481
// Auto-generated comment for commit - 1780350495
// Auto-generated comment for commit - 1780350503
// Auto-generated comment for commit - 1780350507
// Auto-generated comment for commit - 1780350529
// Auto-generated comment for commit - 1780350530
// Auto-generated comment for commit - 1780350530
// Auto-generated comment for commit - 1780350531
// Auto-generated comment for commit - 1780350533
// Auto-generated comment for commit - 1780350533
// Auto-generated comment for commit - 1780350534
// Auto-generated comment for commit - 1780350557
// Auto-generated comment for commit - 1780350559
// Auto-generated comment for commit - 1780350570
// Auto-generated comment for commit - 1780350579
// Auto-generated comment for commit - 1780350581
// Auto-generated comment for commit - 1780350586
// Auto-generated comment for commit - 1780350591
// Auto-generated comment for commit - 1780350596
// Auto-generated comment for commit - 1780350607
// Auto-generated comment for commit - 1780350619
// Auto-generated comment for commit - 1780350620
// Auto-generated comment for commit - 1780350622
