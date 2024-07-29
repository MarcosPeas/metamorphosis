import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';

abstract class ValueObjectRepository {
  Future<ValueObject> save(ValueObject valueObject);

  Future<ValueObject> update(ValueObject valueObject);

  Future<ValueObject> getById(String id);

  Future<List<ValueObject>> getByEntity(String entityId);

  Future<void> delete(String id);
}
