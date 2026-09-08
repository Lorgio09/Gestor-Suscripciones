import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../almacen/almacen.dart';
import '../colores.dart';
import '../formato.dart';
import '../modelos/pago.dart';
import '../tipografia.dart';
import 'encabezado.dart';
import 'pantalla_editar.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../colores.dart';
import '../tipografia.dart';
import 'encabezado.dart';
// import '../modelos/pago.dart'; 

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

  void abrirUrl() async {
    final uri = Uri.parse(pago.url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  String textoEstado() {
    if (pago.estado == 'para_cancelar') return 'Marcada para cancelar';
    if (pago.estado == 'cancelada') return 'Suscripción cancelada';
    return 'Suscripción activa';
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
        backgroundColor: Colores.superficie, 
        title: const Text('Eliminar suscripción', style: Tipografia.titulo1),
        content: Text(
          '¿Eliminar "${pago.nombre}"? Esta acción no se puede deshacer.',
          style: Tipografia.textoCampo,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contexto),
            child: const Text('Cancelar', style: Tipografia.textoAyuda),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(contexto);
              await eliminarPago(pago.id!);
              if (mounted) Navigator.pop(context);
            },
            child: Text(
              'Eliminar',
              style: Tipografia.etiqueta.copyWith(color: Colores.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget tarjetaDato(IconData icono, String etiqueta, String valor) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16), 
        child: Row(
          children: [
            Icon(icono, size: 16, color: Colores.textoSecundario),
            const SizedBox(width: 8), 
            Text(etiqueta, style: Tipografia.textoCampo),
            const Spacer(),
            Text(valor, style: Tipografia.numerico), 
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24), 
              const Encabezado(titulo: 'Detalle'), 
              const SizedBox(height: 24),

              Center(
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colores.primario, 
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        inicialDe(pago.nombre),
                        style: Tipografia.titulo1.copyWith(
                          color: Colors.white, 
                          fontSize: 32, 
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(pago.nombre, style: Tipografia.titulo1),
                    const SizedBox(height: 8),
                    Text(textoEstado(), style: Tipografia.textoAyuda),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              tarjetaDato(
                Icons.schedule,
                'Costo mensual',
                'Bs ${pago.costo.toStringAsFixed(2)}',
              ),
              const SizedBox(height: 16),
              tarjetaDato(
                Icons.calendar_today,
                'Próximo pago',
                calcularProximoPago(pago.fecha), 
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: abrirUrl,
                  icon: const Icon(Icons.open_in_new, size: 16),
                  label: const Text('Ir a pagar'),
                ),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: irAEditar,
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: const Text('Editar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colores.primario,
                        side: const BorderSide(color: Colores.primario),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: confirmarEliminar,
                      icon: const Icon(Icons.delete_outline, size: 16),
                      label: const Text('Eliminar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colores.error,
                        side: const BorderSide(color: Colores.error),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}