import 'dart:convert';

class cPermisosPropietario {
  int? activeMonitoreo;
  int? activeSalidas;
  int? activeConteo;
  int? activeSimulador;
  int? activeRecorrido;
  int? activeMinTarjetaDia;
  int? activeMinTarjetaDiaResu;
  int? activeMinTarjetaVuelta;
  int? activeMinTarjetaVueltaResu;
  int? activeMinTarjRubDia;
  int? activeMinTarjRubVuelta;
  int? minTarjetaDiaVuelResuConfigPagePagehorizontal;
  int? minTarjetaDiaVuelResuConfigPageatrasoF;
  int? minTarjetaDiaVuelResuConfigPageAdelantoF;
  int? minTarjetaDiaVuelResuConfigPageAtrasoJ;
  int? minTarjetaDiaVuelResuConfigPageAdelantoJ;
  int? minTarjetaDiaVuelResuConfigPageTarjeta;
  int? minTarjetaDiaVuelResuConfigPageVeloF;
  int? minTarjetaDiaVuelResuConfigPageVeloJ;
  int? minTarjetaDiaVuelResuConfigPageRubroF;
  int? minTarjetaDiaVuelResuConfigPageRubroJ;
  int? minTarjetaDiaVuelResuConfigPageLabelEstado;
  int? activeCuadroLv;
  int? activeCuadroFs;
  int? activeCuadroFeri;
  String? urlCuadroLv;
  String? urlCuadroFs;
  String? urlCuadroFeri;
  int? activePagoMinTarRuDia;
  int? activePagoMinTarRuVuelta;
  int? activeLiquidacion;
  int? activeDespacho;
  int? activeRecaSalida;
  int? activeAnulaSalida;
  int? activeFinSalida;
  int? activelimitDispositivo;
  int? numlimitDispositivo;
  int? activeLiquidacionChV;
  int? activeReporteLiquidacionChV;
  int? active_liquidacion_ch_d;
  int? active_reporte_liquidacion_ch_d;
  int? active_liquidacion_ch_v_2;
  int? active_reporte_liquidacion_ch_v_2;
  int? active_reporte;
  int? minTarjetaResuDiaConfigPagePagehorizontal;
  int? minTarjetaResuDiaConfigPageAtrasoF;
  int? minTarjetaResuDiaConfigPageAdelantoF;
  int? minTarjetaResuDiaConfigPageAtrasoJ;
  int? minTarjetaResuDiaConfigPageAdelantoJ;
  int? minTarjetaResuDiaConfigPageTarjeta;
  int? minTarjetaResuDiaConfigPageVeloF;
  int? minTarjetaResuDiaConfigPageVeloJ;
  int? minTarjetaResuDiaConfigPageRubroF;
  int? minTarjetaResuDiaConfigPageRubroJ;
  int? minTarjetaResuDiaConfigPageLabelEstado;
  int? activeReporteLiquidacionVueltaSB;
  int? active_reporte_liquidacion_dia;

  cPermisosPropietario({
    this.activeMonitoreo,
    this.activeSalidas,
    this.activeConteo,
    this.activeSimulador,
    this.activeRecorrido,
    this.activeMinTarjetaDia,
    this.activeMinTarjetaDiaResu,
    this.activeMinTarjetaVuelta,
    this.activeMinTarjetaVueltaResu,
    this.activeMinTarjRubDia,
    this.activeMinTarjRubVuelta,
    this.minTarjetaDiaVuelResuConfigPagePagehorizontal,
    this.minTarjetaDiaVuelResuConfigPageatrasoF,
    this.minTarjetaDiaVuelResuConfigPageAdelantoF,
    this.minTarjetaDiaVuelResuConfigPageAtrasoJ,
    this.minTarjetaDiaVuelResuConfigPageAdelantoJ,
    this.minTarjetaDiaVuelResuConfigPageTarjeta,
    this.minTarjetaDiaVuelResuConfigPageVeloF,
    this.minTarjetaDiaVuelResuConfigPageVeloJ,
    this.minTarjetaDiaVuelResuConfigPageRubroF,
    this.minTarjetaDiaVuelResuConfigPageRubroJ,
    this.minTarjetaDiaVuelResuConfigPageLabelEstado,
    this.activeCuadroLv,
    this.activeCuadroFs,
    this.activeCuadroFeri,
    this.urlCuadroLv,
    this.urlCuadroFs,
    this.urlCuadroFeri,
    this.activePagoMinTarRuDia,
    this.activePagoMinTarRuVuelta,
    this.activeLiquidacion,
    this.activeDespacho,
    this.activeRecaSalida,
    this.activeAnulaSalida,
    this.activeFinSalida,
    this.activelimitDispositivo,
    this.numlimitDispositivo,
    this.activeLiquidacionChV,
    this.activeReporteLiquidacionChV,
    this.active_liquidacion_ch_d,
    this.active_reporte_liquidacion_ch_d,
    this.active_liquidacion_ch_v_2,
    this.active_reporte_liquidacion_ch_v_2,
    this.active_reporte,
    this.minTarjetaResuDiaConfigPagePagehorizontal,
    this.minTarjetaResuDiaConfigPageAtrasoF,
    this.minTarjetaResuDiaConfigPageAdelantoF,
    this.minTarjetaResuDiaConfigPageAtrasoJ,
    this.minTarjetaResuDiaConfigPageAdelantoJ,
    this.minTarjetaResuDiaConfigPageTarjeta,
    this.minTarjetaResuDiaConfigPageVeloF,
    this.minTarjetaResuDiaConfigPageVeloJ,
    this.minTarjetaResuDiaConfigPageRubroF,
    this.minTarjetaResuDiaConfigPageRubroJ,
    this.minTarjetaResuDiaConfigPageLabelEstado,
    this.activeReporteLiquidacionVueltaSB,
    this.active_reporte_liquidacion_dia
  });

  factory cPermisosPropietario.fromRawJson(String str) =>
      cPermisosPropietario.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory cPermisosPropietario.fromJson(
    Map<String, dynamic> json,
  ) => cPermisosPropietario(
    activeMonitoreo: json["activeMonitoreo"] ?? 0,
    activeSalidas: json["activeSalidas"] ?? 0,
    activeConteo: json["activeConteo"]  ?? 0,
    activeSimulador: json["activeSimulador"] ?? 0,
    activeRecorrido: json["activeRecorrido"] ?? 0,
    activeMinTarjetaDia: json["activeMinTarjetaDia"] ?? 0,
    activeMinTarjetaDiaResu: json["activeMinTarjetaDiaResu"] ?? 0,
    activeMinTarjetaVuelta: json["activeMinTarjetaVuelta"] ?? 0,
    activeMinTarjetaVueltaResu: json["activeMinTarjetaVueltaResu"] ?? 0,
    activeMinTarjRubDia: json["activeMinTarjRubDia"] ?? 0,
    activeMinTarjRubVuelta: json["activeMinTarjRubVuelta"] ?? 0,
    minTarjetaDiaVuelResuConfigPagePagehorizontal:
        json["MinTarjetaDiaVuelResuConfigPagePagehorizontal"] ?? 0,
    minTarjetaDiaVuelResuConfigPageatrasoF:
        json["MinTarjetaDiaVuelResuConfigPageatrasoF"] ?? 0,
    minTarjetaDiaVuelResuConfigPageAdelantoF:
        json["MinTarjetaDiaVuelResuConfigPageAdelantoF"] ?? 0,
    minTarjetaDiaVuelResuConfigPageAtrasoJ:
        json["MinTarjetaDiaVuelResuConfigPageAtrasoJ"] ?? 0,
    minTarjetaDiaVuelResuConfigPageAdelantoJ:
        json["MinTarjetaDiaVuelResuConfigPageAdelantoJ"] ?? 0,
    minTarjetaDiaVuelResuConfigPageTarjeta:
        json["MinTarjetaDiaVuelResuConfigPageTarjeta"] ?? 0,
    minTarjetaDiaVuelResuConfigPageVeloF:
        json["MinTarjetaDiaVuelResuConfigPageVeloF"] ?? 0,
    minTarjetaDiaVuelResuConfigPageVeloJ:
        json["MinTarjetaDiaVuelResuConfigPageVeloJ"] ?? 0,
    minTarjetaDiaVuelResuConfigPageRubroF:
        json["MinTarjetaDiaVuelResuConfigPageRubroF"] ?? 0,
    minTarjetaDiaVuelResuConfigPageRubroJ:
        json["MinTarjetaDiaVuelResuConfigPageRubroJ"] ?? 0,
    minTarjetaDiaVuelResuConfigPageLabelEstado:
        json["MinTarjetaDiaVuelResuConfigPageLabelEstado"] ?? 0,
    activeCuadroLv: json["activeCuadroLV"]  ?? 0,
    activeCuadroFs: json["activeCuadroFS"]  ?? 0,
    activeCuadroFeri: json["activeCuadroFeri"]  ?? 0,
    urlCuadroLv: json["URLCuadroLV"] ?? "",
    urlCuadroFs: json["URLCuadroFS"]  ?? "",
    urlCuadroFeri: json["URLCuadroFeri"] ?? "",
    activePagoMinTarRuDia: json["activePagoMinTarRuDia"],
    activePagoMinTarRuVuelta: json["activePagoMinTarRuVuelta"],
    activeLiquidacion: json["activeLiquidacion"] ?? 0,
    activeDespacho: json["activeDespacho"] ?? 0,
    activeRecaSalida: json["activeRecaSalida"] ?? 0,
    activeAnulaSalida: json["activeAnulaSalida"] ?? 0,
    activeFinSalida: json["activeFinSalida"] ?? 0,
    activelimitDispositivo: json["activelimitDispositivo"] ?? 0,
    numlimitDispositivo: json["numlimitDispositivo"] ?? 0,
    activeLiquidacionChV: json["active_liquidacion_ch_v"] ?? 0,
    activeReporteLiquidacionChV: json["active_reporte_liquidacion_ch_v"] ?? 0,
    active_liquidacion_ch_d: json["active_liquidacion_ch_d"] ?? 0,
    active_reporte_liquidacion_ch_d: json["active_reporte_liquidacion_ch_d"] ?? 0,
    active_liquidacion_ch_v_2: json["active_liquidacion_ch_v_2"] ?? 0,
    active_reporte_liquidacion_ch_v_2:
        json["active_reporte_liquidacion_ch_v_2"] ?? 0,
    active_reporte: json["active_reporte"] ?? 0,
    minTarjetaResuDiaConfigPagePagehorizontal:
        json["MinTarjetaResuDiaConfigPagePagehorizontal"] ?? 0,
    minTarjetaResuDiaConfigPageAtrasoF:
        json["MinTarjetaResuDiaConfigPageatrasoF"] ?? 0,
    minTarjetaResuDiaConfigPageAdelantoF:
        json["MinTarjetaResuDiaConfigPageAdelantoF"] ?? 0,
    minTarjetaResuDiaConfigPageAtrasoJ:
        json["MinTarjetaResuDiaConfigPageAtrasoJ"] ?? 0,
    minTarjetaResuDiaConfigPageAdelantoJ:
        json["MinTarjetaResuDiaConfigPageAdelantoJ"] ?? 0,
    minTarjetaResuDiaConfigPageTarjeta:
        json["MinTarjetaResuDiaConfigPageTarjeta"] ?? 0,
    minTarjetaResuDiaConfigPageVeloF: json["MinTarjetaResuDiaConfigPageVeloF"] ?? 0,
    minTarjetaResuDiaConfigPageVeloJ: json["MinTarjetaResuDiaConfigPageVeloJ"] ?? 0,
    minTarjetaResuDiaConfigPageRubroF:
        json["MinTarjetaResuDiaConfigPageRubroF"] ?? 0,
    minTarjetaResuDiaConfigPageRubroJ:
        json["MinTarjetaResuDiaConfigPageRubroJ"] ?? 0,
    minTarjetaResuDiaConfigPageLabelEstado:
        json["MinTarjetaResuDiaConfigPageLabelEstado"] ?? 0,
    activeReporteLiquidacionVueltaSB:json["activeReporteLiquidacionVueltaSB"] ?? 0,
    active_reporte_liquidacion_dia: json["activeReporteLiquidacionDia"] ?? 0
  );

  Map<String, dynamic> toJson() => {
    "activeMonitoreo": activeMonitoreo,
    "activeSalidas": activeSalidas,
    "activeConteo": activeConteo,
    "activeSimulador": activeSimulador,
    "activeRecorrido": activeRecorrido,
    "activeMinTarjetaDia": activeMinTarjetaDia,
    "activeMinTarjetaDiaResu": activeMinTarjetaDiaResu,
    "activeMinTarjetaVuelta": activeMinTarjetaVuelta,
    "activeMinTarjetaVueltaResu": activeMinTarjetaVueltaResu,
    "activeMinTarjRubDia": activeMinTarjRubDia,
    "activeMinTarjRubVuelta": activeMinTarjRubVuelta,
    "MinTarjetaDiaVuelResuConfigPagePagehorizontal":
        minTarjetaDiaVuelResuConfigPagePagehorizontal,
    "MinTarjetaDiaVuelResuConfigPageatrasoF":
        minTarjetaDiaVuelResuConfigPageatrasoF,
    "MinTarjetaDiaVuelResuConfigPageAdelantoF":
        minTarjetaDiaVuelResuConfigPageAdelantoF,
    "MinTarjetaDiaVuelResuConfigPageAtrasoJ":
        minTarjetaDiaVuelResuConfigPageAtrasoJ,
    "MinTarjetaDiaVuelResuConfigPageAdelantoJ":
        minTarjetaDiaVuelResuConfigPageAdelantoJ,
    "MinTarjetaDiaVuelResuConfigPageTarjeta":
        minTarjetaDiaVuelResuConfigPageTarjeta,
    "MinTarjetaDiaVuelResuConfigPageVeloF":
        minTarjetaDiaVuelResuConfigPageVeloF,
    "MinTarjetaDiaVuelResuConfigPageVeloJ":
        minTarjetaDiaVuelResuConfigPageVeloJ,
    "MinTarjetaDiaVuelResuConfigPageRubroF":
        minTarjetaDiaVuelResuConfigPageRubroF,
    "MinTarjetaDiaVuelResuConfigPageRubroJ":
        minTarjetaDiaVuelResuConfigPageRubroJ,
    "MinTarjetaDiaVuelResuConfigPageLabelEstado":
        minTarjetaDiaVuelResuConfigPageLabelEstado,
    "activeCuadroLV": activeCuadroLv,
    "activeCuadroFS": activeCuadroFs,
    "activeCuadroFeri": activeCuadroFeri,
    "URLCuadroLV": urlCuadroLv,
    "URLCuadroFS": urlCuadroFs,
    "URLCuadroFeri": urlCuadroFeri,
    "activePagoMinTarRuDia": activePagoMinTarRuDia,
    "activePagoMinTarRuVuelta": activePagoMinTarRuVuelta,
    "activeLiquidacion": activeLiquidacion,
    "activeDespacho": activeDespacho,
    "activeRecaSalida": activeRecaSalida,
    "activeAnulaSalida": activeAnulaSalida,
    "activeFinSalida": activeFinSalida,
    "activelimitDispositivo": activelimitDispositivo,
    "numlimitDispositivo": numlimitDispositivo,
    "active_liquidacion_ch_v": activeLiquidacionChV,
    "active_reporte_liquidacion_ch_v": activeReporteLiquidacionChV,
    "active_liquidacion_ch_d": active_liquidacion_ch_d,
    "active_reporte_liquidacion_ch_d": active_reporte_liquidacion_ch_d,
    "active_liquidacion_ch_v_2": active_liquidacion_ch_v_2,
    "active_reporte_liquidacion_ch_v_2": active_reporte_liquidacion_ch_v_2,
    "active_reporte": active_reporte,
    "MinTarjetaResuDiaConfigPagePagehorizontal":
        minTarjetaResuDiaConfigPagePagehorizontal,
    "MinTarjetaResuDiaConfigPageatrasoF": minTarjetaResuDiaConfigPageAtrasoF,
    "MinTarjetaResuDiaConfigPageAdelantoF":
        minTarjetaResuDiaConfigPageAdelantoF,
    "MinTarjetaResuDiaConfigPageAtrasoJ": minTarjetaResuDiaConfigPageAtrasoJ,
    "MinTarjetaResuDiaConfigPageAdelantoJ":
        minTarjetaResuDiaConfigPageAdelantoJ,
    "MinTarjetaResuDiaConfigPageTarjeta": minTarjetaResuDiaConfigPageTarjeta,
    "MinTarjetaResuDiaConfigPageVeloF": minTarjetaResuDiaConfigPageVeloF,
    "MinTarjetaResuDiaConfigPageVeloJ": minTarjetaResuDiaConfigPageVeloJ,
    "MinTarjetaResuDiaConfigPageRubroF": minTarjetaResuDiaConfigPageRubroF,
    "MinTarjetaResuDiaConfigPageRubroJ": minTarjetaResuDiaConfigPageRubroJ,
    "MinTarjetaResuDiaConfigPageLabelEstado":
        minTarjetaResuDiaConfigPageLabelEstado,
    "activeReporteLiquidacionVueltaSB": activeReporteLiquidacionVueltaSB,
    "activeReporteLiquidacionDia": active_reporte_liquidacion_dia
  };
}
