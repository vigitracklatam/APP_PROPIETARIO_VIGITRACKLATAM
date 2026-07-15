import '../models/salida/salida_user_detalle.dart';
import '../provider/provi_salida_user_detalle.dart';

class ApiRepositorioSalidaDetalle {
  final _provider = ProviSalidaUserDetalle();

  get salida => "";

  Future<SalidasDetalleAppMovil> fetchUerSalidaList(salida) {
    return _provider.readSalidaUserDetalle(salida);
  }
}

class NetworkError extends Error {}
