// To parse this JSON data, do
//
//     final loginPropietario = loginPropietarioFromJson(jsonString);

import 'dart:convert';

import 'data_login_propietario.dart';
import 'permisos_propietario_model.dart';

class LoginPropietario {
  int? statusCode;
  String? sms;
  List<DatoLoginPropietario>? data;
  cPermisosPropietario? permisos;

  LoginPropietario({this.statusCode, this.sms, this.data, this.permisos});

  factory LoginPropietario.fromRawJson(String str) =>
      LoginPropietario.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginPropietario.fromJson(Map<String, dynamic> json) =>
      LoginPropietario(
        statusCode: json["status_code"],
        sms: json["sms"],
        data:
            json["data"] == null
                ? []
                : List<DatoLoginPropietario>.from(
                  json["data"]!.map((x) => DatoLoginPropietario.fromJson(x)),
                ),
        permisos:
            json["permisos"] == null
                ? null
                : cPermisosPropietario.fromJson(json["permisos"]),
      );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "sms": sms,
    "data":
        data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}
