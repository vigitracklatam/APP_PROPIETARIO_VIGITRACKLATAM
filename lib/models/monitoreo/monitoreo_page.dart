// To parse this JSON data, do
//
//     final monitoreoAppMovil = monitoreoAppMovilFromJson(jsonString);

import 'dart:convert';

import 'data_monitoreo_page.dart';

class MonitoreoAppMovil {
  int? statusCode;
  List<DatoMonitoreo>? datos;
  String? sms;

  MonitoreoAppMovil({
    this.statusCode,
    this.datos,
    this.sms,
  });

  factory MonitoreoAppMovil.fromRawJson(String str) =>
      MonitoreoAppMovil.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MonitoreoAppMovil.fromJson(Map<String, dynamic> json) =>
      MonitoreoAppMovil(
        statusCode: json["status_code"],
        datos: json["datos"] == null
            ? []
            : List<DatoMonitoreo>.from(
                json["datos"]!.map((x) => DatoMonitoreo.fromJson(x))),
        sms: json["msm"],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "datos": datos == null
            ? []
            : List<dynamic>.from(datos!.map((x) => x.toJson())),
        "msm": sms,
      };
}
