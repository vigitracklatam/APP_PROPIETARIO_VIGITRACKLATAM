
import '../models/liquidacion/liquidacionUpdateD.dart';
import '../provider/provi_update_liquidaciond2.dart';

class ApiUpdateLiquidacionD2 {
  final _provider = ProviderUpdateLiquidacionD2();
  Future<LiquidacionDUpdateAppMovil> fetchUpdateLiquidacion(
    propietario,
    idLiquidaM,
    fechaLiquidaM,
    idSalidaM,
    idRuta,
    conteoTotal,
    conteoMedio,
    dineroIda,
    dineroVuelta,
  ) {
    return _provider.updateLiquidacionD2(
      propietario,
      idLiquidaM,
      fechaLiquidaM,
      idSalidaM,
      idRuta,
      conteoTotal,
      conteoMedio,
      dineroIda,
      dineroVuelta,
    );
  }
}

class NetworkError extends Error {}
