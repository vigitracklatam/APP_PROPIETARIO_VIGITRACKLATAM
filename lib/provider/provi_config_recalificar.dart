import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import '../models/code_activacion/code_activacion.dart';
import '../models/configRecalicar/configRecalificar.dart';
import '../repositories/security_data.dart';
import '../utils/url.dart';

class ProviConfigRecalificar {
  static SecurityData oS = new SecurityData();
  Future<ReadConfigRecalificarppMovil> readConfigRecalificar() async {
    try {
      //print("ENTRANDO A configuraciones recalificar  ..");
      String url_ =
          "${dotenv.env['baseUrl']}/ReadConfigRecalificaSalidaPropietario";
      CodeActivacion oC = await oS.readDataPreferenciasEmpresa();
      String propietario = await oS.readDataPreferenciasLoginPropietario(
        'dataLoginPropietarioLoginPropietario',
      );
      var body_ = {
        "codigo_empresa": oC.data!.codigo,
        "CodiClieObse": oC.data!.codigo,
        "propietario": propietario,
      };
      Response response = await http.post(
        Uri.parse(url_),
        body: json.encode(body_),
        headers: header_,
        encoding: enconding_,
      );

      //print("ACA CONFIGURACIONES RECALIFICAR" + response.body);

      ReadConfigRecalificarppMovil oCr =
          ReadConfigRecalificarppMovil.fromRawJson(response.body);
      return oCr;
    } catch (e) {
      return ReadConfigRecalificarppMovil(statusCode: 400);
    }
  }
}
