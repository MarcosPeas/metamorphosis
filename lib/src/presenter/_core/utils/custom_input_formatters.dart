import 'package:flutter/services.dart';

class CustomInputFormatters {
  static TextInputFormatter get onlyNumbers =>
      FilteringTextInputFormatter.digitsOnly;

  static TextInputFormatter get onlyAZ09AndUnderscore {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      String text = newValue.text;
      if (text.contains(' ,')) {
        text = text.replaceAll(' ,', ', ');
      }
      if (text.contains('  ')) {
        return oldValue;
      }
      if (text.startsWith(' ')) {
        return oldValue;
      }
      if (text.startsWith(',')) {
        return oldValue;
      }
      if (text.contains(',,')) {
        return oldValue;
      }
      final validCharacters = RegExp(r'^[a-zA-Z0-9_, ]*$');
      if (!validCharacters.hasMatch(text)) {
        return oldValue;
      }
      return newValue.copyWith(text: text.toUpperCase());
    });
  }
}
