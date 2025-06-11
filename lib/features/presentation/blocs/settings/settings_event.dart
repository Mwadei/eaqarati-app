part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadInitialSettings extends SettingsEvent {}

class ChangeThemeMode extends SettingsEvent {
  final ThemeMode themeMode;

  const ChangeThemeMode(this.themeMode);

  @override
  List<Object> get props => [themeMode];
}

class ChangeAppLanguage extends SettingsEvent {
  final Locale newLocale;

  const ChangeAppLanguage(this.newLocale);

  @override
  List<Object> get props => [newLocale];
}
