import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

import '../models/login/login_propietario.dart';
import '../models/produccion_update/produccion.dart';
import '../repositories/repo_produccion.dart';
import '../repositories/security_data.dart';
import '../utils/dimens.dart';
import '../utils/iconos.dart';

class ProduccionBasica extends StatefulWidget {
  SecurityData oS = new SecurityData();
  @override
  _ProduccionState createState() => _ProduccionState();
}

class _ProduccionState extends State<ProduccionBasica> {
  TextEditingController _mTextEditingControllerChofer = TextEditingController();
  TextEditingController _mTextEditingControllerNameChofer =
      TextEditingController();
  TextEditingController _mTextEditingControllerAyudante =
      TextEditingController();
  TextEditingController _mTextEditingControllerCombustible =
      TextEditingController();
  TextEditingController _mTextEditingControllerAlimentacion =
      TextEditingController();
  TextEditingController _mTextEditingControllerOtros = TextEditingController();
  TextEditingController _mTextEditingControllerIngresos =
      TextEditingController();
  TextEditingController _mTextEditingControllerTotal = TextEditingController();
  TextEditingController _mTextEditingControllerTotalEgresos =
      TextEditingController();

  List<DropdownMenuItem<String>> lista_unidades = [];
  int position = 0;
  String _date = "yyyy-mm-dd";
  String _unidad = "*";
  TextEditingController _dateInputController = TextEditingController();

  ProduccionSinConteoAppMovil? datosProduccion = null;
  SimpleFontelicoProgressDialog? _dialog;
  String usuarioObse = "";

  @override
  void initState() {
    super.initState();
    _getItemDropdownButton();
    _getFechaActual();
    _dialog = SimpleFontelicoProgressDialog(
      context: context,
      barrierDimisable: true,
    );
    _readUser();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10, left: 10),
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [SizedBox(height: 15), _formulario()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _formulario() {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  disabledBorder: OutlineInputBorder(),
                ),
                child: DropdownButton<String>(
                  isExpanded:
                      true, // Asegura que se expanda dentro del contenedor
                  underline: Container(height: 0, color: Colors.transparent),
                  value:
                      lista_unidades.isNotEmpty
                          ? lista_unidades[position].value
                          : _unidad,
                  items: lista_unidades,
                  onChanged: (String? value) {
                    setState(() {
                      _unidad = value!;
                      position = _getPosition(_unidad);
                    });
                  },
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: TextField(
                controller: _dateInputController,
                enabled: false,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(fontSize: textBigMedium),
                  labelText: 'Fecha',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  prefixIcon: Icon(IconCalendario),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _getSelectDate(context);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft, // Alinea el texto a la izquierda
          margin: EdgeInsets.only(left: 10.0),
          child: Text(
            'Conductor',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _mTextEditingControllerNameChofer,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: 'Nombre',
            hintText: "Pedro Mite",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            prefixIcon: Icon(Icons.assignment_ind_rounded),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft, // Alinea el texto a la izquierda
          margin: EdgeInsets.only(left: 10.0),
          child: Text(
            'Ingresos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: TextFormField(
                controller: _mTextEditingControllerIngresos,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Ingresos',
                  hintText: "0.0",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  prefixIcon: Icon(Icons.attach_money),
                ),
              ),
            ),
            Container(width: MediaQuery.of(context).size.width * 0.45),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft, // Alinea el texto a la izquierda
          margin: EdgeInsets.only(left: 10.0),
          child: Text(
            'Gastos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: TextFormField(
                controller: _mTextEditingControllerChofer,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Chofer',
                  hintText: "0.0",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  prefixIcon: Icon(Icons.perm_identity_outlined),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: TextFormField(
                controller: _mTextEditingControllerAyudante,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Ayudante',
                  hintText: "0.0",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  prefixIcon: Icon(Icons.assistant),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: TextFormField(
                controller: _mTextEditingControllerCombustible,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Combustible',
                  hintText: "0.0",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  prefixIcon: Icon(Icons.local_gas_station),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: TextFormField(
                controller: _mTextEditingControllerAlimentacion,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Alimentación',
                  hintText: "0.0",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  prefixIcon: Icon(Icons.food_bank_outlined),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: TextFormField(
                controller: _mTextEditingControllerOtros,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Otros',
                  hintText: "0.0",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  prefixIcon: Icon(Icons.attach_money),
                ),
              ),
            ),
            Container(width: MediaQuery.of(context).size.width * 0.45),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: TextFormField(
                controller: _mTextEditingControllerTotalEgresos,
                decoration: InputDecoration(
                  labelText: 'Total Gastos',
                  enabled: false,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  prefixIcon: Icon(Icons.attach_money),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: TextFormField(
                controller: _mTextEditingControllerTotal,
                decoration: InputDecoration(
                  enabled: false,
                  labelText: 'Total producción',
                  hintText: "0.0",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  prefixIcon: Icon(Icons.attach_money),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: ElevatedButton.icon(
                onPressed: () {
                  _calcularProduccion();
                },
                icon: const Icon(Icons.calculate_outlined, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  elevation: 1,
                  backgroundColor: HexColor("#5AC6DE"),
                  minimumSize: Size(
                    MediaQuery.of(context).size.width * 0.50,
                    42,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                label: const Text(
                  'Calcular',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: ElevatedButton.icon(
                onPressed: () {
                  _cancelar();
                },
                icon: const Icon(Icons.cancel_outlined, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  elevation: 1,
                  backgroundColor: HexColor("#FF0000"),
                  minimumSize: Size(
                    MediaQuery.of(context).size.width * 0.50,
                    42,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                label: const Text(
                  'Cancelar',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: ElevatedButton.icon(
                onPressed: () {
                  _mostrarDialogoEnviar();
                },
                icon: const Icon(Icons.send, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  elevation: 1,
                  backgroundColor: Colors.green,
                  minimumSize: Size(
                    MediaQuery.of(context).size.width * 0.40,
                    42,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                label: const Text(
                  'Enviar',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  _calcularProduccion() {
    _mTextEditingControllerChofer.text == ""
        ? _mTextEditingControllerChofer.text = "0"
        : _mTextEditingControllerChofer.text;
    _mTextEditingControllerAyudante.text == ""
        ? _mTextEditingControllerAyudante.text = "0"
        : _mTextEditingControllerAyudante.text;
    _mTextEditingControllerCombustible.text == ""
        ? _mTextEditingControllerCombustible.text = "0"
        : _mTextEditingControllerCombustible.text;
    _mTextEditingControllerAlimentacion.text == ""
        ? _mTextEditingControllerAlimentacion.text = "0"
        : _mTextEditingControllerAlimentacion.text;
    _mTextEditingControllerOtros.text == ""
        ? _mTextEditingControllerOtros.text = "0"
        : _mTextEditingControllerOtros.text;
    _mTextEditingControllerIngresos.text == ""
        ? _mTextEditingControllerIngresos.text = "0"
        : _mTextEditingControllerIngresos.text;
    _mTextEditingControllerTotal.text = (double.parse(
              _mTextEditingControllerIngresos.text,
            ) -
            double.parse(_mTextEditingControllerChofer.text) -
            double.parse(_mTextEditingControllerAyudante.text) -
            double.parse(_mTextEditingControllerCombustible.text) -
            double.parse(_mTextEditingControllerAlimentacion.text) -
            double.parse(_mTextEditingControllerOtros.text))
        .toStringAsFixed(2);
    _mTextEditingControllerTotalEgresos.text = (double.parse(
              _mTextEditingControllerChofer.text,
            ) +
            double.parse(_mTextEditingControllerAyudante.text) +
            double.parse(_mTextEditingControllerCombustible.text) +
            double.parse(_mTextEditingControllerAlimentacion.text) +
            double.parse(_mTextEditingControllerOtros.text))
        .toStringAsFixed(2);
  }

  _cancelar() {
    _mTextEditingControllerChofer.clear();
    _mTextEditingControllerAyudante.clear();
    _mTextEditingControllerCombustible.clear();
    _mTextEditingControllerAlimentacion.clear();
    _mTextEditingControllerOtros.clear();
    _mTextEditingControllerIngresos.clear();
    _mTextEditingControllerNameChofer.clear();
    _mTextEditingControllerTotalEgresos.text = "0.0";
    _mTextEditingControllerTotal.text = "0.0";
  }

  _getItemDropdownButton() async {
    var jsonDataL = await widget.oS.readDataPreferenciasLoginPropietario(
      'dataLoginPropietarioLoginUnidadesd',
    );
    LoginPropietario listabuses = LoginPropietario.fromRawJson(jsonDataL);

    setState(() {
      lista_unidades.clear(); // Limpia la lista antes de agregar elementos
      listabuses.data!.forEach((element) {
        lista_unidades.add(
          DropdownMenuItem<String>(
            value: element.codiVehiObseVehi,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset('assets/online_lista.png', width: 19),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Text(' ${element.codiVehiObseVehi}'),
                ),
              ],
            ),
          ),
        );
        if (lista_unidades.isNotEmpty) {
          _unidad = lista_unidades.first.value!;
        }
      });
    });
  }

  int _getPosition(String value) {
    for (var i = 0; i < lista_unidades.length; i++) {
      if (lista_unidades[i].value == value) {
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
      _dateInputController.text = _date;
    });
  }

  _getSelectDate(BuildContext context) async {
    DateTime? _datePick = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
      locale: const Locale('es'),
    );

    if (_datePick != null) {
      setState(() {
        _date = DateFormat('yyyy-MM-dd').format(_datePick);
        _dateInputController.text = _date;
      });
    }
  }

  void _mostrarDialogoEnviar() {
    if (_mTextEditingControllerTotal.text.isEmpty ||
        _mTextEditingControllerTotal.text == "0.0" ||
        _mTextEditingControllerIngresos.text.isEmpty ||
        _mTextEditingControllerIngresos.text == "0.0" ||
        _mTextEditingControllerNameChofer.text.isEmpty) {
      _mostrarAlertaSinDatos(
        'Faltan Datos',
        'Por favor ingrese todos los datos',
      );
    } else {
      // Si el campo Total tiene información, mostrar el AlertDialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text(
              '¿Desea enviar la producción?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fecha: ${_dateInputController.text}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text('Unidad: $_unidad', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text(
                    'Nombre: ${_mTextEditingControllerNameChofer.text}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ingresos: \$ ${_mTextEditingControllerIngresos.text}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Gastos: \$ ${_mTextEditingControllerTotalEgresos.text}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Producción: \$ ${_mTextEditingControllerTotal.text}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
            actions: [
              // Fila con los botones de Cancelar y Enviar
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.end, // Los pone en el extremo derecho
                children: [
                  // Botón Cancelar
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Cierra el dialogo
                      },
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Centra el contenido
                        children: [
                          Icon(Icons.close, color: Colors.red),
                          SizedBox(width: 8),
                          Text(
                            'Cancelar',
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Espacio entre los botones
                  // Botón Enviar
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // Aquí puedes manejar el envío si es necesario
                        print("Boton enviar");
                        _enviarProduccion();
                        //Navigator.of(context).pop(); // Cierra el dialogo
                      },
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Centra el contenido
                        children: [
                          Icon(Icons.send, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Enviar',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _enviarProduccion() async {
    print("Función enviar producción");

    // Mostrar el diálogo de progreso
    _showAlertProgress();

    try {
      final ApiProduccion servicio = ApiProduccion();

      // Validar y convertir valores
      final String nameChofer = _mTextEditingControllerNameChofer.text;
      final double gChofer =
          double.tryParse(_mTextEditingControllerChofer.text) ?? 0.0;
      final double gAyudante =
          double.tryParse(_mTextEditingControllerAyudante.text) ?? 0.0;
      final double gCombustible =
          double.tryParse(_mTextEditingControllerCombustible.text) ?? 0.0;
      final double gAlimentacion =
          double.tryParse(_mTextEditingControllerAlimentacion.text) ?? 0.0;
      final double gOtros =
          double.tryParse(_mTextEditingControllerOtros.text) ?? 0.0;
      final double gIngresos =
          double.tryParse(_mTextEditingControllerIngresos.text) ?? 0.0;
      final double tGastos =
          double.tryParse(_mTextEditingControllerTotalEgresos.text) ?? 0.0;
      final double produccion =
          double.tryParse(_mTextEditingControllerTotal.text) ?? 0.0;
      final String fecha = _dateInputController.text;

      // Llamar a la API
      datosProduccion = await servicio.fetchProduccion(
        nameChofer,
        gChofer,
        gAyudante,
        gCombustible,
        gAlimentacion,
        gOtros,
        gIngresos,
        tGastos,
        produccion,
        _unidad,
        fecha,
        usuarioObse,
      );

      // Ocultar el diálogo de progreso
      _hideAlertProgress();

      // Manejar la respuesta
      if (datosProduccion?.statusCode == 200) {
        final int changedRows = datosProduccion?.datos?.first?.changedRows ?? 0;

        if (changedRows == 1) {
          _mostrarAlerta('Producción', 'Se envió correctamente la producción.');
        } else {
          _mostrarAlerta(
            'Producción',
            'Ya existe la producción de este día.\n O no existen despacho para esa unidad',
          );
        }
      } else {
        _mostrarAlerta('Producción', 'No se pudo enviar la producción.');
      }
    } catch (e) {
      print("Error en _enviarProduccion: $e");
      _mostrarAlerta('Error', 'Ocurrió un error inesperado.');
    } finally {
      // Asegurarse de cerrar el diálogo de progreso en cualquier caso
      _hideAlertProgress();
    }
  }

  /// Mostrar el diálogo de progreso
  void _showAlertProgress() {
    _dialog?.show(
      message: 'Enviando Producción...',
      type: SimpleFontelicoProgressDialogType.spinner,
    );
  }

  /// Ocultar el diálogo de progreso
  void _hideAlertProgress() {
    _dialog?.hide();
  }

  void _mostrarAlerta(String titulo, String contenido) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(contenido),
          actions: [
            TextButton(
              onPressed: () {
                cerrarModal(context); // Cierra el diálogo
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarAlertaSinDatos(String titulo, String contenido) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(contenido),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  cerrarModal(context) {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  _readUser() async {
    usuarioObse = await widget.oS.readDataPreferenciasLoginPropietario(
      'dataLoginPropietarioLoginUsuario',
    );
    //print('Data del usuario >>>>> ${usuarioObse}');
  }
}
