import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'dart:convert';
import '../models/liquidacion _m/liquidacionUpdateM.dart';
import '../utils/url.dart';

import '../models/code_activacion/code_activacion.dart';
import '../repositories/security_data.dart';

class ProviderUpdateLiquidacionM2 {
  static SecurityData oS = new SecurityData();

  Future<LiquidacionMUpdateMAppMovil> updateLiquidacionM2(
    int idLiquidaM,
    String unidad,
    String fechaLiquidaM,
    double gComida,
    double gChofer,
    double gAyudante,
    double gLimpieza,
    double gBebida,
    double gOtros,
    double gTicket,
    double gPeaje,
    double gGasolina,
    String observacion,
    String propietario,
  ) async {
    try {
      String url_ = "${dotenv.env['baseUrl']}/updateLiquidacionChoferM";
      CodeActivacion oC = await oS.readDataPreferenciasEmpresa();
      String propietario = await oS.readDataPreferenciasLoginPropietario(
        'dataLoginPropietarioLoginPropietario',
      );
      var body_ = {
        "codigo_empresa": oC.data!.codigo,
        "idLiquidaM": idLiquidaM,
        "unidad": unidad,
        "fechaLiquidaM": fechaLiquidaM,
        "gComida": gComida,
        "gChofer": gChofer,
        "gAyudante": gAyudante,
        "gLimpieza": gLimpieza,
        "gBebida": gBebida,
        "gOtros": gOtros,
        "gTicket": gTicket,
        "gPeaje": gPeaje,
        "gGasolina": gGasolina,
        "observacion": observacion,
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

      LiquidacionMUpdateMAppMovil oSa = LiquidacionMUpdateMAppMovil.fromRawJson(
        response.body,
      );

      print('CODIGO EMPRESA liquidacion<< ${oC.data!.codigo}');
      print('propietario choferId<< ${propietario}');
      print('________________________________________________ ');
      print('STATUS CODE liquidacion<< ${oSa.statusCode}');
      ;

      return oSa;
    } catch (e) {
      print('ERROR: $e');
      return LiquidacionMUpdateMAppMovil(statusCode: 400, msm: e.toString());
    }
  }
}
