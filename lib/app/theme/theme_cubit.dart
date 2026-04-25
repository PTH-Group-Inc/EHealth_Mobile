import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:e_health/app/theme/theme_state.dart';

@singleton
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState());

  void setTheme(AppThemeMode mode) {
    emit(state.copyWith(themeMode: mode));
  }

  void toggleTheme() {
    final newMode = state.themeMode == AppThemeMode.light 
        ? AppThemeMode.dark 
        : AppThemeMode.light;
    emit(state.copyWith(themeMode: newMode));
  }
}
