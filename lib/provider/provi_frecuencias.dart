import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../models/code_activacion/code_activacion.dart';
import '../models/frecuencias/frecuencias.dart';
import '../repositories/security_data.dart';
import '../utils/url.dart';

class ProviFrecuencia {
  static SecurityData oS = new SecurityData();

  Future<FrecuenciasPropietario> readFrecuencias(String ruta) async {
    try {
      //print("ACA FRECUENCIA RUTA" + ruta);
      CodeActivacion oC = await oS.readDataPreferenciasEmpresa();
      String url_ = "${dotenv.env['baseUrl']}/frecuencias_rutas_propietario";
      String propietario = await oS.readDataPreferenciasLoginPropietario(
        'dataLoginPropietarioLoginPropietario',
      );
      var body_ = {
        "ruta": ruta,
        "codigo_empresa": oC.data!.codigo,
        "propietario": propietario,
      };

      Response response = await http.post(
        Uri.parse(url_),
        body: json.encode(body_),
        headers: header_,
        encoding: enconding_,
      );

      //print("ACA FRECUENCIA" + response.body);

      FrecuenciasPropietario oF = FrecuenciasPropietario.fromRawJson(
        response.body,
      );
      return oF;
    } catch (e) {
      return FrecuenciasPropietario(statusCode: 400, msg: e.toString());
    }
  }
}
