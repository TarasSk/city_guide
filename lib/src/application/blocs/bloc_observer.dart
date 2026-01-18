import 'package:city_guide_app/src/application/logger/logger_abstract.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  AppBlocObserver({
    required LoggerAbstract logger,
    required FirebaseAnalytics analytics,
  })  : _logger = logger,
        _analytics = analytics;

  final LoggerAbstract _logger;
  final FirebaseAnalytics _analytics;

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    _logger.info('onCreate -- ${bloc.runtimeType}');
    _analytics.logEvent(
      name: 'blocCreate',
      parameters: {
        'bloc': bloc.runtimeType.toString(),
        'state': bloc.state.toString(),
      },
    );
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    _logger.info('onChange -- ${bloc.runtimeType}, $change');
    _analytics.logEvent(
      name: 'blocChange',
      parameters: {
        'bloc': bloc.runtimeType.toString(),
        'change': change.toString(),
      },
    );
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    _logger.info('onEvent -- ${bloc.runtimeType}, $event');
    _analytics.logEvent(
      name: 'blocEvent',
      parameters: {
        'bloc': bloc.runtimeType.toString(),
        'event': event.toString(),
      },
    );
  }

  @override
  void onTransition(
    Bloc bloc,
    Transition transition,
  ) {
    super.onTransition(bloc, transition);
    _logger.info('onTransition -- ${bloc.runtimeType}, $transition');
    _analytics.logEvent(
      name: 'blocTransition',
      parameters: {
        'bloc': bloc.runtimeType.toString(),
        'transition': transition.toString(),
      },
    );
  }

  @override
  void onError(
    BlocBase bloc,
    Object error,
    StackTrace stackTrace,
  ) {
    _logger.error('onError -- ${bloc.runtimeType}, $error');
    super.onError(
      bloc,
      error,
      stackTrace,
    );
    _analytics.logEvent(
      name: 'blocError',
      parameters: {
        'bloc': bloc.runtimeType.toString(),
        'error': error.toString(),
        'stackTrace': stackTrace.toString(),
      },
    );
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    _logger.info('onClose -- ${bloc.runtimeType}');
  }
}
