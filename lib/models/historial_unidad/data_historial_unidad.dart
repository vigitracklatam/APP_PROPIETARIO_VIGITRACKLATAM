import 'dart:convert';

class DatoHistorialUnidad {
  String? horamarc;
  String? horaprog;
  int? idHistEve;
  int? idSaliMHistEven;
  String? fechHistEven;
  String? fechHistEvenTime;
  String? descRutaSaliM;
  String? codiCtrlHistEven;
  int? outRoutHistEven;
  int? evenExceVeloHistEven;
  int? veloHistEven;
  int? sateHistEven;
  String? latiHistEven;
  String? longHistEven;
  int? rumbHistEven;
  String? horaProgSaliD;
  String? horaMarcSaliD;

  DatoHistorialUnidad({
    this.horamarc,
    this.horaprog,
    this.idHistEve,
    this.idSaliMHistEven,
    this.fechHistEven,
    this.fechHistEvenTime,
    this.descRutaSaliM,
    this.codiCtrlHistEven,
    this.outRoutHistEven,
    this.evenExceVeloHistEven,
    this.veloHistEven,
    this.sateHistEven,
    this.latiHistEven,
    this.longHistEven,
    this.rumbHistEven,
    this.horaProgSaliD,
    this.horaMarcSaliD,
  });

  factory DatoHistorialUnidad.fromRawJson(String str) =>
      DatoHistorialUnidad.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DatoHistorialUnidad.fromJson(Map<String, dynamic> json) =>
      DatoHistorialUnidad(
        horamarc: json["HORAMARC"] ?? '',
        horaprog: json["HORAPROG"] ?? '',
        idHistEve: json["idHistEve"],
        idSaliMHistEven: json["idSali_mHistEven"],
        fechHistEven: json["FechHistEven"] ?? '',
        fechHistEvenTime: json["FechHistEvenTime"] ?? '',
        descRutaSaliM: json["DescRutaSali_m"] ?? '',
        codiCtrlHistEven: json["CodiCtrlHistEven"] ?? '',
        outRoutHistEven: json["OutRoutHistEven"],
        evenExceVeloHistEven: json["EvenExceVeloHistEven"],
        veloHistEven: json["VeloHistEven"],
        sateHistEven: json["SateHistEven"],
        latiHistEven: json["LatiHistEven"] ?? '',
        longHistEven: json["LongHistEven"] ?? '',
        rumbHistEven: json["RumbHistEven"],
        horaProgSaliD: json["HoraProgSali_d"] ?? '',
        horaMarcSaliD: json["HoraMarcSali_d"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "HORAMARC": horamarc,
        "HORAPROG": horaprog,
        "idHistEve": idHistEve,
        "idSali_mHistEven": idSaliMHistEven,
        "FechHistEven": fechHistEven,
        "FechHistEvenTime": fechHistEvenTime,
        "DescRutaSali_m": descRutaSaliM,
        "CodiCtrlHistEven": codiCtrlHistEven,
        "OutRoutHistEven": outRoutHistEven,
        "EvenExceVeloHistEven": evenExceVeloHistEven,
        "VeloHistEven": veloHistEven,
        "SateHistEven": sateHistEven,
        "LatiHistEven": latiHistEven,
        "LongHistEven": longHistEven,
        "RumbHistEven": rumbHistEven,
        "HoraProgSali_d": horaProgSaliD,
        "HoraMarcSali_d": horaMarcSaliD,
      };
}
