import 'dart:convert';

class DatoValoresPenPag {
  String? codigo;
  String? unidad;
  DateTime? fecha;
  String? deudaTotal;
  String? descRuta;
  int? estadoCobro;
  int? numeroCobro;
  String? fechaCobro;

  DatoValoresPenPag({
    this.codigo,
    this.unidad,
    this.fecha,
    this.deudaTotal,
    this.descRuta,
    this.estadoCobro,
    this.numeroCobro,
    this.fechaCobro,
  });

  factory DatoValoresPenPag.fromRawJson(String str) =>
      DatoValoresPenPag.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DatoValoresPenPag.fromJson(Map<String, dynamic> json) =>
      DatoValoresPenPag(
        codigo: json["Codigo"],
        unidad: json["Unidad"],
        fecha: json["Fecha"] == null ? null : DateTime.parse(json["Fecha"]),
        deudaTotal: json["DeudaTotal"],
        descRuta: json["DescRuta"],
        estadoCobro: json["EstadoCobro"],
        numeroCobro: json["NumeroCobro"],
        fechaCobro: json["fecha_cobro"],
      );

  Map<String, dynamic> toJson() => {
        "Codigo": codigo,
        "Unidad": unidad,
        "Fecha":
            "${fecha!.year.toString().padLeft(4, '0')}-${fecha!.month.toString().padLeft(2, '0')}-${fecha!.day.toString().padLeft(2, '0')}",
        "DeudaTotal": deudaTotal,
        "DescRuta": descRuta,
        "EstadoCobro": estadoCobro,
        "NumeroCobro": numeroCobro,
        "fecha_cobro": fechaCobro,
      };
}
