import 'dart:convert';
import 'data_geocerca.dart';

class GeocercaAppMovil {
  int? statusCode;
  List<DatoGeocerca>? data;
  dynamic msm;

  GeocercaAppMovil({
    this.statusCode,
    this.data,
    this.msm,
  });

  factory GeocercaAppMovil.fromRawJson(String str) =>
      GeocercaAppMovil.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GeocercaAppMovil.fromJson(Map<String, dynamic> json) =>
      GeocercaAppMovil(
        statusCode: json["status_code"],
        data: json["data"] == null
            ? []
            : List<DatoGeocerca>.from(
                json["data"]!.map((x) => DatoGeocerca.fromJson(x))),
        msm: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "msg": msm,
      };
}
