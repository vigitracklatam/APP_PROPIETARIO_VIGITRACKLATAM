import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/code_activacion/code_activacion.dart';
import '../repositories/security_data.dart';
import '../utils/colors.dart';

class LogoPage extends StatefulWidget {
  const LogoPage({super.key});

  @override
  State<LogoPage> createState() => _LogoPageState();
}

class _LogoPageState extends State<LogoPage> {
  final SecurityData oS = SecurityData();
  bool loadingLogoPage = true;
  String pathImagen = "";

  @override
  void initState() {
    super.initState();
    _readMarca();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: colorWhite,
          body: Center(child: circleLogoDrawer()),
        ),
      ),
    );
  }

  Widget circleLogoDrawer() {
    return Container(
      alignment: Alignment.center,
      height: 250,
      width: 250,
      child: CachedNetworkImage(
        imageUrl: pathImagen,
        progressIndicatorBuilder:
            (context, url, downloadProgress) =>
                CircularProgressIndicator(color: colorBlue),
        errorWidget:
            (context, url, error) =>
                Image.asset('assets/logo_completo_transparente.png'),
      ),
    );
  }

  Future<void> _readMarca() async {
    CodeActivacion empresa = await oS.readDataPreferenciasEmpresa();

    if (!mounted) return;

    setState(() {
      loadingLogoPage = false;
      pathImagen = empresa.data?.logo ?? '';
      print("IMAGEN LOGO : $pathImagen");
    });
  }
}
