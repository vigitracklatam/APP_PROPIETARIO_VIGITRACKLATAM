import 'dart:convert';

class DatoMinTarResumido {
  String? codigo;
  String? unidad;
  String? descRuta;
  DateTime? fecha;
  String? atrasoFPenalidad;
  String? adelantoFPenalidad;
  String? atrasoJPenalidad;
  String? adelantoJPenalidad;
  String? deudaTotal;
  String? tarjetaDiaria;
  String? velocidadFalta;
  String? velocidadJustificacion;
  String? rubroFalta;
  String? rubroJustificacion;
  int? estadoCobro;

  DatoMinTarResumido({
    this.codigo,
    this.unidad,
    this.descRuta,
    this.fecha,
    this.atrasoFPenalidad,
    this.adelantoFPenalidad,
    this.atrasoJPenalidad,
    this.adelantoJPenalidad,
    this.deudaTotal,
    this.tarjetaDiaria,
    this.velocidadFalta,
    this.velocidadJustificacion,
    this.rubroFalta,
    this.rubroJustificacion,
    this.estadoCobro,
  });

  factory DatoMinTarResumido.fromRawJson(String str) =>
      DatoMinTarResumido.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DatoMinTarResumido.fromJson(Map<String, dynamic> json) =>
      DatoMinTarResumido(
        codigo: json["Codigo"],
        unidad: json["Unidad"],
        descRuta: json["DescRuta"],
        fecha: json["Fecha"] == null ? null : DateTime.parse(json["Fecha"]),
        atrasoFPenalidad: json["AtrasoFPenalidad"],
        adelantoFPenalidad: json["AdelantoFPenalidad"],
        atrasoJPenalidad: json["AtrasoJPenalidad"],
        adelantoJPenalidad: json["AdelantoJPenalidad"],
        deudaTotal: json["DeudaTotal"],
        tarjetaDiaria: json["TarjetaDiaria"],
        velocidadFalta: json["VelocidadFalta"],
        velocidadJustificacion: json["VelocidadJustificacion"],
        rubroFalta: json["RubroFalta"],
        rubroJustificacion: json["RubroJustificacion"],
        estadoCobro: json["EstadoCobro"],
      );

  Map<String, dynamic> toJson() => {
        "Codigo": codigo,
        "Unidad": unidad,
        "DescRuta": descRuta,
        "Fecha":
            "${fecha!.year.toString().padLeft(4, '0')}-${fecha!.month.toString().padLeft(2, '0')}-${fecha!.day.toString().padLeft(2, '0')}",
        "AtrasoFPenalidad": atrasoFPenalidad,
        "AdelantoFPenalidad": adelantoFPenalidad,
        "AtrasoJPenalidad": atrasoJPenalidad,
        "AdelantoJPenalidad": adelantoJPenalidad,
        "DeudaTotal": deudaTotal,
        "TarjetaDiaria": tarjetaDiaria,
        "VelocidadFalta": velocidadFalta,
        "VelocidadJustificacion": velocidadJustificacion,
        "RubroFalta": rubroFalta,
        "RubroJustificacion": rubroJustificacion,
        "EstadoCobro": estadoCobro,
      };
}
