part of 'theme_bloc.dart';

sealed class ThemeState extends Equatable {
  const ThemeState();

  const factory ThemeState.dark() = ThemeDark;
  const factory ThemeState.light() = ThemeLight;
  const factory ThemeState.system() = ThemeSystem;

  @override
  List<Object> get props => [];
}

final class ThemeDark extends ThemeState {
  const ThemeDark();
}

final class ThemeLight extends ThemeState {
  const ThemeLight();
}

final class ThemeSystem extends ThemeState {
  const ThemeSystem();
}

