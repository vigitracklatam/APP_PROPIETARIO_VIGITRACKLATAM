import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class DatoMonitoreo {
  String? codiVehiMoni;
  int? estaSaliMoni;
  int? ctrlCounMoni;
  int? idTipoDispVehi;
  String? descDispTipo;
  String? versDispMoni;
  int? alarCortAlimBateExteMoni;
  int? idSaliMMoni;
  int? sateContMoni;
  int? ultiVeloMoni;
  String? ultiFechMoni;
  int? singpsday;
  String? timeSingps;
  int? minutesingps;
  String? ultiFechMoniSecond;
  String? ultiLatiMoni;
  String? ultiLongMoni;
  int? ultiRumbMoni;
  String? placVehiMoni;
  String? letrRutaMoni;
  int? evenAnteGpsConeMoni;
  int? alarAnteGpsDescMoni;
  int? alarEnceChapMoni;
  int? alarFuerRutaMoni;
  String? odometro;
  String? ruta;

  BitmapDescriptor? oBitmapDescriptor;

  DatoMonitoreo({
    this.codiVehiMoni,
    this.estaSaliMoni,
    this.ctrlCounMoni,
    this.idTipoDispVehi,
    this.descDispTipo,
    this.versDispMoni,
    this.alarCortAlimBateExteMoni,
    this.idSaliMMoni,
    this.sateContMoni,
    this.ultiVeloMoni,
    this.ultiFechMoni,
    this.singpsday,
    this.timeSingps,
    this.minutesingps,
    this.ultiFechMoniSecond,
    this.ultiLatiMoni,
    this.ultiLongMoni,
    this.ultiRumbMoni,
    this.placVehiMoni,
    this.letrRutaMoni,
    this.evenAnteGpsConeMoni,
    this.alarAnteGpsDescMoni,
    this.alarEnceChapMoni,
    this.alarFuerRutaMoni,
    this.odometro,
    this.ruta,
  });

  // Getter
  BitmapDescriptor? get getoBitmapDescriptor => oBitmapDescriptor;

  // Setter
  set setoBitmapDescriptor(BitmapDescriptor? value) {
    oBitmapDescriptor = value;
  }

  factory DatoMonitoreo.fromRawJson(String str) =>
      DatoMonitoreo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DatoMonitoreo.fromJson(Map<String, dynamic> json) => DatoMonitoreo(
        codiVehiMoni: json["CodiVehiMoni"],
        estaSaliMoni: json["EstaSaliMoni"],
        ctrlCounMoni: json["CtrlCounMoni"],
        idTipoDispVehi: json["idTipoDispVehi"],
        descDispTipo: json["DescDispTipo"],
        versDispMoni: json["VersDispMoni"],
        alarCortAlimBateExteMoni: json["AlarCortAlimBateExteMoni"] ?? 0,
        idSaliMMoni: json["idSali_mMoni"] ?? 0,
        sateContMoni: json["SateContMoni"] ?? 0,
        ultiVeloMoni: json["UltiVeloMoni"] ?? 0,
        ultiFechMoni: json["UltiFechMoni"],
        singpsday: json["SINGPSDAY"] ?? 0,
        timeSingps: json["timeSINGPS"],
        minutesingps: json["MINUTESINGPS"] ?? 0,
        ultiFechMoniSecond: json["UltiFechMoniSecond"],
        ultiLatiMoni: json["UltiLatiMoni"],
        ultiLongMoni: json["UltiLongMoni"],
        ultiRumbMoni: json["UltiRumbMoni"],
        placVehiMoni: json["PlacVehiMoni"],
        letrRutaMoni: json["LetrRutaMoni"],
        evenAnteGpsConeMoni: json["EvenAnteGPSConeMoni"] ?? 0,
        alarAnteGpsDescMoni: json["AlarAnteGPSDescMoni"] ?? 0,
        alarEnceChapMoni: json["AlarEnceChapMoni"] ?? 0,
        alarFuerRutaMoni: json["AlarFuerRutaMoni"] ?? 0,
        odometro: json["Odometro"],
        ruta: json["ruta"],
      );

  Map<String, dynamic> toJson() => {
        "CodiVehiMoni": codiVehiMoni,
        "EstaSaliMoni": estaSaliMoni,
        "CtrlCounMoni": ctrlCounMoni,
        "idTipoDispVehi": idTipoDispVehi,
        "DescDispTipo": descDispTipo,
        "VersDispMoni": versDispMoni,
        "AlarCortAlimBateExteMoni": alarCortAlimBateExteMoni,
        "idSali_mMoni": idSaliMMoni,
        "SateContMoni": sateContMoni,
        "UltiVeloMoni": ultiVeloMoni,
        "UltiFechMoni": ultiFechMoni,
        "SINGPSDAY": singpsday,
        "timeSINGPS": timeSingps,
        "MINUTESINGPS": minutesingps,
        "UltiFechMoniSecond": ultiFechMoniSecond,
        "UltiLatiMoni": ultiLatiMoni,
        "UltiLongMoni": ultiLongMoni,
        "UltiRumbMoni": ultiRumbMoni,
        "PlacVehiMoni": placVehiMoni,
        "LetrRutaMoni": letrRutaMoni,
        "EvenAnteGPSConeMoni": evenAnteGpsConeMoni,
        "AlarAnteGPSDescMoni": alarAnteGpsDescMoni,
        "AlarEnceChapMoni": alarEnceChapMoni,
        "AlarFuerRutaMoni": alarFuerRutaMoni,
        "Odometro": odometro,
        "ruta": ruta,
      };
}
