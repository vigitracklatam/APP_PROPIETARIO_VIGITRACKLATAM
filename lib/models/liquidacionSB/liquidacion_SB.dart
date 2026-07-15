import 'dart:convert';

import 'data_liquidacion_SB.dart';

GetLiquidacionAppPropietario getLiquidacionAppPropietarioFromJson(String str) => GetLiquidacionAppPropietario.fromJson(json.decode(str));
String getLiquidacionAppPropietarioToJson(GetLiquidacionAppPropietario data) => json.encode(data.toJson());

class GetLiquidacionAppPropietario {
    int? statusCode;
    List<DatoLiquidacionSB>? datos;
    String? msm;

    GetLiquidacionAppPropietario({
        this.statusCode,
        this.datos,
        this.msm,
    });

    factory GetLiquidacionAppPropietario.fromJson(Map<String, dynamic> json) => GetLiquidacionAppPropietario(
        statusCode: json["status_code"],
        datos: json["datos"] == null ? [] : List<DatoLiquidacionSB>.from(json["datos"]!.map((x) => DatoLiquidacionSB.fromJson(x))),
        msm: json["msm"],
    );

    Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "datos": datos == null ? [] : List<dynamic>.from(datos!.map((x) => x.toJson())),
        "msm": msm,
    };
}
