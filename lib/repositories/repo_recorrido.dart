import '../models/recorrido/recorrido.dart';
import '../provider/provi_recorrido.dart';

class ApiRecorrido {
  final _provider = ProviRecorrido();
  Future<RecorridoAppMovil> readRecorrido(unidad, fechaI, fechaF) async {
    return await _provider.readRecorrido(unidad, fechaI, fechaF);
  }
}

class NetworkError extends Error {}
