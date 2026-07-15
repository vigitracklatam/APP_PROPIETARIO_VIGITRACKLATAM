import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../models/code_activacion/code_activacion.dart';
import '../models/minutos_tarjetas_resumen/minutostarjetasresumen.dart';
import '../repositories/security_data.dart';
import '../utils/url.dart';

class ProviMinTarResumen {
  static SecurityData oS = new SecurityData();

  Future<MinutosTarjetasResumenAppMovil> readMinTarResumen(
    String fechaI,
    fechaF,
  ) async {
    try {
      String url_ =
          "${dotenv.env['baseUrl']}/ProduccionMinutosTarjetaResumidoAppMovil";
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
        "codigo_empresa": oC.data!.codigo,
        "fechaI": fechaI,
        "fechaF": fechaF,
        "CodiObse": codiObse,
        "propietario": propietario,
      };

      Response response = await http.post(
        Uri.parse(url_),
        body: json.encode(body_),
        headers: header_,
        encoding: enconding_,
      );

      MinutosTarjetasResumenAppMovil oMtr =
          MinutosTarjetasResumenAppMovil.fromRawJson(response.body);
      //print('STATUS CODE provimintarResumen << ${oMtr.statusCode}');
      //print('DATA provimintarResumen >> ${jsonEncode(oMtr.datos)}');
      return oMtr;
    } catch (e) {
      return MinutosTarjetasResumenAppMovil(statusCode: 400, msm: e.toString());
    }
  }
}
