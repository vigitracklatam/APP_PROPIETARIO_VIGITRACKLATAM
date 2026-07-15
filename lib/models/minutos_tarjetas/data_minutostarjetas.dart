import 'dart:convert';

import 'salidas.dart';

class DatoMinTarjeta {
  String? unidad;
  List<Salida>? salidas;
  String? adelantoJTiempoCabezera;
  String? atrasoJTiempoCabezera;
  String? adelantoFTiempoCabezera;
  String? atrasoFTiempoCabezera;
  String? atrasoPenalidadCabezera;
  String? adelantoPenalidadCabezera;
  String? deudaTotalCabezera;
  String? rubroPenalidadCabezera;
  String? velocidadPenalidadCabezera;
  String? tarjetaDiariaCabezera;

  DatoMinTarjeta({
    this.unidad,
    this.salidas,
    this.adelantoJTiempoCabezera,
    this.atrasoJTiempoCabezera,
    this.adelantoFTiempoCabezera,
    this.atrasoFTiempoCabezera,
    this.atrasoPenalidadCabezera,
    this.adelantoPenalidadCabezera,
    this.deudaTotalCabezera,
    this.rubroPenalidadCabezera,
    this.velocidadPenalidadCabezera,
    this.tarjetaDiariaCabezera,
  });

  factory DatoMinTarjeta.fromRawJson(String str) =>
      DatoMinTarjeta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DatoMinTarjeta.fromJson(Map<String, dynamic> json) => DatoMinTarjeta(
    unidad: json["unidad"],
    salidas:
        json["salidas"] == null
            ? []
            : List<Salida>.from(
              json["salidas"]!.map((x) => Salida.fromJson(x)),
            ),
    adelantoJTiempoCabezera: json["AdelantoJTiempoCabezera"],
    atrasoJTiempoCabezera: json["AtrasoJTiempoCabezera"],
    adelantoFTiempoCabezera: json["AdelantoFTiempoCabezera"],
    atrasoFTiempoCabezera: json["AtrasoFTiempoCabezera"],
    atrasoPenalidadCabezera: json["AtrasoPenalidadCabezera"],
    adelantoPenalidadCabezera: json["AdelantoPenalidadCabezera"],
    deudaTotalCabezera: json["DeudaTotalCabezera"],
    rubroPenalidadCabezera: json["RubroPenalidadCabezera"],
    velocidadPenalidadCabezera: json["VelocidadPenalidadCabezera"],
    tarjetaDiariaCabezera: json["TarjetaDiariaCabezera"],
  );

  Map<String, dynamic> toJson() => {
    "unidad": unidad,
    "salidas":
        salidas == null
            ? []
            : List<dynamic>.from(salidas!.map((x) => x.toJson())),
    "AdelantoJTiempoCabezera": adelantoJTiempoCabezera,
    "AtrasoJTiempoCabezera": atrasoJTiempoCabezera,
    "AdelantoFTiempoCabezera": adelantoFTiempoCabezera,
    "AtrasoFTiempoCabezera": atrasoFTiempoCabezera,
    "AtrasoPenalidadCabezera": atrasoPenalidadCabezera,
    "AdelantoPenalidadCabezera": adelantoPenalidadCabezera,
    "DeudaTotalCabezera": deudaTotalCabezera,
    "RubroPenalidadCabezera": rubroPenalidadCabezera,
    "VelocidadPenalidadCabezera": velocidadPenalidadCabezera,
    "TarjetaDiariaCabezera": tarjetaDiariaCabezera,
  };
}
