import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'controllers/biometric_controller.dart';
import 'models/biometric_data.dart';
import 'widgets/chart_stack.dart';

class BiometricsApp extends StatelessWidget {
  const BiometricsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biometrics Dashboard',
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BiometricController>().loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BiometricController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Biometrics Dashboard'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              value: controller.selectedRange,
              items: BiometricController.timeRanges.keys.map((range) {
                return DropdownMenuItem(value: range, child: Text(range));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.updateTimeRange(value);
                }
              },
              underline: const SizedBox(),
              icon: const Icon(Icons.arrow_drop_down),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.isLoading
                ? null
                : () => controller.loadData(),
          ),
        ],
      ),
      body: _buildBody(controller),
    );
  }

  Widget _buildBody(BiometricController controller) {
    if (controller.isLoading && controller.data == null) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (controller.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Text(
              'Failed to load data: ${controller.errorMessage ?? 'Unknown error'}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: controller.loadData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    
    if (controller.data == null || controller.data!.dataPoints.isEmpty) {
      return const Center(child: Text('No data available'));
    }
    
    final visibleData = controller.visibleData;
    if (visibleData == null || visibleData.dataPoints.isEmpty) {
      return const Center(child: Text('No data available for the selected time range'));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          if (visibleData.dataPoints.any((point) => point.hrv != null))
            ChartStack(
              title: 'Heart Rate Variability (ms)',
              color: Colors.blue,
              showRollingAverage: true,
              showBands: true,
              minY: 0,
              maxY: 100,
              valueExtractor: (point) => point.hrv ?? 0,
              valueFormatter: (value) => '${value.toStringAsFixed(0)} ms',
            ),
          
          if (visibleData.dataPoints.any((point) => point.rhr != null))
            ChartStack(
              title: 'Resting Heart Rate (bpm)',
              color: Colors.green,
              showRollingAverage: true,
              minY: 40,
              maxY: 100,
              valueExtractor: (point) => point.rhr?.toDouble() ?? 0,
              valueFormatter: (value) => '${value.toStringAsFixed(0)} bpm',
            ),
          
          if (visibleData.dataPoints.any((point) => point.steps != null))
            ChartStack(
              title: 'Daily Steps',
              color: Colors.orange,
              minY: 0,
              maxY: 20000,
              valueExtractor: (point) => point.steps?.toDouble() ?? 0,
              valueFormatter: (value) => '${(value / 1000).toStringAsFixed(1)}k',
            ),

          if (controller.selectedDataPoint != null)
            _buildSelectedPointDetails(controller.selectedDataPoint!),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSelectedPointDetails(BiometricDataPoint point) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('EEEE, MMMM d, y').format(point.timestamp),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildMetricRow(
              'HRV',
              '${point.hrv?.toStringAsFixed(1) ?? 'N/A'} ms',
              Colors.blue,
            ),
            _buildMetricRow('RHR', '${point.rhr ?? 'N/A'} bpm', Colors.green),
            _buildMetricRow(
              'Steps',
              '${point.steps?.toStringAsFixed(0) ?? 'N/A'}',
              Colors.orange,
            ),
            if (point.mood != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.mood, color: Colors.amber),
                  const SizedBox(width: 8),
                  Text(
                    'Mood: ${BiometricController.getMoodEmoji(point.mood!)} ${point.mood!}/5',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
            if (point.journalEntry?.isNotEmpty ?? false) ...[
              const SizedBox(height: 8),
              Text(
                'Note: ${point.journalEntry}',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text('$label:'),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
// Auto-generated comment for commit - 1763734966
// Auto-generated comment for commit - 1763735047
// Auto-generated comment for commit - 1763735058
// Auto-generated comment for commit - 1763735059
// Auto-generated comment for commit - 1763735064
// Auto-generated comment for commit - 1763735066
