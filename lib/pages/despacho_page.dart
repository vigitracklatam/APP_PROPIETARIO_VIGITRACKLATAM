import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import '../models/code_activacion/code_activacion.dart';
import '../repositories/repo_frecuencias.dart';
import '../repositories/repo_generar_despacho.dart';
import '../repositories/repo_rutas.dart';
import '../repositories/repo_unidades_despacho.dart';
import '../repositories/security_data.dart';
import '../utils/dimens.dart';
import '../utils/iconos.dart';
import '../utils/textos.dart';
import 'unidadesDespacho.dart';

class DespachoPage extends StatefulWidget {
  DespachoPage({super.key});
  SimpleFontelicoProgressDialog? _dialog;
  String nameCompania = '';
  String propietario = '';
  SecurityData oS = new SecurityData();

  @override
  State<DespachoPage> createState() => _DespachoPageState();
}

class _DespachoPageState extends State<DespachoPage> {
  List<DropdownMenuItem<String>> lista_salidas = [];
  List<DropdownMenuItem<String>> lista_rutas = [];
  List<DropdownMenuItem<String>> lista_frecuencias = [];
  String _ruta = "1";
  String salidas = "0";
  String _frecuencia = "";
  String _unidad = "";
  int positionS = 0;
  int positionR = 0;
  int positionF = 0;
  int position = 0;
  String _date = "yyyy-mm-dd";
  TextEditingController _timeInputController = TextEditingController();
  TextEditingController _dateImputController = TextEditingController();
  TextEditingController _numImputController = TextEditingController();
  var datosRutas;
  String desRuta = "";
  List<String> lista_unidad = [];
  var datosBuses;
  var datosFrecuencias;
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    _ItemDropdownButtonRutas();
    _ItemDropdownButtonSalidas();
    updateRutaFrecuencia().then((_) {
      _ItemDropdownButtonFrecuencia();
    });
    _getFechaActual();
    setState(() {
      final now = TimeOfDay.now();
      final formattedTime = '${now.hour}:${now.minute}';
      _timeInputController.text = formattedTime;
    });
    updateListaUnidades();
    super.initState();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    height: 60,
                    margin: const EdgeInsets.only(
                      right: marginSmallSmall,
                      left: marginSmallSmall,
                      top: marginSmallSmall,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 4,
                              ),
                              isDense: true,
                              disabledBorder: OutlineInputBorder(),
                            ),
                            child: DropdownButton<String>(
                              padding: const EdgeInsets.only(left: 10),
                              isExpanded: true,
                              underline: Container(
                                height: 0,
                                color: Colors.transparent,
                              ),
                              value:
                                  lista_salidas.isNotEmpty
                                      ? lista_salidas[positionS].value
                                      : salidas,
                              items: lista_salidas,
                              onChanged: (String? value) {
                                setState(() {
                                  print(value);
                                  salidas = value!;
                                  positionS = getPositionSalidas(salidas);
                                  print(positionS);
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: marginSmallSmall),
                        Flexible(
                          child: TextField(
                            readOnly: true,
                            controller: _numImputController,
                            onTap: () async {
                              String unidad =
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (BuildContext context) =>
                                              UnidadesDespachoPage(),
                                    ),
                                  ) ??
                                  _unidad;
                              print("UNIDAD DESPACHO : " + unidad);
                              _unidad =
                                  (unidad != null && unidad.isNotEmpty)
                                      ? unidad
                                      : _unidad;
                              _numImputController.text = unidad;
                              position = getPosition(unidad);
                            },
                            decoration: const InputDecoration(
                              labelText: '  Numero Bus',
                              hintText: 'Ingresa el bus',
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 60,
                    margin: const EdgeInsets.only(
                      right: marginSmallSmall,
                      left: marginSmallSmall,
                      top: marginSmallSmall,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: TextField(
                            controller: _dateImputController,
                            decoration: const InputDecoration(
                              labelStyle: TextStyle(fontSize: textBigMedium),
                              labelText: 'Fecha',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(IconCalendario),
                            ),
                            onTap: () {
                              FocusScope.of(
                                context,
                              ).requestFocus(new FocusNode());
                              _getSelectDate(context);
                            },
                          ),
                        ),
                        const SizedBox(width: marginSmallSmall),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: TextFormField(
                              readOnly: true,
                              controller: TextEditingController(
                                text: _selectedTime.format(context),
                              ),
                              onTap: () {
                                _showTimePicker(context);
                              },
                              decoration: const InputDecoration(
                                labelText: 'Hora',
                                prefixIcon: Icon(Icons.access_time),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ), // Borde predeterminado
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ), // Borde cuando está habilitado
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ), // Borde cuando está enfocado
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ), // Borde cuando está deshabilitado
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 60,
                    margin: const EdgeInsets.only(
                      right: marginSmallSmall,
                      left: marginSmallSmall,
                      top: marginSmallSmall,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 4,
                              ),
                              disabledBorder: OutlineInputBorder(),
                            ),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              underline: Container(
                                height: 0,
                                color: Colors.transparent,
                              ),
                              value:
                                  lista_rutas.isNotEmpty
                                      ? lista_rutas[positionR].value
                                      : _ruta,
                              items: lista_rutas,
                              onChanged: (String? value) {
                                setState(() {
                                  print("ACA VALUE RUTA " + value.toString());
                                  _ruta = value!;
                                  if (lista_rutas.isNotEmpty) {
                                    positionR = getPositionRuta(_ruta);
                                    desRuta =
                                        datosRutas.data[positionR].descRuta;
                                    print(" positioR ${positionR}");
                                    _ItemDropdownButtonFrecuencia();
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 60,
                    margin: const EdgeInsets.only(
                      right: marginSmallSmall,
                      left: marginSmallSmall,
                      top: marginSmallSmall,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 4,
                              ),
                              isDense: true,
                              disabledBorder: OutlineInputBorder(),
                            ),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              underline: Container(
                                height: 0,
                                color: Colors.transparent,
                              ),
                              value:
                                  lista_frecuencias.isNotEmpty
                                      ? lista_frecuencias[positionF].value
                                      : _frecuencia,
                              items: lista_frecuencias,
                              onChanged: (String? value) {
                                setState(() {
                                  print(value);
                                  _frecuencia = value!;
                                  positionF = getPositionFrecuencias(
                                    _frecuencia,
                                  );
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 80,
                    width: 250,
                    margin: const EdgeInsets.only(
                      right: marginSmallSmall,
                      left: marginSmallSmall,
                      top: marginSmallSmall,
                      bottom: marginSmall,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  if (!_numImputController.text.isEmpty) {
                                    _showAlertDespacho(context);
                                  } else {
                                    Alert(
                                      context: context,
                                      type: AlertType.info,
                                      title: "Sin Unidad",
                                      desc: "Porfavor seleccione una unidad",
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "Aceptar",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                          ),
                                          onPressed:
                                              () => Navigator.pop(context),
                                          width: 120,
                                        ),
                                      ],
                                    ).show();
                                  }
                                },
                                icon: const Icon(IconAutorizar),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.blue, // Color de fondo azul
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  minimumSize: Size(double.infinity, 50),
                                ),
                                label: const Text(
                                  "Autorizar",
                                  style: TextStyle(fontSize: textBigMedium),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.inputOnly,
      initialTime: _selectedTime,
      builder: (BuildContext context, Widget? child) {
        final ThemeData appTheme = Theme.of(context);
        return Theme(
          data: appTheme.copyWith(),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              alwaysUse24HourFormat: true, // Formato de 24 horas
            ),
            child: child!,
          ),
        );
      },
    );

    if (selectedTime != null && selectedTime != _selectedTime) {
      setState(() {
        _selectedTime = selectedTime;
        _timeInputController.text = _selectedTime.format(
          context,
        ); // Actualiza el valor del controlador
      });
    }
  }

  _ItemDropdownButtonSalidas() {
    setState(() {
      lista_salidas.add(
        const DropdownMenuItem(
          value: "0",
          child: Text("Salida Diferida", style: TextStyle(fontSize: 16)),
        ),
      );
      lista_salidas.add(
        const DropdownMenuItem(
          value: "1",
          child: Text("Salida Normal", style: TextStyle(fontSize: 16)),
        ),
      );
      lista_salidas.add(
        const DropdownMenuItem(
          value: "2",
          child: Text("Generar Tarjeta", style: TextStyle(fontSize: 16)),
        ),
      );
    });
  }

  _ItemDropdownButtonRutas() async {
    ApiRepositorioRutas servicio = new ApiRepositorioRutas();
    datosRutas = await servicio.fetchRutas(widget.propietario);
    desRuta = datosRutas.data[0].descRuta;
    setState(() {
      datosRutas.data!.forEach((element) {
        lista_rutas.add(
          DropdownMenuItem<String>(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    ' ${element.descRuta}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            value: element.idRuta.toString(),
          ),
        );
      });
    });
  }

  _ItemDropdownButtonFrecuencia() async {
    lista_frecuencias = [];
    positionF = 0;

    ApiRepositorioFrecuencias servicios = ApiRepositorioFrecuencias();
    datosFrecuencias = await servicios.fetchFrecuencias(_ruta);

    setState(() {
      _frecuencia = datosFrecuencias.data[0].descFrec;
      datosFrecuencias.data!.forEach((element) {
        lista_frecuencias.add(
          DropdownMenuItem<String>(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    ' ${element.descFrec}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            value: element.descFrec,
          ),
        );
      });
    });
  }

  int getPosition(unidad) {
    for (int i = 0; i < lista_unidad.length; i++) {
      //print("POSITION unidad : " + lista_unidad[i]);
      if (lista_unidad[i] == unidad) {
        return i;
      }
    }
    return 0;
  }

  int getPositionSalidas(salida) {
    for (int i = 0; i < lista_salidas.length; i++) {
      print("POSITION FRECUENCIA : " + lista_salidas[i].value!);
      if (lista_salidas[i].value == salidas) {
        return i;
      }
    }
    return 0;
  }

  int getPositionRuta(ruta) {
    for (int i = 0; i < lista_rutas.length; i++) {
      print("POSITION RUTA : " + lista_rutas[i].value!);
      if (lista_rutas[i].value == ruta) {
        //desRuta = lista_rutas[i].value!;
        return i;
      }
    }
    return 0;
  }

  int getPositionFrecuencias(frecuencia) {
    for (int i = 0; i < lista_frecuencias.length; i++) {
      print("POSITION FRECUENCIA : " + lista_frecuencias[i].value!);
      if (lista_frecuencias[i].value == frecuencia) {
        return i;
      }
    }
    return 0;
  }

  _getFechaActual() {
    var date = DateTime.now();
    var year = date.year;
    var month = date.month < 10 ? "0" + date.month.toString() : date.month;
    var day = date.day < 10 ? "0" + date.day.toString() : date.day;
    setState(() {
      _date = year.toString() + "/" + month.toString() + "/" + day.toString();
      _dateImputController.text = _date;
    });
  }

  _getSelectDate(BuildContext context) async {
    DateTime? pickerdate = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(2020),
      lastDate: new DateTime(2050),
      locale: const Locale('es'),
    );
    if (pickerdate != null) {
      setState(() {
        _date = DateFormat('yyyy-MM-dd').format(pickerdate);
        _dateImputController.text = _date;
      });
    }
  }

  _showAlertProgress() async {
    widget._dialog = SimpleFontelicoProgressDialog(
      context: context,
      barrierDimisable: true,
    );
    widget._dialog!.show(
      message:
          positionS == 0 || positionS == 1
              ? 'Despachando....'
              : 'Generando Tarjeta.....',
      type: SimpleFontelicoProgressDialogType.spinner,
    );
  }

  _showAlertDespacho(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Confirmar Despacho",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Container(
            margin: EdgeInsets.only(bottom: 0), // Ajusta el margen inferior
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "¿Desea generar el despacho de la unidad ${_unidad}?",
                  style: const TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  "Fecha: ${_dateImputController.text} ${_timeInputController.text}:00",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  "Ruta: ${desRuta}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  "Frecuencia: ${_frecuencia}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          actions: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Código para realizar el despacho
                      enviarDespacho();
                      Navigator.of(context).pop(); // Cierra el modal
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Color de fondo azul
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: Text('Aceptar'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  updateListaUnidades() async {
    lista_unidad.clear();

    ApiRepositorioUnidadesDespacho service = ApiRepositorioUnidadesDespacho();

    datosBuses = await service.fectchUnidadesDespacho();
    print('Aca datosBuses');
    print(datosBuses);
    datosBuses.datos!.forEach((element) {
      lista_unidad.add(element.codiVehi);
    });
    print('Aca objeto lista_unidad  ${jsonEncode(lista_unidad)}');

    _unidad = datosBuses.datos[0].codiVehi;
  }

  enviarDespacho() async {
    CodeActivacion oC = await widget.oS.readDataPreferenciasEmpresa();
    print("datosBuses : ${jsonEncode(datosBuses.datos[position])}");
    var dispositivo_imei = datosBuses.datos[position].codiDispVehi;
    print("dispositivo_imei : ${dispositivo_imei}");
    var empresa_codigo = oC.data!.codigo.toString();
    print("empresa_codigo : ${oC.data!.codigo}");
    var channel_port = datosBuses.datos[position].puerChnClie;
    print("channel_port : ${channel_port}");
    var dispositivo_tipo = datosBuses.datos[position].idTipoDispVehi;
    print("dispositivo_tipo : ${dispositivo_tipo}");
    print("salida  : ${positionS}");

    var unidad = datosBuses.datos[position].codiVehi;
    var fecha_hora =
        "${_dateImputController.text} ${_timeInputController.text}:00";
    var minutos_antes = 0;
    var ruta = datosRutas.data[positionR].idRuta;
    var frecuencia = datosFrecuencias.data[positionF].idFrec;
    var autoDespachoDifeFrec =
        datosFrecuencias.data[positionF].autoDespachoDifeFrec;
    var salida_diferida = positionS;
    var ruta_letra = datosRutas.data[positionR].letrRuta;
    _showAlertProgress();
    print("autoDespachoDifeFrec : ${autoDespachoDifeFrec}");
    print("unidad  : ${unidad}");
    print("fecha_hora  : ${fecha_hora}");
    print("ruta  : ${ruta}");
    print("frecuencia  : ${frecuencia}");
    ApiRepositorioGenerarDespacho servicio = ApiRepositorioGenerarDespacho();
    var datosDespacho = await servicio.fectchGenerarDespacho(
      dispositivo_imei,
      empresa_codigo,
      channel_port,
      dispositivo_tipo,
      unidad,
      fecha_hora,
      minutos_antes,
      ruta,
      frecuencia,
      salida_diferida,
      ruta_letra,
      autoDespachoDifeFrec,
    );
    print("Aca respuesta" + jsonEncode(datosDespacho));
    widget._dialog!.hide();
    if (datosDespacho.statusCode == 200) {
      _numImputController.clear();
      Alert(
        context: context,
        type: AlertType.success,
        title: "Exito",
        desc: "Despacho enviado",
        buttons: [
          DialogButton(
            color: Colors.blue,
            child: Text(
              "Aceptar",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          ),
        ],
      ).show();
    } else if (datosDespacho.statusCode == 400) {
      Alert(
        context: context,
        type: AlertType.warning,
        title: "Error",
        desc: datosDespacho.msm.toString(),
        buttons: [
          DialogButton(
            color: Colors.blue,
            child: Text(
              "Aceptar",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          ),
        ],
      ).show();
    } else {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Error ",
        desc: "No se envio el despacho",
        buttons: [
          DialogButton(
            color: Colors.blue,
            child: Text(
              "Aceptar",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          ),
        ],
      ).show();
    }
  }

  updateRutaFrecuencia() async {
    CodeActivacion oC = await widget.oS.readDataPreferenciasEmpresa();
    _ruta = oC.data!.codigo == "7mayo" ? "2" : "1";
    print("object ruta 7 mayo " + _ruta);
  }
}
