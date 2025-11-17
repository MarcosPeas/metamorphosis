import 'package:metamorphis/src/domain/versioned_entity/entities/value_object_screeshot.dart';
import 'package:metamorphis/src/domain/versioned_entity/entities/versioned_entity.dart';
import 'package:uuid/uuid.dart';

class VersionedValueObject {
  late final String id;
  final ValueObjectScreeshot valueObject;
  final ValueObjectScreeshot? oldValueObject;
  VersionedType type;

  VersionedValueObject({
    String? id,
    required this.valueObject,
    this.oldValueObject,
    required this.type,
  }) {
    this.id = id ?? Uuid().v7();
  }

  bool get isCreated => type == VersionedType.created;

  bool get isDeleted => type == VersionedType.deleted;

  VersionedValueObject copyWith({
    ValueObjectScreeshot? valueObject,
    ValueObjectScreeshot? oldValueObject,
    VersionedType? type,
  }) {
    return VersionedValueObject(
      id: id,
      oldValueObject: oldValueObject ?? this.oldValueObject,
      valueObject: valueObject ?? this.valueObject,
      type: type ?? this.type,
    );
  }
}

