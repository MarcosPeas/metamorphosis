import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/reference/entities/reference.dart';
import 'package:metamorphis/src/domain/versioned_entity/entities/value_object_screeshot.dart';
import 'package:metamorphis/src/domain/versioned_entity/entities/versioned_entity.dart';
import 'package:metamorphis/src/domain/versioned_entity/entities/versioned_value_object.dart';
import 'package:uuid/uuid.dart';

class VersionedEntityScreenshot {
  late final String id;
  late final String name;
  late final List<VersionedValueObject> valueObjects;
  late final List<Reference> references;
  late final List<EntityGlobalEnumerator> globalEnumerators;

  VersionedEntityScreenshot({
    String? id,
    required String name,
    List<VersionedValueObject>? valueObjects,
    List<Reference>? references,
    List<EntityGlobalEnumerator>? globalEnumerators,
  }) {
    this.id = id ?? const Uuid().v7();
    name = name;
    this.valueObjects = valueObjects ?? [];
    this.references = references ?? [];
    this.globalEnumerators = globalEnumerators ?? [];
  }

  void addVersiondValueObject(VersionedValueObject vvo) {
    final index = valueObjects.indexWhere((item) => item.id == vvo.id);
    if (index < 0) {
      valueObjects.add(vvo);
      return;
    }
    final old = valueObjects[index];
    if (old.isCreated) {
      if (vvo.isDeleted) {
        valueObjects.removeAt(index);
        return;
      }
      vvo.type = VersionedType.created;
    }
    valueObjects[index] = vvo;
  }

  factory VersionedEntityScreenshot.create(Entity entity) {
    return VersionedEntityScreenshot(
      id: entity.id,
      name: entity.name,
      globalEnumerators: entity.globalEnumerators,
      references: entity.references,
      valueObjects: entity.valueObjects.map((item) {
        final vos = ValueObjectScreeshot.fromValueObject(item);
        return VersionedValueObject(
          type: VersionedType.created,
          valueObject: vos,
        );
      }).toList(),
    );
  }

  factory VersionedEntityScreenshot.delete(Entity entity) {
    return VersionedEntityScreenshot(
      id: entity.id,
      name: entity.name,
      globalEnumerators: entity.globalEnumerators,
      references: entity.references,
      valueObjects: entity.valueObjects.map((item) {
        final vos = ValueObjectScreeshot.fromValueObject(item);
        return VersionedValueObject(
          type: VersionedType.deleted,
          valueObject: vos,
        );
      }).toList(),
    );
  }
}
