import '../models/controles_marcados/controles_marcados.dart';
import '../provider/provi_controles_marcados.dart';

class ApiControlesMarcados {
  final _provider = ProviControlesMarcados();
  Future<ControlesMarcadosAppMovil> readControles(int idSalida) async {
    return await _provider.readControlesMarcados(idSalida);
  }
}

class NetworkError extends Error {}
