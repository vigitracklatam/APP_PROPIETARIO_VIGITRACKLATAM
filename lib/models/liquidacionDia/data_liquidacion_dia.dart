import 'package:intl/intl.dart';

final DateFormat formatter = DateFormat('yyyy-MM-dd');

class DatoLiquidacionDia {
  String? fk_codigo_vehiculo;
  int? fk_id_conductor;
  int? fk_id_ruta;
  String? fecha;
  //Detalle
  double? ingresos;
  double? ahorro_corporativo;
  double? gasto_chofer;
  double? gasto_ayudante;
  double? gasto_combustible;
  double? gasto_alimentacion;
  double? gasto_minutos;
  double? gasto_otros;
  String? observacion;
  //Evidencia
  String? url_evidencia_1;
  String? url_evidencia_2;
  String? url_evidencia_3;
  String? url_evidencia_4;

  DatoLiquidacionDia({
    this.fk_codigo_vehiculo,
    this.fk_id_conductor,
    this.fk_id_ruta,
    this.fecha,
    this.ingresos,
    this.ahorro_corporativo,
    this.gasto_chofer,
    this.gasto_ayudante,
    this.gasto_combustible,
    this.gasto_alimentacion,
    this.gasto_minutos,
    this.gasto_otros,
    this.observacion,
    this.url_evidencia_1,
    this.url_evidencia_2,
    this.url_evidencia_3,
    this.url_evidencia_4,
  });

  factory DatoLiquidacionDia.fromJson(Map<String, dynamic> json) =>
      DatoLiquidacionDia(
        fk_codigo_vehiculo: json["fk_codigo_vehiculo"] ?? "",
        fk_id_conductor: json["fk_id_conductor"] ?? "",
        fk_id_ruta: json["fk_id_ruta"] ?? "",
        fecha: json["fecha"] ?? "",
        ingresos: json["ingresos"] ?? "",
        ahorro_corporativo: json["ahorro_corporativo"] ?? "",
        gasto_chofer: json["gasto_chofer"] ?? "",
        gasto_ayudante: json["gasto_ayudante"] ?? "",
        gasto_combustible: json["gasto_combustible"] ?? "",
        gasto_alimentacion: json["gasto_alimentacion"] ?? "",
        gasto_minutos: json["gasto_minutos"] ?? "",
        gasto_otros: json["gasto_otros"] ?? "",
        observacion: json["observacion"] ?? "",
        url_evidencia_1: json["url_evidencia_1"] ?? "",
        url_evidencia_2: json["url_evidencia_2"] ?? "",
        url_evidencia_3: json["url_evidencia_3"] ?? "",
        url_evidencia_4: json["url_evidencia_4"] ?? "",
      );

  Map<String, dynamic> toJson() => {
    "fk_codigo_vehiculo": fk_codigo_vehiculo,
    "fk_id_conductor": fk_id_conductor,
    "fk_id_ruta": fk_id_ruta,
    "fecha": fecha,
    "ingresos": ingresos,
    "ahorro_corporativo": ahorro_corporativo,
    "gasto_chofer": gasto_chofer,
    "gasto_ayudante": gasto_ayudante,
    "gasto_combustible": gasto_combustible,
    "gasto_alimentacion": gasto_alimentacion,
    "gasto_minutos": gasto_minutos,
    "gasto_otros": gasto_otros,
    "observacion": observacion,
    "url_evidencia_1": url_evidencia_1,
    "url_evidencia_2": url_evidencia_2,
    "url_evidencia_3": url_evidencia_3,
    "url_evidencia_4": url_evidencia_4,
  };
}
