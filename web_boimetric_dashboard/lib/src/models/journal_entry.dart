
class JournalEntry {
  final String id;
  final DateTime date;
  final Map<String, dynamic> metrics;
  final String? notes;

  JournalEntry({
    required this.id,
    required this.date,
    required this.metrics,
    this.notes,
  });

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      metrics: Map<String, dynamic>.from(json['metrics'] as Map),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'metrics': metrics,
      if (notes != null) 'notes': notes,
    };
  }
}
// Auto-generated comment for commit - 1780350394
// Auto-generated comment for commit - 1780350397
// Auto-generated comment for commit - 1780350406
// Auto-generated comment for commit - 1780350408
// Auto-generated comment for commit - 1780350412
// Auto-generated comment for commit - 1780350413
// Auto-generated comment for commit - 1780350416
// Auto-generated comment for commit - 1780350422
// Auto-generated comment for commit - 1780350439
// Auto-generated comment for commit - 1780350453
// Auto-generated comment for commit - 1780350462
// Auto-generated comment for commit - 1780350467
// Auto-generated comment for commit - 1780350469
// Auto-generated comment for commit - 1780350480
// Auto-generated comment for commit - 1780350488
// Auto-generated comment for commit - 1780350497
// Auto-generated comment for commit - 1780350502
// Auto-generated comment for commit - 1780350511
// Auto-generated comment for commit - 1780350516
// Auto-generated comment for commit - 1780350530
// Auto-generated comment for commit - 1780350532
// Auto-generated comment for commit - 1780350535
// Auto-generated comment for commit - 1780350536
// Auto-generated comment for commit - 1780350547
// Auto-generated comment for commit - 1780350558
// Auto-generated comment for commit - 1780350564
// Auto-generated comment for commit - 1780350564
// Auto-generated comment for commit - 1780350569
// Auto-generated comment for commit - 1780350570
// Auto-generated comment for commit - 1780350571
// Auto-generated comment for commit - 1780350572
// Auto-generated comment for commit - 1780350572
