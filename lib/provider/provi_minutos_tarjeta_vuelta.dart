import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../models/code_activacion/code_activacion.dart';
import '../models/min_tarj_vuelta/min_tarj_vuelta.dart';
import '../repositories/security_data.dart';
import '../utils/url.dart';

class ProviMinutosTarjetasVuelta {
  static SecurityData oS = new SecurityData();

  Future<MinTarVueltaAppMovil> readMinTarVuelta(
    String fechaI,
    fechaF,
    unidades,
  ) async {
    try {
      String url_ =
          "${dotenv.env['baseUrl']}/ProduccionMinutosTarjetasVueltaAppMovil";
      CodeActivacion oC = await oS.readDataPreferenciasEmpresa();

      //Traer los datos almacenados localmente
      var jsonString = await oS.readDataPreferenciasLoginPropietario(
        'dataLoginPropietarioLoginUnidadesd',
      );
      String propietario = await oS.readDataPreferenciasLoginPropietario(
        'dataLoginPropietarioLoginPropietario',
      );
      Map<String, dynamic> jsonData = jsonDecode(jsonString);
      List<dynamic> data = jsonData['data'];
      // Accede al primer elemento de la lista
      Map<String, dynamic> firstElement = data[0];
      String codiObse = firstElement['CodiObse'];

      var body_ = {
        "codigo_empresa": oC.data!.codigo,
        "fechaI": fechaI,
        "fechaF": fechaF,
        "unidades": unidades,
        "CodiObse": codiObse,
        "propietario": propietario,
      };
      Response response = await http.post(
        Uri.parse(url_),
        body: json.encode(body_),
        headers: header_,
        encoding: enconding_,
      );

      MinTarVueltaAppMovil oMtv = MinTarVueltaAppMovil.fromRawJson(
        response.body,
      );
      //print('codigo empresa proviMinTarVueltas ${oC.data!.codigo}');
      //print('STATUS CODE proviMinTarVueltas ${oMtv.statusCode}');
      //print('DATA proviMinTarVueltas ${jsonEncode(oMtv.datos)}');
      return oMtv;
    } catch (e) {
      return MinTarVueltaAppMovil(statusCode: 400, msm: e.toString());
    }
  }
}
