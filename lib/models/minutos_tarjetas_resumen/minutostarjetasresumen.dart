import 'dart:convert';

import 'data_minutos tarjetasresumen.dart';

class MinutosTarjetasResumenAppMovil {
  int? statusCode;
  String? msm;
  List<DatoMinTarResumido>? datos;

  MinutosTarjetasResumenAppMovil({
    this.statusCode,
    this.msm,
    this.datos,
  });

  factory MinutosTarjetasResumenAppMovil.fromRawJson(String str) =>
      MinutosTarjetasResumenAppMovil.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MinutosTarjetasResumenAppMovil.fromJson(Map<String, dynamic> json) =>
      MinutosTarjetasResumenAppMovil(
        statusCode: json["status_code"],
        msm: json["msm"],
        datos: json["datos"] == null
            ? []
            : List<DatoMinTarResumido>.from(
                json["datos"]!.map((x) => DatoMinTarResumido.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "msm": msm,
        "datos": datos == null
            ? []
            : List<dynamic>.from(datos!.map((x) => x.toJson())),
      };
}
