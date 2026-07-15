import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewerPDF extends StatefulWidget {
  String assets = "";

  ViewerPDF(String assets_, {super.key}) {
    this.assets = assets_;
  }

  @override
  State<ViewerPDF> createState() => _ViewerPDFState();
}

class _ViewerPDFState extends State<ViewerPDF> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("CUADROS DE TRABAJO"),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Iconsax.arrow_left)),
            ),
            body: SfPdfViewer.network(
              widget.assets,
              enableTextSelection: false,
              enableDocumentLinkAnnotation: false,
              enableHyperlinkNavigation: false,
            )));
  }
}
