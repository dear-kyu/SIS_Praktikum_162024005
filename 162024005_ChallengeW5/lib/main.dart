import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';

import 'screens/splash_screen.dart';

void main() {
  runApp(DevicePreview(enabled: true, builder: (context) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const teaRed = Color(0xFFAA382B);
    const cream = Color(0xFFFFF7F5);
    const darkBrown = Color(0xFF725A52);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mofusand Market',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: cream,
        colorScheme: ColorScheme.fromSeed(
          seedColor: teaRed,
          primary: teaRed,
          secondary: darkBrown,
          surface: const Color(0xFFFFFCFA),
          onSurface: darkBrown,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: cream,
          foregroundColor: darkBrown,
          elevation: 0,
          centerTitle: true,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFFFFCFA),
          labelStyle: const TextStyle(color: darkBrown),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: teaRed, width: 1.5),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: teaRed,
            foregroundColor: Colors.white,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFFFFFCFA),
          selectedItemColor: teaRed,
          unselectedItemColor: Color(0xFF9A8178),
          type: BottomNavigationBarType.fixed,
        ),
      ),
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: const SplashScreen(),
    );
  }
}
