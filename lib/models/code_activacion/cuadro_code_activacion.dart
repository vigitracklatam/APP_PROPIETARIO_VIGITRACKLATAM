import 'dart:convert';

class CuadroTrabajoCodeActivacion {
  CuadroTrabajoCodeActivacion({
    this.activo,
    this.pdf,
  });

  int? activo;
  String? pdf;

  factory CuadroTrabajoCodeActivacion.fromRawJson(String str) =>
      CuadroTrabajoCodeActivacion.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CuadroTrabajoCodeActivacion.fromJson(Map<String, dynamic> json) =>
      CuadroTrabajoCodeActivacion(
        activo: json["activo"],
        pdf: json["pdf"],
      );

  Map<String, dynamic> toJson() => {
        "activo": activo,
        "pdf": pdf,
      };
}
