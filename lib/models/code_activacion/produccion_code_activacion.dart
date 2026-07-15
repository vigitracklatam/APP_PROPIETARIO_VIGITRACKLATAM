import 'dart:convert';

class ProduccionCodeActivacion {
  ProduccionCodeActivacion({
    this.produccionVueltas,
    this.produccionDias,
    this.excesoVelocidadTramos,
    this.tableroAnotaciones,
    this.recorridoDias,
    this.recorridoVueltas,
  });

  int? produccionVueltas;
  int? produccionDias;
  int? excesoVelocidadTramos;
  int? tableroAnotaciones;
  int? recorridoDias;
  int? recorridoVueltas;

  factory ProduccionCodeActivacion.fromRawJson(String str) =>
      ProduccionCodeActivacion.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProduccionCodeActivacion.fromJson(Map<String, dynamic> json) =>
      ProduccionCodeActivacion(
        produccionVueltas: json["produccionVueltas"],
        produccionDias: json["produccionDias"],
        excesoVelocidadTramos: json["excesoVelocidadTramos"],
        tableroAnotaciones: json["TableroAnotaciones"],
        recorridoDias: json["recorridoDias"],
        recorridoVueltas: json["recorridoVueltas"],
      );

  Map<String, dynamic> toJson() => {
        "produccionVueltas": produccionVueltas,
        "produccionDias": produccionDias,
        "excesoVelocidadTramos": excesoVelocidadTramos,
        "TableroAnotaciones": tableroAnotaciones,
        "recorridoDias": recorridoDias,
        "recorridoVueltas": recorridoVueltas,
      };
}
