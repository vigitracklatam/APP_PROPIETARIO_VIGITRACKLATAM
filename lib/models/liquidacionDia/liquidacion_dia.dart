// To parse this JSON data, do
//
//     final liquidacionDia = liquidacionDiaFromJson(jsonString);

import 'dart:convert';

LiquidacionDia liquidacionDiaFromJson(String str) =>
    LiquidacionDia.fromJson(json.decode(str));

String liquidacionDiaToJson(LiquidacionDia data) => json.encode(data.toJson());

class LiquidacionDia {
  int? statusCode;
  List<Dato>? datos;
  String? msm;

  LiquidacionDia({this.statusCode, this.datos, this.msm});

  factory LiquidacionDia.fromRawJson(String str) =>
      LiquidacionDia.fromJson(json.decode(str));

  factory LiquidacionDia.fromJson(Map<String, dynamic> json) => LiquidacionDia(
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
  String? DescRuta;
  String? nombre;
  DateTime? fecha;
  String? total;

  Dato({this.id, this.DescRuta, this.nombre, this.fecha, this.total});

  factory Dato.fromJson(Map<String, dynamic> json) => Dato(
    id: json["id"],
    DescRuta: json["DescRuta"],
    nombre: json["nombre"],
    fecha: json["fecha"] == null ? null : DateTime.parse(json["fecha"]),
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "DescRuta": DescRuta,
    "nombre": nombre,
    "fecha":
        "${fecha!.year.toString().padLeft(4, '0')}-${fecha!.month.toString().padLeft(2, '0')}-${fecha!.day.toString().padLeft(2, '0')}",
    "total": total,
  };
}
