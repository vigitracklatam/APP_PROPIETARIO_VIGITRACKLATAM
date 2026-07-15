import '../models/control/control_propietario.dart';
import '../provider/provi_control_monitoreo.dart';

class ApiRepositorioControlesMonitoreo {
  final _provider = ProviControlMonitoreo();

  Future<ControlPropietarioAppMovil> fetchControlMonitoreo() {
    return _provider.readControlesMonitoreo();
  }
}

class NetworkError extends Error {}
