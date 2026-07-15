import 'dart:convert';

import 'minutos_vueltas.dart';

class Salidas {
  int? salida;
  int? numeVuelSaliM;
  String? fechas;
  String? linea;
  int? adelantoFTiempoCabezera;
  int? atrasoFTiempoCabezera;
  int? adelantoJTiempoCabezera;
  int? atrasoJTiempoCabezera;
  String? deudaTotal;
  String? atrasoPenalidadCabezera;
  int? adelantoPenalidadCabezera;
  int? rubroPenalidadCabezera;
  int? velocidadPenalidadCabezera;
  int? tarjetaDiariaCabezera;
  List<dynamic>? anotaciones;
  List<Minutos>? minutos;

  Salidas({
    this.salida,
    this.numeVuelSaliM,
    this.fechas,
    this.linea,
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

  factory Salidas.fromRawJson(String str) => Salidas.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Salidas.fromJson(Map<String, dynamic> json) => Salidas(
    salida: json["salida"],
    numeVuelSaliM: json["NumeVuelSali_m"],
    fechas: json["fechas"],
    linea: json["linea"],
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
            : List<dynamic>.from(json["anotaciones"]!.map((x) => x)),
    minutos:
        json["minutos"] == null
            ? []
            : List<Minutos>.from(
              json["minutos"]!.map((x) => Minutos.fromJson(x)),
            ),
  );

  Map<String, dynamic> toJson() => {
    "salida": salida,
    "NumeVuelSali_m": numeVuelSaliM,
    "fechas": fechas,
    "linea": linea,
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
