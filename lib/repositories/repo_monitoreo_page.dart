import '../models/monitoreo/monitoreo_page.dart';
import '../provider/provi_monitoreo_page.dart';

class ApiRepositorioMonitoreoPage {
  final _provider = ProviMonitoreoPage();

  Future<MonitoreoAppMovil> fetchMonitoreoPage(propietario, unidad) async {
    return await _provider.readMonitoreoPage(propietario, unidad);
  }
}

class NetworkError extends Error {}
