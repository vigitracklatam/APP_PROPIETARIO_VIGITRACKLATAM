import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/salida/data_salida_user_detalle.dart';
import '../models/salida/salida_user_detalle.dart';
import '../repositories/repo_user_salida_detalle.dart';
import '../utils/colors.dart';
import '../utils/dimens.dart';
import '../utils/iconos.dart';

class ReportDespachoPage extends StatefulWidget {
  String? _unidad;
  String? _fecha;
  int? _idSali;
  String? _ruta;
  String? _frecuencia;
  String? _hLlegada;
  String? _hSalida;
  String? _dispositivo_imei;
  int? _channel_port;
  int? _dispositivo_tipo;
  String? _codigoObse;
  List<DatoSalidaUserDetalle>? mList;
  ReportDespachoPage(
    unidad,
    fecha,
    idSali,
    ruta,
    frecuencia,
    hSalida,
    hLlegada,
    dispositivo_imei,
    channel_port,
    dispositivo_tipo,
    codigoObse, {
    super.key,
  }) : this._unidad = unidad,
       this._fecha = fecha,
       this._idSali = idSali,
       this._ruta = ruta,
       this._frecuencia = frecuencia,
       this._hSalida = hSalida,
       this._hLlegada = hLlegada,
       this._dispositivo_imei = dispositivo_imei,
       this._channel_port = channel_port,
       this._dispositivo_tipo = dispositivo_tipo,
       this._codigoObse = codigoObse;

  @override
  State<ReportDespachoPage> createState() => _ReportDespachoPageState();
}

class _ReportDespachoPageState extends State<ReportDespachoPage> {
  double sum = 0.0;
  int sumCalf = 0;
  List<TableRow> mListaElement = [];
  SalidasDetalleAppMovil? datoUserSalidaDetalle = null;

  @override
  void initState() {
    setState(() {
      datoUserSalidaDetalle = new SalidasDetalleAppMovil(statusCode: null);
    });
    _getDetalleDespacho();
    sumCalf = 0;
    sum = 0;
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    sumCalf = 0;
    sum = 0;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Reporte de Salida"),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Divider(height: 0.5, color: Colors.black),
            Container(child: _headerTable()),
            const Divider(height: 1, color: Colors.black),
            Flexible(child: listaDetalle()),
          ],
        ),
      ),
    );
  }

  Widget _headerTable() {
    return Container(
      decoration: BoxDecoration(
        //borderRadius: BorderRadius.circular(5),
        color: colorWhite,
        boxShadow: [boxShadowPersonalizado],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.blue,
            child: Column(
              children: [
                Text(
                  'Unidad : ${widget._unidad}',
                  style: const TextStyle(
                    fontSize: textBigMedium,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      "Ruta:",
                      style: TextStyle(
                        fontSize: textMedium,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${widget._ruta}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: textMedium,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
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
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${widget._frecuencia}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: textMedium,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "Fecha:",
                      style: TextStyle(
                        fontSize: textMedium,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${widget._fecha}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: textMedium,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "H Salida:",
                      style: TextStyle(
                        fontSize: textMedium,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${widget._hSalida}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: textMedium,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 30),
                    const Text(
                      "H Llegada:",
                      style: TextStyle(
                        fontSize: textMedium,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${widget._hLlegada}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: textMedium,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
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
  }

  Widget _footerTable() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(5),
          color: Colors.blue,
          child: Column(
            children: [
              Text(
                "Total Marcado : $sumCalf",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Total a pagar: \$ $sum ",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  _getElement<Widget>(BuildContext context, SalidasDetalleAppMovil model) {
    widget.mList = model.datos;
    print(
      'ACA model getElement _______________________________________________________ ${jsonEncode(model.datos)}',
    );
    List<TableRow> oL = [];
    oL.add(
      TableRow(
        children: [
          TableCell(
            child: Container(
              padding: EdgeInsets.only(left: 0, top: 5, right: 0, bottom: 5),
              color: Colors.grey,
              child: const Text(
                "Ctrl",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: textMedium,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          TableCell(
            child: Container(
              padding: EdgeInsets.only(left: 0, top: 5, right: 0, bottom: 5),
              color: Colors.grey,
              child: const Text(
                "Prog",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: textMedium,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          TableCell(
            child: Container(
              padding: EdgeInsets.only(left: 0, top: 5, right: 0, bottom: 5),
              color: Colors.grey,
              child: const Text(
                "Marca",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: textMedium,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          TableCell(
            child: Container(
              padding: EdgeInsets.only(left: 0, top: 5, right: 0, bottom: 5),
              color: Colors.grey,
              child: const Text(
                "Calif",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: textMedium,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          TableCell(
            child: Container(
              padding: EdgeInsets.only(left: 0, top: 5, right: 0, bottom: 5),
              color: Colors.grey,
              child: const Text(
                "PEN",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: textMedium,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
    print(
      'ACA widget.mlist getElement >>><<<<1>>><<<< ${jsonEncode(widget.mList)}',
    );
    if (widget.mList != null && widget.mList!.length > 0) {
      for (var item in widget.mList!) {
        print('Aca items faltasSalid salidas ${item.faltSaliD}');
        if (item.faltSaliD != null && item.penaCtrlSaliD != "REF") {
          if (item.faltSaliD! > 0) {
            sumCalf = item.faltSaliD! + sumCalf;
          }
          sum = double.parse(
            (double.parse(item.penaCtrlSaliD!) + sum).toStringAsFixed(2),
          );
        }
      }
    }

    if (widget.mList != null && widget.mList!.length > 0) {
      int cont = 0;
      //Color colorText;
      for (var item in widget.mList!) {
        Color colorText = Colors.black;
        Color bgcolor = Colors.white;
        cont++;
        if (item.faltSaliD != null && item.faltSaliD! > 0) {
          colorText = Colors.red;
          bgcolor;
        } else if (item.horaMarcSaliD == null ||
            item.horaMarcSaliD == "00:00:00") {
          colorText;
          bgcolor = Colors.green.shade100;
        } else {
          colorText;
          bgcolor;
        }
        const Divider(height: 1, color: Colors.black);
        var oE = TableRow(
          children: [
            Container(
              color: bgcolor,
              child: Center(
                child: Text(
                  item.codiCtrlSaliD!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colorText),
                ),
              ),
            ),
            Container(
              color: bgcolor,
              child: Center(
                child: Text(
                  item.horaProgSaliD!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colorText),
                ),
              ),
            ),
            Container(
              color: bgcolor,
              child: Center(
                child: Text(
                  item.horaMarcSaliD == null || item.horaMarcSaliD == "00:00:00"
                      ? ' '
                      : item.horaMarcSaliD!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colorText),
                ),
              ),
            ),
            Container(
              color: bgcolor,
              child: Center(
                child: Text(
                  item.faltSaliD == null || item.horaMarcSaliD == "00:00:00"
                      ? ' '
                      : item.faltSaliD.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colorText),
                ),
              ),
            ),
            Container(
              color: bgcolor,
              child: Center(
                child: Text(
                  item.isCtrlRefeSaliD == null ||
                          item.horaMarcSaliD == "00:00:00" ||
                          item.horaMarcSaliD == null
                      ? ''
                      : item.isCtrlRefeSaliD == 1
                      ? "REF"
                      : item.penaCtrlSaliD == null ||
                          item.penaCtrlSaliD! == '0.00'
                      ? ''
                      : item.penaCtrlSaliD!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colorText),
                ),
              ),
            ),
          ],
        );
        oL.add(oE);
      }
    }

    mListaElement = oL;

    return mListaElement;
  }

  _getDetalleDespacho() async {
    ApiRepositorioSalidaDetalle servicio = ApiRepositorioSalidaDetalle();
    datoUserSalidaDetalle = await servicio.fetchUerSalidaList(widget._idSali);
    print(
      '_getDetalleDespacho() aca detalle user  ${jsonEncode(datoUserSalidaDetalle)}',
    );
    setState(() {});
  }

  Widget listaDetalle() {
    print('listaDetalle() aca detalle user');

    if (datoUserSalidaDetalle != null) {
      print('listaDetalle() aca detalle user  !=null');
      if (datoUserSalidaDetalle!.statusCode == null) {
        print('listaDetalle() aca detalle user  =null');
        return Text("Cargando ...");
      } else if (datoUserSalidaDetalle!.statusCode == 200) {
        return Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Table(children: _getElement(context, datoUserSalidaDetalle!)),
                const Divider(height: 1, color: Colors.black),
                _footerTable(),
                const Divider(height: 1, color: Colors.black),
              ],
            ),
          ),
        );
      } else if (datoUserSalidaDetalle!.statusCode == 300) {
        return const Text("Cargando ...");
      }
    }
    return Container();
  }
}
