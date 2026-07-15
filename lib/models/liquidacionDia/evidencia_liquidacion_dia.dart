// To parse this JSON data, do
//
//     final liquidacionDia = liquidacionDiaFromJson(jsonString);

import 'dart:convert';

EvidenciaLiquidacionDia liquidacionDiaFromJson(String str) =>
    EvidenciaLiquidacionDia.fromJson(json.decode(str));

String liquidacionDiaToJson(EvidenciaLiquidacionDia data) =>
    json.encode(data.toJson());

class EvidenciaLiquidacionDia {
  int? statusCode;
  List<Dato>? datos;
  String? msm;

  EvidenciaLiquidacionDia({this.statusCode, this.datos, this.msm});

  factory EvidenciaLiquidacionDia.fromRawJson(String str) =>
      EvidenciaLiquidacionDia.fromJson(json.decode(str));

  factory EvidenciaLiquidacionDia.fromJson(Map<String, dynamic> json) =>
      EvidenciaLiquidacionDia(
        statusCode: json["status_code"],
        datos:
            json["datos"] == null
                ? []
                : List<Dato>.from(json["datos"]!.map((x) => Dato.fromJson(x))),
        msm: json["msm"],
      );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "datos":
        datos == null ? [] : List<dynamic>.from(datos!.map((x) => x.toJson())),
    "msm": msm,
  };
}

class Dato {
  int? id;
  String? urlEvidencia1;
  dynamic urlEvidencia2;
  dynamic urlEvidencia3;
  dynamic urlEvidencia4;

  Dato({
    this.id,
    this.urlEvidencia1,
    this.urlEvidencia2,
    this.urlEvidencia3,
    this.urlEvidencia4,
  });

  factory Dato.fromJson(Map<String, dynamic> json) => Dato(
    id: json["id"],
    urlEvidencia1: json["url_evidencia_1"],
    urlEvidencia2: json["url_evidencia_2"],
    urlEvidencia3: json["url_evidencia_3"],
    urlEvidencia4: json["url_evidencia_4"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "url_evidencia_1": urlEvidencia1,
    "url_evidencia_2": urlEvidencia2,
    "url_evidencia_3": urlEvidencia3,
    "url_evidencia_4": urlEvidencia4,
  };
}
