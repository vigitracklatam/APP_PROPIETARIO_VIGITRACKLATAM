import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../models/conteo/conteo_page.dart';
import '../models/login/login_propietario.dart';
import '../repositories/repo_conteo_page.dart';
import '../repositories/security_data.dart';
import '../utils/colors.dart';
import '../utils/dimens.dart';
import '../utils/iconos.dart';
import 'package:intl/intl.dart';

import 'produccion_page.dart';

class ConteoPage extends StatefulWidget {
  ConteoPage({super.key});
  SecurityData oS = new SecurityData();

  @override
  State<ConteoPage> createState() => _ConteoPageState();
}

class _ConteoPageState extends State<ConteoPage> {
  List<DropdownMenuItem<String>> lista_unidades = [];
  String _unidad = "";
  String _ruta = "*";
  int position = 0;
  String _date = "yyyy-mm-dd";
  TextEditingController _dateImputController = new TextEditingController();
  TextEditingController _timeStartImputController = new TextEditingController();
  TextEditingController _timeEndImputController = new TextEditingController();
  bool _isHidden = false;
  bool _isTime = false;
  int _subidaTot = 0;
  double _totalDinero = 0;
  ConteoPageAppMovil? datosConteo = null;

  @override
  void initState() {
    super.initState();
    _ItemDropdownButton();
    _getFechaActual();
    setState(() {
      _timeStartImputController.text = "05:00";
      _timeEndImputController.text = "23:59";
    });
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final route = MaterialPageRoute(
              builder: (context) {
                return Produccion(
                  _unidad,
                  _date,
                  'Todas las líneas',
                  _subidaTot.toString(),
                  _totalDinero.toString(),
                );
              },
            );
            Navigator.push(context, route);
          },
          backgroundColor: Colors.red,
          child: const Icon(IconDolar, size: 40, color: Colors.white),
        ),
        backgroundColor: colorGrey,
        resizeToAvoidBottomInset: false,
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
                          horizontal: 10,
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
                            lista_unidades.isNotEmpty
                                ? lista_unidades[position].value
                                : _unidad,
                        items: lista_unidades,
                        onChanged: (String? value) {
                          setState(() {
                            _unidad = value!;
                            position = getPosition(_unidad);
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: marginSmallSmall),
                  Expanded(
                    child: TextField(
                      controller: _dateImputController,
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _timeStartImputController,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(fontSize: textBigMedium),
                        labelText: 'Hora Inicial',
                        //errorText: 'Error mundo',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(IconTiempoInicio),
                      ),
                      onTap: () {
                        _isTime = !_isTime;
                        FocusScope.of(context).requestFocus(new FocusNode());
                        _showTimePicker(context, _timeStartImputController);
                      },
                    ),
                  ),
                  const SizedBox(width: marginSmallSmall),
                  Expanded(
                    child: TextField(
                      controller: _timeEndImputController,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(fontSize: textBigMedium),
                        labelText: 'Hora Final',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(IconTiempoFin),
                      ),
                      onTap: () {
                        _isTime = !_isTime;
                        FocusScope.of(context).requestFocus(new FocusNode());
                        _showTimePicker(context, _timeEndImputController);
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
                        _isHidden = false;
                        setState(() {
                          datosConteo = new ConteoPageAppMovil(
                            statusCode: null,
                          );
                        });
                        _getdatoConteo();
                      },
                      icon: const Icon(IconBuscar, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            5,
                          ), // Establecer borde de 5
                        ),
                        backgroundColor:
                            Colors.blue, // Establecer el fondo azul
                      ),
                      label: const Text(
                        "Buscar",
                        style: TextStyle(
                          fontSize: textBigMedium,
                          color: Colors.white, // Establecer letras blancas
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: marginSmall),
            Flexible(child: listaCard()),
          ],
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
        _unidad = listabuses.data!.elementAt(0).codiVehiObseVehi!;
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

  int getPosition(unidad) {
    for (int i = 0; i < lista_unidades.length; i++) {
      print("POSITION UNIDAD : " + lista_unidades[i].value!);
      if (lista_unidades[i].value == unidad) {
        return i;
      }
    }
    return 0;
  }

  _getSelectDate(BuildContext context) async {
    DateTime? pickerdate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
      locale: const Locale('es'),
    );
    if (pickerdate != null) {
      setState(() {
        _dateImputController.text = DateFormat('yyyy-MM-dd').format(pickerdate);
      });
    }
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

  cardShimmer() {
    return Container(
      height: 180,
      margin: const EdgeInsets.only(
        right: marginSmallSmall,
        left: marginSmallSmall,
        bottom: marginSmallSmall,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: colorWhite,
        boxShadow: [boxShadowPersonalizado],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 36,
            color: Colors.blue,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Unidad',
                  style: TextStyle(
                    fontSize: textBigMedium,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(marginSmallSmall),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: const [
                    Text(
                      "Numero Puerta",
                      style: TextStyle(
                        fontSize: textMedium,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Subidas",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: textMedium,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Skelton(height: 10, width: 60),
                    Skelton(height: 10, width: 20),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Skelton(height: 10, width: 60),
                    Skelton(height: 10, width: 20),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Skelton(height: 10, width: 60),
                    Skelton(height: 10, width: 20),
                  ],
                ),
                const SizedBox(height: 5),
                const Divider(thickness: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Skelton(height: 20, width: 90),
                    Skelton(height: 10, width: 30),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, ConteoPageAppMovil model) {
    print('_buildCard todo datos >>>>>>>>><<<<<<<< ${jsonEncode(model.datos)}');
    return ListView.builder(
      itemCount: model.datos!.length,
      itemBuilder: (context, index) {
        _subidaTot = model.datos![index].totalSubidas!;
        return Container(
          margin: const EdgeInsets.only(
            right: marginSmallSmall,
            left: marginSmallSmall,
            bottom: marginSmallSmall,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: colorWhite,
            boxShadow: [boxShadowPersonalizado],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 36,
                color: Colors.blue,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Unidad ${_unidad}',
                      style: const TextStyle(
                        fontSize: textBigMedium,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(marginSmallSmall),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: const [
                        Text(
                          "Numero Puerta",
                          style: TextStyle(
                            fontSize: textMedium,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Subidas",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: textMedium,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "Puerta 1",
                          style: TextStyle(
                            fontSize: textMedium,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${model.datos![index].subida1}',
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              fontSize: textMedium,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "Puerta 2",
                          style: TextStyle(
                            fontSize: textMedium,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${model.datos![index].subida2}',
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              fontSize: textMedium,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "Puerta 3",
                          style: TextStyle(
                            fontSize: textMedium,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${model.datos![index].subida3}',
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              fontSize: textMedium,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Divider(thickness: 1),
                    Row(
                      children: [
                        const Text(
                          "Total Conteo",
                          style: TextStyle(
                            fontSize: textBigMedium,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${model.datos![index].totalSubidas}',
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              fontSize: textBigMedium,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
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
        );
      },
    );
  }

  _showTimePicker(
    BuildContext context,
    TextEditingController controller,
  ) async {
    print('controller : ${controller.text}');

    // Convierte el texto del controlador en TimeOfDay si es posible
    final timeParts = controller.text.split(":");
    TimeOfDay initialTime;

    if (timeParts.length == 2) {
      final hour = int.tryParse(timeParts[0]);
      final minute = int.tryParse(timeParts[1]);

      if (hour != null && minute != null) {
        initialTime = TimeOfDay(hour: hour, minute: minute);
      } else {
        // Si la conversión falla, usa un tiempo predeterminado
        initialTime = TimeOfDay(hour: 5, minute: 0);
      }
    } else {
      // Usa el tiempo predeterminado si el controlador está vacío o en un formato incorrecto
      initialTime = TimeOfDay(hour: 5, minute: 0);
    }

    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      initialEntryMode: TimePickerEntryMode.inputOnly,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (newTime != null) {
      setState(() {
        final hora = newTime.hour.toString().padLeft(2, '0');
        final minut = newTime.minute.toString().padLeft(2, '0');
        final formattedTime = "$hora:$minut";

        // Actualiza el texto del controlador con el nuevo tiempo seleccionado
        controller.text = formattedTime;
      });
    }
  }

  _cardNoData() {
    return !_isHidden
        ? Container(
          constraints: BoxConstraints(
            minHeight: 150, // Altura mínima
            maxHeight: 200, // Altura máxima
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: marginSmallSmall,
            vertical: marginSmallSmall,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: colorWhite,
            boxShadow: [boxShadowPersonalizado],
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    'No Existen Datos',
                    style: TextStyle(
                      fontSize:
                          MediaQuery.of(context).size.width < 320
                              ? textBig * 0.8
                              : textBig,
                      color: colorBlack,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: Text(
                    'El bus $_unidad en la fecha ${_dateImputController.text} no tiene datos.',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: textMediumSmall, color: colorBlack),
                  ),
                ),
                const SizedBox(height: 4),
                Flexible(
                  child: Text(
                    'Por favor verificar la fecha.',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize:
                          MediaQuery.of(context).size.width < 320
                              ? textMedium * 0.8
                              : textMedium,
                      color: colorBlack,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
               /*  ElevatedButton(
                  onPressed: () {
                    _toggleVisibility();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text("Ok"),
                ), */
              ],
            ),
          ),
        )
        : const SizedBox.shrink();
  }

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  _getdatoConteo() async {
    ApiRepositorioConteoPage servicio = ApiRepositorioConteoPage();
    datosConteo = await servicio.fetchConteoPage(
      _unidad,
      _ruta,
      '${_dateImputController.text} ${_timeStartImputController.text}:00',
      '${_dateImputController.text} ${_timeEndImputController.text}:00',
    );
    setState(() {});
  }

  Widget listaCard() {
    if (datosConteo != null) {
      if (datosConteo!.statusCode == null) {
        return cardShimmer();
      } else if (datosConteo!.statusCode == 200) {
        return _buildCard(context, datosConteo!);
      } else if (datosConteo!.statusCode == 300) {
        return _cardNoData();
      }
    }
    return Container();
  }
}

class Skelton extends StatelessWidget {
  const Skelton({super.key, this.height, this.width});
  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[500]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        margin: const EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.grey.withOpacity(0.25),
        ),
        clipBehavior: Clip.antiAlias,
      ),
    );
  }
}
