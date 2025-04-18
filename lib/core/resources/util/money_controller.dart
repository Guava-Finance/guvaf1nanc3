import 'package:flutter/widgets.dart';

class MoneyMaskedTextController extends TextEditingController {
  MoneyMaskedTextController({
    double initialValue = 0.0,
    this.decimalSeparator = '.',
    this.thousandSeparator = ',',
    this.precision = 2,
  }) {
    addListener(() {
      if (text != _lastValue) {
        updateValue(text);
        afterChange(text, numberValue);
      }
    });

    updateValue(initialValue > 0 ? initialValue.round().toString() : '');
  }

  final String decimalSeparator;
  final String thousandSeparator;
  final int precision;

  Function(String maskedValue, double rawValue) afterChange =
      (String maskedValue, double rawValue) {};

  String _lastValue = '';
  // int x = 0;

  String _applyMask(String str) {
    //  if (str.isEmpty) x = 0;
    //v2 if (str == "0.00" || str == ".00") x = 3;
    // log("prev $str");
    //v2 log("prev $str, $x, ${str.substring(str.length - x, str.length)} ");
    // if (x > 0 && str.length > 2) {
    //   str = str.substring(0, str.length - x);
    // }
    if (str.startsWith('0')) {
      //  log("reached here");
      str = str.replaceFirst('0', '');
    }
    // log("value $str");
    if (str.isEmpty || str == '.00') {
      return '';
    } else {
      // str = str.trim().replaceAll(RegExp(r"(\.)+"), ".").replaceAll(",", "");
      //  log("before yy $str");
      str = str
        ..replaceAll(RegExp(r'^(\d+)\.?(\d+)\.?(\d+)$'), r'$1.$2').toString();
      str = str.trim().replaceAll(RegExp(r'(\.)+'), '.').replaceAll(',', '');
      //  log("after yy $str");
      if (str.isEmpty) {
        return '';
      } else {
        var a = str.split('.').toList();

        if (a.length >= 2) {
          var numb = a[0];
          var bx = a.sublist(1).join('.');
          bx = bx.replaceAll('.', '');

          str = '$numb.$bx';
        } else if (a.length == 1) {
          str = a[0];
        }
      }
      //   log("cleaned str $str");
    }

    // Return the extracted double value
    return str;
  }

  void updateValue(String? value) {
    if (value?.isEmpty ?? true) {
      selection = const TextSelection.collapsed(offset: 0);
      return;
    }
// Remove any negative signs from the input
    String sanitizedValue = value?.replaceAll('-', '') ?? '';
    String formattedValue = _applyMask(sanitizedValue);

    if (formattedValue.isEmpty) {
      text = '';
      selection = const TextSelection.collapsed(offset: 0);
      return;
    }
    double numValue = double.tryParse(formattedValue.replaceAll(',', '')) ?? 0;
    if (numValue > 999999999) {
      // 999 million limit
      // Keep the previous valid value
      text = _lastValue;
      selection = TextSelection.fromPosition(
        TextPosition(offset: _lastValue.length),
      );
      return;
    }
    if (formattedValue.isEmpty) {
      //  log("this is emtpy");
      text = '';
      selection = const TextSelection.collapsed(offset: 0);
      return;
    } else {
      List<String> textRepresentation = formattedValue.split('.');
      // Pad the integer part with zeros if necessary
      if (textRepresentation[0].isEmpty) {
        textRepresentation[0] = '0';
      }
      // Insert thousand separators
      for (var i = textRepresentation[0].length - 3; i > 0; i -= 3) {
        textRepresentation[0] = textRepresentation[0].substring(0, i) +
            thousandSeparator +
            textRepresentation[0].substring(i);
      }
      // Handle the decimal part
      if (textRepresentation.length > 1) {
        //v2 x = (textRepresentation[1].length == 1)
        //     ? 1
        //     : (textRepresentation[1].isEmpty)
        //         ? 2
        //         : 0;
        // ignore: lines_longer_than_80_chars
        //v3  textRepresentation[1] = textRepresentation[1].padRight(precision, '0');
        textRepresentation[1] = (textRepresentation[1].length > 1)
            ? textRepresentation[1].substring(0, 2)
            : textRepresentation[1]; //only 2 decimal place
        textRepresentation[0] += decimalSeparator + textRepresentation[1];
      } else {
        //   x = 3;
        //v3 textRepresentation[0] += '${decimalSeparator}00';
      }
      formattedValue = textRepresentation[0];

      //get cursor position
      int cursorPosition = formattedValue.indexOf('.');
      if (cursorPosition == -1) {
        cursorPosition = formattedValue.length;
      } else {
        cursorPosition = formattedValue.length; //v3 cursorPosition + (3 - x);
      }
      _lastValue = formattedValue;
      text = formattedValue;

      // ignore: lines_longer_than_80_chars
      //   log("$cursorPosition,  ${selection.baseOffset}, ${selection.extentOffset}");
      selection = TextSelection.fromPosition(
        TextPosition(offset: cursorPosition),
      );
    }
  }

  double get numberValue {
    if (text.isNotEmpty) {
      String valueString = _applyMask(text);
      if (valueString.isEmpty) {
        //   log("reached here");

        return 0;
      }
      if (valueString == '.') {
        return 0;
      }
      double value = double.tryParse(valueString) ?? 0;
      // Apply precision to the parsed value
      value = double.parse(value.toStringAsFixed(precision));
      //  log("number value $value");
      return value;
    } else {
      return 0.0;
    }
  }
}
