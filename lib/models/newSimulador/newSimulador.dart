import 'dart:convert';

import 'data_newSimulador.dart';

class SimuladorPageAppMovil {
  int? statusCode;
  List<DatoNewSimulador>? datos;
  String? msm;

  SimuladorPageAppMovil({
    this.statusCode,
    this.datos,
    this.msm,
  });

  factory SimuladorPageAppMovil.fromRawJson(String str) =>
      SimuladorPageAppMovil.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SimuladorPageAppMovil.fromJson(Map<String, dynamic> json) =>
      SimuladorPageAppMovil(
        statusCode: json["status_code"],
        datos: json["datos"] == null
            ? []
            : List<DatoNewSimulador>.from(
                json["datos"]!.map((x) => DatoNewSimulador.fromJson(x))),
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
