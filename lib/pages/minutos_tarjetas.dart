import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/login/login_propietario.dart';
import '../repositories/security_data.dart';
import '../utils/colors.dart';
import '../utils/dimens.dart';
import '../utils/iconos.dart';
import 'mintarjetapdf.dart';

class MinutosTarjetas extends StatefulWidget {
  MinutosTarjetas({super.key});
  SecurityData oS = new SecurityData();
  String propietario = "";
  List<DropdownMenuItem<String>> lista_unidades = [];
  String _unidad = "";

  int position = 0;
  String _date = "yyyy-mm-dd";
  TextEditingController _dateImputController = TextEditingController();

  @override
  State<MinutosTarjetas> createState() => _MinutosTarjetasState();
}

class _MinutosTarjetasState extends State<MinutosTarjetas> {
  @override
  void initState() {
    _ItemDropdownButton();
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
            title: Text("Minutos Tarjetas"),
            elevation: 1,
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          resizeToAvoidBottomInset: false,
          backgroundColor: colorGrey,
          body: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  right: marginSmallSmall,
                  left: marginSmallSmall,
                  top: marginSmallSmall,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
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
                              widget.lista_unidades.isNotEmpty
                                  ? widget.lista_unidades[widget.position].value
                                  : widget._unidad,
                          items: widget.lista_unidades,
                          onChanged: (String? value) {
                            setState(() {
                              widget._unidad = value!;
                              widget.position = getPosition(widget._unidad);
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: marginSmallSmall),
                    Flexible(
                      child: TextField(
                        controller: widget._dateImputController,
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(fontSize: textBigMedium),
                          labelText: 'Fecha',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(IconCalendario),
                        ),
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          _getSelectDate(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  right: marginSmallSmall,
                  left: marginSmallSmall,
                  top: marginSmallSmall,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          print('Onpres unidad ${widget._unidad}');
                          print(
                            'Onpres fechaI ${widget._dateImputController.text}',
                          );
                          print(
                            'Onpres fechaF ${widget._dateImputController.text}',
                          );

                          final route = MaterialPageRoute(
                            builder: (context) {
                              return MinTarjetasPDF(
                                widget._dateImputController.text,
                                widget._dateImputController.text,
                                widget._unidad,
                              );
                            },
                          );
                          Navigator.push(context, route);
                        },
                        icon: const Icon(IconBuscar, color: Colors.white),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          backgroundColor: Colors.blue,
                        ),
                        label: const Text(
                          "Buscar",
                          style: TextStyle(
                            fontSize: textBigMedium,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: marginSmall),
            ],
          ),
        ),
      ),
    );
  }

  _ItemDropdownButton() async {
    var jsonDataL = await widget.oS.readDataPreferenciasLoginPropietario(
      'dataLoginPropietarioLoginUnidadesd',
    );
    LoginPropietario listabuses = LoginPropietario.fromRawJson(jsonDataL);

    setState(() {
      listabuses.data!.forEach((element) {
        widget._unidad = listabuses.data!.elementAt(0).codiVehiObseVehi!;
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
      'dataLoginPropietarioLoginUsuario',
    );
    print('Propietario getsalida ${widget.propietario}');
  }
}
