import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';
import '../models/liquidacion/liquidacionUpdateD.dart';
import '../utils/url.dart';

import '../models/code_activacion/code_activacion.dart';

import '../repositories/security_data.dart';

class ProviderUpdateLiquidacionD {
  static SecurityData oS = new SecurityData();

  Future<LiquidacionDUpdateAppMovil> updateLiquidacionD(
    String propietario,
    int idLiquidaM,
    String fechaLiquidaM,
    int idSalidaM,
    int idRuta,
    int conteoTotal,
    int conteoMedio,
    double dineroConteo,
  ) async {
    try {
      String url_ = "${dotenv.env['baseUrl']}/updateLiquidacionChoferD";
      CodeActivacion oC = await oS.readDataPreferenciasEmpresa();
      var body_ = {
        "codigo_empresa": oC.data!.codigo,
        "propietario": propietario,
        "idLiquidaM": idLiquidaM,
        "fechaLiquidaM": fechaLiquidaM,
        "idSalidaM": idSalidaM,
        "idRuta": idRuta,
        "conteoTotal": conteoTotal,
        "conteoMedio": conteoMedio,
        "dineroConteo": dineroConteo,
        "choferId": propietario,
      };
      print("body_");
      print(body_);

      Response response = await http.post(
        Uri.parse(url_),
        body: json.encode(body_),
        headers: header_,
        encoding: enconding_,
      );

      LiquidacionDUpdateAppMovil oSa = LiquidacionDUpdateAppMovil.fromRawJson(
        response.body,
      );

      print('CODIGO EMPRESA liquidacion<< ${oC.data!.codigo}');
      print('propietario liquidacion<< ${propietario}');
      print('________________________________________________ ');
      print('STATUS CODE liquidacion<< ${oSa.statusCode}');
      ;

      return oSa;
    } catch (e) {
      print('ERROR: $e');
      return LiquidacionDUpdateAppMovil(statusCode: 400, msm: e.toString());
    }
  }
}
