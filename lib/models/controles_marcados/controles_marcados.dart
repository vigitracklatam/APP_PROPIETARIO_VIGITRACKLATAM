import 'dart:convert';
import 'data_controles_marcados.dart';

class ControlesMarcadosAppMovil {
  int? statusCode;
  String? msm;
  List<DatoControlesMarcados>? datos;

  ControlesMarcadosAppMovil({
    this.statusCode,
    this.msm,
    this.datos,
  });

  factory ControlesMarcadosAppMovil.fromRawJson(String str) =>
      ControlesMarcadosAppMovil.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ControlesMarcadosAppMovil.fromJson(Map<String, dynamic> json) =>
      ControlesMarcadosAppMovil(
        statusCode: json["status_code"],
        msm: json["msm"],
        datos: json["datos"] == null
            ? []
            : List<DatoControlesMarcados>.from(
                json["datos"]!.map((x) => DatoControlesMarcados.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "msm": msm,
        "datos": datos == null
            ? []
            : List<dynamic>.from(datos!.map((x) => x.toJson())),
      };
}
