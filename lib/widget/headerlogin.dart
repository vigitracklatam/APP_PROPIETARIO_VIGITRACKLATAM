import 'package:flutter/material.dart';

Widget getHeaderHomePage(context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.4,
    width: double.infinity,
    color: Colors.transparent,
    child: Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                Color.fromARGB(255, 8, 84, 146),
                Color.fromARGB(114, 82, 109, 246)
              ])),
        ),
        Opacity(
            opacity: 1,
            child: Container(
              child: Image.asset(
                "assets/fondo.png",
                repeat: ImageRepeat.noRepeat,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            )),
      ],
    ),
  );
}
