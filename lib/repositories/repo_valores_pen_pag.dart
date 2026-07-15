import '../models/valores_pendientes_pagados/valores_pendientes_pagados.dart';
import '../provider/provi_valores_pen_pag.dart';

class ApiValoresPenPag {
  final _provider = ProviValoresPenPag();
  Future<ValoresPendientesPagadosAppMovil> readValoresPenPag(
    unidad,
    fechaI,
    fechaF,
    tipo,
  ) async {
    return await _provider.readValoresPenPag(unidad, fechaI, fechaF, tipo);
  }
}

class NetworkError extends Error {}
