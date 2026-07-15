import 'package:flutter/material.dart';
import '../utils/dimens.dart';
import '../utils/iconos.dart';

Widget getButtonBuscar(context) {
  return ElevatedButton.icon(
    onPressed: () {
      //hacer algo;
    },
    icon: Icon(IconBuscar),
    style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
    label: Text(
      "Buscar",
      style: TextStyle(fontSize: textBigMedium),
    ),
  );
}
