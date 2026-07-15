

import '../models/liquidacion/liquidacion.dart';
import '../provider/provi_liquidacion_vuelta.dart';

class ApiRepoLiquidacionVuelta {
  final _provider = ProviLiquidacionVuelta();
  Future<LiquidacionDetalleAppMovil> fetchLiquidacion(
    propietario,
    unidad,
    fecha,
  ) {
    return _provider.readLiquidacion(propietario, unidad, fecha);
  }
}

class NetworkError extends Error {}
