import 'dart:convert';

class DataConfigRecalificar {
  int? toleCaliClie;
  int? recaTarjRangInic;
  int? recaTarjRang;
  int? recaSobrCtrlMarcClie;
  int? recaTarjTodoCtrl;
  int? recaTarjUsaPosi;

  DataConfigRecalificar({
    this.toleCaliClie,
    this.recaTarjRangInic,
    this.recaTarjRang,
    this.recaSobrCtrlMarcClie,
    this.recaTarjTodoCtrl,
    this.recaTarjUsaPosi,
  });

  factory DataConfigRecalificar.fromRawJson(String str) =>
      DataConfigRecalificar.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataConfigRecalificar.fromJson(Map<String, dynamic> json) =>
      DataConfigRecalificar(
        toleCaliClie: json["ToleCaliClie"],
        recaTarjRangInic: json["RecaTarjRangInic"],
        recaTarjRang: json["RecaTarjRang"],
        recaSobrCtrlMarcClie: json["RecaSobrCtrlMarcClie"],
        recaTarjTodoCtrl: json["RecaTarjTodoCtrl"],
        recaTarjUsaPosi: json["RecaTarjUsaPosi"],
      );

  Map<String, dynamic> toJson() => {
        "ToleCaliClie": toleCaliClie,
        "RecaTarjRangInic": recaTarjRangInic,
        "RecaTarjRang": recaTarjRang,
        "RecaSobrCtrlMarcClie": recaSobrCtrlMarcClie,
        "RecaTarjTodoCtrl": recaTarjTodoCtrl,
        "RecaTarjUsaPosi": recaTarjUsaPosi,
      };
}
