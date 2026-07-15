import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../models/code_activacion/code_activacion.dart';
import '../models/liquidacionDia/detalle_liquidacion_dia.dart';
import '../models/liquidacionDia/evidencia_liquidacion_dia.dart';
import '../models/liquidacionDia/liquidacion_dia.dart';
import '../repositories/security_data.dart';
import '../utils/url.dart';

class ProviLiquidacionDia {
  static SecurityData oS = new SecurityData();

  Future<LiquidacionDia> readLiquidacionDia(String unidad, String fecha) async {
    String propietario = await oS.readDataPreferenciasLoginPropietario(
      'dataLoginPropietarioLoginPropietario',
    );
    try {
      String url_ =
          "${dotenv.env['baseUrl']}/calcular-liquidacion-diaria-propietario";
      CodeActivacion oC = await oS.readDataPreferenciasEmpresa();

      var body_ = {
        "codigo": oC.data!.codigo,
        "unidad": unidad,
        "fecha": fecha,
        "propietario": propietario,
      };

      print("URL: $url_");
      print("BODY: ${json.encode(body_)}");

      Response response = await http.post(
        Uri.parse(url_),
        body: json.encode(body_),
        headers: header_,
        encoding: enconding_,
      );

      print("STATUS: ${response.statusCode}");
      print("RESPONSE: ${response.body}");
      return LiquidacionDia.fromRawJson(response.body);
    } catch (e) {
      return LiquidacionDia(statusCode: 400, msm: e.toString());
    }
  }

  Future<DetalleLiquidacionDia> readDetalleLiquidacionDia(int id) async {
    try {
      String url_ =
          "${dotenv.env['baseUrl']}/detalle-liquidacion-dia-propietario";
      CodeActivacion oC = await oS.readDataPreferenciasEmpresa();

      var body_ = {"codigo": oC.data!.codigo, "id": id};

      print("URL: $url_");
      print("BODY: ${json.encode(body_)}");

      Response response = await http.post(
        Uri.parse(url_),
        body: json.encode(body_),
        headers: header_,
        encoding: enconding_,
      );

      print("STATUS: ${response.statusCode}");
      print("RESPONSE: ${response.body}");
      return DetalleLiquidacionDia.fromRawJson(response.body);
    } catch (e) {
      return DetalleLiquidacionDia(statusCode: 400, msm: e.toString());
    }
  }

  Future<EvidenciaLiquidacionDia> readEvidenciaLiquidacionDia(int id) async {
    try {
      String url_ =
          "${dotenv.env['baseUrl']}/evidencia-liquidacion-dia-propietario";
      CodeActivacion oC = await oS.readDataPreferenciasEmpresa();

      var body_ = {"codigo": oC.data!.codigo, "id": id};

      print("URL: $url_");
      print("BODY: ${json.encode(body_)}");

      Response response = await http.post(
        Uri.parse(url_),
        body: json.encode(body_),
        headers: header_,
        encoding: enconding_,
      );

      print("STATUS: ${response.statusCode}");
      print("RESPONSE: ${response.body}");
      return EvidenciaLiquidacionDia.fromRawJson(response.body);
    } catch (e) {
      return EvidenciaLiquidacionDia(statusCode: 400, msm: e.toString());
    }
  }
}
