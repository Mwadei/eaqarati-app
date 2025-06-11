part of 'settings_bloc.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final ThemeMode themeMode;
  final Locale currentLocale;

  const SettingsLoaded({required this.themeMode, required this.currentLocale});

  @override
  List<Object> get props => [themeMode, currentLocale];
}
