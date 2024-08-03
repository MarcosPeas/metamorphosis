import 'package:metamorphis/src/domain/bounded_context/entities/bounded_context.dart';
import 'package:metamorphis/src/presenter/_core/store.dart';

class BoundedContextStore extends Store {
  final _boundedContexts = <BoundedContext>[];

  List<BoundedContext> get boundedContexts => List.unmodifiable(
        _boundedContexts,
      );

  void setBoundedContexts(List<BoundedContext> boundedContexts) {
    _boundedContexts.addAll(boundedContexts);
    notifyListeners();
  }

  void addBoundedContext(BoundedContext boundedContext) {
    _boundedContexts.add(boundedContext);
    notifyListeners();
  }

  void updateBoundedContext(BoundedContext boundedContext) {
    final index = _boundedContexts.indexWhere((p) => p.id == boundedContext.id);
    if (index != -1) {
      _boundedContexts[index] = boundedContext;
      notifyListeners();
    }
  }

  void deleteBoundedContext(BoundedContext boundedContext) {
    _boundedContexts.removeWhere((p) => p.id == boundedContext.id);
    notifyListeners();
  }

  void clear() {
    _boundedContexts.clear();
  }
}
