// To parse this JSON data, do
//
//     final recorridoAppMovil = recorridoAppMovilFromJson(jsonString);

import 'dart:convert';

import 'data_recorrido.dart';

class RecorridoAppMovil {
  int? statusCode;
  List<DatoRecorrido>? datos;
  String? msm;

  RecorridoAppMovil({
    this.statusCode,
    this.datos,
    this.msm,
  });

  factory RecorridoAppMovil.fromRawJson(String str) =>
      RecorridoAppMovil.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RecorridoAppMovil.fromJson(Map<String, dynamic> json) =>
      RecorridoAppMovil(
        statusCode: json["status_code"],
        datos: json["datos"] == null
            ? []
            : List<DatoRecorrido>.from(
                json["datos"]!.map((x) => DatoRecorrido.fromJson(x))),
        msm: json["msm"],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "datos": datos == null
            ? []
            : List<dynamic>.from(datos!.map((x) => x.toJson())),
        "msm": msm,
      };
}
