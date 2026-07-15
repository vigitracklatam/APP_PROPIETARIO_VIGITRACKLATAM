import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/code_activacion/code_activacion.dart';
import '../models/login/permisos_propietario_model.dart';
import '../utils/textos.dart';

class SecurityData {
  AndroidOptions _getAndroidOptions() =>
      const AndroidOptions(encryptedSharedPreferences: true);
  FlutterSecureStorage? storage;

  SecurityData() {
    storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
  }

  Future<bool> insertPermisosObservador(String? permisos) async {
    try {
      await storage!.write(key: 'permisObservador', value: permisos);
    } catch (e) {
      print(e.toString());
      return false;
    }

    return true;
  }

  Future<cPermisosPropietario?> readPermisosObservador() async {
    try {
      String? data = await storage!.read(key: 'permisObservador');
      return cPermisosPropietario.fromRawJson(data!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> inertDataPreferenciasEmpresa(String datos) async {
    try {
      await storage!.write(key: 'dataActivacion', value: datos);
    } catch (e) {
      return false;
    }

    return true;
  }

  Future<CodeActivacion> readDataPreferenciasEmpresa() async {
    try {
      String? data = await storage!.read(key: 'dataActivacion');
      return CodeActivacion.fromRawJson(data!);
    } catch (e) {
      return CodeActivacion(statusCode: 400, msm: e.toString());
    }
  }

  Future<bool> inertDataPreferenciasLoginPropietario(
    String usuario,
    String password,
    String unidades,
    String propietario,
  ) async {
    try {
      await storage!.write(
        key: 'dataLoginPropietarioLoginUsuario',
        value: usuario,
      );
      await storage!.write(
        key: 'dataLoginPropietarioLoginPassword',
        value: password,
      );
      await storage!.write(
        key: 'dataLoginPropietarioLoginUnidadesd',
        value: unidades,
      );
      await storage!.write(
        key: 'dataLoginPropietarioLoginPropietario',
        value: propietario,
      );
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<String> readDataPreferenciasLoginPropietario(String key_) async {
    try {
      String? data = await storage!.read(key: key_);
      return (data == null ? "" : data);
    } catch (e) {
      return "";
    }
  }

  Future<bool> deleteDataPreferenciasLoginPropietario() async {
    try {
      await storage!.delete(key: 'dataLoginPropietarioLoginUsuario');
      await storage!.delete(key: 'dataLoginPropietarioLoginPassword');
      await storage!.delete(key: 'dataLoginPropietarioLoginUnidadesd');
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  Future<bool> deleteDataPreferenciasCodeActivacion() async {
    try {
      await storage!.delete(key: 'dataActivacion');
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<String?> readDeviceUUIDUniqueSecureStore() {
    return storage!.read(key: device_uuid);
  }

  Future<bool> insertDeviceUUIDUniqueSecureStore(uuid) async {
    try {
      await storage!.write(key: device_uuid, value: uuid);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
