import 'dart:convert';

import 'data_historial_unidad.dart';

class HistorialUnidadAppMovil {
  int? statusCode;
  List<DatoHistorialUnidad>? datos;
  String? msm;

  HistorialUnidadAppMovil({
    this.statusCode,
    this.datos,
    this.msm,
  });

  factory HistorialUnidadAppMovil.fromRawJson(String str) =>
      HistorialUnidadAppMovil.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HistorialUnidadAppMovil.fromJson(Map<String, dynamic> json) =>
      HistorialUnidadAppMovil(
        statusCode: json["status_code"],
        datos: json["datos"] == null
            ? []
            : List<DatoHistorialUnidad>.from(
                json["datos"]!.map((x) => DatoHistorialUnidad.fromJson(x))),
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
