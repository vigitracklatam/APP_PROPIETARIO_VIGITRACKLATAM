import 'dart:convert';

import 'calculator.dart';

class DatoControl {
  String? codiCtrl;
  String? codiClieCtrl;
  int? idCtrl;
  String? descCtrl;
  int? idTipoCtrl;
  int? coloCtrl;
  String? lati1Ctrl;
  String? long1Ctrl;
  String? lati2Ctrl;
  String? long2Ctrl;
  int? radiCtrl;
  dynamic coloLineCtrl;
  dynamic coloRellCtrl;
  int? initTramCtrl;
  int? inteCtrl;
  int? tipoGeocPatrCtrl;
  int? estaCtrl;
  Calculator? calculator;

  DatoControl({
    this.codiCtrl,
    this.codiClieCtrl,
    this.idCtrl,
    this.descCtrl,
    this.idTipoCtrl,
    this.coloCtrl,
    this.lati1Ctrl,
    this.long1Ctrl,
    this.lati2Ctrl,
    this.long2Ctrl,
    this.radiCtrl,
    this.coloLineCtrl,
    this.coloRellCtrl,
    this.initTramCtrl,
    this.inteCtrl,
    this.tipoGeocPatrCtrl,
    this.estaCtrl,
    this.calculator,
  });

  factory DatoControl.fromRawJson(String str) =>
      DatoControl.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DatoControl.fromJson(Map<String, dynamic> json) => DatoControl(
        codiCtrl: json["CodiCtrl"],
        codiClieCtrl: json["CodiClieCtrl"],
        idCtrl: json["idCtrl"],
        descCtrl: json["DescCtrl"],
        idTipoCtrl: json["idTipoCtrl"],
        coloCtrl: json["ColoCtrl"],
        lati1Ctrl: json["Lati1Ctrl"],
        long1Ctrl: json["Long1Ctrl"],
        lati2Ctrl: json["Lati2Ctrl"],
        long2Ctrl: json["Long2Ctrl"],
        radiCtrl: json["RadiCtrl"],
        coloLineCtrl: json["ColoLineCtrl"],
        coloRellCtrl: json["ColoRellCtrl"],
        initTramCtrl: json["InitTramCtrl"],
        inteCtrl: json["InteCtrl"],
        tipoGeocPatrCtrl: json["TipoGeocPatrCtrl"],
        estaCtrl: json["EstaCtrl"],
        calculator: json["calculator"] == null
            ? null
            : Calculator.fromJson(json["calculator"]),
      );

  Map<String, dynamic> toJson() => {
        "CodiCtrl": codiCtrl,
        "CodiClieCtrl": codiClieCtrl,
        "idCtrl": idCtrl,
        "DescCtrl": descCtrl,
        "idTipoCtrl": idTipoCtrl,
        "ColoCtrl": coloCtrl,
        "Lati1Ctrl": lati1Ctrl,
        "Long1Ctrl": long1Ctrl,
        "Lati2Ctrl": lati2Ctrl,
        "Long2Ctrl": long2Ctrl,
        "RadiCtrl": radiCtrl,
        "ColoLineCtrl": coloLineCtrl,
        "ColoRellCtrl": coloRellCtrl,
        "InitTramCtrl": initTramCtrl,
        "InteCtrl": inteCtrl,
        "TipoGeocPatrCtrl": tipoGeocPatrCtrl,
        "EstaCtrl": estaCtrl,
        "calculator": calculator?.toJson(),
      };
}
