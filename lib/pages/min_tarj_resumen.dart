import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../repositories/security_data.dart';
import '../utils/colors.dart';
import '../utils/dimens.dart';
import '../utils/iconos.dart';
import 'min_tarj_resumenpdf.dart';

class MinuTarjeResumen extends StatefulWidget {
  MinuTarjeResumen({super.key});
  SecurityData oS = new SecurityData();
  String propietario = "";
  String _date = "yyyy-mm-dd";
  TextEditingController _dateImputController = TextEditingController();

  @override
  State<MinuTarjeResumen> createState() => _MinuTarjeResumenState();
}

class _MinuTarjeResumenState extends State<MinuTarjeResumen> {
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
                title: Text("Minutos Tarjetas Resumen"),
                elevation: 1,
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              resizeToAvoidBottomInset: false,
              backgroundColor: colorGrey,
              body: Column(children: [
                Container(
                  width: 150,
                  constraints: BoxConstraints(maxWidth: double.infinity),
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
                          print(
                              'Onpres fechaI ${widget._dateImputController.text}');
                          print(
                              'Onpres fechaF ${widget._dateImputController.text}');

                          final route = MaterialPageRoute(builder: (context) {
                            return MinTarjetasPDFResumido(
                              widget._dateImputController.text,
                              widget._dateImputController.text,
                            );
                          });
                          Navigator.pushReplacement(context, route);
                        },
                        icon: Icon(IconBuscar),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue, // Texto blanco
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10), // Radio de 10
                          ),
                        ),
                        label: const Text(
                          "Buscar",
                          style: TextStyle(fontSize: textBigMedium),
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
}
