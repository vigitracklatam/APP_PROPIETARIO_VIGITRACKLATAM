// To parse this JSON data, do
//
//     final controlPropietarioAppMovil = controlPropietarioAppMovilFromJson(jsonString);

import 'dart:convert';

import 'data_control_propietario.dart';

class ControlPropietarioAppMovil {
  int? statusCode;
  List<DatoControl>? data;
  dynamic msg;

  ControlPropietarioAppMovil({
    this.statusCode,
    this.data,
    this.msg,
  });

  factory ControlPropietarioAppMovil.fromRawJson(String str) =>
      ControlPropietarioAppMovil.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ControlPropietarioAppMovil.fromJson(Map<String, dynamic> json) =>
      ControlPropietarioAppMovil(
        statusCode: json["status_code"],
        data: json["data"] == null
            ? []
            : List<DatoControl>.from(
                json["data"]!.map((x) => DatoControl.fromJson(x))),
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "msg": msg,
      };
}
