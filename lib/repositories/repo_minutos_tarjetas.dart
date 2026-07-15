import '../models/minutos_tarjetas/minutostarjetas.dart';
import '../provider/provi_minutos_tarjetas.dart';

class ApiRepoMinutosTarjetas {
  final _provider = ProviMinutosTarjetas();
  Future<MinutosTarjetasAppMovil> readMinutosTarjetas(
    fechaI,
    fechaF,
    unidades,
  ) async {
    return await _provider.readMinutosTarjetas(fechaI, fechaF, unidades);
  }
}

class NetworkError extends Error {}
