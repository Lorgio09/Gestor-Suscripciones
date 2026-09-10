import 'package:flutter/material.dart';
import '../colores.dart';
import '../tipografia.dart';

class OpcionDestino {
  final int id;
  final String nombre;
  final Color color;

  OpcionDestino({required this.id, required this.nombre, required this.color});
}

class HojaReasignar extends StatefulWidget {
  final String titulo;
  final String texto;
  final List<OpcionDestino> opciones;
  final int idPorDefecto;

  const HojaReasignar({
    super.key,
    required this.titulo,
    required this.texto,
    required this.opciones,
    required this.idPorDefecto,
  });

  @override
  State<HojaReasignar> createState() => _EstadoHojaReasignar();
}

class _EstadoHojaReasignar extends State<HojaReasignar> {
  late int idElegido;

  @override
  void initState() {
    super.initState();
    idElegido = widget.idPorDefecto;
  }

  Widget opcion(OpcionDestino destino) {
    final elegida = idElegido == destino.id;
    return InkWell(
      onTap: () => setState(() => idElegido = destino.id),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              elegida ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 20,
              color: elegida ? colorCoral : colorTextoSecundario,
            ),
            const SizedBox(width: 12),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: destino.color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 12),
            Text(destino.nombre, style: Tipografia.textoCampo),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.titulo,
            style: Tipografia.titulo1.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            widget.texto,
            style: Tipografia.textoCampo.copyWith(color: colorTextoSecundario),
          ),
          const SizedBox(height: 16),
          for (final destino in widget.opciones) opcion(destino),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, idElegido),
                  style: ElevatedButton.styleFrom(backgroundColor: colorError),
                  child: const Text('Mover y eliminar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
