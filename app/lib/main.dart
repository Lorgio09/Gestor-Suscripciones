import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'colores.dart';
import 'tipografia.dart';
import 'pantalla/pantalla_carga.dart';

void main() {
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Suscrip',
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
          seedColor: colorCoral,
          brightness: Brightness.light,
        ),
        fontFamily: 'PlusJakartaSans',
        scaffoldBackgroundColor: colorFondo,

        cardTheme: const CardThemeData(
          color: colorBlanco,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: colorBorde),
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: colorBlanco,
          constraints: const BoxConstraints(minHeight: 50),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          hintStyle: Tipografia.textoCampo.copyWith(color: colorPlaceholder),
          prefixStyle: Tipografia.textoCampo.copyWith(color: colorTextoSecundario),
          errorStyle: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: colorError,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: colorBorde),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: colorBorde),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: colorCoral),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: colorError),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: colorError),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((estados) {
              if (estados.contains(WidgetState.disabled)) return colorDeshabilitado;
              if (estados.contains(WidgetState.pressed)) return colorCoralOscuro;
              return colorCoral;
            }),
            foregroundColor: WidgetStateProperty.resolveWith((estados) {
              if (estados.contains(WidgetState.disabled)) return colorPlaceholder;
              return colorBlanco;
            }),
            elevation: WidgetStateProperty.all(0),
            textStyle: WidgetStateProperty.all(Tipografia.textoBoton),
            minimumSize: WidgetStateProperty.all(const Size.fromHeight(52)),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            backgroundColor: colorBlanco,
            minimumSize: const Size.fromHeight(52),
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
