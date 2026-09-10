import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../almacen/almacen.dart';
import '../almacen/almacen_tarjetas.dart';
import '../colores.dart';
import '../formato.dart';
import '../modelos/pago.dart';
import '../modelos/tarjeta.dart';
import '../tipografia.dart';
import 'encabezado.dart';
import 'pantalla_editar.dart';

class PantallaDetalle extends StatefulWidget {
  final Pago pago;

  const PantallaDetalle({super.key, required this.pago});

  @override
  State<PantallaDetalle> createState() => _EstadoDetalle();
}

class _EstadoDetalle extends State<PantallaDetalle> with WidgetsBindingObserver {
  late Pago pago;
  Tarjeta? tarjeta;
  bool esperandoRespuesta = false;

  @override
  void initState() {
    super.initState();
    pago = widget.pago;
    WidgetsBinding.instance.addObserver(this);
    cargarTarjeta();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState estadoApp) {
    if (estadoApp == AppLifecycleState.resumed && esperandoRespuesta) {
      esperandoRespuesta = false;
      preguntarSiPago();
    }
  }

  Future<void> guardarEstado(String nuevoEstado) async {
    pago.estado = nuevoEstado;
    await actualizarPago(pago.id!, pago);
    if (!mounted) return;
    setState(() {});
  }

  void preguntarSiPago() {
    showDialog(
      context: context,
      builder: (contexto) => AlertDialog(
        backgroundColor: colorBlanco,
        title: Text('¿Pagaste ${pago.nombre}?', style: Tipografia.titulo1.copyWith(fontSize: 18)),
        content: Text(
          'Si todavía no lo pagaste la dejamos como pendiente.',
          style: Tipografia.textoCampo,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(contexto);
              await guardarEstado('pendiente');
            },
            child: Text('Todavía no', style: Tipografia.textoAyuda),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(contexto);
              await guardarEstado('activa');
            },
            child: Text(
              'Sí, ya pagué',
              style: Tipografia.etiqueta.copyWith(color: colorCoral),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> cargarTarjeta() async {
    if (pago.idTarjeta == null) return;
    final encontrada = await buscarTarjeta(pago.idTarjeta!);
    if (!mounted) return;
    setState(() {
      tarjeta = encontrada;
    });
  }

  Future<void> abrirUrl() async {
    esperandoRespuesta = true;
    final uri = Uri.parse(pago.url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> irAEditar() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => PantallaEditar(pago: pago)),
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
        backgroundColor: colorBlanco,
        title: Text('Eliminar suscripción', style: Tipografia.titulo1),
        content: Text(
          '¿Eliminar "${pago.nombre}"? Esta acción no se puede deshacer.',
          style: Tipografia.textoCampo,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contexto),
            child: Text('Cancelar', style: Tipografia.textoAyuda),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(contexto);
              await eliminarPago(pago.id!);
              if (mounted) Navigator.pop(context);
            },
            child: Text(
              'Eliminar',
              style: Tipografia.etiqueta.copyWith(color: colorError),
            ),
          ),
        ],
      ),
    );
  }

  Widget badgeEstado() {
    Color fondo = colorExitoSuave;
    Color letra = colorExito;
    IconData icono = Icons.check;
    String texto = 'Suscripción activa';

    if (pago.estado == 'pendiente') {
      fondo = colorAvisoSuave;
      letra = colorAviso;
      icono = Icons.schedule;
      texto = 'Pago pendiente';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 16, color: letra),
          const SizedBox(width: 8),
          Text(texto, style: Tipografia.etiqueta.copyWith(color: letra)),
        ],
      ),
    );
  }

  Widget tarjetaDato(IconData icono, String etiqueta, String valor, {Color? colorValor}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icono, size: 16, color: colorTextoSecundario),
            const SizedBox(width: 12),
            Text(etiqueta, style: Tipografia.textoCampo),
            const Spacer(),
            Text(
              valor,
              style: Tipografia.numerico.copyWith(fontSize: 15, color: colorValor),
            ),
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        color: colorPorNombre(pago.nombre),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        inicialDe(pago.nombre),
                        style: Tipografia.titulo1.copyWith(color: colorBlanco, fontSize: 32),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(pago.nombre, style: Tipografia.titulo1),
                    const SizedBox(height: 8),
                    badgeEstado(),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              tarjetaDato(
                Icons.credit_card,
                'Costo mensual',
                'Bs ${pago.costo.toStringAsFixed(2)}',
              ),
              const SizedBox(height: 16),
              tarjetaDato(
                Icons.calendar_today,
                'Próximo pago',
                calcularProximoPago(pago.fecha),
                colorValor: colorCoral,
              ),
              const SizedBox(height: 16),
              tarjetaDato(
                Icons.account_balance,
                'Pagado con',
                tarjeta == null
                    ? 'Sin tarjeta'
                    : '${tarjeta!.alias} •••• ${tarjeta!.ultimosDigitos}',
              ),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: abrirUrl,
                icon: const Icon(Icons.open_in_new, size: 16),
                label: const Text('Ir a pagar'),
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
                        foregroundColor: colorCoral,
                        side: const BorderSide(color: colorCoral),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
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
