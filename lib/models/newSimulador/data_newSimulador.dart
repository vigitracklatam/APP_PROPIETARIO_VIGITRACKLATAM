import 'dart:convert';

class DatoNewSimulador {
  int? idHistEve;
  int? idSaliMHistEven;
  String? fechHistEven;
  String? descRutaSaliM;
  String? codiCtrlHistEven;
  int? outRoutHistEven;
  int? evenExceVeloHistEven;
  int? veloHistEven;
  String? latiHistEven;
  String? longHistEven;
  int? rumbHistEven;
  String? horaProgSaliD;
  String? descCtrlSaliD;
  String? horaMarcSaliD;

  DatoNewSimulador({
    this.idHistEve,
    this.idSaliMHistEven,
    this.fechHistEven,
    this.descRutaSaliM = "",
    this.codiCtrlHistEven = "",
    this.outRoutHistEven,
    this.evenExceVeloHistEven,
    this.veloHistEven,
    this.latiHistEven = "",
    this.longHistEven = "",
    this.rumbHistEven,
    this.horaProgSaliD = "",
    this.descCtrlSaliD = "",
    this.horaMarcSaliD = "",
  });

  factory DatoNewSimulador.fromRawJson(String str) =>
      DatoNewSimulador.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DatoNewSimulador.fromJson(Map<String, dynamic> json) =>
      DatoNewSimulador(
        idHistEve: json["idHistEve"],
        idSaliMHistEven: json["idSali_mHistEven"],
        fechHistEven: json["FechHistEven"] ?? "",
        descRutaSaliM: json["DescRutaSali_m"] ?? "",
        codiCtrlHistEven: json["CodiCtrlHistEven"] ?? "",
        outRoutHistEven: json["OutRoutHistEven"],
        evenExceVeloHistEven: json["EvenExceVeloHistEven"],
        veloHistEven: json["VeloHistEven"],
        latiHistEven: json["LatiHistEven"] ?? "",
        longHistEven: json["LongHistEven"] ?? "",
        rumbHistEven: json["RumbHistEven"],
        horaProgSaliD: json["HoraProgSali_d"] ?? "",
        descCtrlSaliD: json["DescCtrlSali_d"] ?? "",
        horaMarcSaliD: json["HoraMarcSali_d"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "idHistEve": idHistEve,
        "idSali_mHistEven": idSaliMHistEven,
        "FechHistEven": fechHistEven,
        "DescRutaSali_m": descRutaSaliM,
        "CodiCtrlHistEven": codiCtrlHistEven,
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
