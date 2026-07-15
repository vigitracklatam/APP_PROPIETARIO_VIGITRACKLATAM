import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import '../models/code_activacion/code_activacion.dart';
import '../models/control/control_propietario.dart';
import '../repositories/security_data.dart';
import '../utils/url.dart';

class ProviControlMonitoreo {
  static SecurityData oS = new SecurityData();

  Future<ControlPropietarioAppMovil> readControlesMonitoreo() async {
    try {
      String url_ = "${dotenv.env['baseUrl']}/AllControlesAppMovil";
      CodeActivacion oC = await oS.readDataPreferenciasEmpresa();
      var jsonString = await oS.readDataPreferenciasLoginPropietario(
        'dataLoginPropietarioLoginUnidadesd',
      );
      Map<String, dynamic> jsonData = jsonDecode(jsonString);
      List<dynamic> data = jsonData['data'];
      // Accede al primer elemento de la lista
      Map<String, dynamic> firstElement = data[0];
      String codiObse = firstElement['CodiObse'];

      String propietario = await oS.readDataPreferenciasLoginPropietario(
        'dataLoginPropietarioLoginPropietario',
      );

      var body_ = {
        "codigo_empresa": oC.data!.codigo,
        "CodiObse": codiObse,
        "propietario": propietario,
      };
      Response response = await http.post(
        Uri.parse(url_),
        body: json.encode(body_),
        headers: header_,
        encoding: enconding_,
      );

      ControlPropietarioAppMovil oCp = ControlPropietarioAppMovil.fromRawJson(
        response.body,
      );

      return oCp;
    } catch (e) {
      return ControlPropietarioAppMovil(statusCode: 400, msg: e.toString());
    }
  }
}
