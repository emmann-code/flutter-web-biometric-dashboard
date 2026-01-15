import '../models/biometrics_point.dart';


/// Simple fast aggregator/decimator. Strategy: bucket into N buckets and output
/// for each bucket: the min and max points preserved plus the bucket mean point.
/// This keeps min/max visible while reducing point count.
List<BiometricsPoint> bucketDecimate(List<BiometricsPoint> data, int maxPoints) {
  if (data.length <= maxPoints) return data;
  final int bucketSize = (data.length / maxPoints).ceil();
  final List<BiometricsPoint> out = [];


  for (int start = 0; start < data.length; start += bucketSize) {
    final end = (start + bucketSize).clamp(0, data.length);
    final bucket = data.sublist(start, end);


// preserve min and max (by hrv if present; fallback to rhr/steps order)
    BiometricsPoint? minPoint;
    BiometricsPoint? maxPoint;
    double? minVal;
    double? maxVal;


    for (final p in bucket) {
      final val = p.hrv ?? p.rhr ?? (p.steps?.toDouble());
      if (val == null) continue;
      if (minPoint == null || val < (minVal ?? double.infinity)) {
        minVal = val;
        minPoint = p;
      }
      if (maxPoint == null || val > (maxVal ?? double.negativeInfinity)) {
        maxVal = val;
        maxPoint = p;
      }
    }


// mean of numeric columns
    double sumHrv = 0;
    int cntHrv = 0;
    double sumRhr = 0;
    int cntRhr = 0;
    int sumSteps = 0;
    int cntSteps = 0;


    for (final p in bucket) {
      if (p.hrv != null) { sumHrv += p.hrv!; cntHrv++; }
      if (p.rhr != null) { sumRhr += p.rhr!; cntRhr++; }
      if (p.steps != null) { sumSteps += p.steps!; cntSteps++; }
    }


    final mean = BiometricsPoint(
      date: bucket[(bucket.length / 2).floor()].date,
      hrv: cntHrv > 0 ? sumHrv / cntHrv : null,
      rhr: cntRhr > 0 ? sumRhr / cntRhr : null,
      steps: cntSteps > 0 ? (sumSteps / cntSteps).round() : null,
    );


    if (minPoint != null) out.add(minPoint);
    out.add(mean);
    if (maxPoint != null) out.add(maxPoint);
  }


  return out;
}// Auto-generated comment for commit - 1763734966
// Auto-generated comment for commit - 1763735020
// Auto-generated comment for commit - 1763735034
// Auto-generated comment for commit - 1763735038
// Auto-generated comment for commit - 1763735039
// Auto-generated comment for commit - 1763735047
// Auto-generated comment for commit - 1763735052
// Auto-generated comment for commit - 1763735053
// Auto-generated comment for commit - 1763735073
// Auto-generated comment for commit - 1763735084
// Auto-generated comment for commit - 1763735086
// Auto-generated comment for commit - 1763735088
// Auto-generated comment for commit - 1763735094
// Auto-generated comment for commit - 1763735107
// Auto-generated comment for commit - 1763735111
// Auto-generated comment for commit - 1763735115
// Auto-generated comment for commit - 1763735128
// Auto-generated comment for commit - 1763735128
// Auto-generated comment for commit - 1763735135
// Auto-generated comment for commit - 1763735139
// Auto-generated comment for commit - 1763735152
// Auto-generated comment for commit - 1763735154
// Auto-generated comment for commit - 1763735159
// Auto-generated comment for commit - 1763735160
// Auto-generated comment for commit - 1763735165
// Auto-generated comment for commit - 1763735168
// Auto-generated comment for commit - 1763735178
// Auto-generated comment for commit - 1780350405
