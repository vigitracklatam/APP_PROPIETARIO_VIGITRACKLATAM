

import '../models/liquidacion _m/liquidacionUpdateM.dart';
import '../provider/provi_update_liquidacion_m.dart';

class ApiUpdateLiquidacionM {
  final _provider = ProviderUpdateLiquidacionM();
  Future<LiquidacionMUpdateMAppMovil> fetchUpdateLiquidacionM(
    int idLiquidaM,
    String unidad,
    String fechaLiquidaM,
    double gComida,
    double gChofer,
    double gAyudante,
    double gLimpieza,
    double gBebida,
    double gOtros,
    double gTicket,
    double gPeaje,
    double gGasolina,
    String observacion,
    String choferId,
  ) {
    return _provider.updateLiquidacionM(
      idLiquidaM,
      unidad,
      fechaLiquidaM,
      gComida,
      gChofer,
      gAyudante,
      gLimpieza,
      gBebida,
      gOtros,
      gTicket,
      gPeaje,
      gGasolina,
      observacion,
      choferId,
    );
  }
}

class NetworkError extends Error {}
