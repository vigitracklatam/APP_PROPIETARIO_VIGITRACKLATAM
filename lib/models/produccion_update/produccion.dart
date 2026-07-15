import 'dart:convert';
import 'data_produccion.dart';

class ProduccionSinConteoAppMovil {
  int? statusCode;
  String? msm;
  List<DatoProduccion?>? datos;

  ProduccionSinConteoAppMovil({this.statusCode, this.msm, this.datos});

  factory ProduccionSinConteoAppMovil.fromRawJson(String str) =>
      ProduccionSinConteoAppMovil.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProduccionSinConteoAppMovil.fromJson(Map<String, dynamic> json) =>
      ProduccionSinConteoAppMovil(
        statusCode: json["status_code"],
        msm: json["msm"],
        datos:
            json["datos"] == null
                ? []
                : List<DatoProduccion?>.from(
                  json["datos"]!.map(
                    (x) => x == null ? null : DatoProduccion.fromJson(x),
                  ),
                ),
      );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "msm": msm,
    "datos":
        datos == null ? [] : List<dynamic>.from(datos!.map((x) => x?.toJson())),
  };
}
