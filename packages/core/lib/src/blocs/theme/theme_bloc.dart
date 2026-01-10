import 'package:core/src/shared_preferences/shared_preferences_abstract.dart';
import 'package:dependencies/dependencies.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc({required SharedPreferencesAbstract sharedPreferences})
      : _sharedPreferences = sharedPreferences,
        super(const ThemeState.system()) {
    on<SetLightThemeEvent>(_setLightTheme);
    on<SetDarkThemeEvent>(_setDarkTheme);
    on<SetSystemThemeEvent>(_setSystemTheme);
    on<GetThemeEvent>(_getTheme);
  }
  static const String _kBrightnessSetings = 'BRIGHTNESS_SETTINGS';
  static const String _kLight = 'LIGHT';
  static const String _kDark = 'DARK';

  final SharedPreferencesAbstract _sharedPreferences;

  Future<void> _setLightTheme(
    SetLightThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    await _sharedPreferences.setString(_kBrightnessSetings, _kLight);
    emit(const ThemeState.light());
  }

  Future<void> _setDarkTheme(
    SetDarkThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    await _sharedPreferences.setString(_kBrightnessSetings, _kDark);
    emit(const ThemeState.dark());
  }

  Future<void> _setSystemTheme(
    SetSystemThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    await _sharedPreferences.remove(_kBrightnessSetings);
    emit(const ThemeState.system());
  }

  Future<void> _getTheme(GetThemeEvent event, Emitter<ThemeState> emit) async {
    final theme = _sharedPreferences.getString(_kBrightnessSetings);
    if (theme == _kLight) {
      emit(const ThemeState.light());
    } else if (theme == _kDark) {
      emit(const ThemeState.dark());
    } else {
      emit(const ThemeState.system());
    }
  }
}
