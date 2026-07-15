import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../models/configRecalicar/configRecalificar.dart';
import '../models/despacho/generar_despacho.dart';
import '../repositories/repo_config_recalificar.dart';
import '../repositories/security_data.dart';
import '../utils/url.dart';

class ProviGenerarDespacho {
  static SecurityData oS = new SecurityData();
  Future<GenerarDespachoPropietario> readGenerarDespacho(
    String dispositivo_imei,
    String empresa_codigo,
    int channel_port,
    int dispositivo_tipo,
    String unidad,
    String fecha_hora,
    int minutos_antes,
    int ruta,
    int frecuencia,
    int salida_diferida,
    String ruta_letra,
    int autoDespachoDifeFrec,
  ) async {
    ApiRepositorioConfigRecalificarSalida servicio =
        ApiRepositorioConfigRecalificarSalida();
    ReadConfigRecalificarppMovil datoConfig = ReadConfigRecalificarppMovil();
    datoConfig = await servicio.fetchReadConfigRecalificar();
    print(jsonEncode(datoConfig));
    String propietario = await oS.readDataPreferenciasLoginPropietario(
      'dataLoginPropietarioLoginPropietario',
    );

    try {
      print(datoConfig.datos!.recaTarjUsaPosi);
      print(datoConfig.datos!.recaTarjRangInic);
      print(datoConfig.datos!.recaTarjRang);
      print(datoConfig.datos!.recaSobrCtrlMarcClie);

      var body_;
      if (salida_diferida == 2) {
        body_ = {
          "codigo_empresa": empresa_codigo,
          "unidad": unidad,
          "empresa_codigo": empresa_codigo,
          "dispositivo_imei": dispositivo_imei,
          "channel_port": channel_port,
          "ruta_letra": ruta_letra,
          "dispositivo_tipo": dispositivo_tipo,
          "ruta": ruta,
          "frecuencia": frecuencia,
          "fecha_hora": fecha_hora,
          "recalificar_usar_posiciones": datoConfig.datos!.recaTarjUsaPosi,
          "recalifica_minutos_antes": datoConfig.datos!.recaTarjRangInic,
          "recalifica_minutos_despues": datoConfig.datos!.recaTarjRang,
          "recalifica_sobreescribir_si_tiene_marcacion":
              datoConfig.datos!.recaSobrCtrlMarcClie,
          "propietario": propietario,
        };
      } else {
        body_ = {
          "codigo_empresa": empresa_codigo,
          "dispositivo_imei": dispositivo_imei,
          "empresa_codigo": empresa_codigo,
          "channel_port": channel_port,
          "dispositivo_tipo": dispositivo_tipo,
          "unidad": unidad,
          "fecha_hora": fecha_hora,
          "ruta": ruta,
          "frecuencia": frecuencia,
          "salida_diferida":
              salida_diferida == 1 || salida_diferida == 2 ? 0 : 1,
          "minutos_antes": salida_diferida == 0 ? autoDespachoDifeFrec : 0,
          "propietario": propietario,
        };
      }

      String url_ =
          "${dotenv.env['baseUrl']}/${salida_diferida == 2 ? 'GeneraTarjeta' : 'generarDespacho'}Propietario";

      Response response = await http.post(
        Uri.parse(url_),
        body: json.encode(body_),
        headers: header_,
        encoding: enconding_,
      );
      print("url" + url_);

      print("Aca Generar despacho: " + response.body);

      GenerarDespachoPropietario oGd = GenerarDespachoPropietario.fromRawJson(
        response.body,
      );
      return oGd;
    } catch (e) {
      return GenerarDespachoPropietario(statusCode: 400, msm: e.toString());
    }
  }
}
