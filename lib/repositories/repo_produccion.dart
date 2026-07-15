import '../models/produccion_update/produccion.dart';
import '../provider/provi_produccion.dart';

class ApiProduccion {
  final _provider = ProviProduccionSinConteo();
  Future<ProduccionSinConteoAppMovil> fetchProduccion(
    usuario,
    gchofer,
    gayudante,
    gcombustible,
    galimentacion,
    gotros,
    gingresos,
    tgastos,
    produccion,
    unidad,
    fecha,
    usuarioObse,
  ) {
    return _provider.readProduccionSC(
      usuario,
      gchofer,
      gayudante,
      gcombustible,
      galimentacion,
      gotros,
      gingresos,
      tgastos,
      produccion,
      unidad,
      fecha,
      usuarioObse,
    );
  }
}

class NetworkError extends Error {}
