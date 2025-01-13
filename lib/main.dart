// lib/main.dart
import 'package:card_scanner/screens/camer_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(BusinessCardScannerApp());

class BusinessCardScannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      home: CameraScreen(),
    );
  }
}