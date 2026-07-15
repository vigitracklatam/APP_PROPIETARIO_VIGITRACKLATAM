import '../models/historial_unidad/historial_unidad.dart';
import '../provider/provi_historial_unidad.dart';

class ApiHistorialUnidad {
  final _provider = ProviHistorialUnidad();
  Future<HistorialUnidadAppMovil> readHistorialUnidad(
      unidad, salida, fechaI, fechaF) async {
    return await _provider.readHistorialUnidad(unidad, salida, fechaI, fechaF);
  }
}

class NetworkError extends Error {}
