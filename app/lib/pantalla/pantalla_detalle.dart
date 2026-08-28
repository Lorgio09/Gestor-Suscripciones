import 'package:flutter/material.dart';
import '../almacen/almacen.dart';
import '../modelos/pago.dart';
import 'pantalla_editar.dart';

class PantallaDetalle extends StatefulWidget {
  final int indice;
  final Pago pago;

  const PantallaDetalle({super.key, required this.indice, required this.pago});

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
        builder: (ctx) => PantallaEditar(indice: widget.indice, pago: pago),
      ),
    );

    final lista = await leerPagos();
    if (!mounted) return;
    if (widget.indice >= lista.length) return;

    setState(() {
      pago = lista[widget.indice];
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
              await eliminarPago(widget.indice);
              if (mounted) Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: const Color.fromARGB(255, 0, 0, 0)),
            child: const Text('Eliminar'),
          ),
        ],
      ),
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
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Jerarquía principal (título grande, sin etiqueta "Servicio")
                    Text(
                      pago.nombre,
                      style: const TextStyle(
                        fontSize: 26, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 32),

                    const Text(
                      'Costo mensual', 
                      style: TextStyle(color: Colors.black54, fontSize: 13)
                    ),
                    const SizedBox(height: 8), // 8px de separación pequeña
                    Text(
                      'Bs ${pago.costo.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16), // 16px para contenido relacionado

                    const Text(
                      'Fecha de pago', 
                      style: TextStyle(color: Colors.black54, fontSize: 13)
                    ),
                    const SizedBox(height: 8), // 8px
                    Text(
                      pago.fecha,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16), // 16px

                    const Text(
                      'URL para cancelar', 
                      style: TextStyle(color: Colors.black54, fontSize: 13)
                    ),
                    const SizedBox(height: 8), // Escala: 8px
                    Text(
                      pago.url,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: irAEditar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF333333),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Editar'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: confirmarEliminar,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black87,
                              side: const BorderSide(color: Colors.black54),
                              padding: const EdgeInsets.symmetric(vertical: 12),
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
