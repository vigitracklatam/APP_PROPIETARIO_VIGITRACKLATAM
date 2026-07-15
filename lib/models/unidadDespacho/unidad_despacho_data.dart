import 'dart:convert';

class DatoUnidadesDespacho {
  String? codiObseObseVehi;
  String? codiVehi;
  String? codiVehiObseVehi;
  String? placVehi;
  String? codiDispVehi;
  int? idTipoDispVehi;
  int? puerChnClie;

  DatoUnidadesDespacho({
    this.codiObseObseVehi,
    this.codiVehi,
    this.codiVehiObseVehi,
    this.placVehi,
    this.codiDispVehi,
    this.idTipoDispVehi,
    this.puerChnClie,
  });

  factory DatoUnidadesDespacho.fromRawJson(String str) =>
      DatoUnidadesDespacho.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DatoUnidadesDespacho.fromJson(Map<String, dynamic> json) =>
      DatoUnidadesDespacho(
        codiObseObseVehi: json["CodiObseObseVehi"]!,
        codiVehi: json["CodiVehi"],
        codiVehiObseVehi: json["CodiVehiObseVehi"],
        placVehi: json["PlacVehi"],
        codiDispVehi: json["CodiDispVehi"],
        idTipoDispVehi: json["idTipoDispVehi"],
        puerChnClie: json["PuerCHNClie"],
      );

  Map<String, dynamic> toJson() => {
        "CodiObseObseVehi": codiObseObseVehi,
        "CodiVehi": codiVehi,
        "CodiVehiObseVehi": codiVehiObseVehi,
        "PlacVehi": placVehi,
        "CodiDispVehi": codiDispVehi,
        "idTipoDispVehi": idTipoDispVehi,
        "PuerCHNClie": puerChnClie,
      };
}
