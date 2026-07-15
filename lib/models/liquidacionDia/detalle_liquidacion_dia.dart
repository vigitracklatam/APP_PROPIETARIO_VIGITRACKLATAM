// To parse this JSON data, do
//
//     final liquidacionDia = liquidacionDiaFromJson(jsonString);

import 'dart:convert';

DetalleLiquidacionDia liquidacionDiaFromJson(String str) =>
    DetalleLiquidacionDia.fromJson(json.decode(str));

String liquidacionDiaToJson(DetalleLiquidacionDia data) =>
    json.encode(data.toJson());

class DetalleLiquidacionDia {
  int? statusCode;
  List<Dato>? datos;
  String? msm;

  DetalleLiquidacionDia({this.statusCode, this.datos, this.msm});

  factory DetalleLiquidacionDia.fromRawJson(String str) =>
      DetalleLiquidacionDia.fromJson(json.decode(str));

  factory DetalleLiquidacionDia.fromJson(Map<String, dynamic> json) =>
      DetalleLiquidacionDia(
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
  String? nombre;
  String? descRuta;
  DateTime? fecha;
  String? ingresos;
  String? ahorroCorporativo;
  String? gastoChofer;
  String? gastoAyudante;
  String? gastoCombustible;
  String? gastoAlimentacion;
  String? gastoMinutos;
  String? gastoOtros;
  String? observacion;

  Dato({
    this.id,
    this.nombre,
    this.descRuta,
    this.fecha,
    this.ingresos,
    this.ahorroCorporativo,
    this.gastoChofer,
    this.gastoAyudante,
    this.gastoCombustible,
    this.gastoAlimentacion,
    this.gastoMinutos,
    this.gastoOtros,
    this.observacion,
  });

  factory Dato.fromJson(Map<String, dynamic> json) => Dato(
    id: json["id"],
    nombre: json["nombre"],
    descRuta: json["DescRuta"],
    fecha: json["fecha"] == null ? null : DateTime.parse(json["fecha"]),
    ingresos: json["ingresos"],
    ahorroCorporativo: json["ahorro_corporativo"],
    gastoChofer: json["gasto_chofer"],
    gastoAyudante: json["gasto_ayudante"],
    gastoCombustible: json["gasto_combustible"],
    gastoAlimentacion: json["gasto_alimentacion"],
    gastoMinutos: json["gasto_minutos"],
    gastoOtros: json["gasto_otros"],
    observacion: json["observacion"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nombre": nombre,
    "DescRuta": descRuta,
    "fecha":
        "${fecha!.year.toString().padLeft(4, '0')}-${fecha!.month.toString().padLeft(2, '0')}-${fecha!.day.toString().padLeft(2, '0')}",
    "ingresos": ingresos,
    "ahorro_corporativo": ahorroCorporativo,
    "gasto_chofer": gastoChofer,
    "gasto_ayudante": gastoAyudante,
    "gasto_combustible": gastoCombustible,
    "gasto_alimentacion": gastoAlimentacion,
    "gasto_minutos": gastoMinutos,
    "gasto_otros": gastoOtros,
    "observacion": observacion,
  };
}
