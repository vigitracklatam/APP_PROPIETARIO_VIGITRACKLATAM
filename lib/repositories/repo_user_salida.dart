import '../models/salida/salida_user.dart';
import '../provider/provi_salida_user.dart';

class ApiRepositorio {
  final _provider = ProviSalidaUser();
  Future<SalidasAppMovil> fetchUerSalidaList(propietario, unidad, fecha) {
    return _provider.readSalidaUser(propietario, unidad, fecha);
  }
}

class NetworkError extends Error {}
