import '../models/rutas/rutas.dart';
import '../provider/provi_rutas.dart';

class ApiRepositorioRutas {
  final _provider = ProviRutas();
  Future<RutasPropietario> fetchRutas(propietario) {
    return _provider.readRutas(propietario);
  }
}
