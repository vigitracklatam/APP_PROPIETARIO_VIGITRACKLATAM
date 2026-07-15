import 'dart:convert';

class Minuto {
  DateTime? horaSalida;
  String? horaLlegada;
  String? idControl;
  String? descripcionControl;
  String? horaProgSaliD;
  String? horaMarcSaliD;
  String? atrasoFTiempo;
  String? adelantoFTiempo;
  String? atrasoJTiempo;
  String? adelantoJTiempo;
  String? rubroPenalidad;
  String? velocidadPenalidad;

  Minuto({
    this.horaSalida,
    this.horaLlegada,
    this.idControl,
    this.descripcionControl,
    this.horaProgSaliD,
    this.horaMarcSaliD,
    this.atrasoFTiempo,
    this.adelantoFTiempo,
    this.atrasoJTiempo,
    this.adelantoJTiempo,
    this.rubroPenalidad,
    this.velocidadPenalidad,
  });

  factory Minuto.fromRawJson(String str) => Minuto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Minuto.fromJson(Map<String, dynamic> json) => Minuto(
        horaSalida: json["HoraSalida"] == null
            ? null
            : DateTime.parse(json["HoraSalida"]),
        horaLlegada: json["HoraLlegada"],
        idControl: json["IDControl"],
        descripcionControl: json["DescripcionControl"],
        horaProgSaliD: json["HoraProgSali_d"],
        horaMarcSaliD: json["HoraMarcSali_d"],
        atrasoFTiempo: json["AtrasoFTiempo"],
        adelantoFTiempo: json["AdelantoFTiempo"],
        atrasoJTiempo: json["AtrasoJTiempo"],
        adelantoJTiempo: json["AdelantoJTiempo"],
        rubroPenalidad: json["RubroPenalidad"],
        velocidadPenalidad: json["VelocidadPenalidad"],
      );

  Map<String, dynamic> toJson() => {
        "HoraSalida": horaSalida?.toIso8601String(),
        "HoraLlegada": horaLlegada,
        "IDControl": idControl,
        "DescripcionControl": descripcionControl,
        "HoraProgSali_d": horaProgSaliD,
        "HoraMarcSali_d": horaMarcSaliD,
        "AtrasoFTiempo": atrasoFTiempo,
        "AdelantoFTiempo": adelantoFTiempo,
        "AtrasoJTiempo": atrasoJTiempo,
        "AdelantoJTiempo": adelantoJTiempo,
        "RubroPenalidad": rubroPenalidad,
        "VelocidadPenalidad": velocidadPenalidad,
      };
}
