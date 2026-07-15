import 'dart:convert';

import '../control/coordinate.dart';

class Calculator {
  double? tang;
  double? cota;
  double? a;
  double? b;
  double? c;
  double? d;
  double? e;
  double? f;
  double? g;
  double? h;
  double? cx;
  double? cy;
  List<Coordinate>? coordinates;

  Calculator({
    this.tang,
    this.cota,
    this.a,
    this.b,
    this.c,
    this.d,
    this.e,
    this.f,
    this.g,
    this.h,
    this.cx,
    this.cy,
    this.coordinates,
  });

  factory Calculator.fromRawJson(String str) =>
      Calculator.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Calculator.fromJson(Map<String, dynamic> json) => Calculator(
        tang: json["Tang"]?.toDouble(),
        cota: json["Cota"]?.toDouble(),
        a: json["a"]?.toDouble(),
        b: json["b"]?.toDouble(),
        c: json["c"]?.toDouble(),
        d: json["d"]?.toDouble(),
        e: json["e"]?.toDouble(),
        f: json["f"]?.toDouble(),
        g: json["g"]?.toDouble(),
        h: json["h"]?.toDouble(),
        cx: json["cx"]?.toDouble(),
        cy: json["cy"]?.toDouble(),
        coordinates: json["coordinates"] == null
            ? []
            : List<Coordinate>.from(
                json["coordinates"]!.map((x) => Coordinate.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Tang": tang,
        "Cota": cota,
        "a": a,
        "b": b,
        "c": c,
        "d": d,
        "e": e,
        "f": f,
        "g": g,
        "h": h,
        "cx": cx,
        "cy": cy,
        "coordinates": coordinates == null
            ? []
            : List<dynamic>.from(coordinates!.map((x) => x.toJson())),
      };
}
