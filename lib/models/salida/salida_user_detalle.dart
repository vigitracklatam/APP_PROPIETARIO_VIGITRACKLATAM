// To parse this JSON data, do
//
//     final salidasAppMovil = salidasAppMovilFromJson(jsonString);

import 'dart:convert';

import 'data_salida_user_detalle.dart';

class SalidasDetalleAppMovil {
  SalidasDetalleAppMovil({
    this.statusCode,
    this.sms,
    this.datos,
  });

  int? statusCode;
  String? sms;
  List<DatoSalidaUserDetalle>? datos;

  factory SalidasDetalleAppMovil.fromRawJson(String str) =>
      SalidasDetalleAppMovil.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SalidasDetalleAppMovil.fromJson(Map<String, dynamic> json) =>
      SalidasDetalleAppMovil(
        statusCode: json["status_code"],
        sms: json["sms"],
        datos: json["data"] == null
            ? []
            : List<DatoSalidaUserDetalle>.from(
                json["data"]!.map((x) => DatoSalidaUserDetalle.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "sms": sms,
        "data": datos == null
            ? []
            : List<dynamic>.from(datos!.map((x) => x.toJson())),
      };
}
