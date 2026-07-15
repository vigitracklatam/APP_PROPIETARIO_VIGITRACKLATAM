import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/code_activacion/code_activacion.dart';
import '../models/newSimulador/newSimulador.dart';
import '../repositories/security_data.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../utils/url.dart';

class ProviNewSimulador {
  static SecurityData oS = new SecurityData();

  Future<SimuladorPageAppMovil> readSimulador(
    String unidad,
    String fechaI,
    fechaF,
  ) async {
    int statusCode = 400;
    try {
      String url_ = "${dotenv.env['baseUrl']}/SimuladorUnidadFechaHoraAppMovil";
      CodeActivacion oC = await oS.readDataPreferenciasEmpresa();
      String propietario = await oS.readDataPreferenciasLoginPropietario(
        'dataLoginPropietarioLoginPropietario',
      );
      var body_ = {
        "codigo_empresa": oC.data!.codigo,
        "unidad": unidad,
        "fechaI": fechaI,
        "fechaF": fechaF,
        "propietario": propietario,
      };
      Response response = await http.post(
        Uri.parse(url_),
        body: json.encode(body_),
        headers: header_,
        encoding: enconding_,
      );

      SimuladorPageAppMovil oSa = SimuladorPageAppMovil.fromRawJson(
        response.body,
      );

      statusCode = oSa.statusCode!;

      //print('CODIGO PROVISIMULADOR<< ${oC.data!.codigo}');
      // print('STATUS CODE PROVISIMULADOR<< ${oSa.statusCode}');
      //print('DATA PROVISIMULADOR >> ${jsonEncode(oSa.datos)}');
      return oSa;
    } catch (e) {
      return SimuladorPageAppMovil(statusCode: statusCode, msm: e.toString());
    }
  }
}
