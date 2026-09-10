import 'package:flutter/material.dart';
import '../almacen/almacen_tarjetas.dart';
import '../colores.dart';
import '../formato.dart';
import '../modelos/pago.dart';
import '../modelos/tarjeta.dart';
import '../tipografia.dart';
import '../widgets/grafico_torta.dart';
import 'pantalla_agregar_tarjeta.dart';

class PantallaDetalleTarjeta extends StatefulWidget {
  final Tarjeta tarjeta;

  const PantallaDetalleTarjeta({super.key, required this.tarjeta});

  @override
  State<PantallaDetalleTarjeta> createState() => _EstadoDetalleTarjeta();
}

class _EstadoDetalleTarjeta extends State<PantallaDetalleTarjeta> {
  late Tarjeta tarjeta;
  List<Pago> listaPagos = [];

  @override
  void initState() {
    super.initState();
    tarjeta = widget.tarjeta;
    cargarPagos();
  }

  Future<void> cargarPagos() async {
    final pagos = await pagosDeTarjeta(tarjeta.id!);
    final actualizada = await buscarTarjeta(tarjeta.id!);
    if (!mounted) return;
    if (actualizada == null) {
      Navigator.pop(context);
      return;
    }
    setState(() {
      tarjeta = actualizada;
      listaPagos = pagos.where((pago) => pago.estado != 'cancelada').toList();
    });
  }

  List<Porcion> get porciones {
    final todas = listaPagos
        .map((pago) => Porcion(
              etiqueta: pago.nombre,
              monto: pago.costo,
              color: colorPorNombre(pago.nombre),
            ))
        .toList();
    return agruparEnOtros(todas);
  }

  Future<void> irAEditar() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => PantallaAgregarTarjeta(tarjeta: tarjeta),
      ),
    );
    if (!mounted) return;
    cargarPagos();
  }

  Widget filaPago(Pago pago) {
    final meses = mesesDesde(pago.fechaInicio);
    final total = pago.costo * meses;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorBlanco,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorBorde),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorPorNombre(pago.nombre),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              inicialDe(pago.nombre),
              style: Tipografia.numerico.copyWith(color: colorBlanco),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pago.nombre,
                  style: Tipografia.textoCampo.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'Desde ${mesYAnio(pago.fechaInicio)} · '
                  '${meses == 1 ? "1 mes" : "$meses meses"}',
                  style: Tipografia.textoAyuda.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Bs ${total.toStringAsFixed(2)}',
                style: Tipografia.numerico.copyWith(fontSize: 15),
              ),
              const SizedBox(height: 8),
              Text('total', style: Tipografia.textoAyuda),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFondo,
      appBar: AppBar(
        backgroundColor: colorFondo,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: colorTexto),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${tarjeta.alias} •••• ${tarjeta.ultimosDigitos}',
          style: Tipografia.titulo1.copyWith(fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: colorTexto),
            onPressed: irAEditar,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorBlanco,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colorBorde),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Gasto de este mes por servicio',
                    style: Tipografia.etiqueta,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  GraficoTorta(porciones: porciones, mostrarPorcentaje: true),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Text('Desde que te suscribiste', style: Tipografia.etiqueta),
            const SizedBox(height: 8),
            if (listaPagos.isEmpty)
              Text(
                'Esta tarjeta todavía no paga ninguna suscripción.',
                style: Tipografia.textoAyuda,
              )
            else
              for (final pago in listaPagos) filaPago(pago),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
