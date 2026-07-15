import 'dart:convert';

import 'data_minutostarjetas.dart';

class MinutosTarjetasAppMovil {
  int? statusCode;
  String? msm;
  List<DatoMinTarjeta>? datos;

  MinutosTarjetasAppMovil({this.statusCode, this.msm, this.datos});

  factory MinutosTarjetasAppMovil.fromRawJson(String str) =>
      MinutosTarjetasAppMovil.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MinutosTarjetasAppMovil.fromJson(Map<String, dynamic> json) =>
      MinutosTarjetasAppMovil(
        statusCode: json["status_code"],
        msm: json["msm"],
        datos:
            json["datos"] == null
                ? []
                : List<DatoMinTarjeta>.from(
                  json["datos"]!.map((x) => DatoMinTarjeta.fromJson(x)),
                ),
      );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "msm": msm,
    "datos":
        datos == null ? [] : List<dynamic>.from(datos!.map((x) => x.toJson())),
  };
}
