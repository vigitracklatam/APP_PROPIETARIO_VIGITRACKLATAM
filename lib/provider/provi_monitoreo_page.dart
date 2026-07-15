import 'dart:convert';
import 'dart:convert' as convert;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import '../models/code_activacion/code_activacion.dart';
import '../models/monitoreo/monitoreo_page.dart';
import '../repositories/security_data.dart';
import '../utils/url.dart';

class ProviMonitoreoPage {
  static SecurityData oS = new SecurityData();

  Future<MonitoreoAppMovil> readMonitoreoPage(
    String propietario,
    unidad,
  ) async {
    try {
      String url_ = "${dotenv.env['baseUrl']}/monitoringPropietarioAppMovil";
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
        "propietario": propietario,
        "unidad": unidad,
        "CodiObse": codiObse,
        "propietario": propietario,
      };

      Response response = await http.post(
        Uri.parse(url_),
        body: json.encode(body_),
        headers: header_,
        encoding: enconding_,
      );


      MonitoreoAppMovil oMa = MonitoreoAppMovil.fromRawJson(response.body);
      //print('object' + jsonEncode(oMa));

      return oMa;
    } catch (e) {
      return MonitoreoAppMovil(statusCode: 400, sms: e.toString());
    }
  }

  Future<String> getDireccion(lat, lng) async {
    try {
      var url = Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=" +
            lat +
            "," +
            lng +
            "&key=AIzaSyCMR83z2AyaiNJTfUHKechVpGh_MjLQvHA",
      );
      //print("object url" + url.toString());
      //print(url.toString());
      var response = await http.get(url);
      var json = convert.json.decode(response.body);
      //print(json);
      var results = json['results'][0]['formatted_address'];
      return results;
    } catch (e) {
      return 'try Catch';
    }
  }
}
