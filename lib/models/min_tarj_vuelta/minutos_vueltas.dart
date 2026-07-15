import 'dart:convert';

class Minutos {
  DateTime? horaSalida;
  String? horaLlegada;
  String? descripcionControl;
  String? horaProgSaliD;
  String? horaMarcSaliD;
  String? atrasoFTiempo;
  String? adelantoFTiempo;
  String? atrasoJTiempo;
  String? adelantoJTiempo;
  int? rubroPenalidad;
  int? velocidadPenalidad;

  Minutos({
    this.horaSalida,
    this.horaLlegada,
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

  factory Minutos.fromRawJson(String str) => Minutos.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Minutos.fromJson(Map<String, dynamic> json) => Minutos(
        horaSalida: json["HoraSalida"] == null
            ? null
            : DateTime.parse(json["HoraSalida"]),
        horaLlegada: json["HoraLlegada"],
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
