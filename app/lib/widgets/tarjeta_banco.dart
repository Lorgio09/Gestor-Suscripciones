import 'package:flutter/material.dart';
import '../colores.dart';
import '../tipografia.dart';

class TarjetaBanco extends StatelessWidget {
  final String alias;
  final String tipo;
  final String ultimosDigitos;
  final Color color;
  final String textoAbajoIzquierda;
  final String textoAbajoDerecha;
  final double alto;

  const TarjetaBanco({
    super.key,
    required this.alias,
    required this.tipo,
    required this.ultimosDigitos,
    required this.color,
    this.textoAbajoIzquierda = '',
    this.textoAbajoDerecha = '',
    this.alto = 132,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: alto,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  alias,
                  style: Tipografia.etiqueta.copyWith(color: colorBlanco),
                ),
              ),
              Text(tipo, style: Tipografia.etiqueta.copyWith(color: colorBlanco)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '•••• $ultimosDigitos',
            style: Tipografia.titulo1.copyWith(color: colorBlanco, letterSpacing: 2),
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  textoAbajoIzquierda,
                  style: Tipografia.textoAyuda.copyWith(fontSize: 12, color: colorBlanco),
                ),
              ),
              Text(
                textoAbajoDerecha,
                style: Tipografia.numerico.copyWith(fontSize: 15, color: colorBlanco),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
