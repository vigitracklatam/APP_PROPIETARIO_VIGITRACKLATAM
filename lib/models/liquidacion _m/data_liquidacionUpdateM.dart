import 'dart:convert';

class PurpleDato {
  int? estado;

  PurpleDato({this.estado});

  factory PurpleDato.fromRawJson(String str) =>
      PurpleDato.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurpleDato.fromJson(Map<String, dynamic> json) =>
      PurpleDato(estado: json["estado"]);

  Map<String, dynamic> toJson() => {"estado": estado};
}
