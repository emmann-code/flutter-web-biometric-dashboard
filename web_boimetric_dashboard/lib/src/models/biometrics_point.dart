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
// Auto-generated comment for commit - 1763735009
// Auto-generated comment for commit - 1763735011
// Auto-generated comment for commit - 1763735021
// Auto-generated comment for commit - 1763735021
// Auto-generated comment for commit - 1763735022
// Auto-generated comment for commit - 1763735037
// Auto-generated comment for commit - 1763735040
// Auto-generated comment for commit - 1763735042
// Auto-generated comment for commit - 1763735042
// Auto-generated comment for commit - 1763735046
// Auto-generated comment for commit - 1763735050
// Auto-generated comment for commit - 1763735056
// Auto-generated comment for commit - 1763735059
// Auto-generated comment for commit - 1763735060
// Auto-generated comment for commit - 1763735067
// Auto-generated comment for commit - 1763735085
// Auto-generated comment for commit - 1763735086
// Auto-generated comment for commit - 1763735090
// Auto-generated comment for commit - 1763735095
// Auto-generated comment for commit - 1763735099
// Auto-generated comment for commit - 1763735108
// Auto-generated comment for commit - 1763735109
// Auto-generated comment for commit - 1763735114
// Auto-generated comment for commit - 1763735116
// Auto-generated comment for commit - 1763735117
// Auto-generated comment for commit - 1763735119
