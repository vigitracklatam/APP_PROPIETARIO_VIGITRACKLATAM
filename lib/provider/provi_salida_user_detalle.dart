import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';
import '../models/salida/salida_user_detalle.dart';
import '../utils/url.dart';

import '../models/code_activacion/code_activacion.dart';
import '../repositories/security_data.dart';

class ProviSalidaUserDetalle {
  static SecurityData oS = new SecurityData();

  Future<SalidasDetalleAppMovil> readSalidaUserDetalle(int salida) async {
    try {
      String url_ = "${dotenv.env['baseUrl']}/detalleSalidaAppMovil";
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
        "salida": salida,
        "CodiObse": codiObse,
        "propietario": propietario,
      };

      Response response = await http.post(
        Uri.parse(url_),
        body: json.encode(body_),
        headers: header_,
        encoding: enconding_,
      );

      SalidasDetalleAppMovil oSd = SalidasDetalleAppMovil.fromRawJson(
        response.body,
      );

      return oSd;
    } catch (e) {
      return SalidasDetalleAppMovil(statusCode: 400, sms: e.toString());
    }
  }
}
