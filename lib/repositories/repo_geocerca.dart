import '../models/geocerca/geocerca.dart';
import '../provider/provi_geocerca.dart';

class ApiGeocerca {
  final _provider = ProviGeocerca();
  Future<GeocercaAppMovil> readGeocerca(rutas) async {
    return await _provider.readGeocerca(rutas);
  }
}

class NetworkError extends Error {}
