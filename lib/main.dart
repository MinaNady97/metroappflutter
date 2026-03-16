import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:metroappflutter/Pages/homepage.dart';
import 'package:metroappflutter/Controllers/homepagecontroller.dart';
import 'package:metroappflutter/Controllers/languagecontroller.dart';
import 'package:metroappflutter/data/datasources/metro_local_datasource.dart';
import 'package:metroappflutter/data/repositories/metro_repository_impl.dart';
import 'package:metroappflutter/domain/repositories/metro_repository.dart';
import 'package:metroappflutter/core/theme/app_theme.dart';
import 'package:metroappflutter/core/theme/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:metroappflutter/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved language preference
  final prefs = await SharedPreferences.getInstance();
  final savedLangCode = prefs.getString('language_code') ?? 'en';

  // ── Register global singletons before the widget tree is built ──

  // This ensures every Get.find<T>() call in widgets succeeds.

  // Data layer
  final datasource = MetroLocalDatasource();
  Get.put<MetroRepository>(
    MetroRepositoryImpl(datasource: datasource),
    permanent: true,
  );

  // Controllers
  Get.put(HomepageController(), permanent: true);
  Get.put(LanguageController(), permanent: true);
  Get.put(ThemeController(), permanent: true);

  runApp(MyApp(savedLangCode: savedLangCode));
}

class MyApp extends StatelessWidget {
  final String savedLangCode;
  MyApp({required this.savedLangCode});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Metro App',
      locale: Locale(savedLangCode),
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.system,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''),
        Locale('ar', ''),
        Locale('fr', ''),
        Locale('es', ''),
        Locale('de', ''),
        Locale('ru', ''),
        Locale('it', ''),
        Locale('pt', ''),
        Locale('zh', ''),
        Locale('tr', ''),
        Locale('ja', ''),
      ],
      home: Homepage(),
    );
  }
}

