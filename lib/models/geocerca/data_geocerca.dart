import 'dart:convert';

import '../control/calculator.dart';

class DatoGeocerca {
  String? codiCtrl;
  String? descRuta;
  String? letrRuta;
  String? descCtrl;
  String? lati1Ctrl;
  String? lati2Ctrl;
  String? long1Ctrl;
  String? long2Ctrl;
  int? radiCtrl;
  Calculator? calculator;

  DatoGeocerca({
    this.codiCtrl,
    this.descRuta,
    this.letrRuta,
    this.descCtrl,
    this.lati1Ctrl,
    this.lati2Ctrl,
    this.long1Ctrl,
    this.long2Ctrl,
    this.radiCtrl,
    this.calculator,
  });

  factory DatoGeocerca.fromRawJson(String str) =>
      DatoGeocerca.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DatoGeocerca.fromJson(Map<String, dynamic> json) => DatoGeocerca(
        codiCtrl: json["CodiCtrl"],
        descRuta: json["DescRuta"],
        letrRuta: json["LetrRuta"],
        descCtrl: json["DescCtrl"],
        lati1Ctrl: json["Lati1Ctrl"],
        lati2Ctrl: json["Lati2Ctrl"],
        long1Ctrl: json["Long1Ctrl"],
        long2Ctrl: json["Long2Ctrl"],
        radiCtrl: json["RadiCtrl"],
        calculator: json["calculator"] == null
            ? null
            : Calculator.fromJson(json["calculator"]),
      );

  Map<String, dynamic> toJson() => {
        "CodiCtrl": codiCtrl,
        "DescRuta": descRuta,
        "LetrRuta": letrRuta,
        "DescCtrl": descCtrl,
        "Lati1Ctrl": lati1Ctrl,
        "Lati2Ctrl": lati2Ctrl,
        "Long1Ctrl": long1Ctrl,
        "Long2Ctrl": long2Ctrl,
        "RadiCtrl": radiCtrl,
        "calculator": calculator?.toJson(),
      };
}
