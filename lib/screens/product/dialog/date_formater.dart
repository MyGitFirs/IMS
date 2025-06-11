import 'package:flutter/services.dart';

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final oldText = oldValue.text;
    final newText = newValue.text;

    // If the user is backspacing, don't add slashes automatically
    if (newText.length < oldText.length) {
      return newValue;
    }

    // Automatically insert '/' after the second and fifth characters
    if (newText.length == 2 || newText.length == 5) {
      return TextEditingValue(
        text: '$newText/',
        selection: TextSelection.collapsed(offset: newText.length + 1),
      );
    }

    // If the length exceeds 10 (mm/dd/yyyy), ignore additional input
    if (newText.length > 10) {
      return oldValue;
    }

    return newValue;
  }
}
