import 'dart:convert';

class FluffyDato {
  int? fieldCount;
  int? affectedRows;
  int? insertId;
  String? info;
  int? serverStatus;
  int? warningStatus;

  FluffyDato({
    this.fieldCount,
    this.affectedRows,
    this.insertId,
    this.info,
    this.serverStatus,
    this.warningStatus,
  });

  factory FluffyDato.fromRawJson(String str) =>
      FluffyDato.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FluffyDato.fromJson(Map<String, dynamic> json) => FluffyDato(
    fieldCount: json["fieldCount"],
    affectedRows: json["affectedRows"],
    insertId: json["insertId"],
    info: json["info"],
    serverStatus: json["serverStatus"],
    warningStatus: json["warningStatus"],
  );

  Map<String, dynamic> toJson() => {
    "fieldCount": fieldCount,
    "affectedRows": affectedRows,
    "insertId": insertId,
    "info": info,
    "serverStatus": serverStatus,
    "warningStatus": warningStatus,
  };
}
