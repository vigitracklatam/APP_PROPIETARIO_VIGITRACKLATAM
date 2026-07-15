import 'dart:convert';

import 'cuadro_code_activacion.dart';

class MovilCodeActivacion {
  MovilCodeActivacion({
    this.cuadroTrabajoLunesViernes,
    this.cuadroTrabajoFinSemana,
    this.cuadroTrabajoFeriado,
    this.reportePagosPendienteProduccion,
    this.conteo,
    this.minutosTar,
    this.minutosTarVuelta,
    this.minutosTarResumido,
    this.minutosTarResumidoVuelta,
    this.calProd,
    this.createliquiChoferV,
    this.createliquiChoferD,
  });

  CuadroTrabajoCodeActivacion? cuadroTrabajoLunesViernes;
  CuadroTrabajoCodeActivacion? cuadroTrabajoFinSemana;
  CuadroTrabajoCodeActivacion? cuadroTrabajoFeriado;
  int? reportePagosPendienteProduccion;
  int? conteo;
  int? minutosTar;
  int? minutosTarVuelta;
  Map<String, int>? minutosTarResumido;
  Map<String, int>? minutosTarResumidoVuelta;
  int? calProd;
  int? createliquiChoferV;
  int? createliquiChoferD;

  factory MovilCodeActivacion.fromRawJson(String str) =>
      MovilCodeActivacion.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MovilCodeActivacion.fromJson(Map<String, dynamic> json) =>
      MovilCodeActivacion(
        cuadroTrabajoLunesViernes:
            json["cuadro_trabajo_lunes_viernes"] == null
                ? null
                : CuadroTrabajoCodeActivacion.fromJson(
                  json["cuadro_trabajo_lunes_viernes"],
                ),
        cuadroTrabajoFinSemana:
            json["cuadro_trabajo_fin_semana"] == null
                ? null
                : CuadroTrabajoCodeActivacion.fromJson(
                  json["cuadro_trabajo_fin_semana"],
                ),
        cuadroTrabajoFeriado:
            json["cuadro_trabajo_feriado"] == null
                ? null
                : CuadroTrabajoCodeActivacion.fromJson(
                  json["cuadro_trabajo_feriado"],
                ),
        reportePagosPendienteProduccion:
            json["reporte_pagos_pendiente_produccion"],
        conteo: json["conteo"],
        minutosTar: json["minutosTar"],
        minutosTarVuelta: json["minutosTarVuelta"],
        minutosTarResumido: Map.from(
          json["minutosTarResumido"]!,
        ).map((k, v) => MapEntry<String, int>(k, v)),
        minutosTarResumidoVuelta: Map.from(
          json["minutosTarResumidoVuelta"]!,
        ).map((k, v) => MapEntry<String, int>(k, v)),
        calProd: json["calProd"],
        createliquiChoferV: json["createliquiChoferV"],
        createliquiChoferD: json["createliquiChoferD"],
      );

  Map<String, dynamic> toJson() => {
    "cuadro_trabajo_lunes_viernes": cuadroTrabajoLunesViernes?.toJson(),
    "cuadro_trabajo_fin_semana": cuadroTrabajoFinSemana?.toJson(),
    "cuadro_trabajo_feriado": cuadroTrabajoFeriado?.toJson(),
    "reporte_pagos_pendiente_produccion": reportePagosPendienteProduccion,
    "conteo": conteo,
    "minutosTar": minutosTar,
    "minutosTarVuelta": minutosTarVuelta,
    "minutosTarResumido": Map.from(
      minutosTarResumido!,
    ).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "minutosTarResumidoVuelta": Map.from(
      minutosTarResumidoVuelta!,
    ).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "calProd": calProd,
    "createliquiChoferV": createliquiChoferV,
    "createliquiChoferD": createliquiChoferD,
  };
}
