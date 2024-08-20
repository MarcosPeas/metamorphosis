/*class ComparatorOperators {
  static List<String> types = [
    'String',
    'Integer',
    'Long',
    'Double',
    'Boolean',
    'Date',
    'Time',
    'DateTime',
    'List',
  ];

  static final List<String> _stringOperators = [
    'equals',
    'is empty',
    'contains',
    'starts with',
    'ends with',
    'not equals',
    'is not empty',
    'not contains',
    'not starts with',
    'not ends with',
    'length equals',
    'length not equals',
    'length greater than',
    'length greater than or equals',
    'length less than',
    'length less than or equals',
    'matches',
  ];

  static final List<String> _numberOperators = [
    'equals',
    'not equals',
    'greater than',
    'greater than or equals',
    'less than',
    'less than or equals',
  ];

  static final List<String> _booleanOperators = [
    'equals',
    'not equals',
  ];

  static final List<String> _dateOperators = [
    'equals',
    'not equals',
    'greater than',
    'greater than or equals',
    'less than',
    'less than or equals',
  ];

  static final List<String> _timeOperators = [
    'equals',
    'not equals',
    'greater than',
    'greater than or equals',
    'less than',
    'less than or equals',
  ];

  static final List<String> _dateTimeOperators = [
    'equals',
    'not equals',
    'greater than',
    'greater than or equals',
    'less than',
    'less than or equals',
  ];

  static final List<String> _listOperators = [
    'contains',
    'not contains',
  ];

  static List<String> getOperators(String type) {
    switch (type) {
      case 'String':
        return _stringOperators;
      case 'Integer':
      case 'Long':
      case 'Double':
        return _numberOperators;
      case 'Boolean':
        return _booleanOperators;
      case 'Date':
        return _dateOperators;
      case 'Time':
        return _timeOperators;
      case 'DateTime':
        return _dateTimeOperators;
      case 'List':
        return _listOperators;
      default:
        return [];
    }
  }
}
*/