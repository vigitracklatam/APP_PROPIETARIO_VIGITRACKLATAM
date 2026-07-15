import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'code_activacion_page.dart';
import 'home_page.dart';
import 'login_page.dart';

class AppPage extends StatelessWidget {
  const AppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Exo',
        colorScheme: const ColorScheme.light(
          primary: Color.fromARGB(133, 56, 56, 56), // Color principal
          onPrimaryContainer: Colors.white, // Color de fondo
          onPrimary:
              Colors
                  .black, // Color de texto y elementos sobre el color primario
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor:
                Colors.blue, // Color del texto de los botones TextButton
          ),
        ),
      ),
      initialRoute: 'codeActivacion',
      localizationsDelegates: const [
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'), // Establece español como idioma predeterminado
      ],
      routes: {
        //'permisos': (context) => PermisosPage(),
        'codeActivacion': (context) => CodeActivacionPage(),
        'login': (context) => LoginPage(),
        'homePage': (context) => HomePage(),
      },
      //home: CodeActivacionPage(),
    );
  }
}
