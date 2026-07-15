import 'dart:convert';

class DatosRutas {
  int? idRuta;
  String? descRuta;
  String? letrRuta;
  String? horaInicSaliProgRuta;
  int? inteSaliProgRuta;
  int? idTermRuta;
  String? descTerm;
  String? horaFinaSaliProgRuta;
  int? actiRuta;

  DatosRutas({
    this.idRuta,
    this.descRuta,
    this.letrRuta,
    this.horaInicSaliProgRuta,
    this.inteSaliProgRuta,
    this.idTermRuta,
    this.descTerm,
    this.horaFinaSaliProgRuta,
    this.actiRuta,
  });

  factory DatosRutas.fromRawJson(String str) =>
      DatosRutas.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DatosRutas.fromJson(Map<String, dynamic> json) => DatosRutas(
        idRuta: json["idRuta"],
        descRuta: json["DescRuta"],
        letrRuta: json["LetrRuta"],
        horaInicSaliProgRuta: json["HoraInicSaliProgRuta"],
        inteSaliProgRuta: json["InteSaliProgRuta"],
        idTermRuta: json["IdTermRuta"],
        descTerm: json["DescTerm"],
        horaFinaSaliProgRuta: json["HoraFinaSaliProgRuta"],
        actiRuta: json["ActiRuta"],
      );

  Map<String, dynamic> toJson() => {
        "idRuta": idRuta,
        "DescRuta": descRuta,
        "LetrRuta": letrRuta,
        "HoraInicSaliProgRuta": horaInicSaliProgRuta,
        "InteSaliProgRuta": inteSaliProgRuta,
        "IdTermRuta": idTermRuta,
        "DescTerm": descTerm,
        "HoraFinaSaliProgRuta": horaFinaSaliProgRuta,
        "ActiRuta": actiRuta,
      };
}
