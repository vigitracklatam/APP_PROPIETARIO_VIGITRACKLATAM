import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/code_activacion/code_activacion.dart';
import '../models/login/permisos_propietario_model.dart';
import '../models/minutos_tarjetas_resumen/data_minutos tarjetasresumen.dart';
import '../models/minutos_tarjetas_resumen/minutostarjetasresumen.dart';
import '../repositories/repo_min_tarj_resuemnen.dart';
import '../repositories/security_data.dart';
import '../utils/colors.dart';
import '../utils/dimens.dart';


class MinTarjetasPDFResumido extends StatefulWidget {
  BuildContext? contextAlert;
  late var datos;
  int? isPagehorizontal = 0;
  int? isatrasoF = 0;
  int? isadelantoF = 0;
  int? isatrasoJ = 0;
  int? isadelantoJ = 0;
  int? istarjeta = 0;
  int? isveloF = 0;
  int? isveloJ = 0;
  int? isrubroF = 0;
  int? isrubroJ = 0;
  int? isLabelEstado = 0;
  final String _fechaI;
  final String _fechaF;
  String empresa = "";

  List<DatoMinTarResumido>? mListDatos;

  SecurityData oS = new SecurityData();
  MinTarjetasPDFResumido(String _fechaI, String _fechaF)
    : this._fechaI = _fechaI,
      this._fechaF = _fechaF;

  @override
  State<MinTarjetasPDFResumido> createState() => _nameState();
}

class _nameState extends State<MinTarjetasPDFResumido> {
  List<TableRow> mListaElement = [];
  double sumP = 0;
  double sumC = 0;
  int number = 0;
  bool permissionGranted = false;
  var path;
  MinutosTarjetasResumenAppMovil? datoMinTarResumen = null;

  @override
  void initState() {
    super.initState();
    _readName();
    _initProcessos();
    setState(() {
      datoMinTarResumen = new MinutosTarjetasResumenAppMovil(statusCode: null);
    });
    _getReporteMinutosTarjetasResumen();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Reporte Minutos y Tarjetas Resumido'),
          elevation: 1,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          heroTag: 'pdf',
          tooltip: 'PDF',
          onPressed: () async {
            if (datoMinTarResumen!.statusCode == 200) {
              List<int> data = await createReporteMinTarjetasResumen(
                widget.mListDatos!,
              );
              savePdfFile(
                "Reporte_Minutos_Tarjetas_Diarias_Resumido.pdf",
                data,
              );

              /*if (Platform.isAndroid) {
                List<int> data = await createReporteMinTarjetasResumen(
                  widget.mListDatos!,
                );
                savePdfFile(
                  "Reporte_Minutos_Tarjetas_Diarias_Resumido.pdf",
                  data,
                );
              } else {
                List<int> data = await createReporteMinTarjetasResumen(
                  widget.mListDatos!,
                );
                String path = await savePdfFileIOS(
                  "Reporte_Minutos_Tarjetas_Diarias_Resumido.pdf",
                  data,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PdfViewIos(path)),
                );
              }*/
            } else {
              Navigator.pop(context);
            }
          },
          child: Icon(Icons.picture_as_pdf),
        ),
        body: Stack(
          children: [
            InteractiveViewer(
              boundaryMargin: EdgeInsets.all(20),
              maxScale: 4,
              minScale: 0.1,
              child: minTarjetasResumenPdf(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> savePdfFile(String fileName, List<int> byteList) async {
    final output = await getExternalStorageDirectory();
    var filePath = "${output!.path}/$fileName";
    final file = File(filePath);
    await file.writeAsBytes(byteList);
    await OpenFilex.open(
      filePath,
      type: "application/pdf",
      uti: "com.adobe.pdf",
    );
  }

  Future<String> savePdfFileIOS(String fileName, List<int> byteList) async {
    final output = await getTemporaryDirectory();
    var filePath = "${output.path}/$fileName";
    final file = File(filePath);
    await file.writeAsBytes(byteList);
    return filePath;
  }

  _getHeader<Widget>(
    BuildContext context,
    MinutosTarjetasResumenAppMovil model,
  ) {
    widget.mListDatos = model.datos!;

    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            Text(
              widget.empresa,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Reporte de Tarjetas y Minutos Resumidos",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "FECHA REPORTE: " +
                  widget.mListDatos![0].fecha.toString().substring(0, 11),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              child: Column(
                children: [
                  Table(
                    border: TableBorder.all(),
                    defaultColumnWidth: IntrinsicColumnWidth(),
                    children: _getBody(context, model),
                  ),
                  SizedBox(height: 25),
                  Container(
                    child: Table(
                      border: TableBorder.all(),
                      columnWidths: {
                        0: FixedColumnWidth(250),
                        1: FixedColumnWidth(250),
                      },
                      children: <TableRow>[
                        TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(
                                  left: 0,
                                  top: 5,
                                  right: 0,
                                  bottom: 5,
                                ),
                                child: Text(
                                  "TOTAL PENDIENTE: " + sumP.toStringAsFixed(2),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  "TOTAL COBRADO: " + sumC.toStringAsFixed(2),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
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
          ],
        ),
      ),
    );
  }

  _getBody<Widget>(BuildContext context, MinutosTarjetasResumenAppMovil model) {
    widget.mListDatos = model.datos!;
    List<TableRow> oL = [];
    oL.add(
      TableRow(
        children: [
          TableCell(
            child: Container(
              padding: EdgeInsets.only(left: 0, top: 5, right: 0, bottom: 5),
              color: Colors.red.shade300,
              child: Text(
                "Unidad",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          TableCell(
            child: Container(
              width: 250,
              padding: EdgeInsets.only(left: 0, top: 5, right: 0, bottom: 5),
              color: Colors.red.shade300,
              child: Text(
                "DescRuta",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.isatrasoF == 1 ? true : false,
            child: TableCell(
              child: Container(
                width: 180,
                padding: EdgeInsets.only(left: 0, top: 5, right: 0, bottom: 5),
                color: Colors.red.shade300,
                child: Text(
                  "Atraso F.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.isadelantoF == 1 ? true : false,
            child: TableCell(
              child: Container(
                width: 180,
                padding: EdgeInsets.only(left: 0, top: 5, right: 0, bottom: 5),
                color: Colors.red.shade300,
                child: Text(
                  "Adelanto F.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.isatrasoJ == 1 ? true : false,
            child: TableCell(
              child: Container(
                width: 180,
                padding: EdgeInsets.only(left: 0, top: 5, right: 0, bottom: 5),
                color: Colors.red.shade300,
                child: Text(
                  "Atraso J.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.isadelantoJ == 1 ? true : false,
            child: TableCell(
              child: Container(
                width: 180,
                padding: EdgeInsets.only(left: 0, top: 5, right: 0, bottom: 5),
                color: Colors.red.shade300,
                child: Text(
                  "Adelanto J.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.istarjeta == 1 ? true : false,
            child: TableCell(
              child: Container(
                width: 180,
                padding: EdgeInsets.only(left: 0, top: 5, right: 0, bottom: 5),
                color: Colors.red.shade300,
                child: Text(
                  "Tarjeta",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.isveloF == 1 ? true : false,
            child: TableCell(
              child: Container(
                width: 180,
                padding: EdgeInsets.only(left: 0, top: 5, right: 0, bottom: 5),
                color: Colors.red.shade300,
                child: Text(
                  "Veloc F.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.isveloJ == 1 ? true : false,
            child: TableCell(
              child: Container(
                width: 180,
                padding: EdgeInsets.only(left: 0, top: 5, right: 0, bottom: 5),
                color: Colors.red.shade300,
                child: Text(
                  "Veloc J.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.isrubroF == 1 ? true : false,
            child: TableCell(
              child: Container(
                width: 180,
                padding: EdgeInsets.only(left: 0, top: 5, right: 0, bottom: 5),
                color: Colors.red.shade300,
                child: Text(
                  "Rubro F.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.isrubroJ == 1 ? true : false,
            child: TableCell(
              child: Container(
                width: 180,
                padding: EdgeInsets.only(left: 0, top: 5, right: 0, bottom: 5),
                color: Colors.red.shade300,
                child: Text(
                  "Rubro J.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          TableCell(
            child: Container(
              width: 180,
              padding: EdgeInsets.only(left: 0, top: 5, right: 0, bottom: 5),
              color: Colors.red.shade300,
              child: Text(
                "Total",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.isLabelEstado == 1 ? true : false,
            child: TableCell(
              child: Container(
                width: 180,
                padding: EdgeInsets.only(left: 0, top: 5, right: 0, bottom: 5),
                color: Colors.red.shade300,
                child: Text(
                  "Estado",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (widget.mListDatos != null && widget.mListDatos!.length > 0) {
      for (var item in widget.mListDatos!) {
        var oE = TableRow(
          children: [
            Container(
              child: Center(
                child: Text(item.unidad!, textAlign: TextAlign.center),
              ),
            ),
            Container(
              child: Center(
                child: Text(item.descRuta!, textAlign: TextAlign.center),
              ),
            ),
            Visibility(
              visible: widget.isatrasoF == 1 ? true : false,
              child: Container(
                child: Center(
                  child: Text(
                    item.atrasoFPenalidad! == "0.00"
                        ? " "
                        : item.atrasoFPenalidad!,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: widget.isadelantoF == 1 ? true : false,
              child: Container(
                child: Center(
                  child: Text(
                    item.adelantoFPenalidad! == "0.00"
                        ? " "
                        : item.adelantoFPenalidad!,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: widget.isatrasoJ == 1 ? true : false,
              child: Container(
                child: Center(
                  child: Text(
                    item.atrasoJPenalidad! == "0.00"
                        ? " "
                        : item.atrasoJPenalidad!,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: widget.isadelantoJ == 1 ? true : false,
              child: Container(
                child: Center(
                  child: Text(
                    item.adelantoJPenalidad! == "0.00"
                        ? " "
                        : item.adelantoJPenalidad!,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: widget.istarjeta == 1 ? true : false,
              child: Container(
                child: Center(
                  child: Text(item.tarjetaDiaria!, textAlign: TextAlign.center),
                ),
              ),
            ),
            Visibility(
              visible: widget.isveloF == 1 ? true : false,
              child: Container(
                child: Center(
                  child: Text(
                    item.velocidadFalta!,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: widget.isveloJ == 1 ? true : false,
              child: Container(
                child: Center(
                  child: Text(
                    item.velocidadJustificacion!,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: widget.isrubroF == 1 ? true : false,
              child: Container(
                child: Center(
                  child: Text(item.rubroFalta!, textAlign: TextAlign.center),
                ),
              ),
            ),
            Visibility(
              visible: widget.isrubroJ == 1 ? true : false,
              child: Container(
                child: Center(
                  child: Text(
                    item.rubroJustificacion!,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Container(
              child: Center(
                child: Text(item.deudaTotal!, textAlign: TextAlign.center),
              ),
            ),
            Visibility(
              visible: widget.isLabelEstado == 1 ? true : false,
              child: Container(
                child: Center(
                  child: Text(
                    item.estadoCobro == 0 ? "PEN" : "",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        );
        oL.add(oE);
      }
    }

    mListaElement = oL;
    for (var item in widget.mListDatos!) {
      if (item.estadoCobro == 0) {
        sumP = double.parse(item.deudaTotal!) + sumP;
      } else {
        sumC = double.parse(item.deudaTotal!) + sumC;
      }
    }
    return mListaElement;
  }

  Future<Uint8List> createReporteMinTarjetasResumen(
    List<DatoMinTarResumido> listMintarResumido,
  ) async {
    var pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat:
            widget.isPagehorizontal == 1
                ? PdfPageFormat.a4.landscape
                : PdfPageFormat.a4,
        orientation:
            widget.isPagehorizontal == 1
                ? pw.PageOrientation.landscape
                : pw.PageOrientation.portrait,
        //margin: pw.EdgeInsets.only(left: 20, top: 12, right: 14, bottom: 13),
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        build: (pw.Context context) {
          return [
            pw.Column(
              children: [
                pw.Text(
                  widget.empresa,
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  "Reporte de Minutos y Tarjetas Resumido",
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  "FECHA REPORTE: " +
                      widget.mListDatos![0].fecha.toString().substring(0, 11),
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
            pw.Table(
              border: pw.TableBorder.all(),
              defaultColumnWidth: pw.IntrinsicColumnWidth(),
              children: [
                pw.TableRow(
                  children: [
                    pw.Container(
                      color: PdfColors.red300,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text(
                            "Unidad",
                            style: pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.white,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Container(
                      color: PdfColors.red300,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text(
                            "DescRuta",
                            style: pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.white,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // if (widget.isatrasoF == 1) ...[
                    pw.Container(
                      color: PdfColors.red300,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text(
                            "Atraso F.",
                            style: pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.white,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    //],
                    //if (widget.isadelantoF == 1) ...[
                    pw.Container(
                      color: PdfColors.red300,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text(
                            "Adelanto F.",
                            style: pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.white,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    //  ],
                    // if (widget.isatrasoJ == 1) ...[
                    pw.Container(
                      color: PdfColors.red300,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text(
                            "Atraso J.",
                            style: pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.white,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // ],
                    // if (widget.isadelantoJ == 1) ...[
                    pw.Container(
                      color: PdfColors.red300,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text(
                            "Adelanto J.",
                            style: pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.white,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    //],
                    if (widget.istarjeta == 1) ...[
                      pw.Container(
                        color: PdfColors.red300,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(
                              "Tarjeta",
                              style: pw.TextStyle(
                                fontSize: 10,
                                color: PdfColors.white,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (widget.isveloF == 1) ...[
                      pw.Container(
                        color: PdfColors.red300,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(
                              "Velocidad F.",
                              style: pw.TextStyle(
                                fontSize: 10,
                                color: PdfColors.white,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (widget.isveloJ == 1) ...[
                      pw.Container(
                        color: PdfColors.red300,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(
                              "Velocidad J.",
                              style: pw.TextStyle(
                                fontSize: 10,
                                color: PdfColors.white,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (widget.isrubroF == 1) ...[
                      pw.Container(
                        color: PdfColors.red300,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(
                              "Rubro F.",
                              style: pw.TextStyle(
                                fontSize: 10,
                                color: PdfColors.white,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (widget.isrubroJ == 1) ...[
                      pw.Container(
                        color: PdfColors.red300,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(
                              "Rubro J.",
                              style: pw.TextStyle(
                                fontSize: 10,
                                color: PdfColors.white,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    pw.Container(
                      color: PdfColors.red300,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text(
                            "Total",
                            style: pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.white,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    //if (widget.isLabelEstado == 1) ...[
                    pw.Container(
                      color: PdfColors.red300,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text(
                            "Estado",
                            style: pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.white,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // ],
                  ],
                ),
                if (listMintarResumido.length > 0) ...[
                  for (var item in listMintarResumido) ...[
                    pw.TableRow(
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(
                              item.unidad!,
                              style: pw.TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(
                              item.descRuta!,
                              style: pw.TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                        // if (widget.isatrasoF == 1) ...[
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(
                              item.atrasoFPenalidad!,
                              style: pw.TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                        // ],
                        // if (widget.isadelantoF == 1) ...[
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(
                              item.adelantoFPenalidad!,
                              style: pw.TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                        //    ],
                        //  if (widget.isatrasoJ == 1) ...[
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(
                              item.atrasoJPenalidad!,
                              style: pw.TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                        //  ],
                        // if (widget.isadelantoJ == 1) ...[
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(
                              item.adelantoJPenalidad!,
                              style: pw.TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                        // ],
                        if (widget.istarjeta == 1) ...[
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            mainAxisAlignment: pw.MainAxisAlignment.center,
                            children: [
                              pw.Text(
                                item.tarjetaDiaria!,
                                style: pw.TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ],
                        if (widget.isveloF == 1) ...[
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            mainAxisAlignment: pw.MainAxisAlignment.center,
                            children: [
                              pw.Text(
                                item.velocidadFalta!,
                                style: pw.TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ],
                        if (widget.isveloJ == 1) ...[
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            mainAxisAlignment: pw.MainAxisAlignment.center,
                            children: [
                              pw.Text(
                                item.velocidadJustificacion!,
                                style: pw.TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ],
                        if (widget.isrubroF == 1) ...[
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            mainAxisAlignment: pw.MainAxisAlignment.center,
                            children: [
                              pw.Text(
                                item.rubroFalta!,
                                style: pw.TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ],
                        if (widget.isrubroJ == 1) ...[
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            mainAxisAlignment: pw.MainAxisAlignment.center,
                            children: [
                              pw.Text(
                                item.rubroJustificacion!,
                                style: pw.TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ],
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(
                              item.deudaTotal!,
                              style: pw.TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                        // if (widget.isLabelEstado == 1) ...[
                        //if (item.estadoCobro == 0) ...[
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(
                              item.estadoCobro == 0 ? "PEN" : " ",
                              style: pw.TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                        //]  else ...[
                        /*pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Text("", style: pw.TextStyle(fontSize: 10))
                              ]), */
                        //]
                        //]
                      ],
                    ),
                  ],
                ],
              ],
            ),
            pw.SizedBox(height: 25),
            pw.Container(
              child: pw.Table(
                border: pw.TableBorder.all(),
                defaultColumnWidth: pw.IntrinsicColumnWidth(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Text(
                            "TOTAL PENDIENTE: " + sumP.toStringAsFixed(2),
                            style: pw.TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Text(
                            "TOTAL PAGADO: " + sumC.toStringAsFixed(2),
                            style: pw.TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );
    return pdf.save();
  }

  Future<void> _initProcessos() async {
    await _getSharedPreferences();
  }

  _getSharedPreferences() async {
    var _isPagehorizontal = 0;
    var _isatrasoF = 0;
    var _isadelantoF = 0;
    var _isatrasoJ = 0;
    var _isadelantoJ = 0;
    var _istarjeta = 0;
    var _isveloF = 0;
    var _isveloJ = 0;
    var _isrubroF = 0;
    var _isrubroJ = 0;
    var _isLabelEstado = 0;

    try {
      var datosE = await widget.oS.readDataPreferenciasEmpresa();
      cPermisosPropietario? oPermisosPropietario =
          await widget.oS.readPermisosObservador();

      _isPagehorizontal =
          oPermisosPropietario!.minTarjetaResuDiaConfigPagePagehorizontal!;
      _isatrasoF = oPermisosPropietario!.minTarjetaResuDiaConfigPageAtrasoF!;
      _isadelantoF =
          oPermisosPropietario!.minTarjetaResuDiaConfigPageAdelantoF!;
      _isatrasoJ = oPermisosPropietario!.minTarjetaResuDiaConfigPageAtrasoJ!;
      _isadelantoJ =
          oPermisosPropietario!.minTarjetaResuDiaConfigPageAdelantoJ!;
      _istarjeta = oPermisosPropietario!.minTarjetaResuDiaConfigPageTarjeta!;
      _isveloF = oPermisosPropietario!.minTarjetaResuDiaConfigPageVeloF!;
      _isveloJ = oPermisosPropietario!.minTarjetaResuDiaConfigPageVeloJ!;
      _isrubroF = oPermisosPropietario!.minTarjetaResuDiaConfigPageRubroF!;
      _isrubroJ = oPermisosPropietario!.minTarjetaResuDiaConfigPageRubroJ!;
      _isLabelEstado =
          oPermisosPropietario!.minTarjetaResuDiaConfigPageLabelEstado!;
    } catch (e) {
      print("____________________________________________");
      print(e.toString());
    }

    setState(() {
      widget.isPagehorizontal = _isPagehorizontal ?? 0;
      widget.isatrasoF = _isatrasoF ?? 0;
      widget.isadelantoF = _isadelantoF ?? 0;
      widget.isatrasoJ = _isatrasoJ ?? 0;
      widget.isadelantoJ = _isadelantoJ ?? 0;
      widget.istarjeta = _istarjeta ?? 0;
      widget.isveloF = _isveloF ?? 0;
      widget.isveloJ = _isveloJ ?? 0;
      widget.isrubroF = _isrubroF ?? 0;
      widget.isrubroJ = _isrubroJ ?? 0;
      widget.isLabelEstado = _isLabelEstado ?? 0;
    });
  }

  _readName() async {
    CodeActivacion empresa = await widget.oS.readDataPreferenciasEmpresa();
    print('Aca name empresa >>>>> ${empresa.data!.name!}');
    return widget.empresa = empresa.data!.name!;
  }

  _cardNoData() {
    return Container(
      height: 180,
      margin: const EdgeInsets.only(
        right: marginSmallSmall,
        left: marginSmallSmall,
        bottom: marginSmallSmall,
        top: marginBig,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: colorWhite,
        boxShadow: [boxShadowPersonalizado],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        'No Existen Datos ',
                        style: TextStyle(
                          fontSize: textBig,
                          color: colorBlack,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        'No existen datos en la fecha ${widget._fechaI} hasta',
                        overflow: TextOverflow.fade,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: textMedium,
                          color: colorBlack,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        ' ${widget._fechaF}, por favor verificar la fecha',
                        overflow: TextOverflow.fade,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: textMedium,
                          color: colorBlack,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Ok",
                          style: TextStyle(color: Colors.white),
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

  cardShimmer() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: const Column(
        children: [
          Center(child: Skelton(height: 10, width: 100)),
          Row(
            children: [
              Skelton(height: 10, width: 20),
              SizedBox(width: 10),
              Skelton(height: 10, width: 40),
              SizedBox(width: 100),
              Skelton(height: 10, width: 40),
              SizedBox(width: 10),
              Skelton(height: 10, width: 80),
            ],
          ),
          Row(
            children: [
              Skelton(height: 10, width: 20),
              SizedBox(width: 10),
              Skelton(height: 10, width: 30),
              SizedBox(width: 80),
              Skelton(height: 10, width: 40),
              SizedBox(width: 10),
              Skelton(height: 10, width: 20),
            ],
          ),
          Center(child: Skelton(height: 10, width: 200)),
          Row(
            children: [
              Skelton(height: 10, width: 40),
              SizedBox(width: 30),
              Skelton(height: 10, width: 40),
              SizedBox(width: 30),
              Skelton(height: 10, width: 80),
            ],
          ),
          Row(
            children: [
              Skelton(height: 10, width: 40),
              SizedBox(width: 30),
              Skelton(height: 10, width: 40),
              SizedBox(width: 30),
              Skelton(height: 10, width: 80),
            ],
          ),
          Row(
            children: [
              Skelton(height: 10, width: 40),
              SizedBox(width: 30),
              Skelton(height: 10, width: 40),
              SizedBox(width: 30),
              Skelton(height: 10, width: 80),
            ],
          ),
          Center(child: Skelton(height: 10, width: 200)),
          Center(child: Skelton(height: 10, width: 150)),
        ],
      ),
    );
  }

  _getReporteMinutosTarjetasResumen() async {
    ApiRepoMinTarResumen servicio = ApiRepoMinTarResumen();
    datoMinTarResumen = await servicio.readMinTarResumen(
      widget._fechaI,
      widget._fechaF,
    );
    setState(() {});
  }

  Widget minTarjetasResumenPdf() {
    if (datoMinTarResumen != null) {
      if (datoMinTarResumen!.statusCode == null) {
        return cardShimmer();
      } else if (datoMinTarResumen!.statusCode == 200) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [Center(child: _getHeader(context, datoMinTarResumen!))],
          ),
        );
      } else if (datoMinTarResumen!.statusCode == 300) {
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
