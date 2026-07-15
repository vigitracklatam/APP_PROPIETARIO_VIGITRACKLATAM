import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/code_activacion/code_activacion.dart';
import '../models/geocerca/geocerca.dart';
import '../repositories/security_data.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../utils/url.dart';

class ProviGeocerca {
  static SecurityData oS = new SecurityData();

  Future<GeocercaAppMovil> readGeocerca(String rutas) async {
    int statusCode = 400;
    try {
      String url_ = "${dotenv.env['baseUrl']}/AllControlesPorRutaAppMovil";
      CodeActivacion oC = await oS.readDataPreferenciasEmpresa();
      String propietario = await oS.readDataPreferenciasLoginPropietario(
        'dataLoginPropietarioLoginPropietario',
      );

      var body_ = {
        "codigo_empresa": oC.data!.codigo,
        "rutas": [rutas],
        "propietario": propietario,
      };
      //print('object body');
      //print(body_);
      Response response = await http.post(
        Uri.parse(url_),
        body: json.encode(body_),
        headers: header_,
        encoding: enconding_,
      );

      GeocercaAppMovil oG = GeocercaAppMovil.fromRawJson(response.body);

      statusCode = oG.statusCode!;

      //print('CODIGO PROVIGEOCERCA<< ${oC.data!.codigo}');
      //print('STATUS CODE PROVIGEOCERCA<< ${oG.statusCode}');
      //print('DATA PROVIGEOCERCA >> ${jsonEncode(oG.data)}');
      return oG;
    } catch (e) {
      return GeocercaAppMovil(statusCode: statusCode, msm: e.toString());
    }
  }
}
