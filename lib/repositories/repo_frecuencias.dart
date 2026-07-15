import '../models/frecuencias/frecuencias.dart';
import '../provider/provi_frecuencias.dart';

class ApiRepositorioFrecuencias {
  final _provider = ProviFrecuencia();
  Future<FrecuenciasPropietario> fetchFrecuencias(ruta) async {
    return await _provider.readFrecuencias(ruta);
  }
}
