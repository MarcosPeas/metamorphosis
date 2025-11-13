import 'package:metamorphis/src/domain/_core/domain/repository.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';

abstract class EntityRepository extends Repository<Entity> {
  Future<List<Entity>> updateAll(List<Entity> entities);
}
