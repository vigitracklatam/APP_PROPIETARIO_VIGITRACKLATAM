import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../models/code_activacion/code_activacion.dart';
import '../utils/url.dart';

class RepoCodeActivacion {
  static Future<CodeActivacion> readCodigoActivacion(String empresa) async {
    try {
      String url_ = "${dotenv.env['baseUrl']}/${empresa}/infoEmpresa";

      Response response = await http.post(
        Uri.parse(url_),
        headers: header_,
        encoding: enconding_,
      );

      //print('Aca datos de codigoactivacion >>>>>>>>>${response.body}');

      return CodeActivacion.fromRawJson(response.body);
    } catch (e) {
      return CodeActivacion(statusCode: 400, msm: e.toString());
    }
  }
}
