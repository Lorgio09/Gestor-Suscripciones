import 'package:flutter/material.dart';
import '../almacen/almacen.dart';
import '../colores.dart';
import '../modelos/pago.dart';
import 'pantalla_editar.dart';

class PantallaDetalle extends StatefulWidget {
  final Pago pago;

  const PantallaDetalle({super.key, required this.pago});

  @override
  State<PantallaDetalle> createState() => _EstadoDetalle();
}

class _EstadoDetalle extends State<PantallaDetalle> {
  late Pago pago;

  @override
  void initState() {
    super.initState();
    pago = widget.pago;
  }

  Future<void> irAEditar() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => PantallaEditar(pago: pago),
      ),
    );

    final pagoActualizado = await buscarPago(pago.id!);
    if (!mounted) return;
    if (pagoActualizado == null) return;

    setState(() {
      pago = pagoActualizado;
    });
  }

  void confirmarEliminar() {
    showDialog(
      context: context,
      builder: (contexto) => AlertDialog(
        title: const Text('Eliminar suscripción'),
        content: Text('¿Eliminar "${pago.nombre}"? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contexto),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(contexto);
              await eliminarPago(pago.id!);
              if (mounted) Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: colorError),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  Widget filaDato(String etiqueta, String valor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          etiqueta,
          style: const TextStyle(fontSize: 13, color: colorTextoSuave),
        ),
        const SizedBox(height: 8),
        Text(
          valor,
          style: const TextStyle(fontSize: 16, color: colorTexto),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Suscripción'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pago.nombre,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: colorTexto,
                      ),
                    ),
                    const SizedBox(height: 24),

                    filaDato('Costo mensual', 'Bs ${pago.costo.toStringAsFixed(2)}'),
                    const SizedBox(height: 16),

                    filaDato('Fecha de pago', pago.fecha),
                    const SizedBox(height: 16),

                    filaDato('URL para cancelar', pago.url),
                    const SizedBox(height: 32),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: irAEditar,
                            child: const Text('Editar'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: confirmarEliminar,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: colorError,
                              side: const BorderSide(color: colorError),
                            ),
                            child: const Text('Eliminar'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
