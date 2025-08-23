import 'package:flutter/services.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';

class CustomInputFormatters {
  static TextInputFormatter get onlyNumbers {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      String text = newValue.text;
      if (text.isEmpty) {
        return newValue;
      }
      final regex = RegExp(r'^[+-]?\d*$');
      if (!regex.hasMatch(text)) {
        return oldValue;
      }
      return newValue;
    });
  }

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

  static TextInputFormatter get decimalOnly {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      final regExp = RegExp(r'^[+-]?\d*([.,]\d*)?$');
      final text = newValue.text;
      if (regExp.hasMatch(text)) {
        return newValue;
      }
      return oldValue;
    });
  }

  static TextInputFormatter fromType(ValueObject vo, String comparator) {
    if (vo.isAllInt) {
      return onlyNumbers;
    }
    if (vo.isAllDecimal) {
      return decimalOnly;
    }
    if (vo.isString) {
      return _forString(comparator);
    }
    return TextInputFormatter.withFunction((oldValue, newValue) {
      return newValue;
    });
  }

  static TextInputFormatter _forString(String comparator) {
    final integerInputs = ['minLength', 'maxLength', 'lengthEquals'];
    if (integerInputs.contains(comparator)) {
      return FilteringTextInputFormatter.digitsOnly;
    }
    return TextInputFormatter.withFunction((oldValue, newValue) {
      return newValue;
    });
  }

  static bool needInput(String comparator) {
    final noNeedInput = [
      'isEmpty',
      'isNotEmpty',
      'isNull',
      'isNotNull',
      'isTrue',
      'isFalse',
      'isCnpj',
      'isCpf',
      'isEmail',
      'isUrl',
      'isPhone',
      'isCep',
      'isDate',
      'isDateTime',
      'isEnum',
      'isBoolean',
    ];
    return !noNeedInput.contains(comparator);
  }
}

enum InputType {
  onlyNumbers,
  onlyAZ09AndUnderscore,
  text,
  data,
  dateTime,
  time,
}
