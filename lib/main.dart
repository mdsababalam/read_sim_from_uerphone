import 'package:flutter/material.dart';
import 'package:technical_task_app/splash_screen.dart';

void main() {
  runApp(const FlutterAssessmentApp());
}

class FlutterAssessmentApp extends StatelessWidget {
  const FlutterAssessmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Technical Assessment',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
