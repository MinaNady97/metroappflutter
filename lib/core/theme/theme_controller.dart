import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persisted light / dark theme toggle.
/// Register once with Get.put(ThemeController(), permanent: true).
class ThemeController extends GetxController {
  static const _prefKey = 'is_dark_mode';

  final _isDark = false.obs;

  /// Reactive: true when dark mode is active.
  bool get isDark => _isDark.value;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final dark = prefs.getBool(_prefKey) ??
        // Default to system preference on first launch
        (WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark);
    _isDark.value = dark;
    _apply(dark);
  }

  Future<void> toggleTheme() async {
    final next = !_isDark.value;
    _isDark.value = next;
    _apply(next);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, next);
  }

  void _apply(bool dark) {
    Get.changeThemeMode(dark ? ThemeMode.dark : ThemeMode.light);
  }
}
