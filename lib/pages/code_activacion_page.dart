import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import '../models/code_activacion/code_activacion.dart';
import '../repositories/repo_code_activacion.dart';
import '../repositories/security_data.dart';
import '../utils/dimens.dart';
import '../utils/iconos.dart';
import '../utils/textos.dart';
import '../widget/app_version.dart';
import 'login_page.dart';

class CodeActivacionPage extends StatefulWidget {
  final _formKey = GlobalKey<FormState>();

  //final _checker = AppVersionChecker();
  final codigoActivacion = TextEditingController();
  SecurityData oS = new SecurityData();
  SimpleFontelicoProgressDialog? _dialog;
  CodeActivacionPage({super.key});

  @override
  State<CodeActivacionPage> createState() => _CodeActivacionState();
}

class _CodeActivacionState extends State<CodeActivacionPage> {
  String propietario = "";
  @override
  void initState() {
    super.initState();
    checkVersion();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        // Tu imagen de fondo es clara, pero quieres forzar un fondo negro para la barra de estado
        // Para lograr eso, lo mejor es hacerla transparente y que se vea tu fondo.
        // Si realmente la quieres negra, usa Colors.black
        statusBarColor:
            Colors.transparent, // Permite ver la imagen de fondo detrás
        // La clave: Forzar los iconos a ser BLANCOS (light)
        statusBarIconBrightness: Brightness.light,

        // Para que los iconos del sistema (como los botones de navegación de Android) sean claros también
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    repeat: ImageRepeat.noRepeat,
                    fit: BoxFit.cover,
                    image: AssetImage("assets/fondo.jpg"),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: AppVersionText(color: Colors.black),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.only(left: 5, right: 5, bottom: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: Form(
                          key: widget._formKey,
                          child: TextFormField(
                            controller: widget.codigoActivacion,
                            textAlign: TextAlign.start,
                            keyboardType: TextInputType.text,
                            maxLines: 1,
                            autocorrect: false,
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return 'Ingrese un codigo de activación';
                              }
                            },
                            decoration: const InputDecoration(
                              labelText: 'Codigo de activación',
                              labelStyle: TextStyle(
                                fontSize: textBigMedium,
                                color: Colors.black54,
                              ),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              prefixIcon: Icon(
                                IconCodeAct,
                                color: Colors.black38,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          final codigoSE = widget.codigoActivacion.text
                              .replaceAll(' ', '');

                          if (widget._formKey.currentState!.validate()) {
                            _readApiCodeActivacion(codigoSE);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Color de fondo azul
                          foregroundColor:
                              Colors.white, // Color del texto blanco
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        child: const Text(
                          "Activar",
                          style: TextStyle(fontSize: textBigMedium),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _readApiCodeActivacion(codigo) async {
    _showAlertProgress();
    CodeActivacion oC = await RepoCodeActivacion.readCodigoActivacion(codigo);

    try {
      widget._dialog!.hide();
    } catch (e) {
      print(e);
    }
    SecurityData oS = new SecurityData();
    if (oC.statusCode == 200) {
      if (oC.data!.active == 1) {
        if (await oS.inertDataPreferenciasEmpresa(oC.toRawJson())) {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => LoginPage()));
        } else {
          // sweet alert
          // Error al guardar en secuty store
          Alert(
            context: context,
            type: AlertType.error,
            title: namecompany,
            desc: "Error al Guardar Security Store.",
            buttons: [
              DialogButton(
                child: Text(
                  "Aceptar",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                width: 120,
              ),
            ],
          ).show();
        }
      } else {
        Alert(
          context: context,
          type: AlertType.warning,
          title: namecompany,
          desc: "${oC.msm}",
          buttons: [
            DialogButton(
              child: Text(
                "Aceptar",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            ),
          ],
        ).show();
      }
    } else if (oC.statusCode == 300) {
      //print(oC.msm);
      Alert(
        context: context,
        type: AlertType.info,
        title: namecompany,
        desc: "Su empresa no se encuentra registrada",
        buttons: [
          DialogButton(
            child: Text(
              "Aceptar",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          ),
        ],
      ).show();
    } else {
      Alert(
        context: context,
        type: AlertType.error,
        title: "CODIGO " + oC.statusCode.toString(),
        desc: oC.msm,
        style: AlertStyle(
          descStyle: TextStyle(fontSize: 15),
          titleStyle: TextStyle(fontSize: 16),
        ),
        buttons: [
          DialogButton(
            child: Text(
              "Aceptar",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          ),
        ],
      ).show();
    }
  }

  _initConfigData() async {
    CodeActivacion oC = await widget.oS.readDataPreferenciasEmpresa();

    if (oC.statusCode == 200) {
      if (oC.data != null) {
        if (oC.data!.codigo != null && oC.data!.codigo!.isNotEmpty) {
          widget.codigoActivacion.text = oC.data!.codigo.toString();
          _readApiCodeActivacion(oC.data!.codigo!);
        }
      }
    }
  }

  _showAlertProgress() async {
    widget._dialog = SimpleFontelicoProgressDialog(
      context: context,
      barrierDimisable: true,
    );
    widget._dialog!.show(
      message: 'Verificando Datos...',
      type: SimpleFontelicoProgressDialogType.spinner,
    );
  }

  checkVersion() {
    _initConfigData();
    /*widget._checker.checkUpdate().then((value) {
      print(value.canUpdate); //return true if update is available
      print(value.currentVersion); //return current app version
      print(value.newVersion); //return the new app version
      print(value.appURL); //return the app url
      print(value
          .errorMessage); //return error message if found else it will return null

      if (value.canUpdate) {
        _showAlertCheckUpdateApp(value);
      } else {
        _initConfigData();
      }
    });*/
  }

  /*_showAlertCheckUpdateApp(value) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Container(
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.all(0),
              height: 150,
              width: double.infinity,
              color: Colors.white,
              child: Image.asset(
                Platform.isIOS ? "assets/appstore.gif" : "assets/playstore.gif",
              ),
            ),
            content: Text(
              'Nueva version disponible ' +
                  value.newVersion.toString() +
                  ' porfavor actualizarla en su tienda.',
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black45),
            ),
            actions: [
              ElevatedButton.icon(
                  onPressed: () {
                    LaunchReview.launch();

                    /*LaunchReview.launch(
                            androidAppId: "com.vigitracklatam.siu",
                            iOSAppId: "com.vigitracklatam.siu");*/
                  },
                  icon: Icon(Icons.system_update),
                  label: Text(update_app))
            ],
          );
        });
  }*/
}
