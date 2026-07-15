// To parse this JSON data, do
//
//     final velMaxAppMovil = velMaxAppMovilFromJson(jsonString);

import 'dart:convert';

class VelMaxAppMovil {
  int? statusCode;
  int? datos;
  String? msm;

  VelMaxAppMovil({
    this.statusCode,
    this.datos,
    this.msm,
  });

  factory VelMaxAppMovil.fromRawJson(String str) =>
      VelMaxAppMovil.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VelMaxAppMovil.fromJson(Map<String, dynamic> json) => VelMaxAppMovil(
        statusCode: json["status_code"],
        datos: json["datos"],
        msm: json["msm"],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "datos": datos,
        "msm": msm,
      };
}
