import 'dart:convert';

import '../liquidacion _m/data_liquidacionUpdateM.dart';
import '../liquidacion _m/data_liquidacionUpdateM2.dart';

class LiquidacionDUpdateAppMovil {
  int? statusCode;
  List<PurpleDato>? listaEstado;
  FluffyDato? resultado;
  String? msm;

  LiquidacionDUpdateAppMovil({
    this.statusCode,
    this.listaEstado,
    this.resultado,
    this.msm,
  });

  /// ✅ Para decodificar desde un String JSON
  factory LiquidacionDUpdateAppMovil.fromRawJson(String str) =>
      LiquidacionDUpdateAppMovil.fromJson(json.decode(str));

  /// ✅ Para codificar a un String JSON
  String toRawJson() => json.encode(toJson());

  /// ✅ Para decodificar desde un Map
  factory LiquidacionDUpdateAppMovil.fromJson(Map<String, dynamic> json) {
    final datos = json["datos"];
    List<PurpleDato>? estadoList;
    FluffyDato? resultado;

    if (datos != null && datos.length == 2) {
      final estadoRaw = datos[0] as List<dynamic>;
      estadoList = estadoRaw.map((e) => PurpleDato.fromJson(e)).toList();

      resultado = FluffyDato.fromJson(datos[1]);
    }

    return LiquidacionDUpdateAppMovil(
      statusCode: json["status_code"],
      listaEstado: estadoList,
      resultado: resultado,
      msm: json["msm"],
    );
  }

  /// ✅ Para codificar a un Map
  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "datos": [
      listaEstado?.map((e) => e.toJson()).toList(),
      resultado?.toJson(),
    ],
    "msm": msm,
  };
}
