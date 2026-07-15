import 'dart:convert';

class DatoMinTarVueResumen {
  int? codigoDeuda;
  String? unidad;
  int? numeVuelSaliM;
  String? descRuta;
  DateTime? fecha;
  String? atrasoFPenalidad;
  String? atrasoJPenalidad;
  String? deudaTotal;
  int? estadoCobro;

  DatoMinTarVueResumen({
    this.codigoDeuda,
    this.unidad,
    this.numeVuelSaliM,
    this.descRuta,
    this.fecha,
    this.atrasoFPenalidad,
    this.atrasoJPenalidad,
    this.deudaTotal,
    this.estadoCobro,
  });

  factory DatoMinTarVueResumen.fromRawJson(String str) =>
      DatoMinTarVueResumen.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DatoMinTarVueResumen.fromJson(Map<String, dynamic> json) =>
      DatoMinTarVueResumen(
        codigoDeuda: json["CodigoDeuda"],
        unidad: json["Unidad"],
        numeVuelSaliM: json["NumeVuelSali_m"],
        descRuta: json["DescRuta"]!,
        fecha: json["Fecha"] == null ? null : DateTime.parse(json["Fecha"]),
        atrasoFPenalidad: json["AtrasoFPenalidad"],
        atrasoJPenalidad: json["AtrasoJPenalidad"],
        deudaTotal: json["DeudaTotal"],
        estadoCobro: json["EstadoCobro"],
      );

  Map<String, dynamic> toJson() => {
        "CodigoDeuda": codigoDeuda,
        "Unidad": unidad,
        "NumeVuelSali_m": numeVuelSaliM,
        "DescRuta": descRuta,
        "Fecha":
            "${fecha!.year.toString().padLeft(4, '0')}-${fecha!.month.toString().padLeft(2, '0')}-${fecha!.day.toString().padLeft(2, '0')}",
        "AtrasoFPenalidad": atrasoFPenalidad,
        "AtrasoJPenalidad": atrasoJPenalidad,
        "DeudaTotal": deudaTotal,
        "EstadoCobro": estadoCobro,
      };
}
