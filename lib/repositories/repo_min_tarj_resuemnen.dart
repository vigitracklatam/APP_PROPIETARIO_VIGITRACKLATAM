import '../models/minutos_tarjetas_resumen/minutostarjetasresumen.dart';
import '../provider/provi_min_tarj_resumen.dart';

class ApiRepoMinTarResumen {
  final _provider = ProviMinTarResumen();
  Future<MinutosTarjetasResumenAppMovil> readMinTarResumen(
    fechaI,
    fechaF,
  ) async {
    return await _provider.readMinTarResumen(fechaI, fechaF);
  }
}

class NetworkError extends Error {}
