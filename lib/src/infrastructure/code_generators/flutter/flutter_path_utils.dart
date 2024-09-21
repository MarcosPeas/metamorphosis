
class FlutterPathUtils {
  static String getFlutterPath(String path) {
    return path.replaceAll('lib/', '');
  }
}