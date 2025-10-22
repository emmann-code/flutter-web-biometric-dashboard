import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_biometric_dashboard/src/app.dart';
import 'package:web_biometric_dashboard/src/controllers/biometric_controller.dart';
import 'package:web_biometric_dashboard/src/services/biometric_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BiometricService()),
        ChangeNotifierProxyProvider<BiometricService, BiometricController>(
          create: (context) => BiometricController(context.read<BiometricService>()),
          update: (_, service, controller) => controller!..updateService(service),
        ),
      ],
      child: const BiometricsApp(),
    ),
  );
}