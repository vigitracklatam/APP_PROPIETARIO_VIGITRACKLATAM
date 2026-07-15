import 'dart:convert';

import 'data_salida_user.dart';

class SalidasAppMovil {
  int? statusCode;
  String? msm;
  List<DatoSalida>? datos;

  SalidasAppMovil({
    this.statusCode,
    this.msm,
    this.datos,
  });

  factory SalidasAppMovil.fromRawJson(String str) =>
      SalidasAppMovil.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SalidasAppMovil.fromJson(Map<String, dynamic> json) =>
      SalidasAppMovil(
        statusCode: json["status_code"],
        msm: json["msm"],
        datos: json["datos"] == null
            ? []
            : List<DatoSalida>.from(
                json["datos"]!.map((x) => DatoSalida.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "msm": msm,
        "datos": datos == null
            ? []
            : List<dynamic>.from(datos!.map((x) => x.toJson())),
      };
}
