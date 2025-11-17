import 'package:flutter/material.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/domain/versioned_entity/entities/value_object_screeshot.dart';
import 'package:metamorphis/src/domain/versioned_entity/entities/versioned_entity.dart';
import 'package:metamorphis/src/domain/versioned_entity/entities/versioned_entity_screenshot.dart';
import 'package:metamorphis/src/domain/versioned_entity/entities/versioned_value_object.dart';

class VersionedStore extends ChangeNotifier {
  final List<VersionedEntity> entities = [];

  void create(Entity entity, int version) {
    final ves = VersionedEntityScreenshot.create(entity);
    final versioned = VersionedEntity(
      type: VersionedType.created,
      entityScreenshot: ves,
      version: version,
    );
    entities.add(versioned);
  }

  void delete(Entity entity, int version) {
    final index = entities.indexWhere(
      (item) => item.entityScreenshot.id == entity.id,
    );
    if (index < 0) {
      final ves = VersionedEntityScreenshot.delete(entity);
      final versioned = VersionedEntity(
        type: VersionedType.deleted,
        entityScreenshot: ves,
        version: version,
      );
      entities.add(versioned);
      return;
    }
    final ves = entities[index];
    if (ves.isCreated) {
      entities.removeAt(index);
      return;
    }
    ves.type = VersionedType.deleted;
  }

  void update(String oldName, Entity entity, int version) {
    final index = entities.indexWhere(
      (item) => item.entityScreenshot.id == entity.id,
    );
    if (index < 0) {
      final ves = VersionedEntityScreenshot(
        id: entity.id,
        name: entity.name,
        globalEnumerators: [],
        references: [],
        valueObjects: [],
      );
      final versioned = VersionedEntity(
        type: VersionedType.updated,
        entityScreenshot: ves,
        version: version,
        oldName: oldName,
      );
      entities.add(versioned);
      return;
    }
    entities[index].oldName = oldName;
    entities[index].entityScreenshot.name = entity.name;
  }

  void deleteValueObject({
    required Entity entity,
    required ValueObject valueObject,
    required int version,
  }) {
    final versionedEntity = _getVersionedEntity(
      entity,
      version,
      VersionedType.none,
    );
    final vvo = VersionedValueObject(
      valueObject: ValueObjectScreeshot(
        id: valueObject.id,
        name: valueObject.name,
        type: valueObject.type,
        isNullable: valueObject.isNullable,
        isUnique: valueObject.isUnique,
      ),
      type: VersionedType.deleted,
    );
    versionedEntity.entityScreenshot.addVersiondValueObject(vvo);
  }

  void updateValueObject({
    required Entity entity,
    required ValueObject valueObject,
    required ValueObject oldValueObject,
    required int version,
  }) {
    final versionedEntity = _getVersionedEntity(
      entity,
      version,
      VersionedType.updated,
    );
    final vvo = VersionedValueObject(
      valueObject: ValueObjectScreeshot(
        id: valueObject.id,
        name: valueObject.name,
        type: valueObject.type,
        isNullable: valueObject.isNullable,
        isUnique: valueObject.isUnique,
      ),
      oldValueObject: ValueObjectScreeshot(
        id: oldValueObject.id,
        name: oldValueObject.name,
        type: oldValueObject.type,
        isNullable: oldValueObject.isNullable,
        isUnique: oldValueObject.isUnique,
      ),
      type: VersionedType.updated,
    );
    versionedEntity.entityScreenshot.addVersiondValueObject(vvo);
  }

  void createValueObject({
    required Entity entity,
    required ValueObject valueObject,
    required int version,
  }) {
    final versionedEntity = _getVersionedEntity(
      entity,
      version,
      VersionedType.created,
    );
    final vvo = VersionedValueObject(
      valueObject: ValueObjectScreeshot(
        id: valueObject.id,
        name: valueObject.name,
        type: valueObject.type,
        isNullable: valueObject.isNullable,
        isUnique: valueObject.isUnique,
      ),
      type: VersionedType.created,
    );
    versionedEntity.entityScreenshot.addVersiondValueObject(vvo);
  }

  VersionedEntity _getVersionedEntity(
    Entity entity,
    int version,
    VersionedType type,
  ) {
    final index = entities.indexWhere(
      (item) => item.entityScreenshot.id == entity.id,
    );
    if (index >= 0) {
      return entities[0];
    }
    final ves = VersionedEntityScreenshot(
      id: entity.id,
      name: entity.name,
      globalEnumerators: [],
      references: [],
      valueObjects: [],
    );
    return VersionedEntity(type: type, entityScreenshot: ves, version: version);
  }

  VersionedValueObject _getVersionedValueObject(
    VersionedEntity entity,
    ValueObject valueObject,
    ValueObject oldValueObject,
    int version,
    VersionedType type,
  ) {
    final index = entity.entityScreenshot.valueObjects.indexWhere(
      (item) => item.id == valueObject.id,
    );
    if (index >= 0) {
      return entity.entityScreenshot.valueObjects[index];
    }
    return VersionedValueObject(
      valueObject: ValueObjectScreeshot(
        id: valueObject.id,
        name: valueObject.name,
        type: valueObject.type,
        isNullable: valueObject.isNullable,
        isUnique: valueObject.isUnique,
      ),
      oldValueObject: ValueObjectScreeshot(
        id: oldValueObject.id,
        name: oldValueObject.name,
        type: oldValueObject.type,
        isNullable: oldValueObject.isNullable,
        isUnique: oldValueObject.isUnique,
      ),
      type: type,
    );
  }

  void clear() {
    entities.clear();
  }
}
