import 'dart:convert';

import 'minuto.dart';

class Salida {
  int? salida;
  String? fechas;
  String? frecuencia;
  String? linea;
  String? codigo;
  int? adelantoFTiempoCabezera;
  int? atrasoFTiempoCabezera;
  int? adelantoJTiempoCabezera;
  int? atrasoJTiempoCabezera;
  String? deudaTotal;
  String? atrasoPenalidadCabezera;
  String? adelantoPenalidadCabezera;
  String? rubroPenalidadCabezera;
  String? velocidadPenalidadCabezera;
  String? tarjetaDiariaCabezera;
  List<String>? anotaciones;
  List<Minuto>? minutos;

  Salida({
    this.salida,
    this.fechas,
    this.frecuencia,
    this.linea,
    this.codigo,
    this.adelantoFTiempoCabezera,
    this.atrasoFTiempoCabezera,
    this.adelantoJTiempoCabezera,
    this.atrasoJTiempoCabezera,
    this.deudaTotal,
    this.atrasoPenalidadCabezera,
    this.adelantoPenalidadCabezera,
    this.rubroPenalidadCabezera,
    this.velocidadPenalidadCabezera,
    this.tarjetaDiariaCabezera,
    this.anotaciones,
    this.minutos,
  });

  factory Salida.fromRawJson(String str) => Salida.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Salida.fromJson(Map<String, dynamic> json) => Salida(
    salida: json["salida"],
    fechas: json["fechas"],
    frecuencia: json["frecuencia"],
    linea: json["linea"],
    codigo: json["Codigo"],
    adelantoFTiempoCabezera: json["AdelantoFTiempoCabezera"],
    atrasoFTiempoCabezera: json["AtrasoFTiempoCabezera"],
    adelantoJTiempoCabezera: json["AdelantoJTiempoCabezera"],
    atrasoJTiempoCabezera: json["AtrasoJTiempoCabezera"],
    deudaTotal: json["DeudaTotal"],
    atrasoPenalidadCabezera: json["AtrasoPenalidadCabezera"],
    adelantoPenalidadCabezera: json["AdelantoPenalidadCabezera"],
    rubroPenalidadCabezera: json["RubroPenalidadCabezera"],
    velocidadPenalidadCabezera: json["VelocidadPenalidadCabezera"],
    tarjetaDiariaCabezera: json["TarjetaDiariaCabezera"],
    anotaciones:
        json["anotaciones"] == null
            ? []
            : List<String>.from(json["anotaciones"]!.map((x) => x)),
    minutos:
        json["minutos"] == null
            ? []
            : List<Minuto>.from(
              json["minutos"]!.map((x) => Minuto.fromJson(x)),
            ),
  );

  Map<String, dynamic> toJson() => {
    "salida": salida,
    "fechas": fechas,
    "frecuencia": frecuencia,
    "linea": linea,
    "Codigo": codigo,
    "AdelantoFTiempoCabezera": adelantoFTiempoCabezera,
    "AtrasoFTiempoCabezera": atrasoFTiempoCabezera,
    "AdelantoJTiempoCabezera": adelantoJTiempoCabezera,
    "AtrasoJTiempoCabezera": atrasoJTiempoCabezera,
    "DeudaTotal": deudaTotal,
    "AtrasoPenalidadCabezera": atrasoPenalidadCabezera,
    "AdelantoPenalidadCabezera": adelantoPenalidadCabezera,
    "RubroPenalidadCabezera": rubroPenalidadCabezera,
    "VelocidadPenalidadCabezera": velocidadPenalidadCabezera,
    "TarjetaDiariaCabezera": tarjetaDiariaCabezera,
    "anotaciones":
        anotaciones == null
            ? []
            : List<dynamic>.from(anotaciones!.map((x) => x)),
    "minutos":
        minutos == null
            ? []
            : List<dynamic>.from(minutos!.map((x) => x.toJson())),
  };
}
