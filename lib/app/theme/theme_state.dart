enum AppThemeMode { light, dark }

class ThemeState {
  final AppThemeMode themeMode;

  const ThemeState({this.themeMode = AppThemeMode.light});

  ThemeState copyWith({AppThemeMode? themeMode}) {
    return ThemeState(themeMode: themeMode ?? this.themeMode);
  }
}
