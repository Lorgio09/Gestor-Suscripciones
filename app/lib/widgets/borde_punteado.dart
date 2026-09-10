import 'package:flutter/material.dart';
import '../colores.dart';

class BordePunteado extends StatelessWidget {
  final Widget child;

  const BordePunteado({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PintorPunteado(),
      child: child,
    );
  }
}

class _PintorPunteado extends CustomPainter {
  @override
  void paint(Canvas lienzo, Size medida) {
    final pincel = Paint()
      ..color = colorCoral
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final contorno = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, medida.width, medida.height),
        const Radius.circular(18),
      ));

    for (final tramo in contorno.computeMetrics()) {
      double avance = 0;
      while (avance < tramo.length) {
        lienzo.drawPath(tramo.extractPath(avance, avance + 4), pincel);
        avance = avance + 8;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter pintorViejo) => false;
}
