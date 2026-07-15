class cDeviceInfoModel {
  String _imei;
  String _modelo;

  cDeviceInfoModel({required String imei, required String modelo})
    : _imei = imei,
      _modelo = modelo;

  // Getter para imei
  String get getImei => _imei;

  // Setter para imei
  set setImei(String value) {
    _imei = value;
  }

  // Getter para modelo
  String get getModelo => _modelo;

  set setModelo(String value) {
    _modelo = value;
  }
}
