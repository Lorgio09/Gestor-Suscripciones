import 'package:flutter/material.dart';
import 'colores.dart';

const fuenteTitulos = 'Sora';
const fuenteInterfaz = 'Plus Jakarta Sans';

TextStyle armarEstilo(String fuente, double tamano, int peso, Color color) {
  return TextStyle(
    fontFamily: fuente,
    fontSize: tamano,
    color: color,
    fontVariations: [FontVariation('wght', peso.toDouble())],
  );
}

final estiloTituloPantalla = armarEstilo(fuenteTitulos, 24, 700, colorTinta);
final estiloEncabezado = armarEstilo(fuenteTitulos, 16, 700, colorTinta);
final estiloNombreServicio = armarEstilo(fuenteInterfaz, 16, 600, colorTinta);
final estiloValorDato = armarEstilo(fuenteTitulos, 16, 700, colorTinta);
final estiloEtiquetaCampo = armarEstilo(fuenteInterfaz, 16, 600, colorTinta);
final estiloTextoCampo = armarEstilo(fuenteInterfaz, 16, 400, colorTinta);
final estiloSecundario = armarEstilo(fuenteInterfaz, 16, 400, colorSecundario);
final estiloBoton = armarEstilo(fuenteInterfaz, 16, 600, Colors.white);
final estiloInicial = armarEstilo(fuenteTitulos, 16, 700, Colors.white);
final estiloInicialGrande = armarEstilo(fuenteTitulos, 24, 700, Colors.white);
