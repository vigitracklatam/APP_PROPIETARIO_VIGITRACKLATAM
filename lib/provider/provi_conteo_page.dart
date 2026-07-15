import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../models/code_activacion/code_activacion.dart';
import '../models/conteo/conteo_page.dart';
import '../repositories/security_data.dart';
import '../utils/url.dart';

class ProviContePage {
  static SecurityData oS = new SecurityData();
  Future<ConteoPageAppMovil> readConteoPage(
    String unidad,
    ruta,
    fechaI,
    fechaF,
  ) async {
    try {
      String url_ = "${dotenv.env['baseUrl']}/contadorPasajerosFechaAppMovil";
      CodeActivacion oC = await oS.readDataPreferenciasEmpresa();
      //Traer los datos almacenados localmente
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
        "unidades": unidad,
        'rutas': ruta,
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

      ConteoPageAppMovil oCp = ConteoPageAppMovil.fromRawJson(response.body);

      //print('STATUS CODE ProviContePage ${oCp.statusCode}');
      //print('MENSAJES CODE ProviContePage ${oCp.sms}');
      //print('DATA CODE ProviContePage ${jsonString}');
      //print('DATA CODIOBSE CODE ProviContePage ${codiObse}');
      return oCp;
    } catch (e) {
      return ConteoPageAppMovil(statusCode: 400, sms: e.toString());
    }
  }
}
