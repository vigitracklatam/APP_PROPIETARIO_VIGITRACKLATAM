import 'dart:convert';

class DatoLoginPropietario {
  DatoLoginPropietario({
    this.codiObse,
    this.codiVehiObseVehi,
  });

  String? codiObse;
  String? codiVehiObseVehi;

  factory DatoLoginPropietario.fromRawJson(String str) =>
      DatoLoginPropietario.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DatoLoginPropietario.fromJson(Map<String, dynamic> json) =>
      DatoLoginPropietario(
        codiObse: json["CodiObse"],
        codiVehiObseVehi: json["CodiVehiObseVehi"],
      );

  Map<String, dynamic> toJson() => {
        "CodiObse": codiObse,
        "CodiVehiObseVehi": codiVehiObseVehi,
      };
}
