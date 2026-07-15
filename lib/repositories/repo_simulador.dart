import '../models/simulador/simulador.dart';
import '../provider/provi_simulador.dart';

class ApiSimulador {
  final _provider = ProviSimulador();
  Future<SimuladorAppMovil> readSimulador(unidad, fechaI, fechaF) async {
    return await _provider.readSimulador(unidad, fechaI, fechaF);
  }
}

class NetworkError extends Error {}
