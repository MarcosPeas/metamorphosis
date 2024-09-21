class CasesUtils {
  static String toTitleCase(String text) {
    return text
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  static String toCamelCase(String text) {
    final words = text.split(' ');
    final firstWord = words.first.toLowerCase();
    final restWords = words.sublist(1).map((word) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join('');
    return firstWord + restWords;
  }

  static String toSnakeCase(String text) {
    return text.replaceAll(' ', '').replaceAllMapped(RegExp(r'^([a-z])|[A-Z]'),
        (Match m) => m[1] == null ? " ${m[0]}" : m[1]?.toUpperCase() ?? '');
  }

  static String toKebabCase(String text) {
    return text.toLowerCase().replaceAll(' ', '-');
  }

  static String toPascalCase(String text) {
    return text
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join('');
  }

  static String toScreamingSnakeCase(String text) {
    return text.toUpperCase().replaceAll(' ', '_');
  }

  static String toScreamingKebabCase(String text) {
    return text.toUpperCase().replaceAll(' ', '-');
  }

  static String toConstantCase(String text) {
    return text.toUpperCase().replaceAll(' ', '_');
  }
}
