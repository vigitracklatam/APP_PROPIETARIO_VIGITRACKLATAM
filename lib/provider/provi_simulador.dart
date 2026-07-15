import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/code_activacion/code_activacion.dart';
import '../models/simulador/simulador.dart';
import '../repositories/security_data.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../utils/url.dart';

class ProviSimulador {
  static SecurityData oS = new SecurityData();

  Future<SimuladorAppMovil> readSimulador(
    String unidad,
    String fechaI,
    fechaF,
  ) async {
    try {
      String url_ = "${dotenv.env['baseUrl']}/SimuladorUnidadFechaHoraAppMovil";
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
        "unidad": unidad,
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
      SimuladorAppMovil oSa = SimuladorAppMovil.fromRawJson(response.body);
      /* print('CODIGO PROVISIMULADOR<< ${oC.data!.codigo}');
      print('STATUS CODE PROVISIMULADOR<< ${oSa.statusCode}');
      print('DATA PROVISIMULADOR >> ${jsonEncode(oSa.datos)}'); */
      return oSa;
    } catch (e) {
      return SimuladorAppMovil(statusCode: 400, msm: e.toString());
    }
  }
}
