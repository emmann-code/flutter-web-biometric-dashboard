import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../models/biometrics_point.dart';
import '../models/journal_entry.dart';


class AssetLoader {
  final Random _rng = Random(42);


  /// State holders
  List<BiometricsPoint>? biometrics;
  List<JournalEntry>? journals;
  bool loading = false;
  String? error;


  Future<void> loadAll() async {
    loading = true;
    error = null;
    try {
      biometrics = await _loadJsonWithFlakiness('assets/biometrics_90d.json', _parseBiometrics);
      journals = await _loadJsonWithFlakiness('assets/journals.json', _parseJournals);
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
    }
  }


  Future<T> _loadJsonWithFlakiness<T>(String path, T Function(String) parser) async {
// Inject latency 700-1200ms
    final latency = 700 + _rng.nextInt(500);
    await Future.delayed(Duration(milliseconds: latency));


// ~10% failure
    if (_rng.nextDouble() < 0.10) throw Exception('Simulated asset load failure for $path');


    final raw = await rootBundle.loadString(path);
    return parser(raw);
  }


  List<BiometricsPoint> _parseBiometrics(String raw) {
    final data = json.decode(raw) as List<dynamic>;
    return data.map((e) => BiometricsPoint.fromJson(e as Map<String, dynamic>)).toList();
  }


  List<JournalEntry> _parseJournals(String raw) {
    final data = json.decode(raw) as List<dynamic>;
    return data.map((e) => JournalEntry.fromJson(e as Map<String, dynamic>)).toList();
  }
}// Auto-generated comment for commit - 1763734993
// Auto-generated comment for commit - 1763734999
// Auto-generated comment for commit - 1763735015
// Auto-generated comment for commit - 1763735015
// Auto-generated comment for commit - 1763735016
// Auto-generated comment for commit - 1763735028
// Auto-generated comment for commit - 1763735030
// Auto-generated comment for commit - 1763735038
// Auto-generated comment for commit - 1763735040
// Auto-generated comment for commit - 1763735043
// Auto-generated comment for commit - 1763735045
// Auto-generated comment for commit - 1763735048
// Auto-generated comment for commit - 1763735051
// Auto-generated comment for commit - 1763735071
// Auto-generated comment for commit - 1763735073
// Auto-generated comment for commit - 1763735076
// Auto-generated comment for commit - 1763735084
// Auto-generated comment for commit - 1763735105
// Auto-generated comment for commit - 1763735107
// Auto-generated comment for commit - 1763735109
// Auto-generated comment for commit - 1763735122
// Auto-generated comment for commit - 1763735143
// Auto-generated comment for commit - 1763735154
// Auto-generated comment for commit - 1763735155
// Auto-generated comment for commit - 1763735167
// Auto-generated comment for commit - 1763735177
// Auto-generated comment for commit - 1780350397
// Auto-generated comment for commit - 1780350398
// Auto-generated comment for commit - 1780350399
// Auto-generated comment for commit - 1780350402
// Auto-generated comment for commit - 1780350417
// Auto-generated comment for commit - 1780350442
// Auto-generated comment for commit - 1780350442
// Auto-generated comment for commit - 1780350452
// Auto-generated comment for commit - 1780350469
// Auto-generated comment for commit - 1780350473
// Auto-generated comment for commit - 1780350494
// Auto-generated comment for commit - 1780350509
