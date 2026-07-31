import 'package:flutter/material.dart';

void main() {
  runApp(const SystemTestApp());
}

/// Minimal system test app - replaces full app for debugging
class SystemTestApp extends StatelessWidget {
  const SystemTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'System Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const Scaffold(
        body: Center(
          child: Text('System Test'),
        ),
      ),
    );
  }
}
