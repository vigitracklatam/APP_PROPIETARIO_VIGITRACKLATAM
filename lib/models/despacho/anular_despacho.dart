import 'dart:convert';

class AnularDespachoPropietario {
  int? statusCode;
  String? msm;

  AnularDespachoPropietario({
    this.statusCode,
    this.msm,
  });

  factory AnularDespachoPropietario.fromRawJson(String str) =>
      AnularDespachoPropietario.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AnularDespachoPropietario.fromJson(Map<String, dynamic> json) =>
      AnularDespachoPropietario(
        statusCode: json["status_code"],
        msm: json["msm"],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "msm": msm,
      };
}
