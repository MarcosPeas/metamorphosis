import 'package:change_case/change_case.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/use_case/entities/use_case.dart';
import 'package:metamorphis/src/presenter/_core/extensions/words_extensions.dart';
import 'package:metamorphis/src/presenter/_core/store.dart';

class UseCasesStore extends Store {
  final List<String> _useCases = [];
  final List<String> _useCasesName = [];

  List<String> get useCases => [..._useCases];

  void setupPaginationList(Entity entity) {
    _useCases.clear();
    _useCasesName.clear();
    final useCases = [...entity.useCases];
    useCases.removeWhere((uc) {
      return uc.useCaseType != UseCaseType.paginate;
    });
    _useCasesName.addAll(entity.useCases.map((e) => e.name));
    final valueObjects = [...entity.valueObjects];
    for (final vo in valueObjects) {
      final isUnique = vo.isUnique;
      final isId = vo.name.toLowerCase().contains('id');
      if (isUnique || isId) {
        final name = entity.name.toPascalCase();
        final voName = vo.name.toPascalCase();
        final useCaseByName = 'Find${name}By${voName}UseCase';
        if (!_useCasesName.contains(useCaseByName)) {
          _useCases.add(useCaseByName);
        }
      }
    }
    valueObjects.removeWhere((vo) {
      return vo.name == 'id' ||
          vo.name.toLowerCase().contains('id') ||
          vo.type != 'String' ||
          vo.isUnique;
    });
    for (final vo in valueObjects) {
      final name = entity.name.plural().toPascalCase();
      final voName = vo.name.toPascalCase();
      final useCaseLikeName = 'Paginate${name}Like${voName}UseCase';
      final useCaseByName = 'Paginate${name}By${voName}UseCase';
      if (!_useCasesName.contains(useCaseByName)) {
        _useCases.add(useCaseByName);
      }
      if (!_useCases.contains(useCaseLikeName)) {
        _useCases.add(useCaseLikeName);
      }
    }
  }
}
