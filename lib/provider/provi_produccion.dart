import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';
import '../models/code_activacion/code_activacion.dart';
import '../models/produccion_update/produccion.dart';
import '../utils/url.dart';
import '../repositories/security_data.dart';

class ProviProduccionSinConteo {
  static SecurityData oS = new SecurityData();

  Future<ProduccionSinConteoAppMovil> readProduccionSC(
    String usuario,
    gchofer,
    gayudante,
    gcombustible,
    galimentacion,
    gotros,
    gingresos,
    tgastos,
    produccion,
    String unidad,
    String fecha,
    String usuarioObse,
  ) async {
    try {
      String url_ = "${dotenv.env['baseUrl']}/ProduccionSinConteoAppMovil";

      CodeActivacion oC = await oS.readDataPreferenciasEmpresa();
      String propietario = await oS.readDataPreferenciasLoginPropietario(
        'dataLoginPropietarioLoginPropietario',
      );
      var body_ = {
        "codigo_empresa": oC.data!.codigo,
        "usuario": usuario,
        "gchofer": gchofer,
        "gayudante": gayudante,
        "gcombustible": gcombustible,
        "galimentacion": galimentacion,
        "gotros": gotros,
        "gingresos": gingresos,
        "tgastos": tgastos,
        "produccion": produccion,
        "unidad": unidad,
        "fecha": fecha,
        "usuarioObse": usuarioObse,
        "propietario": propietario,
      };
      print(body_);
      Response response = await http.post(
        Uri.parse(url_),
        body: json.encode(body_),
        headers: header_,
        encoding: enconding_,
      );
      //print("Response");
      //print((response.body));
      ProduccionSinConteoAppMovil oP = ProduccionSinConteoAppMovil.fromRawJson(
        response.body,
      );

      //print('________________________________________________ ');
      //print('STATUS CODE PROVISALIDA<< ${oP.statusCode}');
      //print('DATA PROVISALIDA >> ${jsonEncode(oP.datos)}');
      return oP;
    } catch (e) {
      print('ERROR: $e');
      return ProduccionSinConteoAppMovil(statusCode: 400, msm: e.toString());
    }
  }
}
