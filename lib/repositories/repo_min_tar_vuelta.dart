import '../models/min_tarj_vuelta/min_tarj_vuelta.dart';
import '../provider/provi_minutos_tarjeta_vuelta.dart';

class ApiRepoMinTarjVuelta {
  final _provider = ProviMinutosTarjetasVuelta();
  Future<MinTarVueltaAppMovil> readMinTarVuelta(
    fechaI,
    fechaF,
    unidades,
  ) async {
    return await _provider.readMinTarVuelta(fechaI, fechaF, unidades);
  }
}

class NetworkError extends Error {}
