import 'dart:convert';

class DatoRecorrido {
  int? idHistEve;
  int? idSaliMHistEven;
  DateTime? fechHistEven;
  String? descRutaSaliM;
  String? codiCtrlHistEven;
  int? sateHistEven;
  int? outRoutHistEven;
  int? evenExceVeloHistEven;
  int? veloHistEven;
  String? latiHistEven;
  String? longHistEven;
  int? rumbHistEven;
  String? horaProgSaliD;
  String? descCtrlSaliD;
  String? horaMarcSaliD;

  DatoRecorrido({
    this.idHistEve,
    this.idSaliMHistEven,
    this.fechHistEven,
    this.descRutaSaliM,
    this.codiCtrlHistEven,
    this.sateHistEven,
    this.outRoutHistEven,
    this.evenExceVeloHistEven,
    this.veloHistEven,
    this.latiHistEven,
    this.longHistEven,
    this.rumbHistEven,
    this.horaProgSaliD,
    this.descCtrlSaliD,
    this.horaMarcSaliD,
  });

  factory DatoRecorrido.fromRawJson(String str) =>
      DatoRecorrido.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DatoRecorrido.fromJson(Map<String, dynamic> json) => DatoRecorrido(
        idHistEve: json["idHistEve"],
        idSaliMHistEven: json["idSali_mHistEven"],
        fechHistEven: json["FechHistEven"] == null
            ? null
            : DateTime.parse(json["FechHistEven"]),
        descRutaSaliM: json["DescRutaSali_m"],
        codiCtrlHistEven: json["CodiCtrlHistEven"],
        sateHistEven: json["SateHistEven"],
        outRoutHistEven: json["OutRoutHistEven"],
        evenExceVeloHistEven: json["EvenExceVeloHistEven"],
        veloHistEven: json["VeloHistEven"],
        latiHistEven: json["LatiHistEven"],
        longHistEven: json["LongHistEven"],
        rumbHistEven: json["RumbHistEven"],
        horaProgSaliD: json["HoraProgSali_d"],
        descCtrlSaliD: json["DescCtrlSali_d"],
        horaMarcSaliD: json["HoraMarcSali_d"],
      );

  Map<String, dynamic> toJson() => {
        "idHistEve": idHistEve,
        "idSali_mHistEven": idSaliMHistEven,
        "FechHistEven": fechHistEven?.toIso8601String(),
        "DescRutaSali_m": descRutaSaliM,
        "CodiCtrlHistEven": codiCtrlHistEven,
        "SateHistEven": sateHistEven,
        "OutRoutHistEven": outRoutHistEven,
        "EvenExceVeloHistEven": evenExceVeloHistEven,
        "VeloHistEven": veloHistEven,
        "LatiHistEven": latiHistEven,
        "LongHistEven": longHistEven,
        "RumbHistEven": rumbHistEven,
        "HoraProgSali_d": horaProgSaliD,
        "DescCtrlSali_d": descCtrlSaliD,
        "HoraMarcSali_d": horaMarcSaliD,
      };
}
