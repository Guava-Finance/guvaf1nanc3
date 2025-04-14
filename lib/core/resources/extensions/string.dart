import 'package:dart_casing/dart_casing.dart';

extension StringExt on String {
  String get pathToName {
    final name = split('/');

    return '_${name.map((e) => Casing.titleCase(e)).join()}';
  }
}
