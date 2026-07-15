import '../models/newSimulador/newSimulador.dart';
import '../provider/provi_new_simulador.dart';

class ApiNewSimulador {
  final _provider = ProviNewSimulador();
  Future<SimuladorPageAppMovil> readSimulador(unidad, fechaI, fechaF) async {
    return await _provider.readSimulador(unidad, fechaI, fechaF);
  }
}

class NetworkError extends Error {}
