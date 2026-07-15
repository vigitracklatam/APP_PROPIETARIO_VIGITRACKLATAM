import '../models/configRecalicar/configRecalificar.dart';
import '../provider/provi_config_recalificar.dart';

class ApiRepositorioConfigRecalificarSalida {
  final _provider = ProviConfigRecalificar();
  Future<ReadConfigRecalificarppMovil> fetchReadConfigRecalificar() async {
    return await _provider.readConfigRecalificar();
  }
}
