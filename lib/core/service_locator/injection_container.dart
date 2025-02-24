import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

GetIt sl = GetIt.instance;
@InjectableInit(
  asExtension: false,
  preferRelativeImports: true,
)
Future<void> configureDependencies() async => init(sl);
