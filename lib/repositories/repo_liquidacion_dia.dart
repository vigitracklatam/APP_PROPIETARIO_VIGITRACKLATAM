

import '../models/liquidacionDia/detalle_liquidacion_dia.dart';
import '../models/liquidacionDia/evidencia_liquidacion_dia.dart';
import '../models/liquidacionDia/liquidacion_dia.dart';
import '../provider/provi_liquidacion_dia.dart';

class ApiRepositorioLiquidacionDespacho {
  final _provider = ProviLiquidacionDia();

  Future<LiquidacionDia> fetchLiquidacionDia(
    String unidad,
    String fecha,
  ) async {
    return await _provider.readLiquidacionDia(unidad, fecha);
  }

  Future<DetalleLiquidacionDia> fetchDetalleLiquidacionDia(int id) async {
    return await _provider.readDetalleLiquidacionDia(id);
  }

  Future<EvidenciaLiquidacionDia> fetchEvidenciaLiquidacionDia(int id) async {
    return await _provider.readEvidenciaLiquidacionDia(id);
  }
}
