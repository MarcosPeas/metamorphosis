import 'package:metamorphis/src/domain/data_class/entities/data_class.dart';
import 'package:metamorphis/src/domain/field/entities/field.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';

class InOutGenerator {
  static DataClass generate({
    required String name,
    List<ValueObject> vos = const [],
    required DataClassType type,
    required String useCaseId,
    bool includeId = true,
    bool isList = false,
  }) {
    final dataClass = DataClass(
      name: name,
      dataClassType: type,
      useCaseId: useCaseId,
      isList: isList,
    );
    if (includeId) {
      final idField = Field(
        name: 'id',
        type: 'String',
        dataClassId: dataClass.id,
      );
      dataClass.addField(idField);
    }
    for (final vo in vos) {
      final field = Field(
        name: vo.name,
        type: vo.type,
        dataClassId: dataClass.id,
        isNullable: vo.isNullable,
        enumName: vo.enumName,
        enumValues: vo.enumValues,
      );
      dataClass.addField(field);
    }
    return dataClass;
  }
}
