import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../repositories/security_data.dart';
import '../utils/colors.dart';
import '../utils/dimens.dart';
import '../utils/iconos.dart';
import 'min_tar_vuel_resumenpdf.dart';

class MinTarjetasVuelResumen extends StatefulWidget {
  MinTarjetasVuelResumen({super.key});
  SecurityData oS = new SecurityData();
  String propietario = "";
  List<DropdownMenuItem<String>> lista_unidades = [];
  String _unidad = "*";

  int position = 0;
  String _date = "yyyy-mm-dd";
  TextEditingController _dateImputController = TextEditingController();
  @override
  State<MinTarjetasVuelResumen> createState() => _nameState();
}

class _nameState extends State<MinTarjetasVuelResumen> {
  @override
  void initState() {
    _getFechaActual();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: SafeArea(
          child: Scaffold(
              appBar: AppBar(
                title: Text("Minutos Tarjetas Vueltas Resumen"),
                elevation: 1,
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              resizeToAvoidBottomInset: false,
              backgroundColor: colorGrey,
              body: Column(children: [
                Container(
                  margin: const EdgeInsets.only(
                      right: marginSmallSmall,
                      left: marginSmallSmall,
                      top: marginSmallSmall),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                          child: TextField(
                        controller: widget._dateImputController,
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(fontSize: textBigMedium),
                          labelText: 'Fecha',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            IconCalendario,
                          ),
                        ),
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          _getSelectDate(context);
                        },
                      )),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      right: marginSmallSmall,
                      left: marginSmallSmall,
                      top: marginSmallSmall),
                  child: Row(
                    children: [
                      Expanded(
                          child: ElevatedButton.icon(
                        onPressed: () {
                          print('Onpres unidad ${widget._unidad}');
                          print(
                              'Onpres fechaI ${widget._dateImputController.text}');
                          print(
                              'Onpres fechaF ${widget._dateImputController.text}');

                          final route = MaterialPageRoute(builder: (context) {
                            return MinTarjetasPDFResumido_Vuelta(
                                widget._dateImputController.text,
                                widget._dateImputController.text);
                          });
                          Navigator.push(context, route);
                        },
                        icon: const Icon(
                          IconBuscar,
                          color: Colors.white,
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        label: const Text(
                          "Buscar",
                          style: TextStyle(
                            fontSize: textBigMedium,
                            color: Colors.white, // Texto azul
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: marginSmall,
                ),
              ]))),
    );
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
        widget._date = DateFormat('yyyy-MM-dd').format(pickerdate);
        widget._dateImputController.text = widget._date;
      });
    }
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

  _getFechaActual() {
    var date = DateTime.now();
    var year = date.year;
    var month = date.month < 10 ? "0" + date.month.toString() : date.month;
    var day = date.day < 10 ? "0" + date.day.toString() : date.day;
    setState(() {
      widget._date =
          year.toString() + "/" + month.toString() + "/" + day.toString();
      widget._dateImputController.text = widget._date;
    });
  }

  _readPropietario() async {
    widget.propietario = await widget.oS.readDataPreferenciasLoginPropietario(
        'dataLoginPropietarioLoginUsuario');
    print('Propietario getsalida ${widget.propietario}');
  }
}
