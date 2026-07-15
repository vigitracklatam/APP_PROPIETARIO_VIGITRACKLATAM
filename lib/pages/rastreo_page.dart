import 'dart:convert';
import 'dart:io';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:label_marker/label_marker.dart';
import '../models/login/login_propietario.dart';
import '../models/recorrido/recorrido.dart';
import '../models/velocidad_maxima/velocidad_max.dart';
import '../repositories/repo_recorrido.dart';
import '../repositories/repo_velocidad_max.dart';
import '../repositories/security_data.dart';

class RastreoPage extends StatefulWidget {
  @override
  State<RastreoPage> createState() => _RastreoPageState();
}

class _RastreoPageState extends State<RastreoPage> {
  var datos;
  Set<Circle> _circles = Set();
  BuildContext? _buildContextAlert;
  String _date = "yyyy-mm-dd";
  TextEditingController _inputFieldDateController = new TextEditingController();
  TextEditingController _inputFieldVeloController = new TextEditingController();
  TextEditingController _inputFieldTimeStartController =
      new TextEditingController();
  TextEditingController _inputFieldTimeEndController =
      new TextEditingController();
  List<DropdownMenuItem<String>> lista_unidades = [];
  String _unidad = "";
  int position = 0;
  int suma = 0;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.43296265331129, -122.08832357078792),
    zoom: 14.4746,
  );

  final Set<Marker> _markers = Set();
  bool banderaCenter = true;

  static final CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(-1.24167, -78.6197),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  GoogleMapController? mapController;

  @override
  void initState() {
    // TODO: implement initState
    _getVeloMaxima();
    super.initState();
    _getFechaActual();
    _ItemDropdownButton();
    setState(() {
      _inputFieldTimeEndController.text = "23:59";
      _inputFieldTimeStartController.text = "05:00";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _kGooglePlex,
          mapType: MapType.normal,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          markers: _markers,
          circles: _circles,
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
          },
        ),
        Container(
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(5),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 7),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 130,
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 1),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: DropdownButton<String>(
                      underline: Container(
                        height: 0,
                        color: Colors.transparent,
                      ),
                      value:
                          lista_unidades.isNotEmpty
                              ? lista_unidades[getPosition(_unidad)].value
                              : _unidad,
                      items: lista_unidades,
                      onChanged: (String? value) {
                        setState(() {
                          _unidad = value!;
                          //widget.position = getPosition(widget._unidad);
                        });
                      },
                    ),
                  ),
                  Flexible(
                    child: TextField(
                      controller: _inputFieldDateController,
                      style: TextStyle(height: 0.2),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        icon: Icon(Icons.calendar_today_outlined),
                        hintText: _date,
                      ),
                      onTap: () {
                        /**Quitar Foco**/
                        FocusScope.of(context).requestFocus(new FocusNode());
                        _selectDate(context);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 7),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: TextField(
                      controller: _inputFieldTimeStartController,
                      style: TextStyle(height: 0.5),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "HH:mm",
                        icon: Icon(Icons.timer),
                      ),
                      onTap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        _showTimePicker(
                          context,
                          _inputFieldTimeStartController,
                        );
                      },
                    ),
                  ),
                  Flexible(
                    child: TextField(
                      controller: _inputFieldTimeEndController,
                      onTap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        _showTimePicker(context, _inputFieldTimeEndController);
                      },
                      style: TextStyle(height: 0.5),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "HH:mm",
                        icon: Icon(Icons.timer),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        _inputFieldVeloController.text + " km/h",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 7),
              OutlinedButton.icon(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                    Size(double.infinity, 40),
                  ),
                ),
                icon: Icon(Icons.format_paint, color: Colors.blue),
                onPressed: () async {
                  _showAlertProgres(context);
                  print("Aca UNIDAD >>>>>>>>>>>>>>>>>>>>>${_unidad}");
                  print(
                    "Aca fechaI>>>>>>>>>>>>>>>>>>>>>${_date + " " + _inputFieldTimeStartController.text + ":00"}",
                  );
                  print(
                    "Aca fechaF>>>>>>>>>>>>>>>>>>>>>${_date + " " + _inputFieldTimeEndController.text + ":00"}",
                  );
                  RecorridoAppMovil oRa = await ApiRecorrido().readRecorrido(
                    _unidad,
                    _date + " " + _inputFieldTimeStartController.text + ":00",
                    _date + " " + _inputFieldTimeEndController.text + ":00",
                  );
                  datos = oRa;
                  print("Aca datos >>>>>>>>>>>>>>>>>>>>>${jsonEncode(datos)}");
                  Navigator.of(_buildContextAlert!).pop(true);
                  if (datos.statusCode == 300) {
                    _showToas("¡ " + datos.msm);
                  } else if (datos.statusCode == 400) {
                    _showToas("¡ " + datos.msm);
                  }
                  setState(() {
                    _showAlerDialog();
                  });
                  setState(() {
                    _addMarker(datos.datos);
                  });
                  _showAlerDialog();
                  _getVeloMaxima();
                },
                label: const Text(
                  "Dibujar",
                  style: TextStyle(
                    color: Colors.black, // Establece el color del texto a negro
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  int getPosition(unidad) {
    for (int i = 0; i < lista_unidades.length; i++) {
      print("POSITION UNIDAD : " + lista_unidades[i].value!);
      if (lista_unidades[i].value == unidad) {
        return i;
      }
    }
    return 0;
  }

  _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(2020),
      lastDate: new DateTime(2050),
      locale: Locale('es', ''),
    );

    if (picked != null) {
      setState(() {
        _date =
            (picked.year.toString() +
                "/" +
                picked.month.toString() +
                "/" +
                picked.day.toString());
        _inputFieldDateController.text = _date;
      });
    }
  }

  _showTimePicker(context, controller) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 5, minute: 0),
      initialEntryMode: TimePickerEntryMode.inputOnly,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (TimeOfDay != null) {
      setState(() {
        var hora =
            newTime!.hour < 10 ? "0" + newTime.hour.toString() : newTime.hour;
        var minut =
            newTime.minute < 10
                ? "0" + newTime.minute.toString()
                : newTime.minute;
        controller.text = (hora.toString() + ":" + minut.toString());
      });
    }
  }

  _showAlertProgres(context_) {
    showDialog(
      context: context_,
      barrierDismissible: false,
      builder: (context) {
        _buildContextAlert = context;
        return AlertDialog(
          title: Text("Consultando Recorrido"),
          content: LinearProgressIndicator(color: Colors.blue),
        );
      },
    );
  }

  void _showToas(msm) {
    Fluttertoast.showToast(
      msg: msm,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red.shade400,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  _ItemDropdownButton() async {
    SecurityData oS = new SecurityData();
    var jsonDataL = await oS.readDataPreferenciasLoginPropietario(
      'dataLoginPropietarioLoginUnidadesd',
    );
    LoginPropietario listabuses = LoginPropietario.fromRawJson(jsonDataL);

    setState(() {
      listabuses.data!.forEach((element) {
        _unidad = listabuses.data!.elementAt(0).codiVehiObseVehi!;
        lista_unidades.add(
          DropdownMenuItem<String>(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset('assets/online_lista.png', width: 19),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(' ${element.codiVehiObseVehi}'),
                ),
              ],
            ),
            value: element.codiVehiObseVehi,
          ),
        );
      });
    });
  }

  _showAlerDialog() {
    if (datos.datos.length == 0) {
      showAlertDialogDatos(
        ArtSweetAlertType.warning,
        "Recorrido",
        "No existen datos disponibles.",
      );
    }
  }

  showAlertDialogDatos(ArtSweetAlertType type, String title, String text) {
    ArtSweetAlert.show(
      context: context,
      artDialogArgs: ArtDialogArgs(
        type: type,
        title: title,
        confirmButtonColor: Colors.blue,
        text: text,
      ),
    );
  }

  void _addMarker(mList) async {
    _circles.clear();
    _markers.clear();
    int contPosSiguiente = 1;
    for (var oR in mList) {
      if (contPosSiguiente < datos.datos.length) {
        print("Aca datos del marker logitud ${datos.datos.length}");
        if (oR.veloHistEven == 0 &&
            datos.datos[contPosSiguiente].veloHistEven == 0) {
          final timeParado1 = oR.fechHistEven;
          final timeParado2 = datos.datos![contPosSiguiente].fechHistEven;
          final difference = timeParado2.difference(timeParado1);
          suma = suma + int.parse(difference.inSeconds.toString());
          if (suma >= 60) {
            int minutes = (suma / 60).toInt();
            int seconds = (suma % 60);
            String timeToShow =
                minutes.toString().padLeft(2, "0") +
                "." +
                seconds.toString().padLeft(2, "0");
            print(timeToShow);
            _markers.addLabelMarker(
              LabelMarker(
                label: timeToShow + " mins",
                markerId: MarkerId(
                  'Label ' + datos.datos[contPosSiguiente].idHistEve.toString(),
                ),
                position: LatLng(
                  double.parse(datos.datos[contPosSiguiente].latiHistEven),
                  double.parse(datos.datos[contPosSiguiente].longHistEven),
                ),
                textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
                backgroundColor: Colors.red,
              ),
            );

            _circles.add(
              Circle(
                circleId: CircleId(
                  datos.datos[contPosSiguiente].idHistEve.toString(),
                ),
                center: LatLng(
                  double.parse(datos.datos[contPosSiguiente].latiHistEven),
                  double.parse(datos.datos[contPosSiguiente].longHistEven),
                ),
                radius: 25,
                fillColor: Colors.red.withOpacity(0.4),
                strokeColor: Colors.red,
                strokeWidth: 3,
              ),
            );
          }
        } else {
          suma = 0;
        }
      }
      /*  print("********************** SUMA ******************");
      print(suma); */
      var assets = _getIdMarker(oR.evenExceVeloHistEven);
      var imgenconfig = ImageConfiguration();
      var info = InfoWindow(
        title: "Unidad : " + _unidad,
        snippet:
            "Velocidad : " +
            oR.veloHistEven.toString() +
            'km/h' +
            " Fecha : " +
            oR.fechHistEven.toString().substring(0, 19),
      );

      mapController!.moveCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(
            double.parse(datos.datos[0].latiHistEven),
            double.parse(datos.datos[0].longHistEven),
          ),
          17,
        ),
      );

      this._markers.add(
        Marker(
          markerId: MarkerId(oR.latiHistEven.toString()),
          rotation: double.parse(oR.rumbHistEven.toString()),
          infoWindow: info,
          position: LatLng(
            double.parse(oR.latiHistEven),
            double.parse(oR.longHistEven),
          ),
          icon: await BitmapDescriptor.fromAssetImage(imgenconfig, assets),
        ),
      );

      contPosSiguiente = contPosSiguiente + 1;
    }
  }

  _getIdMarker(bandera) {
    if (Platform.isAndroid) {
      if (bandera == 1) {
        return 'assets/recorrido_f_ruta_c.png';
      }
      return 'assets/recorrido_trazado_c.png';
    } else if (Platform.isIOS) {
      {
        if (bandera == 1) {
          return 'assets/recorrido_f_ruta.png';
        }
        return 'assets/recorrido_trazado.png';
      }
    }
  }

  _getVeloMaxima() async {
    VelMaxAppMovil oVm = await ApiVelMax().readVelMax();
    var velo = oVm;
    setState(() {
      _inputFieldVeloController.text = velo.datos.toString();
    });
  }

  _getFechaActual() {
    var date = DateTime.now();
    var year = date.year;
    var month = date.month < 10 ? "0" + date.month.toString() : date.month;
    var day = date.day < 10 ? "0" + date.day.toString() : date.day;
    setState(() {
      _date = year.toString() + "/" + month.toString() + "/" + day.toString();
      _inputFieldDateController.text = _date;
    });
  }
}
