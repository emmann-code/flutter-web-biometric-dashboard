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
// Auto-generated comment for commit - 1763734973
// Auto-generated comment for commit - 1763734973
// Auto-generated comment for commit - 1763734978
// Auto-generated comment for commit - 1763734980
// Auto-generated comment for commit - 1763734984
// Auto-generated comment for commit - 1763734985
// Auto-generated comment for commit - 1763734987
// Auto-generated comment for commit - 1763734989
// Auto-generated comment for commit - 1763734991
// Auto-generated comment for commit - 1763734994
// Auto-generated comment for commit - 1763735000
// Auto-generated comment for commit - 1763735008
