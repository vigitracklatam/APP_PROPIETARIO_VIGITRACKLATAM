import 'dart:convert';

import 'data_configRecalificar.dart';

class ReadConfigRecalificarppMovil {
  int? statusCode;
  DataConfigRecalificar? datos;

  ReadConfigRecalificarppMovil({
    this.statusCode,
    this.datos,
  });

  factory ReadConfigRecalificarppMovil.fromRawJson(String str) =>
      ReadConfigRecalificarppMovil.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReadConfigRecalificarppMovil.fromJson(Map<String, dynamic> json) =>
      ReadConfigRecalificarppMovil(
        statusCode: json["status_code"],
        datos: json["datos"] == null
            ? null
            : DataConfigRecalificar.fromJson(json["datos"]),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "datos": datos?.toJson(),
      };
}
