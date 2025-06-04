import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

class SettingsService {
  // This class can be used to manage application settings.
  // For example, you can add methods to get and set user preferences,
  // manage themes, or handle other configuration options.

  static final String _settingBoxName = 'app_settings_v1';
  static final String _languageKey = 'language_code';
  static final String _themeKey = 'theme_mode';

  late Box _settingsBox;

  // Initialize the settings service
  Future<void> init() async {
    // Open the Hive box for settings
    _settingsBox = await Hive.openBox(_settingBoxName);
  }

  //language management
  String get languageCode {
    return _settingsBox.get(_languageKey, defaultValue: 'ar');
  }

  Future<void> setLanguageCode(String code) async {
    await _settingsBox.put(_languageKey, code);
  }

  Locale get locale {
    return Locale(languageCode);
  }

  // Theme management
  ThemeMode get themeMode {
    final themeIndex = _settingsBox.get(
      _themeKey,
      defaultValue: ThemeMode.system.index,
    );

    Logger().d('[SettingsService] Reading themeIndex from Hive: $themeIndex');
    if (themeIndex >= 0 && themeIndex < ThemeMode.values.length) {
      return ThemeMode.values[themeIndex];
    } else {
      return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    Logger().d('[SettingsService] Saving themeMode to Hive: ${mode.index}');
    await _settingsBox.put(_themeKey, mode.index);
  }
}
