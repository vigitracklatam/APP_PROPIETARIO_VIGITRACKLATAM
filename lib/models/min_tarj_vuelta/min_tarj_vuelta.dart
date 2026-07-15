// To parse this JSON data, do
//
//     final minTarVueltaAppMovil = minTarVueltaAppMovilFromJson(jsonString);

import 'dart:convert';

import 'data_min_tarj_vuelta.dart';

class MinTarVueltaAppMovil {
  int? statusCode;
  String? msm;
  List<DatosMinTarjetasVuelta>? datos;

  MinTarVueltaAppMovil({
    this.statusCode,
    this.msm,
    this.datos,
  });

  factory MinTarVueltaAppMovil.fromRawJson(String str) =>
      MinTarVueltaAppMovil.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MinTarVueltaAppMovil.fromJson(Map<String, dynamic> json) =>
      MinTarVueltaAppMovil(
        statusCode: json["status_code"],
        msm: json["msm"],
        datos: json["datos"] == null
            ? []
            : List<DatosMinTarjetasVuelta>.from(
                json["datos"]!.map((x) => DatosMinTarjetasVuelta.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "msm": msm,
        "datos": datos == null
            ? []
            : List<dynamic>.from(datos!.map((x) => x.toJson())),
      };
}
