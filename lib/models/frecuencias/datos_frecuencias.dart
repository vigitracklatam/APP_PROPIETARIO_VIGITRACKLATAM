import 'dart:convert';

class DatoFrecuencia {
  int? autoDespachoDifeFrec;
  int? autoDespTipo;
  int? idRuta;
  String? letrRuta;
  String? descRuta;
  int? idFrec;
  String? descFrec;
  String? letrFrec;
  int? actiFrec;
  int? inteFrec;
  String? horaInicFrec;
  String? horaInic1Frec;
  String? horaFina2Frec;
  int? luneFrec;
  int? martFrec;
  int? mierFrec;
  int? juevFrec;
  int? vierFrec;
  int? sabaFrec;
  int? domiFrec;

  DatoFrecuencia({
    this.autoDespachoDifeFrec,
    this.autoDespTipo,
    this.idRuta,
    this.letrRuta,
    this.descRuta,
    this.idFrec,
    this.descFrec,
    this.letrFrec,
    this.actiFrec,
    this.inteFrec,
    this.horaInicFrec,
    this.horaInic1Frec,
    this.horaFina2Frec,
    this.luneFrec,
    this.martFrec,
    this.mierFrec,
    this.juevFrec,
    this.vierFrec,
    this.sabaFrec,
    this.domiFrec,
  });

  factory DatoFrecuencia.fromRawJson(String str) =>
      DatoFrecuencia.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DatoFrecuencia.fromJson(Map<String, dynamic> json) => DatoFrecuencia(
        autoDespachoDifeFrec: json["AutoDespachoDifeFrec"],
        autoDespTipo: json["AutoDespTipo"],
        idRuta: json["idRuta"],
        letrRuta: json["LetrRuta"],
        descRuta: json["DescRuta"],
        idFrec: json["idFrec"],
        descFrec: json["DescFrec"],
        letrFrec: json["LetrFrec"],
        actiFrec: json["ActiFrec"],
        inteFrec: json["InteFrec"],
        horaInicFrec: json["HoraInicFrec"],
        horaInic1Frec: json["HoraInic1Frec"],
        horaFina2Frec: json["HoraFina2Frec"],
        luneFrec: json["LuneFrec"],
        martFrec: json["MartFrec"],
        mierFrec: json["MierFrec"],
        juevFrec: json["JuevFrec"],
        vierFrec: json["VierFrec"],
        sabaFrec: json["SabaFrec"],
        domiFrec: json["DomiFrec"],
      );

  Map<String, dynamic> toJson() => {
        "AutoDespachoDifeFrec": autoDespachoDifeFrec,
        "AutoDespTipo": autoDespTipo,
        "idRuta": idRuta,
        "LetrRuta": letrRuta,
        "DescRuta": descRuta,
        "idFrec": idFrec,
        "DescFrec": descFrec,
        "LetrFrec": letrFrec,
        "ActiFrec": actiFrec,
        "InteFrec": inteFrec,
        "HoraInicFrec": horaInicFrec,
        "HoraInic1Frec": horaInic1Frec,
        "HoraFina2Frec": horaFina2Frec,
        "LuneFrec": luneFrec,
        "MartFrec": martFrec,
        "MierFrec": mierFrec,
        "JuevFrec": juevFrec,
        "VierFrec": vierFrec,
        "SabaFrec": sabaFrec,
        "DomiFrec": domiFrec,
      };
}
