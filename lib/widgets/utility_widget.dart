import 'dart:ui';

Color hexColor(String hexColor) {
  String hex = hexColor.toUpperCase().replaceAll('#', '');
  if (hexColor.length >= 6) {
    hex = '0XFF$hex';
  }
  final int? temp = int.tryParse(hex);
  return Color(temp ?? 0xFFE41613);
}