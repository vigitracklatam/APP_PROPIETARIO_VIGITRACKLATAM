import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Produccion extends StatefulWidget {
  TextEditingController _mTextEditingControllerUnidad = TextEditingController();
  TextEditingController _mTextEditingControllerFecha = TextEditingController();
  TextEditingController _mTextEditingControllerPasajeros =
      TextEditingController();
  TextEditingController _mTextEditingControllerTarifa = TextEditingController();
  TextEditingController _mTextEditingControllerEfectivo =
      TextEditingController();
  TextEditingController _mTextEditingControllerChofer = TextEditingController();
  TextEditingController _mTextEditingControllerAyudante =
      TextEditingController();
  TextEditingController _mTextEditingControllerCombustible =
      TextEditingController();
  TextEditingController _mTextEditingControllerAlimentacion =
      TextEditingController();
  TextEditingController _mTextEditingControllerOtros = TextEditingController();
  TextEditingController _mTextEditingControllerTotal = TextEditingController();
  TextEditingController _mTextEditingControllerTotalEgresos =
      TextEditingController();

  double tarifa = 0.27;

  final String _unidad;
  final String _date;
  final String _ruta;
  final String _conteo;
  final String _efectivo;

  Produccion(String _unidad, String _date, String _ruta, String _conteo,
      String _efectivo)
      : this._unidad = _unidad,
        this._date = _date,
        this._ruta = _ruta,
        this._conteo = _conteo,
        this._efectivo = _efectivo;

  @override
  _ProduccionState createState() => _ProduccionState();
}

class _ProduccionState extends State<Produccion> {
  @override
  void initState() {
    super.initState();
    widget._mTextEditingControllerUnidad.text = widget._unidad;
    widget._mTextEditingControllerFecha.text = widget._date;
    widget._mTextEditingControllerPasajeros.text = widget._conteo;
    widget._mTextEditingControllerTarifa.text = "0.27";
    widget._mTextEditingControllerEfectivo.text =
        (double.parse(widget._conteo) *
                double.parse(widget._mTextEditingControllerTarifa.text))
            .toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Calcular produccion"),
      ),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 7, left: 10, top: 15),
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  _formulario(),
                ],
              ),
            ),
          )
        ],
      ),
    ));
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
                child: TextFormField(
                  controller: widget._mTextEditingControllerUnidad,
                  decoration: InputDecoration(
                    labelText: 'Unidad',
                    enabled: false,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    prefixIcon: Icon(Icons.directions_bus_filled_outlined),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.45,
                child: TextFormField(
                  controller: widget._mTextEditingControllerFecha,
                  decoration: InputDecoration(
                    labelText: 'Fecha',
                    enabled: false,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                ),
              )
            ]),
        const SizedBox(
          height: 15,
        ),
        Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.45,
                child: TextFormField(
                  controller: widget._mTextEditingControllerPasajeros,
                  decoration: InputDecoration(
                      labelText: 'Pasajeros',
                      enabled: false,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      prefixIcon: Icon(Icons.people_outline)),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.45,
                child: TextFormField(
                  controller: widget._mTextEditingControllerTarifa,
                  decoration: InputDecoration(
                      labelText: 'Tarifa',
                      hintText: "0.27",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      prefixIcon: Icon(Icons.attach_money)),
                ),
              ),
            ]),
        const SizedBox(
          height: 15,
        ),
        Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.45,
                child: TextFormField(
                  controller: widget._mTextEditingControllerChofer,
                  decoration: InputDecoration(
                      labelText: 'Chofer',
                      hintText: "0.0",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      prefixIcon: Icon(Icons.perm_identity_outlined)),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.45,
                child: TextFormField(
                  controller: widget._mTextEditingControllerAyudante,
                  decoration: InputDecoration(
                      labelText: 'Ayudante',
                      hintText: "0.0",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      prefixIcon: Icon(Icons.assistant)),
                ),
              )
            ]),
        const SizedBox(
          height: 15,
        ),
        Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.45,
                child: TextFormField(
                  controller: widget._mTextEditingControllerCombustible,
                  decoration: InputDecoration(
                      labelText: 'Combustible',
                      hintText: "0.0",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      prefixIcon: Icon(Icons.local_gas_station)),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.45,
                child: TextFormField(
                  controller: widget._mTextEditingControllerAlimentacion,
                  decoration: InputDecoration(
                      labelText: 'Alimentación',
                      hintText: "0.0",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      prefixIcon: Icon(Icons.food_bank_outlined)),
                ),
              )
            ]),
        const SizedBox(
          height: 15,
        ),
        Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.45,
                child: TextFormField(
                  controller: widget._mTextEditingControllerOtros,
                  decoration: InputDecoration(
                      labelText: 'Otros',
                      hintText: "0.0",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      prefixIcon: Icon(Icons.attach_money)),
                ),
              ),
              Container(width: MediaQuery.of(context).size.width * 0.45)
            ]),
        const SizedBox(
          height: 15,
        ),
        Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.45,
                child: TextFormField(
                  controller: widget._mTextEditingControllerTotalEgresos,
                  decoration: InputDecoration(
                      labelText: 'Total Egresos',
                      enabled: false,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      prefixIcon: Icon(Icons.attach_money)),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.45,
                child: TextFormField(
                  controller: widget._mTextEditingControllerTotal,
                  decoration: InputDecoration(
                      enabled: false,
                      labelText: 'Total producción',
                      hintText: "0.0",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      prefixIcon: Icon(Icons.attach_money)),
                ),
              )
            ]),
        const SizedBox(
          height: 10,
        ),
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
                  icon: const Icon(
                    Icons.calculate_outlined,
                    color: Colors.white,
                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: 1,
                      backgroundColor: HexColor("#5AC6DE"),
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.50, 42),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  label: const Text(
                    'Calcular',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: ElevatedButton.icon(
                  onPressed: () {
                    _cancelar();
                  },
                  icon: const Icon(
                    Icons.cancel_outlined,
                    color: Colors.white,
                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: 1,
                      backgroundColor: HexColor("#FF0000"),
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.50, 42),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  label: const Text(
                    'Cancelar',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  )),
            )
          ],
        )
      ],
    );
  }

  _calcularProduccion() {
    widget._mTextEditingControllerTarifa.text == ""
        ? widget._mTextEditingControllerTarifa.text = "0.27"
        : widget._mTextEditingControllerOtros.text;
    widget._mTextEditingControllerChofer.text == ""
        ? widget._mTextEditingControllerChofer.text = "0"
        : widget._mTextEditingControllerChofer.text;
    widget._mTextEditingControllerAyudante.text == ""
        ? widget._mTextEditingControllerAyudante.text = "0"
        : widget._mTextEditingControllerAyudante.text;
    widget._mTextEditingControllerCombustible.text == ""
        ? widget._mTextEditingControllerCombustible.text = "0"
        : widget._mTextEditingControllerCombustible.text;
    widget._mTextEditingControllerAlimentacion.text == ""
        ? widget._mTextEditingControllerAlimentacion.text = "0"
        : widget._mTextEditingControllerAlimentacion.text;
    widget._mTextEditingControllerOtros.text == ""
        ? widget._mTextEditingControllerOtros.text = "0"
        : widget._mTextEditingControllerOtros.text;
    widget._mTextEditingControllerEfectivo.text =
        (double.parse(widget._conteo) *
                double.parse(widget._mTextEditingControllerTarifa.text))
            .toStringAsFixed(2);
    widget._mTextEditingControllerTotal.text =
        (double.parse(widget._mTextEditingControllerEfectivo.text) -
                double.parse(widget._mTextEditingControllerChofer.text) -
                double.parse(widget._mTextEditingControllerAyudante.text) -
                double.parse(widget._mTextEditingControllerCombustible.text) -
                double.parse(widget._mTextEditingControllerAlimentacion.text) -
                double.parse(widget._mTextEditingControllerOtros.text))
            .toStringAsFixed(2);
    widget._mTextEditingControllerTotalEgresos.text =
        (double.parse(widget._mTextEditingControllerChofer.text) +
                double.parse(widget._mTextEditingControllerAyudante.text) +
                double.parse(widget._mTextEditingControllerCombustible.text) +
                double.parse(widget._mTextEditingControllerAlimentacion.text) +
                double.parse(widget._mTextEditingControllerOtros.text))
            .toStringAsFixed(2);
  }

  _cancelar() {
    widget._mTextEditingControllerUnidad.text = widget._unidad;
    widget._mTextEditingControllerFecha.text = widget._date;
    widget._mTextEditingControllerPasajeros.text = widget._conteo;
    widget._mTextEditingControllerTarifa.text = widget.tarifa.toString();
    widget._mTextEditingControllerEfectivo.text = widget._efectivo;
    widget._mTextEditingControllerChofer.clear();
    widget._mTextEditingControllerAyudante.clear();
    widget._mTextEditingControllerCombustible.clear();
    widget._mTextEditingControllerAlimentacion.clear();
    widget._mTextEditingControllerOtros.clear();
    widget._mTextEditingControllerTotalEgresos.text = "0.0";
    widget._mTextEditingControllerTotal.text = "0.0";
  }
}
