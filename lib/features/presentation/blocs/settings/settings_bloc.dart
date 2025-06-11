import 'package:bloc/bloc.dart';
import 'package:eaqarati_app/core/services/settings_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsService _settingsService;

  SettingsBloc(this._settingsService) : super(SettingsInitial()) {
    on<LoadInitialSettings>(_onLoadInitialSettings);
    on<ChangeThemeMode>(_onChangeThemeMode);
    on<ChangeAppLanguage>(_onChangeAppLanguage);
  }

  Future<void> _onLoadInitialSettings(
    LoadInitialSettings event,
    Emitter<SettingsState> emit,
  ) async {
    final themeMode = _settingsService.themeMode;
    final locale = _settingsService.locale;
    emit(SettingsLoaded(themeMode: themeMode, currentLocale: locale));
  }

  Future<void> _onChangeThemeMode(
    ChangeThemeMode event,
    Emitter<SettingsState> emit,
  ) async {
    await _settingsService.setThemeMode(event.themeMode);
    final locale = _settingsService.locale; // Keep current locale
    emit(SettingsLoaded(themeMode: event.themeMode, currentLocale: locale));
  }

  Future<void> _onChangeAppLanguage(
    ChangeAppLanguage event,
    Emitter<SettingsState> emit,
  ) async {
    await _settingsService.setLanguageCode(event.newLocale.languageCode);
    final themeMode = _settingsService.themeMode; // Keep current theme
    emit(SettingsLoaded(themeMode: themeMode, currentLocale: event.newLocale));
  }
}
