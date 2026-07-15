import 'package:intl/intl.dart';

final DateFormat formatter = DateFormat('yyyy-MM-dd');

class DatoLiquidacionSB {
  String? unidadLiquidacionM;
  String? fechaLiquidacionM;
  String? totalGasto;
  String? totalRecaudado;
  String? total;
  String? horaSaliProgSaliM;
  String? horaLlegProgSaliM;
  int? numeVuelSaliM;
  String? letraRutaSaliM;
  String? letrFrec;
  String? dineroRecaudoConductorIda;
  String? dineroRecaudoConductorVuelta;
  String? gastoComida;
  String? gastoConductor;
  String? gastoAyudante;
  String? gastoLimpieza;
  String? gastoConbustible;
  String? gastoTicket;
  String? gastoPeaje;
  String? gastoHidratacion;
  String? evidencia1Foto;
  String? evidencia2Foto;
  String? evidencia3Foto;
  String? observacion;

  DatoLiquidacionSB({
    this.unidadLiquidacionM,
    this.fechaLiquidacionM,
    this.totalGasto,
    this.totalRecaudado,
    this.total,
    this.horaSaliProgSaliM,
    this.horaLlegProgSaliM,
    this.numeVuelSaliM,
    this.letraRutaSaliM,
    this.letrFrec,
    this.dineroRecaudoConductorIda,
    this.dineroRecaudoConductorVuelta,
    this.gastoComida,
    this.gastoConductor,
    this.gastoAyudante,
    this.gastoLimpieza,
    this.gastoConbustible,
    this.gastoTicket,
    this.gastoPeaje,
    this.gastoHidratacion,
    this.evidencia1Foto,
    this.evidencia2Foto,
    this.evidencia3Foto,
    this.observacion
  });

  factory DatoLiquidacionSB.fromJson(Map<String, dynamic> json) =>
      DatoLiquidacionSB(
        unidadLiquidacionM: json["unidad_liquidacion_m"] ?? "",
        fechaLiquidacionM: json["fecha_liquidacion_m"] ?? "",
        totalGasto: json["total_gasto"] ?? "",
        totalRecaudado: json["total_recaudado"] ?? "",
        total: json["total"] ?? "",
        horaSaliProgSaliM: json["HoraSaliProgSali_m"] ?? "",
        horaLlegProgSaliM: json["HoraLlegProgSali_m"] ?? "",
        numeVuelSaliM: json["NumeVuelSali_m"] ?? 0,
        letraRutaSaliM: json["LetraRutaSali_m"] ?? "",
        letrFrec: json["LetrFrec"] ?? "",
        dineroRecaudoConductorIda: json["dinero_recaudo_conductor_ida"] ?? "",
        dineroRecaudoConductorVuelta:
            json["dinero_recaudo_conductor_vuelta"] ?? "",
        gastoComida: json["gasto_comida"] ?? "",
        gastoConductor: json["gasto_conductor"] ?? "",
        gastoAyudante: json["gasto_ayudante"] ?? "",
        gastoLimpieza: json["gasto_limpieza"] ?? "",
        gastoConbustible: json["gasto_conbustible"] ?? "",
        gastoTicket: json["gasto_ticket"] ?? "",
        gastoPeaje: json["gasto_peaje"] ?? "",
        gastoHidratacion: json["gasto_hidratacion"] ?? "",
        evidencia1Foto: json["evidencia_1_foto"] ?? "",
        evidencia2Foto: json["evidencia_2_foto"] ?? "",
        evidencia3Foto: json["evidencia_3_foto"] ?? "",
        observacion: json["observacion_gasto"] ?? "",
      );

  Map<String, dynamic> toJson() => {
    "unidad_liquidacion_m": unidadLiquidacionM,
    "fecha_liquidacion_m": fechaLiquidacionM,
    "total_gasto": totalGasto,
    "total_recaudado": totalRecaudado,
    "total": total,
    "HoraSaliProgSali_m": horaSaliProgSaliM,
    "HoraLlegProgSali_m": horaLlegProgSaliM,
    "NumeVuelSali_m": numeVuelSaliM,
    "LetraRutaSali_m": letraRutaSaliM,
    "LetrFrec": letrFrec,
    "dinero_recaudo_conductor_ida": dineroRecaudoConductorIda,
    "dinero_recaudo_conductor_vuelta": dineroRecaudoConductorVuelta,
    "gasto_comida": gastoComida,
    "gasto_conductor": gastoConductor,
    "gasto_ayudante": gastoAyudante,
    "gasto_limpieza": gastoLimpieza,
    "gasto_conbustible": gastoConbustible,
    "gasto_ticket": gastoTicket,
    "gasto_peaje": gastoPeaje,
    "gasto_hidratacion": gastoHidratacion,
    "evidencia_1_foto": evidencia1Foto,
    "evidencia_2_foto": evidencia2Foto,
    "evidencia_3_foto": evidencia3Foto,
    "observacion_gasto": observacion,
  };
}
