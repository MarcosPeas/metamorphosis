extension NavigationExtension on String {
  String plural() {
    final Map<String, String> pluralExceptions = {
      'child': 'children',
      'Child': 'Children',
      'person': 'people',
      'Person': 'People',
    };
    final esRules = [
      's', 'ss', 'x', 'z', 'ch', 'sh'
    ];
    if (pluralExceptions.containsKey(this)) {
      return pluralExceptions[this]!;
    }
    if (endsWith('y')) {
      return replaceRange(length - 1, length, 'ies');
    } else if (esRules.any((rule) => endsWith(rule))) {
      return '${this}es';
    } else {
      return '${this}s';
    }
  }
}