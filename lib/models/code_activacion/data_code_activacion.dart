import 'dart:convert';

import 'movil_code_activacion.dart';

class DataCodeActivacion {
  DataCodeActivacion({
    this.active,
    this.name,
    this.codigo,
    this.logo,
    this.movil,
  });

  int? active;
  String? name;
  String? codigo;
  String? logo;
  MovilCodeActivacion? movil;

  factory DataCodeActivacion.fromRawJson(String str) =>
      DataCodeActivacion.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataCodeActivacion.fromJson(Map<String, dynamic> json) =>
      DataCodeActivacion(
        active: json["active"],
        name: json["name"],
        codigo: json["codigo"],
        logo: json["logo"],
        movil: json["movil"] == null
            ? null
            : MovilCodeActivacion.fromJson(json["movil"]),
      );

  Map<String, dynamic> toJson() => {
        "active": active,
        "name": name,
        "codigo": codigo,
        "logo": logo,
        "movil": movil?.toJson(),
      };
}
