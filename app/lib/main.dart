import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'colores.dart'; 
import 'tipografia.dart'; 
import 'pantalla/pantalla_lista.dart';
import 'pantalla/pantalla_carga.dart';

void main() {
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de Suscripciones',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'BO'), 
        Locale('es', 'ES'),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colores.primario,
          brightness: Brightness.light,
        ),
        fontFamily: 'PlusJakartaSans', 
        scaffoldBackgroundColor: Colores.fondo,
        
        cardTheme: const CardThemeData(
          color: Colores.superficie,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colores.borde),
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
        ),
        
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colores.superficie,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          hintStyle: Tipografia.textoAyuda,
          prefixStyle: Tipografia.textoAyuda,
          errorStyle: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colores.error,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: const BorderSide(color: Colores.borde),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: const BorderSide(color: Colores.borde),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: const BorderSide(color: Colores.primario),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: const BorderSide(color: Colores.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: const BorderSide(color: Colores.error),
          ),
        ),
        
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((estados) {
              if (estados.contains(WidgetState.disabled)) return Colores.botonDeshabilitado;
              if (estados.contains(WidgetState.pressed)) return Colores.primario; 
              return Colores.primario;
            }),
            foregroundColor: WidgetStateProperty.resolveWith((estados) {
              if (estados.contains(WidgetState.disabled)) return Colores.textoDeshabilitado;
              return Colores.superficie; 
            }),
            elevation: WidgetStateProperty.all(0),
            textStyle: WidgetStateProperty.all(Tipografia.textoBoton),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(vertical: 15),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colores.superficie,
            padding: const EdgeInsets.symmetric(vertical: 13),
            textStyle: Tipografia.etiqueta,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const PantallaCarga(),
    );
  }
}