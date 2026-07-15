import 'dart:convert';

class GenerarDespachoPropietario {
  int? statusCode;
  int? salidaId;
  String? msm;

  GenerarDespachoPropietario({
    this.statusCode,
    this.salidaId,
    this.msm,
  });

  factory GenerarDespachoPropietario.fromRawJson(String str) =>
      GenerarDespachoPropietario.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GenerarDespachoPropietario.fromJson(Map<String, dynamic> json) =>
      GenerarDespachoPropietario(
        statusCode: json["status_code"],
        salidaId: json["salida_id"],
        msm: json["msm"],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "salida_id": salidaId,
        "msm": msm,
      };
}
