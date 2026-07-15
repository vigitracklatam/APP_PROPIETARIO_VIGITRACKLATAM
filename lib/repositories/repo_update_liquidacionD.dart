

import '../models/liquidacion/liquidacionUpdateD.dart';
import '../provider/provi_update_liquidacion.dart';

class ApiUpdateLiquidacionD {
  final _provider = ProviderUpdateLiquidacionD();
  Future<LiquidacionDUpdateAppMovil> fetchUpdateLiquidacion(
    propietario,
    idLiquidaM,
    fechaLiquidaM,
    idSalidaM,
    idRuta,
    conteoTotal,
    conteoMedio,
    dineroConteo,
  ) {
    return _provider.updateLiquidacionD(
      propietario,
      idLiquidaM,
      fechaLiquidaM,
      idSalidaM,
      idRuta,
      conteoTotal,
      conteoMedio,
      dineroConteo,
    );
  }
}

class NetworkError extends Error {}
