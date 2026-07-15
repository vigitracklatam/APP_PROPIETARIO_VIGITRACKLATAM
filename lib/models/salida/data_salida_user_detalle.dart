import 'dart:convert';

class DatoSalidaUserDetalle {
  DatoSalidaUserDetalle({
    this.idSaliMSaliD,
    this.codiCtrlSaliD,
    this.descCtrlSaliD,
    this.isCtrlRefeSaliD,
    this.horaProgSaliD,
    this.horaMarcSaliD,
    this.faltSaliD,
    this.penaCtrlSaliD,
  });

  int? idSaliMSaliD;
  String? codiCtrlSaliD;
  String? descCtrlSaliD;
  int? isCtrlRefeSaliD;
  String? horaProgSaliD;
  String? horaMarcSaliD;
  int? faltSaliD;
  String? penaCtrlSaliD;

  factory DatoSalidaUserDetalle.fromRawJson(String str) =>
      DatoSalidaUserDetalle.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DatoSalidaUserDetalle.fromJson(Map<String, dynamic> json) =>
      DatoSalidaUserDetalle(
        idSaliMSaliD: json["idSali_mSali_d"],
        codiCtrlSaliD: json["CodiCtrlSali_d"],
        descCtrlSaliD: json["DescCtrlSali_d"],
        isCtrlRefeSaliD: json["isCtrlRefeSali_d"],
        horaProgSaliD: json["HoraProgSali_d"],
        horaMarcSaliD: json["HoraMarcSali_d"],
        faltSaliD: json["FaltSali_d"],
        penaCtrlSaliD: json["PenaCtrlSali_d"],
      );

  Map<String, dynamic> toJson() => {
        "idSali_mSali_d": idSaliMSaliD,
        "CodiCtrlSali_d": codiCtrlSaliD,
        "DescCtrlSali_d": descCtrlSaliD,
        "isCtrlRefeSali_d": isCtrlRefeSaliD,
        "HoraProgSali_d": horaProgSaliD,
        "HoraMarcSali_d": horaMarcSaliD,
        "FaltSali_d": faltSaliD,
        "PenaCtrlSali_d": penaCtrlSaliD,
      };
}
