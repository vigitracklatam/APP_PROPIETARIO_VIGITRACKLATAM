import 'dart:convert';

import 'datos_rutas.dart';

class RutasPropietario {
  int? statusCode;
  List<DatosRutas>? data;
  String? msm;

  RutasPropietario({
    this.statusCode,
    this.data,
    this.msm,
  });

  factory RutasPropietario.fromRawJson(String str) =>
      RutasPropietario.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RutasPropietario.fromJson(Map<String, dynamic> json) =>
      RutasPropietario(
        statusCode: json["status_code"],
        data: json["data"] == null
            ? []
            : List<DatosRutas>.from(
                json["data"]!.map((x) => DatosRutas.fromJson(x))),
        msm: json["msm"],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "msm": msm,
      };
}
