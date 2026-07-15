// To parse this JSON data, do
//
//     final minTarVueResumenAppMovil = minTarVueResumenAppMovilFromJson(jsonString);

import 'dart:convert';

import 'data_min_tar_vue_resumen.dart';

class MinTarVueResumenAppMovil {
  int? statusCode;
  String? msm;
  List<DatoMinTarVueResumen>? datos;

  MinTarVueResumenAppMovil({
    this.statusCode,
    this.msm,
    this.datos,
  });

  factory MinTarVueResumenAppMovil.fromRawJson(String str) =>
      MinTarVueResumenAppMovil.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MinTarVueResumenAppMovil.fromJson(Map<String, dynamic> json) =>
      MinTarVueResumenAppMovil(
        statusCode: json["status_code"],
        msm: json["msm"],
        datos: json["datos"] == null
            ? []
            : List<DatoMinTarVueResumen>.from(
                json["datos"]!.map((x) => DatoMinTarVueResumen.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "msm": msm,
        "datos": datos == null
            ? []
            : List<dynamic>.from(datos!.map((x) => x.toJson())),
      };
}
