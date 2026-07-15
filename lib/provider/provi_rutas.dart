import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../models/code_activacion/code_activacion.dart';
import '../models/rutas/rutas.dart';
import '../repositories/security_data.dart';
import '../utils/url.dart';

class ProviRutas {
  Future<RutasPropietario> readRutas(propietario) async {
    SecurityData oS = new SecurityData();
    try {
      String url_ = "${dotenv.env['baseUrl']}/rutesPropietario";
      CodeActivacion oC = await oS.readDataPreferenciasEmpresa();
      String propietario = await oS.readDataPreferenciasLoginPropietario(
        'dataLoginPropietarioLoginPropietario',
      );
      var body_ = {
        "codigo_empresa": oC.data!.codigo,
        "tipo": 1,
        "codigo_usuario": propietario,
        "propietario": propietario,
      };
      Response response = await http.post(
        Uri.parse(url_),
        body: json.encode(body_),
        headers: header_,
        encoding: enconding_,
      );

      //print("ACA RUTAS" + response.body);

      RutasPropietario oR = RutasPropietario.fromRawJson(response.body);
      return oR;
    } catch (e) {
      return RutasPropietario(statusCode: 400, msm: e.toString());
    }
  }
}
