import 'dart:convert';

class DatoSalida {
  int? idRutaMSaliM;
  int? idSaliM;
  String? codiVehiSaliM;
  String? horaSaliProgSaliM;
  String? horaSaliProgSaliMF;
  String? horaLlegProgSaliM;
  String? horaLlegProgSaliMF;
  String? atrasoSec;
  String? adelantoSec;
  String? atrasoTime;
  String? adelantoTime;
  int? estaSaliM;
  int? veloMaxiSaliM;
  int? numeVuelSaliM;
  int? numeTarjSaliM;
  String? letraRutaSaliM;
  String? descRutaSaliM;
  int? idFrec;
  String? descFrec;
  String? penaCtrlSaliD;
  String? atrasoFaltas;
  String? adelantoFaltas;
  String? adelantoFaltasTime;
  String? atrasoFaltasTime;

  DatoSalida({
    this.idRutaMSaliM,
    this.idSaliM,
    this.codiVehiSaliM,
    this.horaSaliProgSaliM,
    this.horaSaliProgSaliMF,
    this.horaLlegProgSaliM,
    this.horaLlegProgSaliMF,
    this.atrasoSec,
    this.adelantoSec,
    this.atrasoTime,
    this.adelantoTime,
    this.estaSaliM,
    this.veloMaxiSaliM,
    this.numeVuelSaliM,
    this.numeTarjSaliM,
    this.letraRutaSaliM,
    this.descRutaSaliM,
    this.idFrec,
    this.descFrec,
    this.penaCtrlSaliD,
    this.atrasoFaltas,
    this.adelantoFaltas,
    this.adelantoFaltasTime,
    this.atrasoFaltasTime,
  });

  factory DatoSalida.fromRawJson(String str) =>
      DatoSalida.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DatoSalida.fromJson(Map<String, dynamic> json) => DatoSalida(
        idRutaMSaliM: json["idRuta_mSali_m"],
        idSaliM: json["idSali_m"],
        codiVehiSaliM: json["CodiVehiSali_m"],
        horaSaliProgSaliM: json["HoraSaliProgSali_m"],
        horaSaliProgSaliMF: json["HoraSaliProgSali_mF"],
        horaLlegProgSaliM: json["HoraLlegProgSali_m"],
        horaLlegProgSaliMF: json["HoraLlegProgSali_mF"],
        atrasoSec: json["atrasoSec"],
        adelantoSec: json["adelantoSec"],
        atrasoTime: json["atrasoTime"],
        adelantoTime: json["adelantoTime"],
        estaSaliM: json["EstaSali_m"],
        veloMaxiSaliM: json["VeloMaxiSali_m"],
        numeVuelSaliM: json["NumeVuelSali_m"],
        numeTarjSaliM: json["NumeTarjSali_m"],
        letraRutaSaliM: json["LetraRutaSali_m"],
        descRutaSaliM: json["DescRutaSali_m"],
        idFrec: json["idFrec"],
        descFrec: json["DescFrec"],
        penaCtrlSaliD: json["PenaCtrlSali_d"].toString(),
        atrasoFaltas: json["atrasos"],
        adelantoFaltas: json["adelantos"],
        adelantoFaltasTime: json["adelantoFaltasTime"],
        atrasoFaltasTime: json["atrasoFaltasTime"],
      );

  Map<String, dynamic> toJson() => {
        "idRuta_mSali_m": idRutaMSaliM,
        "idSali_m": idSaliM,
        "CodiVehiSali_m": codiVehiSaliM,
        "HoraSaliProgSali_m": horaSaliProgSaliM,
        "HoraSaliProgSali_mF": horaSaliProgSaliMF,
        "HoraLlegProgSali_m": horaLlegProgSaliM,
        "HoraLlegProgSali_mF": horaLlegProgSaliMF,
        "atrasoSec": atrasoSec,
        "adelantoSec": adelantoSec,
        "atrasoTime": atrasoTime,
        "adelantoTime": adelantoTime,
        "EstaSali_m": estaSaliM,
        "VeloMaxiSali_m": veloMaxiSaliM,
        "NumeVuelSali_m": numeVuelSaliM,
        "NumeTarjSali_m": numeTarjSaliM,
        "LetraRutaSali_m": letraRutaSaliM,
        "DescRutaSali_m": descRutaSaliM,
        "idFrec": idFrec,
        "DescFrec": descFrec,
        "PenaCtrlSali_d": penaCtrlSaliD,
        "atrasos": atrasoFaltas,
        "adelantos": adelantoFaltas,
        "adelantoFaltasTime": adelantoFaltasTime,
        "atrasoFaltasTime": atrasoFaltasTime,
      };
}
