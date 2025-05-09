part of 'theme_bloc.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  const factory ThemeEvent.setLightTheme() = SetLightThemeEvent;
  const factory ThemeEvent.setDarkTheme() = SetDarkThemeEvent;
  const factory ThemeEvent.setSystemTheme() = SetSystemThemeEvent;
  const factory ThemeEvent.getTheme() = GetThemeEvent;

  @override
  List<Object?> get props => [];
}

final class SetLightThemeEvent extends ThemeEvent {
  const SetLightThemeEvent();
}
final class SetDarkThemeEvent extends ThemeEvent {
  const SetDarkThemeEvent();
}
final class SetSystemThemeEvent extends ThemeEvent {
  const SetSystemThemeEvent();
}
final class GetThemeEvent extends ThemeEvent {
  const GetThemeEvent();
}
