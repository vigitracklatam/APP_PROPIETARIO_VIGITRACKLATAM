import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../models/code_activacion/code_activacion.dart';
import '../models/login/login_propietario.dart';
import '../utils/url.dart';
import 'security_data.dart';

class RepoLoginPropietario {
  static SecurityData oS = new SecurityData();

  static Future<LoginPropietario> readLoginPropietario(
    String email,
    password,
    imei,
    name_device,
    ip,
    String packageName,
    String plataforma,
  ) async {
    int statusCode = 400;
    try {
      String url_ = "${dotenv.env['baseUrl']}/loginPropietario";
      CodeActivacion oC = await oS.readDataPreferenciasEmpresa();
      String? tokenFCM;
      try {
        tokenFCM = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        print(e);
      }
      var body_ = {
        "codigo_empresa": oC.data!.codigo,
        "user": email,
        "pass": password,
        "imei": imei,
        "name_device": name_device,
        "ip": ip,
        "app_id": packageName,
        "device_platform": plataforma,
        "fcm_token": tokenFCM ?? "",
      };

      print(body_.toString());

      Response response = await http.post(
        Uri.parse(url_),
        body: json.encode(body_),
        headers: header_,
        encoding: enconding_,
      );

      //print(response.body);

      LoginPropietario oL = LoginPropietario.fromRawJson(response.body);

      statusCode = oL.statusCode!;

      if (oL.statusCode == 200) {
        String? codiObse = oL.data![0].codiObse;
        print('codiObse del primer elemento: $codiObse');
        await oS.insertPermisosObservador(oL.permisos!.toRawJson());
        await oS.inertDataPreferenciasLoginPropietario(
          email,
          password,
          oL.toRawJson(),
          codiObse!,
        );
      }

      return oL;
    } catch (e) {
      return LoginPropietario(statusCode: statusCode, sms: e.toString());
    }
  }
}
