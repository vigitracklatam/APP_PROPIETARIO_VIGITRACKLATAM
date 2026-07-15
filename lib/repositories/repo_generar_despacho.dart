import '../models/despacho/generar_despacho.dart';
import '../provider/provi_generar_despacho.dart';

class ApiRepositorioGenerarDespacho {
  final _provider = ProviGenerarDespacho();

  Future<GenerarDespachoPropietario> fectchGenerarDespacho(
      dispositivo_imei,
      empresa_codigo,
      channel_port,
      dispositivo_tipo,
      unidad,
      fecha_hora,
      minutos_antes,
      ruta,
      frecuencia,
      salida_diferida,
      ruta_letra,
      autoDespachoDifeFrec) async {
    return await _provider.readGenerarDespacho(
        dispositivo_imei,
        empresa_codigo,
        channel_port,
        dispositivo_tipo,
        unidad,
        fecha_hora,
        minutos_antes,
        ruta,
        frecuencia,
        salida_diferida,
        ruta_letra,
        autoDespachoDifeFrec);
  }
}

class NetworkError extends Error {}
