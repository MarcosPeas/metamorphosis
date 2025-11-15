import 'package:metamorphis/src/domain/data_class/entities/data_class.dart';
import 'package:uuid/uuid.dart';

class UseCase {
  late final String id;
  String name;
  UseCaseType useCaseType;
  String searchField;
  String orderByField;
  bool isAscending;
  final String entityId;
  DataClass? input;
  DataClass? output;
  late final List<String> _jwtRules;

  UseCase({
    String? id,
    required this.name,
    required this.useCaseType,
    this.searchField = '',
    this.orderByField = '',
    this.isAscending = true,
    this.input,
    this.output,
    required this.entityId,
    required List<String> jwtRules,
  }) {
    this.id = id ?? const Uuid().v4();
    _jwtRules = jwtRules;
  }

  void addJwtRules(String jwtRules) {
    _jwtRules.clear();
    String rules = jwtRules.trim().replaceAll(' ', '');
    List<String> rulesList = rules.split(',');
    rulesList.removeWhere((rule) => rule.isEmpty);
    _jwtRules.addAll(rulesList);
  }

  List<String> get jwtRules => _jwtRules;

  UseCase copyWith() {
    return UseCase(
      id: id,
      name: name,
      useCaseType: useCaseType,
      entityId: entityId,
      jwtRules: jwtRules,
      input: input,
      isAscending: isAscending,
      orderByField: orderByField,
      output: output,
      searchField: searchField,      
    );
  }
}

enum UseCaseType {
  create('create'),
  findById('findById'),
  filterOne('filterOne'),
  update('update'),
  delete('delete'),
  paginate('paginate');

  final String name;

  const UseCaseType(this.name);

  static UseCaseType fromString(String value) {
    switch (value) {
      case 'create':
        return UseCaseType.create;
      case 'findById':
        return UseCaseType.findById;
      case 'filterOne':
        return UseCaseType.filterOne;
      case 'update':
        return UseCaseType.update;
      case 'delete':
        return UseCaseType.delete;
      case 'paginate':
        return UseCaseType.paginate;
      default:
        throw Exception('Invalid value');
    }
  }
}
