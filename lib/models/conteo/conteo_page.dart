// To parse this JSON data, do
//
//     final salidasAppMovil = salidasAppMovilFromJson(jsonString);

import 'dart:convert';

import 'data_conteo_page.dart';

class ConteoPageAppMovil {
  int? statusCode;
  List<DatoConteo>? datos;
  String? sms;

  ConteoPageAppMovil({
    this.statusCode,
    this.datos,
    this.sms,
  });

  factory ConteoPageAppMovil.fromRawJson(String str) =>
      ConteoPageAppMovil.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ConteoPageAppMovil.fromJson(Map<String, dynamic> json) =>
      ConteoPageAppMovil(
        statusCode: json["status_code"],
        datos: json["datos"] == null
            ? []
            : List<DatoConteo>.from(
                json["datos"]!.map((x) => DatoConteo.fromJson(x))),
        sms: json["msm"],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "datos": datos == null
            ? []
            : List<dynamic>.from(datos!.map((x) => x.toJson())),
        "msm": sms,
      };
}
