abstract class Repository<T> {
  Future<T> save(T entity);

  Future<T> update(T entity);

  Future<T> getById(String id);

  Future<List<T>> filter(PaginateParams params);

  Future<Page<T>> paginate(Filter filter);

  Future<void> delete(T entity);
}

class Page<T> {
  final int page;
  final int perPage;
  final int totalItems;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final List<T> items;

  Page({
    required this.page,
    required this.perPage,
    required this.totalItems,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
    required this.items,
  });
}

class PaginateParams {
  final int limit;
  final int offset;
  final String? orderBy;
  final bool ascending;
  final String? filterBy;
  final String? filterValue;

  PaginateParams({
    this.limit = 10,
    this.offset = 0,
    this.orderBy,
    this.ascending = true,
    this.filterBy,
    this.filterValue,
  });
}

class Filter {
  final PaginateParams params;
  final List<QueryGroup> queryGroups;

  Filter({required this.params, required this.queryGroups});
}

class QueryGroup {
  final List<Query> filters;
  final LogicOperator logicOperator;

  QueryGroup({required this.filters, this.logicOperator = LogicOperator.and});
}

class Query {
  final LogicOperator logicOperator;
  final String field;
  final ComparatorOperator comparatorOperator;
  final String value;

  Query({
    required this.logicOperator,
    required this.field,
    required this.comparatorOperator,
    required this.value,
  });
}

enum LogicOperator {
  and('AND'),
  or('OR');

  final String name;

  const LogicOperator(this.name);

  LogicOperator fromString(String value) {
    switch (value.toUpperCase()) {
      case 'AND':
        return LogicOperator.and;
      case 'OR':
        return LogicOperator.or;
      default:
        return LogicOperator.and;
    }
  }
}

enum ComparatorOperator {
  equals('equals'),
  notEquals('notEquals'),
  greaterThan('greaterThan'),
  lessThan('lessThan'),
  greaterThanOrEqualTo('greaterThanOrEqualTo'),
  lessThanOrEqualTo('lessThanOrEqualTo'),
  contains('contains');

  final String name;

  const ComparatorOperator(this.name);

  ComparatorOperator fromString(String value) {
    switch (value.toLowerCase()) {
      case 'equals':
        return ComparatorOperator.equals;
      case 'notequals':
        return ComparatorOperator.notEquals;
      case 'greaterthan':
        return ComparatorOperator.greaterThan;
      case 'lessthan':
        return ComparatorOperator.lessThan;
      case 'greaterthanorequalto':
        return ComparatorOperator.greaterThanOrEqualTo;
      case 'lessthanorequalto':
        return ComparatorOperator.lessThanOrEqualTo;
      case 'contains':
        return ComparatorOperator.contains;
      default:
        return ComparatorOperator.equals;
    }
  }
}
