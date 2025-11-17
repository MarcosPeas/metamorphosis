import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/domain/versioned_entity/entities/versioned_entity_screenshot.dart';
import 'package:metamorphis/src/domain/versioned_entity/entities/versioned_value_object.dart';
import 'package:uuid/uuid.dart';

class VersionedEntity {
  late final String id;
  VersionedType type;
  final VersionedEntityScreenshot entityScreenshot;
  String? _oldName;
  final int version;

  VersionedEntity({
    String? id,
    required this.type,
    required this.entityScreenshot,
    String? oldName,
    required this.version,
  }) {
    this.id = id ?? Uuid().v7();
    _oldName = oldName;
  }

  bool get isCreated => type == VersionedType.created;

  String? get oldName => _oldName;

  set oldName(String? value) {
    if (_oldName != null && !isCreated) {
      _oldName = value;
    }
  }

  void addversiondValueObject(VersionedValueObject vvo) {
    final index = entityScreenshot.valueObjects.indexWhere(
      (item) => item.id == vvo.id,
    );
    if (index < 0) {
      entityScreenshot.valueObjects.add(vvo);
      return;
    }
    entityScreenshot.valueObjects[index] = vvo;
  }

  VersionedValueObject? getCurrentValueObject(ValueObject vo) {
    final result = entityScreenshot.valueObjects.where(
      (item) => item.valueObject.id == vo.id,
    );
    return result.firstOrNull;
  }
}

enum VersionedType {
  created('created'),
  updated('updated'),
  deleted('deleted'),
  none('none');

  final String name;

  const VersionedType(this.name);

  static VersionedType fromString(String? name) {
    final value = VersionedType.values
        .where((item) => item.name == name)
        .firstOrNull;
    return value ?? none;
  }
}
