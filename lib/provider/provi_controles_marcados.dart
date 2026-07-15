import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/code_activacion/code_activacion.dart';
import '../models/controles_marcados/controles_marcados.dart';
import '../repositories/security_data.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../utils/url.dart';

class ProviControlesMarcados {
  static SecurityData oS = new SecurityData();

  Future<ControlesMarcadosAppMovil> readControlesMarcados(int idSalida) async {
    int statusCode = 400;
    try {
      String url_ = "${dotenv.env['baseUrl']}/controlesMarcadosSalidaAppMovil";
      CodeActivacion oC = await oS.readDataPreferenciasEmpresa();
      String propietario = await oS.readDataPreferenciasLoginPropietario(
        'dataLoginPropietarioLoginPropietario',
      );
      var body_ = {
        "codigo_empresa": oC.data!.codigo,
        "salida": idSalida,
        "propietario": propietario,
      };

      Response response = await http.post(
        Uri.parse(url_),
        body: json.encode(body_),
        headers: header_,
        encoding: enconding_,
      );

      ControlesMarcadosAppMovil oCm = ControlesMarcadosAppMovil.fromRawJson(
        response.body,
      );

      statusCode = oCm.statusCode!;

      //print('CODIGO CONTROLES<< ${oC.data!.codigo}');
      //print('STATUS CODE CONTROLES<< ${oCm.statusCode}');
      //print('DATA CONTROLES >> ${jsonEncode(oCm.datos)}');
      return oCm;
    } catch (e) {
      return ControlesMarcadosAppMovil(
        statusCode: statusCode,
        msm: e.toString(),
      );
    }
  }
}
