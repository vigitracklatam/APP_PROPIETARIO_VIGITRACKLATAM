import 'dart:convert';

import 'unidad_despacho_data.dart';

class UnidadesDespachoPropietario {
  int? statusCode;
  List<DatoUnidadesDespacho>? datos;
  String? msm;

  UnidadesDespachoPropietario({
    this.statusCode,
    this.datos,
    this.msm,
  });

  factory UnidadesDespachoPropietario.fromRawJson(String str) =>
      UnidadesDespachoPropietario.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UnidadesDespachoPropietario.fromJson(Map<String, dynamic> json) =>
      UnidadesDespachoPropietario(
        statusCode: json["status_code"],
        datos: json["datos"] == null
            ? []
            : List<DatoUnidadesDespacho>.from(
                json["datos"]!.map((x) => DatoUnidadesDespacho.fromJson(x))),
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
