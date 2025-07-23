import 'package:uuid/uuid.dart';

class IdGenerator {
  static String generateId() {
    final uuid = Uuid();
    return uuid.v7();
  }
}