import 'dart:convert';

class DatoProduccion {
  int? fieldCount;
  int? affectedRows;
  int? insertId;
  String? info;
  int? serverStatus;
  int? warningStatus;
  int? changedRows;

  DatoProduccion({
    this.fieldCount,
    this.affectedRows,
    this.insertId,
    this.info,
    this.serverStatus,
    this.warningStatus,
    this.changedRows,
  });

  factory DatoProduccion.fromRawJson(String str) =>
      DatoProduccion.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DatoProduccion.fromJson(Map<String, dynamic> json) => DatoProduccion(
        fieldCount: json["fieldCount"],
        affectedRows: json["affectedRows"],
        insertId: json["insertId"],
        info: json["info"],
        serverStatus: json["serverStatus"],
        warningStatus: json["warningStatus"],
        changedRows: json["changedRows"],
      );

  Map<String, dynamic> toJson() => {
        "fieldCount": fieldCount,
        "affectedRows": affectedRows,
        "insertId": insertId,
        "info": info,
        "serverStatus": serverStatus,
        "warningStatus": warningStatus,
        "changedRows": changedRows,
      };
}
