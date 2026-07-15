// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, unnecessary_new, prefer_final_fields, non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:label_marker/label_marker.dart';
import 'dart:ui' as ui;
import '../models/login/login_propietario.dart';
import '../models/simulador/simulador.dart';
import '../repositories/repo_simulador.dart';
import '../repositories/security_data.dart';
import '../utils/dimens.dart';

class SimuladorPage extends StatefulWidget {
  SimuladorPage({super.key});

  var controles = [];
  BuildContext? _buildContextAlert;
  SecurityData oS = new SecurityData();

  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.43296265331129, -122.08832357078792),
    zoom: 14.4746,
  );
  Set<Circle> _circles = Set();

  int position = 0;

  @override
  State<SimuladorPage> createState() => _SimuladorState();
}

class _SimuladorState extends State<SimuladorPage> {
  Set<Circle> _circles = Set();
  final Set<Marker> _markers = Set();
  String propietario = "";
  Duration _duration = Duration(seconds: 1);
  int position = 0;
  int contador = 0;
  int contPosSiguiente = 1;
  int suma = 0;
  var controles = [];
  Timer? timer_rastreo;
  GoogleMapController? mapController;
  var datos;
  TextEditingController _inputFieldDateController = new TextEditingController();
  TextEditingController _inputFieldTimeStartController =
      new TextEditingController();
  TextEditingController _inputFieldTimeEndController =
      new TextEditingController();
  String _dateSalida = "";
  String _horaI = "";
  String _horaF = "";
  String _unidad = "";
  List<DropdownMenuItem<String>> lista_unidades = [];
  @override
  void initState() {
    _ItemDropdownButton();
    _getFechaActual();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    pausarSimulacion();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: widget._kGooglePlex,
              mapType: MapType.normal,
              markers: _markers,
              myLocationButtonEnabled: false,
              myLocationEnabled: false,
              zoomControlsEnabled: false,
              circles: widget._circles,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
            Center(
              child: Container(
                width: 130,
                margin: const EdgeInsets.only(
                  right: marginSmallSmall,
                  left: marginSmallSmall,
                  top: marginSmallSmall,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 150,
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
                    const SizedBox(width: marginSmallSmall),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showModalMenu(context);
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        child: Divider(
                          height: 20,
                          thickness: 2,
                          indent: 110,
                          endIndent: 110,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 3),
                      child: FloatingActionButton(
                        heroTag: 'controles',
                        tooltip: 'Controles',
                        backgroundColor: Colors.blue,
                        onPressed: () {
                          _viewAlerDialog(context);
                        },
                        child: const Icon(
                          Icons.copy_all_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 3),
                      child: FloatingActionButton(
                        heroTag: 'pausar',
                        tooltip: 'Pausar',
                        backgroundColor: Colors.blue,
                        onPressed: () {
                          pausarSimulacion();
                        },
                        child: const Icon(Icons.pause, color: Colors.white),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 3),
                      child: FloatingActionButton(
                        heroTag: 'Play',
                        tooltip: 'Continuar',
                        backgroundColor: Colors.blue,
                        onPressed: () {
                          _startSimulacion();
                        },
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: marginSmall),
            //_buildListaSimulador()
          ],
        ),
      ),
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

  _ItemDropdownButton() async {
    var jsonDataL = await widget.oS.readDataPreferenciasLoginPropietario(
      'dataLoginPropietarioLoginUnidadesd',
    );
    LoginPropietario listabuses = LoginPropietario.fromRawJson(jsonDataL);
    _inputFieldTimeStartController.text = _horaI;
    _inputFieldTimeEndController.text = _horaF;
    _unidad = listabuses.data!.elementAt(0).codiVehiObseVehi!;
    print('Aca unidad >>>>>>>>>>>>>>>>><<<<<${_unidad}');
    if (_inputFieldTimeStartController.text != "" &&
        _inputFieldTimeEndController.text != "") {
      _inputFieldDateController.text = _dateSalida;
      _unidad = _unidad;
      //await _initSimulador();
      // _startSimulacion();
    }

    setState(() {
      listabuses.data!.forEach((element) {
        listabuses.data!.elementAt(0).codiVehiObseVehi!;
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

  _getFechaActual() {
    var date = DateTime.now();
    var year = date.year;
    var month = date.month < 10 ? "0" + date.month.toString() : date.month;
    var day = date.day < 10 ? "0" + date.day.toString() : date.day;
    setState(() {
      _dateSalida =
          year.toString() + "/" + month.toString() + "/" + day.toString();
      _inputFieldDateController.text = _dateSalida;
    });
  }

  _showModalMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Color(0xff757575),
          height: 150,
          child: Container(
            padding: EdgeInsets.only(left: 2, bottom: 25, right: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.white70,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 150,
                            child: TextField(
                              controller: _inputFieldDateController,
                              style: TextStyle(height: 1.2),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                icon: Icon(Icons.calendar_today_outlined),
                                hintText: _dateSalida,
                              ),
                              onTap: () {
                                /**Quitar Foco**/
                                FocusScope.of(
                                  context,
                                ).requestFocus(new FocusNode());
                                _selectDate(context);
                              },
                            ),
                          ),
                          Flexible(
                            child: TextField(
                              controller: _inputFieldTimeStartController,
                              style: TextStyle(height: 1.2),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: "00:00",
                                icon: Icon(Icons.timer),
                              ),
                              onTap: () {
                                FocusScope.of(
                                  context,
                                ).requestFocus(new FocusNode());
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
                                FocusScope.of(
                                  context,
                                ).requestFocus(new FocusNode());
                                _showTimePicker(
                                  context,
                                  _inputFieldTimeEndController,
                                );
                              },
                              style: TextStyle(height: 1.2),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: "00:00",
                                icon: Icon(Icons.timer),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        icon: Icon(Icons.search, color: Colors.white),
                        onPressed: () async {
                          _markers.clear();
                          widget.controles.clear();
                          await _initSimulador();
                        },
                        label: Text(
                          "Consultar Recorrido",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
        _dateSalida =
            (picked.year.toString() +
                "/" +
                picked.month.toString() +
                "/" +
                picked.day.toString());
        _inputFieldDateController.text = _dateSalida;
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
    setState(() {
      var hora =
          newTime!.hour < 10 ? "0" + newTime.hour.toString() : newTime.hour;
      var minut =
          newTime.minute < 10
              ? "0" + newTime.minute.toString()
              : newTime.minute;
      controller.text = (hora.toString() + ":" + minut.toString() + ":00");
    });
  }

  _viewAlerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            titlePadding: EdgeInsets.all(0),
            title: Container(
              padding: EdgeInsets.all(5),
              color: Colors.blue,
              child: Text(
                'Controles',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            contentPadding: EdgeInsets.all(0),
            content: Container(
              color: Colors.orange,
              padding: EdgeInsets.all(0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: Text(
                          'Nombre Control',
                          style: TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          'Hora Marc.',
                          style: TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 800,
                    height: 200,
                    padding: EdgeInsets.only(left: 10, right: 35),
                    color: Colors.white,
                    child: ListView.builder(
                      itemCount: controles.length == 0 ? 0 : controles.length,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: EdgeInsets.only(top: 5),
                                height: 25,
                                child: Text(
                                  controles[index]['descCtrlSaliD'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              //fit: FlexFit.tight,
                              child: Container(
                                padding: EdgeInsets.only(right: 18),
                                child: Text(
                                  controles[index]['horaMarcSaliD'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Cerrar el diálogo
                  Navigator.of(context).pop();
                },
                child: Text('Cerrar'),
              ),
            ],
          ),
    );
  }

  _initSimulador() async {
    if (_inputFieldTimeStartController.text == "" ||
        _inputFieldTimeEndController.text == "") {
      _showToas(Colors.indigo.shade300, "¡ Error de horas");
    } else {
      _showAlertProgres(context);
      print("unidad rastreo >>>>>>>>>>>>>>>>>>>>" + _unidad);
      SimuladorAppMovil oSi = await ApiSimulador().readSimulador(
        _unidad,
        _dateSalida +
            ' ' +
            _inputFieldTimeStartController.text.substring(0, 5) +
            ':00',
        _dateSalida +
            ' ' +
            _inputFieldTimeEndController.text.substring(0, 5) +
            ':00',
      );
      datos = oSi;
      //print('object OSI >>>>>>>${oSi.statusCode}');
      if (datos!.statusCode == 200) {
        _startSimulacion();
        for (var i = 0; i < datos.datos.length; i++) {
          var cont = 0;
          if (datos.datos[i].horaMarcSaliD != null &&
              datos.datos[i].descCtrlSaliD != null) {
            for (var j = i; j < datos.datos.length; j++) {
              if (datos.datos[i].horaMarcSaliD ==
                  datos.datos[j].horaMarcSaliD) {
                cont = cont + 1;
              }
            }
            if (cont == 1) {
              var results = {
                "descCtrlSaliD": datos.datos[i].descCtrlSaliD,
                "horaMarcSaliD": datos.datos[i].horaMarcSaliD,
              };
              controles.add(results);
            }
          }
        }
      }
      print('object OSI Datos MODAL>>>>>>>${controles}');
      Navigator.of(widget._buildContextAlert!).pop(true);
      if (datos.statusCode == 400) {
        _showToas(Colors.indigo.shade300, "¡ " + datos.msm);
      } else if (datos.datos.length == 0) {
        _showToas(Colors.indigo.shade300, "¡ " + datos.msm);
      }
    }
  }

  _showToas(color, msm) {
    Fluttertoast.showToast(
      msg: msm,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  _showAlertProgres(context_) {
    showDialog(
      context: context_,
      barrierDismissible: false,
      builder: (context) {
        widget._buildContextAlert = context;
        return AlertDialog(
          title: Text("Obteniendo Posiciones"),
          content: LinearProgressIndicator(color: Colors.blue),
        );
      },
    );
  }

  pausarSimulacion() {
    if (timer_rastreo != null) {
      print("fin simulacion");
      timer_rastreo!.cancel();
    }
  }

  _startSimulacion() async {
    if (datos != null) {
      if (this.mounted) {
        if (timer_rastreo != null) {
          timer_rastreo!.cancel();
        }
        timer_rastreo = Timer.periodic(_duration, (timer) async {
          setState(() {
            this._addmarker();
            print('Se inicio el Simulador');
          });
        });
      }
    } else {
      _showToas(Colors.indigo.shade300, "¡ No existen datos disponibles");
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    ))!.buffer.asUint8List();
  }

  void _addmarker() async {
    if (contador < datos.datos.length) {
      if (_markers.length == 0) {
        var assets = 'assets/online_ios.png';
        Uint8List markerIcon = await getBytesFromAsset(assets, 50);
        mapController!.moveCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(
              double.parse(datos.datos[contador].latiHistEven),
              double.parse(datos.datos[contador].longHistEven),
            ),
            15,
          ),
        );
        _markers.add(
          Marker(
            markerId: MarkerId('unidad'),
            position: LatLng(
              double.parse(datos.datos[contador].latiHistEven),
              double.parse(datos.datos[contador].longHistEven),
            ),
            rotation: double.parse(
              (datos.datos[contador].rumbHistEven + 180).toString(),
            ),
            icon: BitmapDescriptor.fromBytes(markerIcon),
          ),
        );
      } else {
        if (contPosSiguiente < datos.datos.length) {
          if (datos.datos[contador].veloHistEven == 0 &&
              datos.datos[contPosSiguiente].veloHistEven == 0) {
            final timeParado1 = datos.datos[contador].fechHistEven;
            final timeParado2 = datos.datos[contPosSiguiente].fechHistEven;
            final difference = timeParado2.difference(timeParado1);
            suma = suma + int.parse(difference.inSeconds.toString());
            if (suma >= 60) {
              int minutes = (suma / 60).toInt();
              int seconds = (suma % 60);
              String timeToShow =
                  minutes.toString().padLeft(2, "0") +
                  "." +
                  seconds.toString().padLeft(2, "0");
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
              _markers.addLabelMarker(
                LabelMarker(
                  label: timeToShow + " mins",
                  markerId: MarkerId(
                    'Label ' +
                        datos.datos[contPosSiguiente].idHistEve.toString(),
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
            }
          } else {
            suma = 0;
          }
        }
        var assets = 'assets/online_ios.png';
        Uint8List markerIcon = await getBytesFromAsset(assets, 50);

        mapController!.moveCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(
              double.parse(datos.datos[contador].latiHistEven),
              double.parse(datos.datos[contador].longHistEven),
            ),
            15,
          ),
        );

        _markers.add(
          Marker(
            markerId: MarkerId('unidad'),
            position: LatLng(
              double.parse(datos.datos[contador].latiHistEven),
              double.parse(datos.datos[contador].longHistEven),
            ),
            rotation: double.parse(
              (datos.datos[contador].rumbHistEven).toString(),
            ),
            icon: BitmapDescriptor.fromBytes(markerIcon),
          ),
        );
      }

      var assets = _getIdMarkerBandera(
        datos.datos[contador].evenExceVeloHistEven,
      );
      Uint8List markerIcon = await getBytesFromAsset(assets, 50);

      _markers.add(
        new Marker(
          markerId: MarkerId(datos.datos[contador].latiHistEven),
          position: LatLng(
            double.parse(datos.datos[contador].latiHistEven),
            double.parse(datos.datos[contador].longHistEven),
          ),
          rotation: double.parse(
            (datos.datos[contador].rumbHistEven).toString(),
          ),
          icon: BitmapDescriptor.fromBytes(markerIcon),
        ),
      );

      if (datos.datos[contador].codiCtrlHistEven != null &&
          datos.datos[contador].horaMarcSaliD != null) {
        _showToas(
          Colors.green,
          "✓ " +
              datos.datos[contador].codiCtrlHistEven +
              " " +
              datos.datos[contador].horaMarcSaliD,
        );
      }
    } else {
      pausarSimulacion();
    }
    contador = contador + 1;
    contPosSiguiente = contPosSiguiente + 1;
  }

  _getIdMarkerBandera(bandera) {
    if (bandera == 1) {
      return 'assets/recorrido_f_ruta.png';
    }
    return 'assets/recorrido_trazado.png';
  }
}
