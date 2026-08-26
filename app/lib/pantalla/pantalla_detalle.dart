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
  late final TextEditingController controlNombre;
  late final TextEditingController controlCosto;
  late final TextEditingController controlFecha;
  late final TextEditingController controlUrl;

  @override
  void initState() {
    super.initState();
    pago = widget.pago;
    controlNombre = TextEditingController(text: pago.nombre);
    controlCosto = TextEditingController(text: 'Bs ${pago.costo.toStringAsFixed(2)}');
    controlFecha = TextEditingController(text: pago.fecha);
    controlUrl = TextEditingController(text: pago.url);
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
      controlNombre.text = pago.nombre;
      controlCosto.text = 'Bs ${pago.costo.toStringAsFixed(2)}';
      controlFecha.text = pago.fecha;
      controlUrl.text = pago.url;
    });
  }

  void confirmarEliminar() {
    showDialog(
      context: context,
      builder: (contexto) => AlertDialog(
        title: const Text('Eliminar suscripcion'),
        content: Text('¿Eliminar "${pago.nombre}"? Esta accion no se puede deshacer.'),
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
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controlNombre.dispose();
    controlCosto.dispose();
    controlFecha.dispose();
    controlUrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de suscripcion'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Servicio', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                    const SizedBox(height: 6),
                    TextField(controller: controlNombre, enabled: false),
                    const SizedBox(height: 16),

                    const Text('Costo mensual (Bs)', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                    const SizedBox(height: 6),
                    TextField(controller: controlCosto, enabled: false),
                    const SizedBox(height: 16),

                    const Text('Fecha de pago', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                    const SizedBox(height: 6),
                    TextField(controller: controlFecha, enabled: false),
                    const SizedBox(height: 16),

                    const Text('URL para cancelar', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                    const SizedBox(height: 6),
                    TextField(controller: controlUrl, enabled: false),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: irAEditar,
                            child: const Text('Editar'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: confirmarEliminar,
                            style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
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
