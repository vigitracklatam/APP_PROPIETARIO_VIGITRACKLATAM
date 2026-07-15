import 'dart:convert';

import 'data_liquidacion.dart';

class LiquidacionDetalleAppMovil {
  int? statusCode;
  String? msm;
  List<DatoLiquidacion>? datos;

  LiquidacionDetalleAppMovil({this.statusCode, this.msm, this.datos});

  factory LiquidacionDetalleAppMovil.fromRawJson(String str) =>
      LiquidacionDetalleAppMovil.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LiquidacionDetalleAppMovil.fromJson(Map<String, dynamic> json) =>
      LiquidacionDetalleAppMovil(
        statusCode: json["status_code"],
        msm: json["msm"],
        datos:
            json["datos"] == null
                ? []
                : List<DatoLiquidacion>.from(
                  json["datos"]!.map((x) => DatoLiquidacion.fromJson(x)),
                ),
      );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "msm": msm,
    "datos":
        datos == null ? [] : List<dynamic>.from(datos!.map((x) => x.toJson())),
  };
}
