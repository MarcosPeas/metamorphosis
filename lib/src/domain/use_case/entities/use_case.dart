import 'package:uuid/uuid.dart';

class UseCase {
  late final String id;
  String name;
  UseCaseType useCaseType;
  String searchField;
  String orderByField;
  bool isAscending;
  final String entityId;

  UseCase({
    String? id,
    required this.name,
    required this.useCaseType,
    this.searchField = '',
    this.orderByField = '',
    this.isAscending = true,
    required this.entityId,
  }) {
    {
      this.id = id ?? const Uuid().v4();
    }
  }
}

enum UseCaseType {
  create,
  read,
  update,
  delete,
  paginate;

  static UseCaseType fromString(String value) {
    switch (value) {
      case 'create':
        return UseCaseType.create;
      case 'read':
        return UseCaseType.read;
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
