// To parse this JSON data, do
//
//     final codeActivacion = codeActivacionFromJson(jsonString);

import 'dart:convert';

import 'data_code_activacion.dart';

class CodeActivacion {
  CodeActivacion({
    this.statusCode,
    this.data,
    this.msm,
  });

  int? statusCode;
  DataCodeActivacion? data;
  String? msm;

  factory CodeActivacion.fromRawJson(String str) =>
      CodeActivacion.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CodeActivacion.fromJson(Map<String, dynamic> json) => CodeActivacion(
        statusCode: json["status_code"],
        data: json["data"] == null
            ? null
            : DataCodeActivacion.fromJson(json["data"]),
        msm: json["msm"],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "data": data?.toJson(),
        "msm": msm,
      };
}
