import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/code_activacion/code_activacion.dart';
import '../models/historial_unidad/historial_unidad.dart';
import '../repositories/security_data.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../utils/url.dart';

class ProviHistorialUnidad {
  static SecurityData oS = new SecurityData();

  Future<HistorialUnidadAppMovil> readHistorialUnidad(
    String unidad,
    salida,
    fechaI,
    fechaF,
  ) async {
    int statusCode = 400;
    try {
      String url_ = "${dotenv.env['baseUrl']}/historialUnidadSalidaAppMovil";
      CodeActivacion oC = await oS.readDataPreferenciasEmpresa();
      String propietario = await oS.readDataPreferenciasLoginPropietario(
        'dataLoginPropietarioLoginPropietario',
      );
      var body_ = {
        "codigo_empresa": oC.data!.codigo,
        "unidad": unidad,
        "salida": salida,
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

      HistorialUnidadAppMovil oHu = HistorialUnidadAppMovil.fromRawJson(
        response.body,
      );

      statusCode = oHu.statusCode!;

      print('CODIGO PROVIHistoralUnidad<< ${oC.data!.codigo}');
      print('STATUS CODE HistoralUnidad<< ${oHu.statusCode}');
      print('DATA HistoralUnidad >> ${jsonEncode(oHu.datos)}');
      return oHu;
    } catch (e) {
      return HistorialUnidadAppMovil(statusCode: statusCode, msm: e.toString());
    }
  }
}
