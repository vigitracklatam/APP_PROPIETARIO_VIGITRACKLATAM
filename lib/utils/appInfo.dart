import 'package:package_info_plus/package_info_plus.dart';

class AppInfo {
  static Future<String> getAppVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return '${info.version}+${info.buildNumber}';
    } catch (e) {
      print('Error al obtener versión: $e');
      return 'Desconocida';
    }
  }

  static Future<String> getVersionOnly() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return info.version;
    } catch (e) {
      print('Error al obtener versión: $e');
      return 'Desconocida';
    }
  }

  static Future<String> getBuildNumberOnly() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return info.buildNumber;
    } catch (e) {
      print('Error al obtener número de compilación: $e');
      return 'Desconocido';
    }
  }
}
