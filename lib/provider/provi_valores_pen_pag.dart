import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../models/code_activacion/code_activacion.dart';
import '../models/valores_pendientes_pagados/valores_pendientes_pagados.dart';
import '../repositories/security_data.dart';
import '../utils/url.dart';

class ProviValoresPenPag {
  static SecurityData oS = new SecurityData();
  Future<ValoresPendientesPagadosAppMovil> readValoresPenPag(
    String unidad,
    fechaI,
    fechaF,
    int tipo,
  ) async {
    try {
      String url_ = "${dotenv.env['baseUrl']}/pagosPendientesPagadosMovil";
      CodeActivacion oC = await oS.readDataPreferenciasEmpresa();
      String propietario = await oS.readDataPreferenciasLoginPropietario(
        'dataLoginPropietarioLoginPropietario',
      );
      //Traer los datos almacenados localmente
      var jsonString = await oS.readDataPreferenciasLoginPropietario(
        'dataLoginPropietarioLoginUnidadesd',
      );
      Map<String, dynamic> jsonData = jsonDecode(jsonString);
      List<dynamic> data = jsonData['data'];
      // Accede al primer elemento de la lista
      Map<String, dynamic> firstElement = data[0];
      String codiObse = firstElement['CodiObse'];

      var body_ = {
        "codigo": oC.data!.codigo,
        "unidad": unidad,
        "fechaI": fechaI,
        "fechaF": fechaF,
        "tipo": tipo,
        "CodiObse": codiObse,
        "propietario": propietario,
      };

      Response response = await http.post(
        Uri.parse(url_),
        body: json.encode(body_),
        headers: header_,
        encoding: enconding_,
      );

      ValoresPendientesPagadosAppMovil oVpp =
          ValoresPendientesPagadosAppMovil.fromRawJson(response.body);
      /* print('Codigo << ${oC.data!.codigo}');
      print('STATUS CODE proviValoresPenPag << ${oVpp.statusCode}');
      print('DATA proviValoresPenPag >> ${jsonEncode(oVpp.datos)}'); */

      return oVpp;
    } catch (e) {
      return ValoresPendientesPagadosAppMovil(
        statusCode: 400,
        msm: e.toString(),
      );
    }
  }
}
