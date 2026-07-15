import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../models/code_activacion/code_activacion.dart';
import '../models/liquidacionSB/liquidacion_SB.dart';
import '../utils/url.dart';

import '../repositories/security_data.dart';

class ProviLiquidacionSB {
  static SecurityData oS = new SecurityData();

  Future<GetLiquidacionAppPropietario> readLiquidacionSB(unidad, fecha) async {
    try {
      CodeActivacion oC = await oS.readDataPreferenciasEmpresa();
      String url_ =
          "${dotenv.env['baseUrl']}/obtener_reporte_liquidacion_vuelta_sb_v2_PropietarioAppMovil";
      var body_ = {
        "codigo_empresa": oC.data!.codigo,
        "unidad": unidad,
        "fecha": fecha,
      };
      print("body_ en readLiquidacionvSB:");
      print(body_);

      Response response = await http.post(
        Uri.parse(url_),
        body: json.encode(body_),
        headers: header_,
        encoding: enconding_,
      );

       GetLiquidacionAppPropietario oSa = getLiquidacionAppPropietarioFromJson(response.body);

      print(response.body);

      print('________________________________________________ ');
      print('STATUS CODE OBTEMER liquidacion SB<< ${oSa.statusCode}');
      print('DATA OBTEMER Gastosliquidacion SB>> ${jsonEncode(oSa.datos)}');

      return oSa;
    } catch (e) {
      print('ERROR: $e');
      return GetLiquidacionAppPropietario(
        statusCode: 400,
        datos: [],
        msm: e.toString(),
      );
    }
  }
}
