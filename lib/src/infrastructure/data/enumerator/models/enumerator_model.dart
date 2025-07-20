import 'package:metamorphis/src/domain/enumerator/entities/enumerator.dart';

class EnumeratorModel extends Enumerator {
  EnumeratorModel({required super.name, required super.values});

  factory EnumeratorModel.fromEntity(Enumerator enumerator) {
    return EnumeratorModel(
      name: enumerator.name,
      values: enumerator.values,
    );
  }

  factory EnumeratorModel.fromMap(Map<String, dynamic> json) {
    return EnumeratorModel(
      name: json['name'],
      values: json['values'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': super.name,
      'values': super.values,
    };
  }
}
