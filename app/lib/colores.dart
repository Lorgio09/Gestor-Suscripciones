import 'package:flutter/material.dart';

class Colores {
  // Colores principales
  static const Color primario = Color(0xFFF26B5B);
  static const Color secundario = Color(0xFF2B5A5E); 

  // Colores de texto
  static const Color textoPrincipal = Color(0xFF2B2B2B); 
  static const Color textoSecundario = Color(0xFF9B8B85);
  
  // Colores de estado
  static const Color error = Color(0xFFC62828);
  
  // Fondos y Bordes
  static const Color superficie = Colors.white; 
  static const Color fondo = Color(0xFFF6EFEC); 
  static const Color borde = Color(0xFFEADFDA); 
  
  static const Color botonDeshabilitado = Color(0xFFF3EDEA);
  static const Color textoDeshabilitado = Color(0xFFB5A8A3);


  static const Color degradado1 = Color(0xFFF05E3F); 
  static const Color degradado2 = Color(0xFFE83716);
  static const Color degradado3 = Color(0xFFCA3D27); 

  // Degradado junto
  static const LinearGradient degradadoFondo = LinearGradient(
    begin: Alignment.topCenter, 
    end: Alignment.bottomCenter, 
    stops: [0.13, 0.38, 0.77], 
    colors: [
      degradado1,
      degradado2,
      degradado3,
    ],
  );
}