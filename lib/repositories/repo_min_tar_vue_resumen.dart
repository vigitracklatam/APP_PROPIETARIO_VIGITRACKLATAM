import '../models/min_tar_vue_resumen/min_tar_vue_resumen.dart';
import '../provider/provi_min_tar_vuel_resusmen.dart';

class ApiRepoMinTarVueResumen {
  final _provider = ProviMinTarVuelResumen();
  Future<MinTarVueResumenAppMovil> readMinTarVueResumen(fechaI, fechaF) async {
    return await _provider.readMinTarVueResumen(fechaI, fechaF);
  }
}
