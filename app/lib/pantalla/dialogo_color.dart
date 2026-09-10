import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../colores.dart';
import '../tipografia.dart';

String colorAHexa(Color color) {
  final valor = color.toARGB32() & 0xFFFFFF;
  return '#${valor.toRadixString(16).padLeft(6, '0').toUpperCase()}';
}

Color hexaAColor(String hexa) {
  final limpio = hexa.replaceAll('#', '');
  return Color(int.parse('FF$limpio', radix: 16));
}

Future<Color?> elegirColor(BuildContext context, Color colorActual) async {
  Color colorTemporal = colorActual;

  final confirmado = await showDialog<bool>(
    context: context,
    builder: (contexto) => AlertDialog(
      backgroundColor: colorBlanco,
      title: Text('Elegí un color', style: Tipografia.titulo1),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: colorActual,
          enableAlpha: false,
          hexInputBar: true,
          onColorChanged: (color) => colorTemporal = color,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(contexto, false),
          child: Text('Cancelar', style: Tipografia.textoAyuda),
        ),
        TextButton(
          onPressed: () => Navigator.pop(contexto, true),
          child: Text(
            'Usar este',
            style: Tipografia.etiqueta.copyWith(color: colorCoral),
          ),
        ),
      ],
    ),
  );

  if (confirmado != true) return null;
  return colorTemporal;
}
