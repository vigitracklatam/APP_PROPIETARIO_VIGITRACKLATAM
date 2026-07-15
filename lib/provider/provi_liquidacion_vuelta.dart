import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../models/liquidacion/liquidacion.dart';
import '../utils/url.dart';

import '../models/code_activacion/code_activacion.dart';

import '../repositories/security_data.dart';

class ProviLiquidacionVuelta {
  static SecurityData oS = new SecurityData();

  Future<LiquidacionDetalleAppMovil> readLiquidacion(
    String propietario,
    unidad,
    fecha,
  ) async {
    try {
      String url_ =
          "${dotenv.env['baseUrl']}/liquidacionChoferVueltaPropietarioAppMovil";
      CodeActivacion oC = await oS.readDataPreferenciasEmpresa();
      var body_ = {
        "codigo_empresa": oC.data!.codigo,
        "unidad": unidad,
        "fecha": fecha,
        "propietario": propietario,
      };
      print("body_");
      print(body_);

      Response response = await http.post(
        Uri.parse(url_),
        body: json.encode(body_),
        headers: header_,
        encoding: enconding_,
      );

      LiquidacionDetalleAppMovil oSa = LiquidacionDetalleAppMovil.fromRawJson(
        response.body,
      );
      print(response.body);

      print('________________________________________________ ');
      print('STATUS CODE liquidacion<< ${oSa.statusCode}');
      print('DATA liquidacion >> ${jsonEncode(oSa.datos)}');

      return oSa;
    } catch (e) {
      print('ERROR: $e');
      return LiquidacionDetalleAppMovil(statusCode: 400, msm: e.toString());
    }
  }
}
