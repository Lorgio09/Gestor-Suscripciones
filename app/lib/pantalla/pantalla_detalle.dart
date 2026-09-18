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
import 'pantalla_suscripcion_cancelada.dart';

const motivosCancelacion = ['Muy cara', 'Ya no la uso', 'Encontré otra', 'Otro'];

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
  String? opcionElegida;
  String? errorOpcion;
  String? motivoElegido;
  String? errorMotivo;
  final controlMotivo = TextEditingController();

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
    controlMotivo.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState estadoApp) {
    if (estadoApp == AppLifecycleState.resumed && esperandoRespuesta) {
      esperandoRespuesta = false;
      preguntarSiPago();
    }
  }

  Widget opcionRespuesta(String valor, String texto, void Function(void Function()) refrescar) {
    final elegida = opcionElegida == valor;
    return InkWell(
      onTap: () => refrescar(() {
        opcionElegida = valor;
        errorOpcion = null;
      }),
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
            Text(texto, style: Tipografia.textoCampo),
          ],
        ),
      ),
    );
  }

  void preguntarSiPago() {
    opcionElegida = null;
    errorOpcion = null;

    showDialog(
      context: context,
      builder: (contexto) => StatefulBuilder(
        builder: (ctx, refrescar) => AlertDialog(
          backgroundColor: colorBlanco,
          title: Text('¿Qué pasó con ${pago.nombre}?', style: Tipografia.tituloDialogo),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              opcionRespuesta('pague', 'Ya pagué', refrescar),
              opcionRespuesta('cancele', 'La cancelé', refrescar),
              opcionRespuesta('nada', 'Todavía nada', refrescar),
              if (errorOpcion != null) ...[
                const SizedBox(height: 8),
                Text(
                  errorOpcion!,
                  style: Tipografia.textoAyuda.copyWith(color: colorError),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (opcionElegida == null) {
                  refrescar(() => errorOpcion = 'Elegí una opción para continuar');
                  return;
                }
                Navigator.pop(contexto);
                resolverRespuesta(opcionElegida!);
              },
              child: Text(
                'Confirmar',
                style: Tipografia.etiqueta.copyWith(color: colorCoral),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> resolverRespuesta(String opcion) async {
    if (opcion == 'cancele') {
      hojaCancelar();
      return;
    }

    if (opcion == 'pague') {
      pago.fechaUltimoPago = fechaDeHoy();
      pago.estado = 'activa';
      pago.fecha = calcularProximoPago(pago.fecha);
    } else {
      pago.estado = 'pendiente';
    }

    await actualizarPago(pago.id!, pago);
    if (!mounted) return;
    setState(() {});
  }

  Widget etiquetaObligatoria(String texto) {
    return Row(
      children: [
        Text(texto, style: Tipografia.etiqueta),
        Text(' *', style: Tipografia.etiqueta.copyWith(color: colorError)),
      ],
    );
  }

  Widget chipMotivo(String motivo, void Function(void Function()) refrescar) {
    final elegido = motivoElegido == motivo;
    return InkWell(
      onTap: () => refrescar(() {
        motivoElegido = motivo;
        errorMotivo = null;
      }),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: elegido ? colorCoral : colorBlanco,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: elegido ? colorCoral : colorBorde),
        ),
        child: Text(
          motivo,
          style: Tipografia.etiqueta.copyWith(
            color: elegido ? colorBlanco : colorTexto,
          ),
        ),
      ),
    );
  }

  void hojaCancelar() {
    motivoElegido = null;
    errorMotivo = null;
    controlMotivo.clear();

    showModalBottomSheet(
      context: context,
      backgroundColor: colorBlanco,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (contexto) => StatefulBuilder(
        builder: (ctx, refrescar) => Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 24,
            bottom: MediaQuery.of(contexto).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Cancelar ${pago.nombre}', style: Tipografia.titulo2),
              const SizedBox(height: 8),
              Text(
                'Dejará de contar en tu gasto mensual (Bs ${pago.costo.toStringAsFixed(2)}).',
                style: Tipografia.textoChico,
              ),
              const SizedBox(height: 24),

              etiquetaObligatoria('¿Por qué la cancelás?'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final motivo in motivosCancelacion) chipMotivo(motivo, refrescar),
                ],
              ),

              if (motivoElegido == 'Otro') ...[
                const SizedBox(height: 8),
                TextField(
                  controller: controlMotivo,
                  style: Tipografia.textoCampo,
                  decoration: InputDecoration(
                    hintText: 'Contanos qué pasó',
                    errorText: errorMotivo,
                  ),
                ),
              ] else if (errorMotivo != null) ...[
                const SizedBox(height: 8),
                Text(
                  errorMotivo!,
                  style: Tipografia.textoAyuda.copyWith(color: colorError),
                ),
              ],

              const SizedBox(height: 16),
              Text(
                'No se borra nada: la podés reactivar cuando quieras.',
                style: Tipografia.textoAyuda,
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(contexto),
                      child: const Text('Volver'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => confirmarCancelacion(refrescar, contexto),
                      child: const Text('Cancelar suscripción'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> confirmarCancelacion(
    void Function(void Function()) refrescar,
    BuildContext hoja,
  ) async {
    if (motivoElegido == null) {
      refrescar(() => errorMotivo = 'Elegí un motivo');
      return;
    }
    if (motivoElegido == 'Otro' && controlMotivo.text.trim().length < 5) {
      refrescar(() => errorMotivo = 'Contanos el motivo (mínimo 5 letras)');
      return;
    }

    Navigator.pop(hoja);

    pago.estado = 'cancelada';
    pago.motivoCancelacion =
        motivoElegido == 'Otro' ? controlMotivo.text.trim() : motivoElegido!;
    pago.fechaCancelacion = fechaDeHoy();
    await actualizarPago(pago.id!, pago);

    if (!mounted) return;
    setState(() {});

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => PantallaSuscripcionCancelada(pago: pago),
      ),
    );
  }

  Future<void> reactivar() async {
    try {
      pago.estado = 'activa';
      pago.fecha = calcularProximoPago(fechaDeHoy());
      pago.motivoCancelacion = '';
      pago.fechaCancelacion = null;
      await actualizarPago(pago.id!, pago);
    } catch (falla) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No se pudo reactivar, revisá tu conexión',
            style: Tipografia.textoCampo.copyWith(color: colorBlanco),
          ),
        ),
      );
      return;
    }

    if (!mounted) return;
    setState(() {});
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

  Widget etiquetaEstado() {
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

    if (pago.estado == 'cancelada') {
      fondo = colorDeshabilitado;
      letra = colorTextoSecundario;
      icono = Icons.block;
      texto = 'Cancelada';
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
              style: Tipografia.montoFila.copyWith(color: colorValor),
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
                        color: colorDePago(pago),
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
                    etiquetaEstado(),
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

              if (pago.fechaUltimoPago != null) ...[
                const SizedBox(height: 16),
                tarjetaDato(
                  Icons.check_circle_outline,
                  'Último pago',
                  pago.fechaUltimoPago!,
                  colorValor: colorExito,
                ),
              ],

              if (pago.estado == 'cancelada') ...[
                const SizedBox(height: 16),
                tarjetaDato(
                  Icons.info_outline,
                  'Motivo',
                  pago.motivoCancelacion.isEmpty ? 'Sin motivo' : pago.motivoCancelacion,
                ),
              ],

              const SizedBox(height: 24),

              if (pago.estado == 'cancelada')
                ElevatedButton.icon(
                  onPressed: reactivar,
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Reactivar suscripción'),
                )
              else
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

              if (pago.estado != 'cancelada') ...[
                const SizedBox(height: 8),
                TextButton(
                  onPressed: hojaCancelar,
                  child: Text(
                    'Cancelar suscripción',
                    style: Tipografia.etiqueta.copyWith(color: colorError),
                  ),
                ),
              ],

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
