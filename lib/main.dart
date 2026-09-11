import 'package:flutter/material.dart';
import 'package:lavasaas/app/theme/app_theme.dart';
import 'package:lavasaas/features/portal/landing/landing_page.dart';

void main() {
  runApp(const LavaSaaSApp());
}

class LavaSaaSApp extends StatefulWidget {
  const LavaSaaSApp({super.key});

  @override
  State<LavaSaaSApp> createState() => _LavaSaaSAppState();
}

class _LavaSaaSAppState extends State<LavaSaaSApp> {
  @override
  void initState() {
    super.initState();
    LavaTheme.themeMode.addListener(_onThemeModeChanged);
  }

  @override
  void dispose() {
    LavaTheme.themeMode.removeListener(_onThemeModeChanged);
    super.dispose();
  }

  void _onThemeModeChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LavaSaaS',
      debugShowCheckedModeBanner: false,
      theme: LavaTheme.lightTheme,
      darkTheme: LavaTheme.darkTheme,
      themeMode: LavaTheme.themeMode.value,
      home: const LandingPage(),
    );
  }
}
