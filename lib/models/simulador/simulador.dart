// To parse this JSON data, do
//
//     final simuladorAppMovil = simuladorAppMovilFromJson(jsonString);

import 'dart:convert';

import 'data_simulador.dart';

class SimuladorAppMovil {
  int? statusCode;
  List<DatoSimulador>? datos;
  String? msm;

  SimuladorAppMovil({
    this.statusCode,
    this.datos,
    this.msm,
  });

  factory SimuladorAppMovil.fromRawJson(String str) =>
      SimuladorAppMovil.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SimuladorAppMovil.fromJson(Map<String, dynamic> json) =>
      SimuladorAppMovil(
        statusCode: json["status_code"],
        datos: json["datos"] == null
            ? []
            : List<DatoSimulador>.from(
                json["datos"]!.map((x) => DatoSimulador.fromJson(x))),
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
