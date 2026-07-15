import 'dart:convert';

import 'salidas_vueltas.dart';

class DatosMinTarjetasVuelta {
  String? unidad;
  List<Salidas>? salidas;
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

  DatosMinTarjetasVuelta({
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

  factory DatosMinTarjetasVuelta.fromRawJson(String str) =>
      DatosMinTarjetasVuelta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DatosMinTarjetasVuelta.fromJson(Map<String, dynamic> json) =>
      DatosMinTarjetasVuelta(
        unidad: json["unidad"],
        salidas: json["salidas"] == null
            ? []
            : List<Salidas>.from(
                json["salidas"]!.map((x) => Salidas.fromJson(x))),
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
        "salidas": salidas == null
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
