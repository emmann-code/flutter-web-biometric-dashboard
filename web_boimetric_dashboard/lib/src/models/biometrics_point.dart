class BiometricsPoint {
  final DateTime date;
  final double? hrv;
  final double? rhr;
  final int? steps;
  final int? sleepScore;


  BiometricsPoint({required this.date, this.hrv, this.rhr, this.steps, this.sleepScore});


  factory BiometricsPoint.fromJson(Map<String, dynamic> json) => BiometricsPoint(
    date: DateTime.parse(json['date'] as String),
    hrv: (json['hrv'] as num?)?.toDouble(),
    rhr: (json['rhr'] as num?)?.toDouble(),
    steps: (json['steps'] as num?)?.toInt(),
    sleepScore: (json['sleepScore'] as num?)?.toInt(),
  );
}// Auto-generated comment for commit - 1763734963
// Auto-generated comment for commit - 1763734965
