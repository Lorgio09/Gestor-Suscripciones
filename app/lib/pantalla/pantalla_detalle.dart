import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../almacen/almacen.dart';
import '../colores.dart';
import '../formato.dart';
import '../modelos/pago.dart';
import '../tipografia.dart';
import 'encabezado.dart';
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
        backgroundColor: Colors.white,
        title: Text('Eliminar suscripción', style: estiloEncabezado),
        content: Text(
          '¿Eliminar "${pago.nombre}"? Esta acción no se puede deshacer.',
          style: estiloTextoCampo,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contexto),
            child: Text('Cancelar', style: estiloSecundario),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(contexto);
              await eliminarPago(pago.id!);
              if (mounted) Navigator.pop(context);
            },
            child: Text(
              'Eliminar',
              style: estiloNombreServicio.copyWith(color: colorError),
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
            Icon(icono, size: 16, color: colorSecundario),
            const SizedBox(width: 8),
            Text(etiqueta, style: estiloTextoCampo),
            const Spacer(),
            Text(valor, style: estiloValorDato),
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
              Encabezado(titulo: 'Detalle'),
              const SizedBox(height: 24),

              Center(
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colorPorNombre(pago.nombre),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(inicialDe(pago.nombre), style: estiloInicialGrande),
                    ),
                    const SizedBox(height: 16),
                    Text(pago.nombre, style: estiloEncabezado),
                    const SizedBox(height: 8),
                    Text(textoEstado(), style: estiloSecundario),
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
                        foregroundColor: colorMarca,
                        side: const BorderSide(color: colorMarca),
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
                        foregroundColor: colorError,
                        side: const BorderSide(color: colorError),
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
