import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:label_marker/label_marker.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

import '../models/control/control_propietario.dart';
import '../models/control/data_control_propietario.dart';
import '../models/login/login_propietario.dart';
import '../models/monitoreo/data_monitoreo_page.dart';
import '../provider/provi_direccion.dart';
import '../repositories/repo_control_monitoreo.dart';
import '../repositories/repo_monitoreo_page.dart';
import '../repositories/security_data.dart';
import '../utils/iconos.dart';

class MonitoreoPage extends StatefulWidget {
  SecurityData oS = new SecurityData();
  int _isColor = 1;
  @override
  State<MonitoreoPage> createState() => _MonitoreoPageState();
}

class _MonitoreoPageState extends State<MonitoreoPage> {
  var datos;
  List<DatoMonitoreo> mListMonitoreo = [];
  var controles;
  var subpoint = [];
  final Set<Marker> _markers = Set();
  late LabelMarker oMarkerLabelBus;
  late LabelMarker oMarkerControles;
  Set<Polygon> _polygons = Set();
  Timer? timer_rastreo;
  bool banderaCenter = true;
  Duration _duration = Duration(seconds: 10);
  bool _traffic = false;
  bool _control = true;
  List<LatLng> points = [];
  int position = 0;
  List<DatoControl> mListaControles = [];
  double altura = 0;
  String propietario = "";

  GoogleMapController? mapController;

  static final CameraPosition _kLake = CameraPosition(
    target: LatLng(-0.23613787887498106, -78.52698468711493),
    zoom: 7.4746,
  );

  List<DropdownMenuItem<String>> list_unidades = [];
  String _unidad = "*";

  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  @override
  void initState() {
    if (mounted) {
      _ItemDropdownButton();
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _customInfoWindowController.dispose();
    detenerMonitoreo();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: SpeedDial(
          openBackgroundColor: Colors.blue,
          closedBackgroundColor: Colors.blue,
          speedDialChildren: <SpeedDialChild>[
            SpeedDialChild(
              backgroundColor: Colors.blue,
              child: const Icon(IconSemaforo, color: Colors.white),
              label: 'Semaforo',
              onPressed: () {
                setState(() {
                  if (_traffic) {
                    _traffic = false;
                  } else {
                    _traffic = true;
                  }
                });
              },
            ),
            SpeedDialChild(
              backgroundColor: Colors.blue,
              child: const Icon(IconCuadro, color: Colors.white),
              label: 'Controles',
              onPressed: () {
                setState(() {
                  if (_control) {
                    _getControlesMonitoreo();
                    _control = false;
                  } else {
                    _removeMarkersControles();
                    _control = true;
                  }
                });
              },
            ),
          ],
          child: const Icon(IconAdd, color: Colors.white),
        ),
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _kLake,
              zoomControlsEnabled: false,
              minMaxZoomPreference: MinMaxZoomPreference(8, 18),
              myLocationButtonEnabled: false,
              myLocationEnabled: false,
              trafficEnabled: _traffic,
              markers: _markers,
              polygons: _polygons,
              mapType: MapType.normal,
              onTap: (position) {
                _customInfoWindowController.hideInfoWindow!();
              },
              onCameraMove: (position) {
                _customInfoWindowController.onCameraMove!();
              },
              onMapCreated: (GoogleMapController controller) {
                _customInfoWindowController.googleMapController = controller;
                mapController = controller;
                _initReadApi();
              },
            ),
            CustomInfoWindow(
              controller: _customInfoWindowController,
              height: altura,
              width: 250,
              offset: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 90),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 1),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: DropdownButton<String>(
                    underline: Container(height: 0, color: Colors.transparent),
                    value:
                        list_unidades.isNotEmpty
                            ? list_unidades[position].value
                            : _unidad,
                    /*  icon: const Icon(
                      Icons.arrow_downward,
                      color: Colors.blue,
                    ), 
                    iconSize: 24,
                    elevation: 16, */
                    style: const TextStyle(color: Colors.black),
                    items: list_unidades,
                    onChanged: (String? value) {
                      setState(() {
                        timer_rastreo!.cancel();
                        _unidad = value!;
                        print("Unidad Monitoreo : " + _unidad);
                        banderaCenter = true;
                        this.position = getPosition(_unidad);
                        _removeMarkersControles();
                        if (_control == false) {
                          _getControlesMonitoreo();
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int getPosition(unidad) {
    for (int i = 0; i < list_unidades.length; i++) {
      print("POSITION UNIDAD : " + list_unidades[i].value!);
      if (list_unidades[i].value == unidad) {
        return i;
      }
    }

    return 0;
  }

  _initMonitoreo() async {
    print(" _initMonitoreo() unidad rastreo " + _unidad);
    print(" _initMonitoreo() unidad pripietario " + propietario);

    /*if (propietario.isEmpty && propietario != null) {
      print("SIN PROPIETARIO");
      return;
    }*/

    ApiRepositorioMonitoreoPage servicio = ApiRepositorioMonitoreoPage();

    datos = await servicio.fetchMonitoreoPage(propietario, _unidad);

    print("_initMonitoreo()  ${(jsonEncode(datos))}");
    if (datos.statusCode == 300) {
      _showToas(Colors.blue, "¡ " + datos.sms);
    }
    if (datos.statusCode == 400) {
      _showToas(Colors.red, "¡ " + datos.sms);
      return detenerMonitoreo();
    } else if (this.mounted) {
      if (timer_rastreo != null) {
        timer_rastreo!.cancel();
      }
      timer_rastreo = Timer.periodic(_duration, (timer) async {
        this._initMonitoreo();
      });
      setState(() {
        _addMarkerImage(datos.datos);
      });
    }
  }

  _initMonitoreoImagen() async {
    print('_initMonitoreoImagen();');
    print("_initMonitoreoImagen() unidad rastreo " + _unidad);
    print("_initMonitoreoImagen() unidad pripietario " + propietario);
    ApiRepositorioMonitoreoPage servicio = ApiRepositorioMonitoreoPage();
    datos = await servicio.fetchMonitoreoPage(propietario, "*");
    print("initMonitoreoImagen();  ${(jsonEncode(datos))}");
    if (datos.statusCode == 400) {
      return detenerMonitoreo();
    } else {
      setState(() {
        mListMonitoreo = datos.datos;
        print(mListMonitoreo);
        _addMarkerImage(datos.datos);
      });
    }
  }

  Future<String> _getSharedPreferences() async {
    var propietario = await widget.oS.readDataPreferenciasLoginPropietario(
      'dataLoginPropietarioLoginUsuario',
    );
    return propietario;
  }

  _ItemDropdownButton() async {
    if (mounted) {
      var jsonDataL = await widget.oS.readDataPreferenciasLoginPropietario(
        'dataLoginPropietarioLoginUnidadesd',
      );
      LoginPropietario listabuses = LoginPropietario.fromRawJson(jsonDataL);
      await _initMonitoreoImagen();
      setState(() {
        list_unidades.add(
          DropdownMenuItem<String>(
            child: Row(
              children: [
                Image.asset('assets/online_lista.png', width: 19),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text('Todas las unidades'),
                ),
              ],
            ),
            value: '*',
          ),
        );

        listabuses.data!.forEach((element) {
          list_unidades.add(
            DropdownMenuItem<String>(
              child: Row(
                children: [
                  Image.asset(
                    getIconoLista(mListMonitoreo, element.codiVehiObseVehi),
                    width: 19,
                  ),
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
  }

  void _addMarkerImage(List<DatoMonitoreo> oList) async {
    for (var oM in oList) {
      var assets = Platform.isAndroid ? _getIcono(oM) : _getIconoIos(oM);

      if (banderaCenter == true) {
        mapController!.moveCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(
              double.parse(oM.ultiLatiMoni!),
              double.parse(oM.ultiLongMoni!),
            ),
            15,
          ),
        );
        banderaCenter = false;
      }
      var imgenconfig = ImageConfiguration(size: Size(150, 150));

      _addMarkerWithLabel(oM);
      altura = oM.singpsday! > 0 ? 180 : 165;
      _markers.add(
        Marker(
          markerId: MarkerId(oM.codiVehiMoni!),
          //infoWindow: info,
          rotation: oM.ultiRumbMoni!.toDouble() + 180,
          onTap: () async {
            _customInfoWindowController.addInfoWindow!(
              Container(
                height: 200,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Column(
                            children: [
                              Text(
                                'UNIDAD N°: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                oM.codiVehiMoni!,
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Column(
                            children: [
                              Text(
                                'FECHA MONI: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                oM.ultiFechMoni.toString().substring(0, 19),
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: oM.singpsday! > 0 ? true : false,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Column(
                              children: [
                                Text(
                                  'DIAS SIN TRANSMISION: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  oM.singpsday.toString() + ' DÍAS',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Column(
                            children: [
                              Text(
                                'RUTA: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                oM.ruta! == '' ? "SIN RUTA" : oM.ruta!,
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Column(
                            children: [
                              Text(
                                'EVENTO: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                oM.alarAnteGpsDescMoni == 1
                                    ? 'ALERTA GPS'
                                    : oM.alarFuerRutaMoni == null ||
                                        oM.alarFuerRutaMoni == 1
                                    ? 'FUERA DE RUTA'
                                    : 'EN RUTA',
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Column(
                            children: [
                              Text(
                                'VELOCIDAD: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                oM.ultiVeloMoni.toString() + ' KM/H',
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Column(
                            children: [
                              Text(
                                'DIR: ',
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Text(
                              await _getDireccion(
                                oM.ultiLatiMoni,
                                oM.ultiLongMoni,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Text(
                                'SATELITES: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                oM.sateContMoni.toString(),
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              LatLng(
                double.parse(oM.ultiLatiMoni!),
                double.parse(oM.ultiLongMoni!),
              ),
            );
          },
          position: LatLng(
            double.parse(oM.ultiLatiMoni!),
            double.parse(oM.ultiLongMoni!),
          ),
          icon: await BitmapDescriptor.fromAssetImage(imgenconfig, assets),
        ),
      );
    }
  }

  _getIcono(DatoMonitoreo unidad) {
    var imagen = 'assets/online.png';
    widget._isColor = 0;
    if (unidad.alarAnteGpsDescMoni == 1) {
      widget._isColor = 1;
      imagen = 'assets/alerta.png';
      return imagen;
    }
    if (unidad.singpsday! > 0) {
      imagen = 'assets/sin_gps_full.png';
      widget._isColor = 2;
    } else {
      if (unidad.minutesingps! > 30) {
        widget._isColor = 3;
        imagen = 'assets/sin_gps_now.png';
      } else {
        if (unidad.letrRutaMoni != '' && unidad.letrRutaMoni != null) {
          widget._isColor = 4;
          imagen =
              unidad.ultiVeloMoni == 0
                  ? 'assets/stop_online.png'
                  : 'assets/online.png';
          return imagen;
        } else {
          imagen =
              unidad.ultiVeloMoni == 0
                  ? 'assets/online_sin_ruta_stop.png'
                  : 'assets/online_sin_ruta.png';
          widget._isColor = 5;
          return imagen;
        }
      }
    }
    return imagen;
  }

  _getIconoIos(DatoMonitoreo unidad) {
    var imagen = 'assets/online_ios.png';
    widget._isColor = 0;
    if (unidad.alarAnteGpsDescMoni == 1) {
      imagen = 'assets/alerta_ios.png';
      widget._isColor = 1;
      return imagen;
    }
    if (unidad.singpsday! > 0) {
      imagen = 'assets/sin_gps_full_ios.png';
      widget._isColor = 2;
    } else {
      if (unidad.minutesingps! > 30) {
        imagen = 'assets/sin_gps_now_ios.png';
        widget._isColor = 3;
      } else {
        if (unidad.letrRutaMoni != '' && unidad.letrRutaMoni != null) {
          widget._isColor = 4;
          imagen =
              unidad.ultiVeloMoni == 0
                  ? 'assets/stop_online_ios.png'
                  : 'assets/online_ios.png';
          return imagen;
        } else {
          imagen =
              unidad.ultiVeloMoni == 0
                  ? 'assets/online_sin_ruta_stop_ios.png'
                  : 'assets/online_sin_ruta_ios.png';
          widget._isColor = 5;
          return imagen;
        }
      }
    }
    return imagen;
  }

  Future _addMarkerWithLabel(oM) async {
    oMarkerLabelBus = LabelMarker(
      label: '' + oM.codiVehiMoni!,
      markerId: MarkerId('Bus: ' + oM.codiVehiMoni!),
      position: LatLng(
        double.parse(oM.ultiLatiMoni!),
        double.parse(oM.ultiLongMoni!),
      ),
      textStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      backgroundColor:
          widget._isColor == 0
              ? Color.fromARGB(255, 13, 115, 69)
              : widget._isColor == 1
              ? Color.fromARGB(255, 186, 23, 0)
              : widget._isColor == 2
              ? Color.fromARGB(255, 145, 147, 142)
              : widget._isColor == 3
              ? Color.fromARGB(255, 58, 59, 57)
              : widget._isColor == 4
              ? Color.fromARGB(255, 13, 115, 69)
              : Color.fromARGB(255, 6, 12, 146),
    );
    _markers.addLabelMarker(oMarkerLabelBus);
    return;
  }

  detenerMonitoreo() {
    if (timer_rastreo != null) {
      print("CANCELAR TIMER RASTREO");
      timer_rastreo!.cancel();
    }
  }

  void _showToas(color, msm) {
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

  _initControlesMonitoreo() async {
    ApiRepositorioControlesMonitoreo servicio =
        new ApiRepositorioControlesMonitoreo();
    ControlPropietarioAppMovil listaControles =
        await servicio.fetchControlMonitoreo();

    mListaControles = listaControles.data!;
  }

  _getControlesMonitoreo() async {
    if (mListaControles.length > 0) {
      _addMarkerWithLabelControl(mListaControles);
      for (var i = 0; i < mListaControles.length; i++) {
        for (
          var j = 0;
          j < mListaControles[i].calculator!.coordinates!.length;
          j++
        ) {
          points.add(
            LatLng(
              mListaControles[i].calculator!.coordinates![j].lat!,
              mListaControles[i].calculator!.coordinates![j].lng!,
            ),
          );
        }
      }
      int cont = 4;
      for (int i = 0; i < points.length; i = i + 4) {
        var pedazo = points.sublist(i, cont);
        subpoint.add(pedazo);
        cont = cont + 4;
      }
      mapController!.moveCamera(CameraUpdate.newLatLngZoom(points[0], 16));
      setState(() {
        for (var i = 0; i < subpoint.length; i++) {
          _polygons.add(
            Polygon(
              polygonId: PolygonId(mListaControles[i].descCtrl!),
              fillColor: Colors.indigo.shade100,
              points: subpoint[i],
              strokeColor: Colors.indigo,
              strokeWidth: 3,
            ),
          );
        }
      });
    }
  }

  getIconoLista(List<DatoMonitoreo> oM, unidadPropietario) {
    var imagenLista = "assets/online_lista.png";
    for (var unidadMonitoreo in oM) {
      if (unidadMonitoreo.codiVehiMoni == unidadPropietario) {
        if (unidadMonitoreo.alarAnteGpsDescMoni == 1) {
          imagenLista = "assets/alerta_lista.png";
          return imagenLista;
        }
        if (unidadMonitoreo.singpsday! > 0) {
          imagenLista = "assets/sin_gps_full_lista.png";
        } else {
          if (unidadMonitoreo.minutesingps! > 30) {
            imagenLista = "assets/sin_gps_now_lista.png";
          } else {
            if (unidadMonitoreo.letrRutaMoni != "" &&
                unidadMonitoreo.letrRutaMoni != null) {
              imagenLista = "assets/online_lista.png";
              return imagenLista;
            } else {
              imagenLista = "assets/online_sin_ruta_lista.png";
              return imagenLista;
            }
          }
        }
        return imagenLista;
      }
    }
    return imagenLista;
  }

  Future _addMarkerWithLabelControl(oListMC) async {
    for (var oM in oListMC) {
      oMarkerControles = LabelMarker(
        label: oM.descCtrl,
        markerId: MarkerId('Control ' + oM.descCtrl),
        position: LatLng(
          oM.calculator.coordinates[0].lat,
          oM.calculator.coordinates[0].lng,
        ),
        textStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        backgroundColor: Colors.white,
      );
      _markers.addLabelMarker(oMarkerControles);
    }
    return;
  }

  _readPropietario() async {
    propietario = await widget.oS.readDataPreferenciasLoginPropietario(
      'dataLoginPropietarioLoginPropietario',
    );
    print('Propietario getsalida ${propietario}');
  }

  _removeMarkersControles() {
    _markers.clear();
    _polygons.clear();
    points.clear();
    subpoint.clear();
    _initMonitoreo();
  }

  _getDireccion(latitud, longitud) {
    ProviDireccion servicio = ProviDireccion();
    return servicio.getDireccion(double.parse(latitud), double.parse(longitud));
  }

  void _initReadApi() async {
    await _readPropietario();
    await _initMonitoreo();
    await _initControlesMonitoreo();
  }
}
