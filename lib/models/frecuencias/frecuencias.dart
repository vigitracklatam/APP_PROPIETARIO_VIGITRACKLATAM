import 'dart:convert';

import 'datos_frecuencias.dart';

class FrecuenciasPropietario {
  int? statusCode;
  String? msg;
  List<DatoFrecuencia>? data;

  FrecuenciasPropietario({
    this.statusCode,
    this.msg,
    this.data,
  });

  factory FrecuenciasPropietario.fromRawJson(String str) =>
      FrecuenciasPropietario.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FrecuenciasPropietario.fromJson(Map<String, dynamic> json) =>
      FrecuenciasPropietario(
        statusCode: json["status_code"],
        msg: json["msg"],
        data: json["data"] == null
            ? []
            : List<DatoFrecuencia>.from(
                json["data"]!.map((x) => DatoFrecuencia.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "msg": msg,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}
