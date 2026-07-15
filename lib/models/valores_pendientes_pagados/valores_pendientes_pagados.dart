// To parse this JSON data, do
//
//     final valoresPendientesPagadosAppMovil = valoresPendientesPagadosAppMovilFromJson(jsonString);

import 'dart:convert';

import 'data_valores_pendientes_pagados.dart';

class ValoresPendientesPagadosAppMovil {
  int? statusCode;
  String? msm;
  List<DatoValoresPenPag>? datos;

  ValoresPendientesPagadosAppMovil({
    this.statusCode,
    this.msm,
    this.datos,
  });

  factory ValoresPendientesPagadosAppMovil.fromRawJson(String str) =>
      ValoresPendientesPagadosAppMovil.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ValoresPendientesPagadosAppMovil.fromJson(
          Map<String, dynamic> json) =>
      ValoresPendientesPagadosAppMovil(
        statusCode: json["status_code"],
        msm: json["msm"],
        datos: json["datos"] == null
            ? []
            : List<DatoValoresPenPag>.from(
                json["datos"]!.map((x) => DatoValoresPenPag.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "msm": msm,
        "datos": datos == null
            ? []
            : List<dynamic>.from(datos!.map((x) => x.toJson())),
      };
}
