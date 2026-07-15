import 'dart:convert';

class DatoConteo {
  double? error;
  int? subida1;
  int? subida2;
  int? subida3;
  int? bajada1;
  int? bajada2;
  int? bajada3;
  String? descRutaSaliM;
  int? salidaMId;
  int? numeVuelSaliM;
  int? estaSaliM;
  String? unidad;
  int? totalSubidas;
  int? totalBajadas;
  double? valorPonderada;
  String? nombrePonderada;
  int? odometro;
  String? dinero;
  int? ipk;

  DatoConteo({
    this.error,
    this.subida1,
    this.subida2,
    this.subida3,
    this.bajada1,
    this.bajada2,
    this.bajada3,
    this.descRutaSaliM,
    this.salidaMId,
    this.numeVuelSaliM,
    this.estaSaliM,
    this.unidad,
    this.totalSubidas,
    this.totalBajadas,
    this.valorPonderada,
    this.nombrePonderada,
    this.odometro,
    this.dinero,
    this.ipk,
  });

  factory DatoConteo.fromRawJson(String str) =>
      DatoConteo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DatoConteo.fromJson(Map<String, dynamic> json) => DatoConteo(
        error: json["error"]?.toDouble(),
        subida1: json["subida1"],
        subida2: json["subida2"],
        subida3: json["subida3"],
        bajada1: json["bajada1"],
        bajada2: json["bajada2"],
        bajada3: json["bajada3"],
        descRutaSaliM: json["DescRutaSali_m"],
        salidaMId: json["salida_m_id"],
        numeVuelSaliM: json["NumeVuelSali_m"],
        estaSaliM: json["EstaSali_m"],
        unidad: json["unidad"],
        totalSubidas: json["totalSubidas"],
        totalBajadas: json["totalBajadas"],
        valorPonderada: json["valorPonderada"]?.toDouble(),
        nombrePonderada: json["nombrePonderada"],
        odometro: json["Odometro"],
        dinero: json["dinero"],
        ipk: json["ipk"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "subida1": subida1,
        "subida2": subida2,
        "subida3": subida3,
        "bajada1": bajada1,
        "bajada2": bajada2,
        "bajada3": bajada3,
        "DescRutaSali_m": descRutaSaliM,
        "salida_m_id": salidaMId,
        "NumeVuelSali_m": numeVuelSaliM,
        "EstaSali_m": estaSaliM,
        "unidad": unidad,
        "totalSubidas": totalSubidas,
        "totalBajadas": totalBajadas,
        "valorPonderada": valorPonderada,
        "nombrePonderada": nombrePonderada,
        "Odometro": odometro,
        "dinero": dinero,
        "ipk": ipk,
      };
}
