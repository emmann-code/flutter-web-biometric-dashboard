import 'package:flutter/foundation.dart';

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
// Auto-generated comment for commit - 1763734978
// Auto-generated comment for commit - 1763734982
// Auto-generated comment for commit - 1763734988
// Auto-generated comment for commit - 1763735012
// Auto-generated comment for commit - 1763735014
// Auto-generated comment for commit - 1763735022
// Auto-generated comment for commit - 1763735029
// Auto-generated comment for commit - 1763735035
// Auto-generated comment for commit - 1763735054
// Auto-generated comment for commit - 1763735060
// Auto-generated comment for commit - 1763735063
// Auto-generated comment for commit - 1763735066
// Auto-generated comment for commit - 1763735074
// Auto-generated comment for commit - 1763735078
// Auto-generated comment for commit - 1763735090
// Auto-generated comment for commit - 1763735123
// Auto-generated comment for commit - 1763735124
// Auto-generated comment for commit - 1763735131
// Auto-generated comment for commit - 1763735132
// Auto-generated comment for commit - 1763735135
// Auto-generated comment for commit - 1763735138
// Auto-generated comment for commit - 1763735141
