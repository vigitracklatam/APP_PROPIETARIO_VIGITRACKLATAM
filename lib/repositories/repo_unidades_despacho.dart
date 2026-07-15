import '../models/unidadDespacho/unidad_despacho.dart';
import '../provider/provi_unidades_despacho.dart';

class ApiRepositorioUnidadesDespacho {
  final _provider = ProviUnidadesDespacho();

  Future<UnidadesDespachoPropietario> fectchUnidadesDespacho() async {
    return await _provider.readUnidadesDespacho();
  }
}
