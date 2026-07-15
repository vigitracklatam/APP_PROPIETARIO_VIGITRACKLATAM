import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../models/code_activacion/code_activacion.dart';
import '../models/unidadDespacho/unidad_despacho.dart';
import '../repositories/security_data.dart';
import '../utils/url.dart';

class ProviUnidadesDespacho {
  static SecurityData oS = new SecurityData();
  Future<UnidadesDespachoPropietario> readUnidadesDespacho() async {
    String propietario = await oS.readDataPreferenciasLoginPropietario(
      'dataLoginPropietarioLoginPropietario',
    );
    print("Aca propietario: " + propietario);
    try {
      String url_ = "${dotenv.env['baseUrl']}/readUnidadesPropietarioAppMovil";
      CodeActivacion oC = await oS.readDataPreferenciasEmpresa();

      var body_ = {
        "codigo_empresa": oC.data!.codigo,
        "propietario": propietario,
      };

      Response response = await http.post(
        Uri.parse(url_),
        body: json.encode(body_),
        headers: header_,
        encoding: enconding_,
      );
      //print(body_);
      //print("Aca unidades despacho: " + response.body);

      UnidadesDespachoPropietario oUa = UnidadesDespachoPropietario.fromRawJson(
        response.body,
      );
      return oUa;
    } catch (e) {
      return UnidadesDespachoPropietario(statusCode: 400, msm: e.toString());
    }
  }
}
