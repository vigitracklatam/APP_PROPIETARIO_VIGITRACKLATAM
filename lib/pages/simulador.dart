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

class Simulador extends StatefulWidget {
  String _horaI;
  String _horaF;
  var controles = [];
  BuildContext? _buildContextAlert;
  TextEditingController _inputFieldDateController = new TextEditingController();
  TextEditingController _inputFieldTimeStartController =
      new TextEditingController();
  TextEditingController _inputFieldTimeEndController =
      new TextEditingController();
  String _dateSalida;
  SecurityData oS = new SecurityData();
  String _unidad;
  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.43296265331129, -122.08832357078792),
    zoom: 14.4746,
  );
  Set<Circle> _circles = Set();
  List<DropdownMenuItem<String>> lista_unidades = [];
  int position = 0;
  Simulador(String _unidad, String _dateSalida, String _horaI, String _horaF)
    : this._unidad = _unidad,
      this._dateSalida = _dateSalida,
      this._horaI = _horaI,
      this._horaF = _horaF;

  @override
  State<Simulador> createState() => _SimuladorState();
}

class _SimuladorState extends State<Simulador> {
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
  @override
  void initState() {
    _ItemDropdownButton();
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
        appBar: AppBar(
          title: Text('Simulador'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              pausarSimulacion();

              Navigator.pop(context);
            },
          ),
        ),
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
                margin: const EdgeInsets.only(top: marginSmallSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 140,
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
                            widget.lista_unidades.isNotEmpty
                                ? widget
                                    .lista_unidades[getPosition(widget._unidad)]
                                    .value
                                : widget._unidad,
                        items: widget.lista_unidades,
                        onChanged: (String? value) {
                          setState(() {
                            widget._unidad = value!;
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
                        onPressed: () {
                          _viewAlerDialog(context);
                        },
                        child: Icon(Icons.copy_all_rounded),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 3),
                      child: FloatingActionButton(
                        heroTag: 'pausar',
                        tooltip: 'Pausar',
                        onPressed: () {
                          pausarSimulacion();
                        },
                        child: Icon(Icons.pause),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 3),
                      child: FloatingActionButton(
                        heroTag: 'Play',
                        tooltip: 'Continuar',
                        onPressed: () {
                          _startSimulacion();
                        },
                        child: Icon(Icons.play_arrow),
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
    for (int i = 0; i < widget.lista_unidades.length; i++) {
      print("POSITION UNIDAD : " + widget.lista_unidades[i].value!);
      if (widget.lista_unidades[i].value == unidad) {
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
    widget._inputFieldTimeStartController.text = widget._horaI;
    widget._inputFieldTimeEndController.text = widget._horaF;
    widget._unidad = widget._unidad;
    print('Aca unidad >>>>>>>>>>>>>>>>><<<<<${widget._unidad}');
    if (widget._inputFieldTimeStartController.text != "" &&
        widget._inputFieldTimeEndController.text != "") {
      widget._inputFieldDateController.text = widget._dateSalida;
      widget._unidad = widget._unidad;
      await _initSimulador();
      _startSimulacion();
    }

    setState(() {
      listabuses.data!.forEach((element) {
        listabuses.data!.elementAt(0).codiVehiObseVehi!;
        widget.lista_unidades.add(
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
      widget._dateSalida =
          year.toString() + "/" + month.toString() + "/" + day.toString();
      widget._inputFieldDateController.text = widget._dateSalida;
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
                              controller: widget._inputFieldDateController,
                              style: TextStyle(height: 1.2),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                icon: Icon(Icons.calendar_today_outlined),
                                hintText: widget._dateSalida,
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
                              controller: widget._inputFieldTimeStartController,
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
                                  widget._inputFieldTimeStartController,
                                );
                              },
                            ),
                          ),
                          Flexible(
                            child: TextField(
                              controller: widget._inputFieldTimeEndController,
                              onTap: () {
                                FocusScope.of(
                                  context,
                                ).requestFocus(new FocusNode());
                                _showTimePicker(
                                  context,
                                  widget._inputFieldTimeEndController,
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
                      OutlinedButton.icon(
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(
                            Size(double.infinity, 40),
                          ),
                        ),
                        icon: Icon(Icons.search),
                        onPressed: () async {
                          _markers.clear();
                          widget.controles.clear();
                          await _initSimulador();
                        },
                        label: Text("Consultar Recorrido"),
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
        widget._dateSalida =
            (picked.year.toString() +
                "/" +
                picked.month.toString() +
                "/" +
                picked.day.toString());
        widget._inputFieldDateController.text = widget._dateSalida;
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
    if (widget._inputFieldTimeStartController.text == "" ||
        widget._inputFieldTimeEndController.text == "") {
      _showToas(Colors.indigo.shade300, "¡ Error de horas");
    } else {
      _showAlertProgres(context);
      print("unidad rastreo >>>>>>>>>>>>>>>>>>>>" + widget._unidad);
      SimuladorAppMovil oSi = await ApiSimulador().readSimulador(
        widget._unidad,
        widget._dateSalida +
            ' ' +
            widget._inputFieldTimeStartController.text.substring(0, 5) +
            ':00',
        widget._dateSalida +
            ' ' +
            widget._inputFieldTimeEndController.text.substring(0, 5) +
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
        Uint8List markerIcon = await getBytesFromAsset(assets, 100);
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
        Uint8List markerIcon = await getBytesFromAsset(assets, 100);
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
      Uint8List markerIcon = await getBytesFromAsset(assets, 100);

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
