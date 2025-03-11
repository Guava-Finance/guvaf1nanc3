import 'package:get_it/get_it.dart';
import 'package:guava/core/service_locator/injection_container.config.dart';
import 'package:injectable/injectable.dart';

GetIt sl = GetIt.instance;
@InjectableInit(
  asExtension: false,
  preferRelativeImports: true,
  initializerName: 'init',
)
Future<void> configureDependencies() async => init(sl);
