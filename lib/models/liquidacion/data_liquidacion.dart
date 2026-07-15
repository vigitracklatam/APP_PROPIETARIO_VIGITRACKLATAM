import 'dart:convert';

class DatoLiquidacion {
  int? idLiquidacionMChofer;
  DateTime? fecha;
  String? gastoLimpieza;
  String? gBebida;
  String? gastoAyudante;
  String? gastoChofer;
  String? gastoOtro;
  String? gastoComida;
  String? gastoTicket;
  String? gastoPeaje;
  String? gastoGasolina;
  String? observacion;
  int? fkSalida;
  int? fkIdRuta;
  String? descRuta;
  int? numVuelta;
  String? dineroConteo;
  String? totalGasto;
  String? total;
  String? LetrRuta;
  String? LetrFrec;
  String? DescFrec;
  String? horaSalida;
  String? horaLLegada;
  int? conteoPasajeroMedio;
  int? conteoPasajeroCompleto;
  String? dineroConteoPasajero;
  String? dineroIda;
  String? dineroVuelta;
  int? estado_ld;

  DatoLiquidacion({
    this.idLiquidacionMChofer,
    this.fecha,
    this.gastoLimpieza,
    this.gBebida,
    this.gastoAyudante,
    this.gastoChofer,
    this.gastoOtro,
    this.gastoComida,
    this.gastoTicket,
    this.gastoPeaje,
    this.gastoGasolina,
    this.observacion,
    this.fkSalida,
    this.fkIdRuta,
    this.descRuta,
    this.numVuelta,
    this.dineroConteo,
    this.totalGasto,
    this.total,
    this.LetrRuta,
    this.LetrFrec,
    this.DescFrec,
    this.horaSalida,
    this.horaLLegada,
    this.conteoPasajeroMedio,
    this.conteoPasajeroCompleto,
    this.dineroConteoPasajero,
    this.dineroIda,
    this.dineroVuelta,
    this.estado_ld,
  });

  factory DatoLiquidacion.fromRawJson(String str) =>
      DatoLiquidacion.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DatoLiquidacion.fromJson(Map<String, dynamic> json) =>
      DatoLiquidacion(
        idLiquidacionMChofer: json["id_liquidacion_m_chofer"],
        fecha: json["fecha"] == null ? null : DateTime.parse(json["fecha"]),
        gastoLimpieza: json["gastoLimpieza"],
        gBebida: json["gastoBebida"],
        gastoAyudante: json["gastoAyudante"],
        gastoChofer: json["gastoChofer"],
        gastoOtro: json["gastoOtro"],
        gastoComida: json["gastoComida"],
        gastoTicket: json["gastoTicket"],
        gastoPeaje: json["gastoPeaje"],
        gastoGasolina: json["gastoGasolina"],
        observacion: json["observacion"],
        fkSalida: json["fk_salida"],
        fkIdRuta: json["fk_idRuta"],
        descRuta: json["DescRuta"],
        numVuelta: json["numVuelta"],
        dineroConteo: json["dineroConteo"],
        totalGasto: json["totalGasto"],
        total: json["total"],
        LetrRuta: json["LetrRuta"],
        LetrFrec: json["LetrFrec"],
        DescFrec: json["DescFrec"],
        horaSalida: json["horaSalida"],
        horaLLegada: json["horaLLegada"],
        conteoPasajeroMedio: json["conteoPasajeroMedio"],
        conteoPasajeroCompleto: json["conteoPasajeroCompleto"],
        dineroConteoPasajero: json["dineroConteoPasajero"],
        dineroIda: json["dineroIda"],
        dineroVuelta: json["dineroVuelta"],
        estado_ld: json["estado_ld"],
      );

  Map<String, dynamic> toJson() => {
    "id_liquidacion_m_chofer": idLiquidacionMChofer,
    "fecha": fecha?.toIso8601String().split('T')[0],
    "gastoLimpieza": gastoLimpieza,
    "gBebida": gBebida,
    "gastoAyudante": gastoAyudante,
    "gastoChofer": gastoChofer,
    "gastoOtro": gastoOtro,
    "gastoComida": gastoComida,
    "gastoTicket": gastoTicket,
    "gastoPeaje": gastoPeaje,
    "gastoGasolina": gastoGasolina,
    "observacion": observacion,
    "fk_salida": fkSalida,
    "fk_idRuta": fkIdRuta,
    "DescRuta": descRuta,
    "numVuelta": numVuelta,
    "dineroConteo": dineroConteo,
    "totalGasto": totalGasto,
    "total": total,
    "LetrRuta": LetrRuta,
    "LetrFrec": LetrFrec,
    "DescFrec": DescFrec,
    "horaSalida": horaSalida,
    "horaLLegada": horaLLegada,
    "conteoPasajeroMedio": conteoPasajeroMedio,
    "conteoPasajeroCompleto": conteoPasajeroCompleto,
    "dineroConteoPasajero": dineroConteoPasajero,
    "dineroIda": dineroIda,
    "dineroVuelta": dineroVuelta,
    "estado_ld": estado_ld,
  };
}
