import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  static const _prefKey = 'language_code';

  var selectedLanguage = 'en'.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefKey) ?? 'en';
    selectedLanguage.value = saved;
    Get.updateLocale(Locale(saved));
  }

  Future<void> switchLanguage(String langCode) async {
    selectedLanguage.value = langCode;
    Get.updateLocale(Locale(langCode));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, langCode);
  }
}
