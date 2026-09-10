import 'dart:math';
import 'package:flutter/material.dart';
import '../colores.dart';
import '../tipografia.dart';

class Porcion {
  final String etiqueta;
  final double monto;
  final Color color;

  Porcion({required this.etiqueta, required this.monto, required this.color});
}

List<Porcion> agruparEnOtros(List<Porcion> todas) {
  final ordenadas = List<Porcion>.from(todas);
  ordenadas.sort((una, otra) => otra.monto.compareTo(una.monto));
  if (ordenadas.length <= 6) return ordenadas;

  final grandes = ordenadas.sublist(0, 5);
  double resto = 0;
  for (final porcion in ordenadas.sublist(5)) {
    resto = resto + porcion.monto;
  }
  grandes.add(Porcion(etiqueta: 'Otros', monto: resto, color: colorTextoSecundario));
  return grandes;
}

class GraficoTorta extends StatelessWidget {
  final List<Porcion> porciones;
  final bool mostrarPorcentaje;

  const GraficoTorta({
    super.key,
    required this.porciones,
    this.mostrarPorcentaje = false,
  });

  double get total {
    double suma = 0;
    for (final porcion in porciones) {
      suma = suma + porcion.monto;
    }
    return suma;
  }

  Widget leyenda(Porcion porcion) {
    final derecha = mostrarPorcentaje && total > 0
        ? '${(porcion.monto / total * 100).round()}%'
        : 'Bs ${porcion.monto.toStringAsFixed(0)}';

    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: porcion.color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            porcion.etiqueta,
            style: Tipografia.textoAyuda.copyWith(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(derecha, style: Tipografia.numerico.copyWith(fontSize: 12)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (porciones.isEmpty) {
      return Text(
        'Todavía no hay gastos para mostrar.',
        style: Tipografia.textoAyuda,
        textAlign: TextAlign.center,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: SizedBox(
            width: 120,
            height: 120,
            child: CustomPaint(painter: PintorTorta(porciones)),
          ),
        ),
        const SizedBox(height: 16),
        for (int i = 0; i < porciones.length; i = i + 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(child: leyenda(porciones[i])),
                const SizedBox(width: 12),
                Expanded(
                  child: i + 1 < porciones.length
                      ? leyenda(porciones[i + 1])
                      : const SizedBox(),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class PintorTorta extends CustomPainter {
  final List<Porcion> porciones;

  PintorTorta(this.porciones);

  @override
  void paint(Canvas lienzo, Size medida) {
    double total = 0;
    for (final porcion in porciones) {
      total = total + porcion.monto;
    }
    if (total <= 0) return;

    final area = Rect.fromLTWH(0, 0, medida.width, medida.height);
    double comienzo = -pi / 2;

    for (final porcion in porciones) {
      final barrido = (porcion.monto / total) * 2 * pi;
      final pincel = Paint()..color = porcion.color;
      lienzo.drawArc(area, comienzo, barrido, true, pincel);
      comienzo = comienzo + barrido;
    }

    final hueco = Paint()..color = colorBlanco;
    lienzo.drawCircle(
      Offset(medida.width / 2, medida.height / 2),
      medida.width / 4,
      hueco,
    );
  }

  @override
  bool shouldRepaint(covariant PintorTorta pintorViejo) {
    return pintorViejo.porciones != porciones;
  }
}
