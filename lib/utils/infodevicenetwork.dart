// ignore_for_file: prefer_if_null_operators
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:uuid/uuid.dart';

import '../models/cDeviceInfoModel.dart';
import '../repositories/security_data.dart';

dynamic headersApi = {
  'Content-Type': 'application/json; charset=UTF-8',
  'Accept': 'application/json',
};

// Instancia del almacenamiento seguro
final _secureStorage = FlutterSecureStorage();

class InfoDeviceNetWork {
  static Future<String?> getIpAddress() async {
    String? result;

    try {
      // 🔹 1️⃣ Primero intentamos obtener la IP pública desde la API
      http.Response oR = await http.get(
        Uri.parse(dotenv.env['BASE_URL_GET_IP']!),
        headers: headersApi,
      );

      if (oR.statusCode == 200) {
        final body = jsonDecode(oR.body);
        result = body['ip'];

        if (result != null && result.trim().isNotEmpty) {
          print("IP Pública API: $result");
          return result;
        }
      }

      // 🔹 2️⃣ Si falla la API o viene vacía, usamos NetworkInfo
      NetworkInfo oNetworkInfo = NetworkInfo();

      result = await oNetworkInfo.getWifiIP();

      if (result == null || result.trim().isEmpty) {
        result = await oNetworkInfo.getWifiIPv6();
      }

      print("IP Local NetworkInfo: $result");
    } catch (e) {
      print("Error obteniendo IP: ${e.toString()}");
    }

    return result;
  }

  /*
  static Future<String> getIpAddress() async {
    String? result;

    try {
      NetworkInfo oNetworkInfo = NetworkInfo();
      result =
          await oNetworkInfo.getWifiIP() == null
              ? await oNetworkInfo.getWifiIPv6()
              : await oNetworkInfo.getWifiIP();

      if (result == null || result!.trim().isEmpty) {
        http.Response oR = await http.get(
          Uri.parse(dotenv.env['BASE_URL_GET_IP']!),
          headers: headersApi,
        );
        result = oR.statusCode != 200 ? null : jsonDecode(oR.body)['ip'];
        print(jsonDecode(oR.body)['ip']);
      }
    } catch (e) {
      print(e.toString());
    }

    return result ?? "NO_IP";
  }
*/
  static Future<String?> getUUIDDevice() async {
    try {
      // Primero intentamos obtener el UUID desde el almacenamiento seguro
      String? storedUUID =
          await SecurityData().readDeviceUUIDUniqueSecureStore();

      // Si no existe, significa que es la primera vez que se inicia la app
      if (storedUUID == null) {
        // Generamos un nuevo UUID
        String newUUID = Uuid().v4();

        // Guardamos el UUID generado en el almacenamiento seguro
        await SecurityData().insertDeviceUUIDUniqueSecureStore(newUUID);

        return newUUID; // Devolvemos el nuevo UUID
      }

      // Si ya existe un UUID, lo devolvemos
      return storedUUID;
    } catch (e) {
      print(e);
    }
    return null;

    /*try {
      return await DeviceInformation.deviceIMEINumber;
    } catch (e) {
      return null;
    }*/
  }

  Future<cDeviceInfoModel> getImeiInfoDevice() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    try {
      var serial = await UniqueIdentifier.serial;

      if (serial == null) {
        serial = await getUUIDDevice();
      }

      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;

        return cDeviceInfoModel(
          imei: serial ?? 'Desconocido',
          modelo: (androidInfo.name + " " + androidInfo.model) ?? 'Desconocido',
        );
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        return cDeviceInfoModel(
          imei: serial ?? 'Desconocido',
          modelo:
              (iosInfo.name +
                  " " +
                  iosInfo.model +
                  " " +
                  iosInfo.utsname.machine) ??
              'Desconocido',
        );
      } else {
        return cDeviceInfoModel(imei: 'Desconocido', modelo: 'Desconocido');
      }
    } catch (e) {
      print("⚠️ Error al obtener la información del dispositivo: $e");
      return cDeviceInfoModel(imei: 'Desconocido', modelo: 'Desconocido');
    }

    /*try {
      // Primero intentamos obtener el UUID desde el almacenamiento seguro
      String? storedUUID =
          await cSecureStore().readDeviceUUIDUniqueSecureStore();

      // Si no existe, significa que es la primera vez que se inicia la app
      if (storedUUID == null) {
        // Generamos un nuevo UUID
        String newUUID = Uuid().v4();

        // Guardamos el UUID generado en el almacenamiento seguro
        await cSecureStore().insertDeviceUUIDUniqueSecureStore(newUUID);

        return newUUID; // Devolvemos el nuevo UUID
      }

      // Si ya existe un UUID, lo devolvemos
      return storedUUID;
    } catch (e) {
      print(e);
    }
    return null;*/

    /*try {
      return await DeviceInformation.deviceIMEINumber;
    } catch (e) {
      return null;
    }*/
  }

    Future<String> getPackageName() async {
    final info = await PackageInfo.fromPlatform();
    return info.packageName;
  }

}
