import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:metroappflutter/Pages/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved language
  final prefs = await SharedPreferences.getInstance();
  String? savedLangCode = prefs.getString('language_code');

  runApp(MyApp(savedLangCode: savedLangCode ?? 'en')); // Default to 'en'
}

class MyApp extends StatelessWidget {
  final String savedLangCode;
  MyApp({required this.savedLangCode});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, // 🔴 removes the DEBUG banner
      title: 'Metro App',
      locale: Locale(savedLangCode),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''),
        Locale('ar', ''),
      ],
      home: Homepage(),
    );
  }
}
