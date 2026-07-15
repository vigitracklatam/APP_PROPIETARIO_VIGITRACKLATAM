import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';
import '../utils/url.dart';

import '../models/code_activacion/code_activacion.dart';
import '../models/salida/salida_user.dart';
import '../repositories/security_data.dart';

class ProviSalidaUser {
  static SecurityData oS = new SecurityData();

  Future<SalidasAppMovil> readSalidaUser(
    String propietario,
    unidad,
    fecha,
  ) async {
    try {
      String url_ = "${dotenv.env['baseUrl']}/salidasUnidadPropietarioAppMovil";
      CodeActivacion oC = await oS.readDataPreferenciasEmpresa();
      var body_ = {
        "codigo_empresa": oC.data!.codigo,
        "propietario": propietario,
        "unidad": unidad,
        "fecha": fecha,
        //"CodiObse": codiObse
      };
      print("body_");
      print(body_);

      Response response = await http.post(
        Uri.parse(url_),
        body: json.encode(body_),
        headers: header_,
        encoding: enconding_,
      );

      SalidasAppMovil oSa = SalidasAppMovil.fromRawJson(response.body);

      print('CODIGO EMPRESA PROVISALIDA<< ${oC.data!.codigo}');
      print('propietario PROVISALIDA<< ${propietario}');
      print('unidad PROVISALIDA<< ${unidad}');
      print('fecha EMPRESA PROVISALIDA<< ${fecha}');
      print('________________________________________________ ');
      print('STATUS CODE PROVISALIDA<< ${oSa.statusCode}');
      print('DATA PROVISALIDA >> ${jsonEncode(oSa.datos)}');

      return oSa;
    } catch (e) {
      print('ERROR: $e');
      return SalidasAppMovil(statusCode: 400, msm: e.toString());
    }
  }
}
