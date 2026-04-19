import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:e_health/app/dependency_injection/configure_injectable.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies({String? environment}) =>
    getIt.init(environment: environment);
