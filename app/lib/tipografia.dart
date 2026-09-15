import 'package:flutter/material.dart';
import 'colores.dart';

class Tipografia {
  // Título 
  static const TextStyle titulo1 = TextStyle(
    fontFamily: 'Sora',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: colorTexto,
  );

  // Etiqueta de los campos
  static const TextStyle etiqueta = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: colorTexto,
  );

  // Texto que el usuario escribe en el campo 
  static const TextStyle textoCampo = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: colorTexto,
  );

  // Texto de ayuda abajo del input 
  static const TextStyle textoAyuda = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: colorTextoSecundario,
  );

  // Texto del botón 
  static const TextStyle textoBoton = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: colorBlanco,
  );
  
  static const TextStyle numerico = TextStyle(
    fontFamily: 'Sora',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: colorTexto,
  );

  static const TextStyle titulo2 = TextStyle(
    fontFamily: 'Sora',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: colorTexto,
  );

  static const TextStyle tituloDialogo = TextStyle(
    fontFamily: 'Sora',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: colorTexto,
  );

  static const TextStyle textoCampoFuerte = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: colorTexto,
  );

  static const TextStyle textoChico = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: colorTextoSecundario,
  );

  static const TextStyle saludo = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: colorTextoSecundario,
  );

  static const TextStyle montoFila = TextStyle(
    fontFamily: 'Sora',
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: colorTexto,
  );
}