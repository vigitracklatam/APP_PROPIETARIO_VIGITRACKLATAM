import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:label_marker/label_marker.dart';
import '../models/controles_marcados/controles_marcados.dart';
import '../models/geocerca/geocerca.dart';
import '../models/historial_unidad/data_historial_unidad.dart';
import '../models/historial_unidad/historial_unidad.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../repositories/repo_controles_marcados.dart';
import '../repositories/repo_geocerca.dart';
import '../repositories/repo_historial_unidad.dart';

class NewSimulador extends StatefulWidget {
  int _idSali;
  String _unidad;
  String _horaI;
  String _horaF;
  String _dateSalida;
  String _letraRuta;
  String _desRuta;
  int _vuelSali;
  NewSimulador(
    int _idSali,
    String _unidad,
    String _dateSalida,
    String _horaI,
    String _horaF,
    String _letraRuta,
    String _desRuta,
    int _vuelSali,
  ) : this._idSali = _idSali,
      this._unidad = _unidad,
      this._dateSalida = _dateSalida,
      this._horaI = _horaI,
      this._horaF = _horaF,
      this._letraRuta = _letraRuta,
      this._desRuta = _desRuta,
      this._vuelSali = _vuelSali;

  @override
  State<NewSimulador> createState() => _NewSimuladorState();
}

class _NewSimuladorState extends State<NewSimulador> {
  HistorialUnidadAppMovil? datoSimulador = null;
  GeocercaAppMovil? datoGeocerca = null;
  ControlesMarcadosAppMovil? datoControles = null;
  GoogleMapController? _controller;
  Set<Marker> _markers = Set<Marker>();
  Set<Polygon> _polygons = {};
  late LabelMarker oMarkerLabelControl;
  late LabelMarker oMarkerLabel;
  List<DatoHistorialUnidad>? datos;

  void initState() {
    super.initState();
    getPoligonoControl();
    getPosiciones();
    getControlesMarcados();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Salida #${(widget._idSali)}',
            style: const TextStyle(color: Colors.white),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body:
            datoSimulador == null
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target:
                        datoSimulador!.datos!.isEmpty
                            ? const LatLng(
                              -1.254340,
                              -78.622850,
                            ) // Coordenadas de Ecuador
                            : LatLng(
                              double.parse(
                                datoSimulador!.datos!.first.latiHistEven!,
                              ),
                              double.parse(
                                datoSimulador!.datos!.first.longHistEven!,
                              ),
                            ),
                    zoom: 14,
                  ),
                  markers: _markers,
                  myLocationButtonEnabled: false,
                  myLocationEnabled: false,
                  zoomControlsEnabled: false,
                  polygons: _polygons,
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                    if (datoSimulador != null &&
                        datoSimulador!.datos!.isNotEmpty) {
                      setMarkers();
                    }
                  },
                ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            _showMarcacionesModal(context);
          },
          tooltip: 'Marcaciones',
          child: const Icon(Icons.event_note_outlined, color: Colors.white),
        ),
      ),
    );
  }

  void setMarkers() async {
    List<Marker> markers = [];
    for (var posicion in datoSimulador!.datos!) {
      String iconPath = getPositionIcon(posicion);
      BitmapDescriptor customIcon = await getBitmapDescriptor(iconPath);

      markers.add(
        Marker(
          markerId: MarkerId(posicion.idHistEve.toString()),
          position: LatLng(
            double.parse(posicion.latiHistEven!),
            double.parse(posicion.longHistEven!),
          ),
          rotation: double.parse((posicion.rumbHistEven!).toString()),
          icon: customIcon,
          infoWindow: InfoWindow(
            title: 'Fecha Moni: ${posicion.fechHistEven}',
            snippet:
                'Velocidad: ${posicion.veloHistEven}    Satelite: ${posicion.sateHistEven}',
          ),
        ),
      );

      if (posicion.horaMarcSaliD != "" && posicion.horaProgSaliD != "") {
        oMarkerLabel = LabelMarker(
          label: 'PROG: ${posicion.horamarc} MARC: ${posicion.horaprog}',
          visible: true,
          markerId: MarkerId(
            posicion.codiCtrlHistEven! + posicion.descRutaSaliM!,
          ),
          position: LatLng(
            double.parse(posicion.latiHistEven!),
            double.parse(posicion.longHistEven!),
          ),
          backgroundColor: Colors.white, // Fondo blanco
          textStyle: const TextStyle(
            color: Color(0xFF055EB1), // Letra azul
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        );
        _markers.addLabelMarker(oMarkerLabel);
      }
    }
    setState(() {
      _markers.addAll(markers);
    });
  }

  getPosiciones() async {
    print('aca unidad ' + widget._unidad);
    print('aca FechaI ' + widget._dateSalida + ' ' + widget._horaI);
    print('aca FechaF ' + widget._dateSalida + ' ' + widget._horaF);

    ApiHistorialUnidad servicio = ApiHistorialUnidad();
    datoSimulador = await servicio.readHistorialUnidad(
      widget._unidad,
      widget._idSali,
      widget._dateSalida + ' ' + widget._horaI,
      widget._dateSalida + ' ' + widget._horaF,
    );

    print('object datoHistorialUnidad');
    print(jsonEncode(datoSimulador));

    if (datoSimulador!.statusCode == 200) {
      setMarkers();
    }
    if (datoSimulador!.statusCode == 300) {
      _showToas(Colors.indigo.shade300, "¡ ${datoSimulador!.msm!}");
    } else if (datoSimulador!.datos!.isEmpty) {
      _showToas(Colors.indigo.shade300, "¡ ${datoSimulador!.msm!}");
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

  // Función para obtener el icono de posición según alguna condición
  String getPositionIcon(DatoHistorialUnidad posicion) {
    if (posicion.horaMarcSaliD != "" && posicion.horaProgSaliD != "") {
      return 'assets/recorrido_trazado_azul.png';
    } else if (posicion.evenExceVeloHistEven == 1) {
      return 'assets/recorrido_trazado_amarillo.png';
    } else if (posicion.outRoutHistEven == 1) {
      return 'assets/recorrido_f_ruta.png';
    } else {
      return 'assets/recorrido_trazado.png';
    }
  }

  // Función para obtener BitmapDescriptor desde un asset
  Future<BitmapDescriptor> getBitmapDescriptor(String assetPath) async {
    return BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(), // Asegúrate de convertir a double
      assetPath,
    );
  }

  void getPoligonoControl() async {
    ApiGeocerca servicio = ApiGeocerca();
    datoGeocerca = await servicio.readGeocerca(widget._letraRuta);

    //print('object datoGeocerca');
    //print(jsonEncode(datoGeocerca));

    if (datoGeocerca != null && datoGeocerca!.data != null) {
      BitmapDescriptor customIcon = await getBitmapDescriptor(
        "assets/control.png",
      );

      List<Polygon> polygons = [];
      List<Marker> markers = [];

      datoGeocerca!.data!.forEach((element) {
        List<LatLng> points = [];
        element.calculator!.coordinates!.forEach((coordenada) {
          points.add(LatLng(coordenada.lat!, coordenada.lng!));
        });

        if (points.isNotEmpty) {
          polygons.add(
            Polygon(
              polygonId: PolygonId(element.codiCtrl! + element.lati1Ctrl!),
              points: points,
              fillColor: Color(0x172b4d80).withOpacity(0.3),
              strokeColor: Colors.black,
              geodesic: true,
              strokeWidth: 2,
            ),
          );

          markers.add(
            Marker(
              markerId: MarkerId(element.codiCtrl! + element.long1Ctrl!),
              position: points[0],
              icon: customIcon,
            ),
          );

          oMarkerLabelControl = LabelMarker(
            label: element.descCtrl!,
            visible: true,
            markerId: MarkerId(element.codiCtrl! + element.descCtrl!),
            position: LatLng(points[0].latitude, points[0].longitude),
            backgroundColor: Colors.white.withOpacity(
              0.6,
            ), // Cambia esto por el color de fondo deseado
            textStyle: const TextStyle(
              color: Colors.black, // Cambia esto por el color del texto deseado
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          );
          _markers.addLabelMarker(oMarkerLabelControl);
        }
      });

      setState(() {
        _polygons.addAll(polygons);
        _markers.addAll(markers);
      });
    }
  }

  void getControlesMarcados() async {
    ApiControlesMarcados servicio = ApiControlesMarcados();
    datoControles = await servicio.readControles(widget._idSali);
    // print('object datoControles');
    //print(jsonEncode(datoControles));

    setState(() {});
  }

  void _showMarcacionesModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Unidad: ${widget._unidad}    Vuelta: ${widget._vuelSali}',
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Ruta: ${widget._desRuta} ',
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Fecha: ${widget._dateSalida} ',
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Hora I: ${widget._horaI}   Hora F: ${widget._horaF}',
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 12,
          ),
          content: SingleChildScrollView(
            child: DataTable(
              horizontalMargin: 4,
              columnSpacing: 20,
              columns: const [
                DataColumn(
                  label: SizedBox(
                    width: 100, // Ajusta el ancho aquí según tus necesidades
                    child: Text(
                      'CONTROL',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: 80, // Ajusta el ancho aquí según tus necesidades
                    child: Text(
                      'H. PROG',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: 80, // Ajusta el ancho aquí según tus necesidades
                    child: Text(
                      'H. MARC',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
              rows: _buildRows(),
            ),
          ),
        );
      },
    );
  }

  List<DataRow> _buildRows() {
    List<DataRow> rows = [];
    if (datoControles != null && datoControles!.datos != null) {
      datoControles!.datos!.forEach((control) {
        bool canTap =
            control.horaMarcSaliD != ""; // Verifica si hay horaMarcSaliD
        rows.add(
          DataRow(
            cells: [
              DataCell(
                SizedBox(
                  width: 100,
                  child: InkWell(
                    onTap: () {
                      _centerMapOnControl(
                        control,
                        context,
                      ); // Función para centrar el mapa en el control
                    },
                    child: Text(
                      control.isCtrlRefeSaliD == 1
                          ? '${control.descCtrl ?? ''} (REF)'
                          : control.descCtrl ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            control.isCtrlRefeSaliD == 1
                                ? Colors.red
                                : Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 80,
                  child: InkWell(
                    onTap: () {
                      _centerMapOnControl(control, context);
                    },
                    child: Text(
                      control.horaProgSaliD ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            control.isCtrlRefeSaliD == 1
                                ? Colors.red
                                : Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 80,
                  child: InkWell(
                    onTap:
                        canTap
                            ? () {
                              _centerMapOnControl(control, context);
                            }
                            : null, // Si no se puede hacer clic, onTap es null
                    child: Text(
                      control.horaMarcSaliD ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            control.isCtrlRefeSaliD == 1
                                ? Colors.red
                                : Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      });
    }
    return rows;
  }

  void _centerMapOnControl(control, BuildContext context) {
    Navigator.pop(context); // Cierra el modal antes de continuar

    const double zoomLevel = 17; // Define el nivel de zoom deseado

    _controller!.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(
          double.parse(control.lati1Ctrl),
          double.parse(control.long1Ctrl),
        ),
        zoomLevel,
      ),
    );
  }
}
