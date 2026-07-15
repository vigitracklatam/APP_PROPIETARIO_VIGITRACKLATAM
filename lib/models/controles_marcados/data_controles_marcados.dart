import 'dart:convert';

class DatoControlesMarcados {
  String? codiCtrlSaliD;
  String? descCtrl;
  String? lati1Ctrl;
  String? long1Ctrl;
  String? lati2Ctrl;
  String? long2Ctrl;
  int? radiCtrl;
  String? horaProgSaliD;
  String? horaMarcSaliD;
  int? isCtrlRefeSaliD;

  DatoControlesMarcados({
    this.codiCtrlSaliD,
    this.descCtrl,
    this.lati1Ctrl,
    this.long1Ctrl,
    this.lati2Ctrl,
    this.long2Ctrl,
    this.radiCtrl,
    this.horaProgSaliD,
    this.horaMarcSaliD,
    this.isCtrlRefeSaliD,
  });

  factory DatoControlesMarcados.fromRawJson(String str) =>
      DatoControlesMarcados.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DatoControlesMarcados.fromJson(Map<String, dynamic> json) =>
      DatoControlesMarcados(
        codiCtrlSaliD: json["CodiCtrlSali_d"] ?? '',
        descCtrl: json["DescCtrl"] ?? '',
        lati1Ctrl: json["Lati1Ctrl"] ?? '',
        long1Ctrl: json["Long1Ctrl"] ?? '',
        lati2Ctrl: json["Lati2Ctrl"] ?? '',
        long2Ctrl: json["Long2Ctrl"] ?? '',
        radiCtrl: json["RadiCtrl"],
        horaProgSaliD: json["HoraProgSali_d"] ?? '',
        horaMarcSaliD: json["HoraMarcSali_d"] ?? '',
        isCtrlRefeSaliD: json["isCtrlRefeSali_d"],
      );

  Map<String, dynamic> toJson() => {
        "CodiCtrlSali_d": codiCtrlSaliD,
        "DescCtrl": descCtrl,
        "Lati1Ctrl": lati1Ctrl,
        "Long1Ctrl": long1Ctrl,
        "Lati2Ctrl": lati2Ctrl,
        "Long2Ctrl": long2Ctrl,
        "RadiCtrl": radiCtrl,
        "HoraProgSali_d": horaProgSaliD,
        "HoraMarcSali_d": horaMarcSaliD,
        "isCtrlRefeSali_d": isCtrlRefeSaliD,
      };
}
