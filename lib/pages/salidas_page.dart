import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../models/login/login_propietario.dart';
import '../models/salida/salida_user.dart';
import '../models/unidadDespacho/unidad_despacho.dart';
import '../repositories/repo_unidades_despacho.dart';
import '../repositories/repo_user_salida.dart';
import '../repositories/security_data.dart';
import '../utils/colors.dart';
import '../utils/dimens.dart';
import 'newSimulador_page.dart';
import 'report_despacho_page.dart';
import 'simulador.dart';
import '../utils/iconos.dart';

class SalidasPage extends StatefulWidget {
  SalidasPage({Key? key});
  UnidadesDespachoPropietario lista = UnidadesDespachoPropietario();
  SecurityData oS = new SecurityData();
  @override
  _SalidasPageState createState() => _SalidasPageState();
}

class _SalidasPageState extends State<SalidasPage> {
  String propietario = "";
  List<DropdownMenuItem<String>> lista_unidades = [];
  String _unidad = "*";
  int position = 0;
  String _date = "yyyy-mm-dd";
  bool _isHidden = false;
  SalidasAppMovil? datosUserSalida = null;

  TextEditingController _dateInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _readPropietario();
    _getItemDropdownButton();
    _getFechaActual();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
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
                          disabledBorder: OutlineInputBorder(),
                        ),
                        child: DropdownButton<String>(
                          //isDense: true,
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
                              position = _getPosition(_unidad);
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: marginSmallSmall),
                    Flexible(
                      child: TextField(
                        controller: _dateInputController,
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(fontSize: textBigMedium),
                          labelText: 'Fecha',
                          border: OutlineInputBorder(),
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
                          print('OnPress unidad $_unidad');
                          setState(() {
                            datosUserSalida = new SalidasAppMovil(
                              statusCode: null,
                            );
                          });
                          _getSalidas();
                        },
                        icon: Icon(IconBuscar),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Color de fondo azul
                          foregroundColor: colorWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        label: const Text(
                          "Buscar",
                          style: TextStyle(fontSize: textBigMedium),
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
      ),
    );
  }

  Widget listaCard() {
    if (datosUserSalida != null) {
      if (datosUserSalida!.statusCode == null) {
        return SingleChildScrollView(
          child: Column(
            children: [
              cardResuladoShimmer(),
              cardResuladoShimmer(),
              cardResuladoShimmer(),
              cardResuladoShimmer(),
            ],
          ),
        );
      } else if (datosUserSalida!.statusCode == 200 &&
          datosUserSalida!.datos!.length > 0) {
        return _buildCard(datosUserSalida!);
      } else if (datosUserSalida!.statusCode == 200 &&
          datosUserSalida!.datos!.length == 0) {
        return _cardNoData();
      } else if (datosUserSalida!.statusCode == 300) {
        return _cardNoData();
      }
    }
    return Container();
  }

  Widget _buildCard(SalidasAppMovil model) {
    return ListView.builder(
      itemCount: model.datos!.length,
      itemBuilder: (context, index) {
        /*String idSali = model.datos![index].idSaliM.toString();
          String ruta = model.datos![index].descRutaSaliM.toString();
          String frecuencia = model.datos![index].descFrec.toString();
          String hSalida = model.datos![index].horaSaliProgSaliM.toString();
          String hLlegada = model.datos![index].horaLlegProgSaliM.toString();
          String unidad = model.datos![index].codiVehiSaliM.toString();
          String letraRuta = model.datos![index].letraRutaSaliM.toString();
          String desRuta = model.datos![index].descRutaSaliM.toString();
          int vuelSali = model.datos![index].numeVuelSaliM!;*/
        //int estadoSali = model.datos![index].estaSaliM!;
        if (widget.lista != null && widget.lista.datos != null) {
          var datosNum =
              widget.lista.datos!
                  .where(
                    (element) =>
                        element.codiVehi == model.datos![index].codiVehiSaliM,
                  )
                  .toList();
          String dispositivo_imei = datosNum[0].codiDispVehi!;
          int channel_port = datosNum[0].puerChnClie!;
          int dispositivo_tipo = datosNum[0].idTipoDispVehi!;
          String codigoObse = datosNum[0].codiObseObseVehi!;
          return InkWell(
            onTap: () {
              ver_salida_detallePage(
                model.datos![index].codiVehiSaliM,
                model.datos![index].idSaliM,
                model.datos![index].descRutaSaliM,
                model.datos![index].descFrec,
                model.datos![index].horaSaliProgSaliM,
                model.datos![index].horaLlegProgSaliM,
                dispositivo_imei,
                channel_port,
                dispositivo_tipo,
                codigoObse,
              );
            },
            child: Container(
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
                          '[ ${model.datos![index].codiVehiSaliM} ]',
                          style: const TextStyle(
                            fontSize: textBigMedium,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          ' # ${model.datos![index].idSaliM}',
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
                          children: [
                            const Text(
                              "Ruta:",
                              style: TextStyle(
                                fontSize: textMedium,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '${model.datos![index].descRutaSaliM}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
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
                              "Frecuencia:",
                              style: TextStyle(
                                fontSize: textMedium,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '${model.datos![index].descFrec}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
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
                              "Salida:",
                              style: TextStyle(
                                fontSize: textMedium,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '${model.datos![index].horaSaliProgSaliM}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: textMedium,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(width: 30),
                            const Text(
                              "Llegada:",
                              style: TextStyle(
                                fontSize: textMedium,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '${model.datos![index].horaLlegProgSaliM}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
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
                              "Atrasos:",
                              style: TextStyle(
                                fontSize: textMedium,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '${model.datos![index].atrasoFaltas}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: textMedium,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(width: 30),
                            const Text(
                              "Adelantos:",
                              style: TextStyle(
                                fontSize: textMedium,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '${model.datos![index].adelantoFaltas}',
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
                              "Total PEN:",
                              style: TextStyle(
                                fontSize: textMedium,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                '\$ ${model.datos![index].penaCtrlSaliD}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
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
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                final route = MaterialPageRoute(
                                  builder: (context) {
                                    return NewSimulador(
                                      model.datos![index].idSaliM!,
                                      model.datos![index].codiVehiSaliM!,
                                      _dateInputController.text,
                                      model.datos![index].horaSaliProgSaliM!,
                                      model.datos![index].horaLlegProgSaliM!,
                                      model.datos![index].letraRutaSaliM!,
                                      model.datos![index].descRutaSaliM!,
                                      model.datos![index].numeVuelSaliM!,
                                    );
                                  },
                                );
                                Navigator.push(context, route);
                              },
                              icon: const Icon(
                                Icontrazado,
                                color: Colors.blue, // Color del icono azul
                              ),
                              label: const Text(
                                "Recorrido",
                                style: TextStyle(
                                  color: Colors.blue, // Color del texto blanco
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                      Colors.white,
                                    ), // Fondo blanco
                                shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder
                                >(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
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
            ),
          );
        }
      },
    );
  }

  _getSalidas() async {
    ApiRepositorio servicio = ApiRepositorio();
    datosUserSalida = await servicio.fetchUerSalidaList(
      propietario,
      _unidad,
      _dateInputController.text,
    );
    setState(() {});
    readUnidadesDespacho();
  }

  ver_salida_detallePage(
    unidad,
    idSali,
    ruta,
    frecuencia,
    hSalida,
    hLlegada,
    dispositivo_imei,
    channel_port,
    dispositivo_tipo,
    obse,
  ) async {
    final route = MaterialPageRoute(
      builder: (context) {
        return ReportDespachoPage(
          unidad,
          _dateInputController.text,
          idSali,
          ruta,
          frecuencia,
          hSalida,
          hLlegada,
          dispositivo_imei,
          channel_port,
          dispositivo_tipo,
          obse,
        );
      },
    );
    await Navigator.push(context, route);
    _getSalidas();
  }

  _ItemDropdownButton(String value, String desc) {
    return DropdownMenuItem<String>(value: value, child: Text(desc));
  }

  cardResuladoShimmer() {
    return Container(
      height: 195,
      margin: EdgeInsets.only(
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
            color: Colors.white,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [Skelton(height: 20, width: 100)],
            ),
          ),
          Container(
            padding: EdgeInsets.all(marginSmallSmall),
            child: Column(
              children: [
                Row(
                  children: const [
                    Skelton(height: 10, width: 40),
                    SizedBox(width: 10),
                    Expanded(child: Skelton(height: 10, width: 100)),
                  ],
                ),
                Row(
                  children: const [
                    Skelton(height: 10, width: 80),
                    SizedBox(width: 10),
                    Expanded(child: Skelton(height: 10, width: 100)),
                  ],
                ),
                Row(
                  children: const [
                    Skelton(height: 10, width: 50),
                    SizedBox(width: 10),
                    Skelton(height: 10, width: 50),
                    SizedBox(width: 60),
                    Skelton(height: 10, width: 50),
                    SizedBox(width: 10),
                    Skelton(height: 10, width: 50),
                  ],
                ),
                Row(
                  children: const [
                    Skelton(height: 10, width: 50),
                    SizedBox(width: 10),
                    Skelton(height: 10, width: 20),
                    SizedBox(width: 90),
                    Skelton(height: 10, width: 50),
                    SizedBox(width: 10),
                    Skelton(height: 10, width: 20),
                  ],
                ),
                Row(
                  children: const [
                    Skelton(height: 10, width: 100),
                    SizedBox(width: 5),
                    Skelton(height: 10, width: 20),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Skelton(height: 35, width: 100)],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _getItemDropdownButton() async {
    var jsonDataL = await widget.oS.readDataPreferenciasLoginPropietario(
      'dataLoginPropietarioLoginUnidadesd',
    );
    LoginPropietario listabuses = LoginPropietario.fromRawJson(jsonDataL);

    setState(() {
      lista_unidades.add(
        DropdownMenuItem<String>(child: Text('*'), value: '*'),
      );
      listabuses.data!.forEach((element) {
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

  _readPropietario() async {
    propietario = await widget.oS.readDataPreferenciasLoginPropietario(
      'dataLoginPropietarioLoginPropietario',
    );
    print('Propietario getsalida ${propietario}');
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

  int _getPosition(String value) {
    for (var i = 0; i < lista_unidades.length; i++) {
      if (lista_unidades[i].value == value) {
        return i;
      }
    }
    return 0;
  }

  Widget _cardNoData() {
    return !_isHidden
        ? Container(
          width:
              MediaQuery.of(context).size.width > 400
                  ? 400
                  : MediaQuery.of(context).size.width * 0.95,
          margin: const EdgeInsets.symmetric(
            horizontal: marginSmallSmall,
            vertical: marginSmallSmall,
          ),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: colorWhite,
            boxShadow: [boxShadowPersonalizado],
          ),
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No Existen Datos',
                  style: TextStyle(
                    fontSize:
                        MediaQuery.of(context).size.width < 320
                            ? textBig * 0.85
                            : textBig,
                    color: colorBlack,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  _unidad == "*"
                      ? 'Todos los buses en la fecha $_date no tienen datos'
                      : 'El bus $_unidad en la fecha $_date no tiene datos',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: textMedium, color: colorBlack),
                ),
                const SizedBox(height: 6),
                Text(
                  'Por favor verifica la fecha.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: textMedium, color: colorBlack),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _toggleVisibility,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text("Ok"),
                ),
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

  readUnidadesDespacho() async {
    ApiRepositorioUnidadesDespacho service = ApiRepositorioUnidadesDespacho();
    widget.lista = await service.fectchUnidadesDespacho();
    print('Aca datosBuses');
    //print(widget.lista);
    setState(() {});
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
