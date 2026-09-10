import 'package:flutter/material.dart';
import '../almacen/almacen.dart';
import '../almacen/almacen_tarjetas.dart';
import '../colores.dart';
import '../modelos/pago.dart';
import '../modelos/tarjeta.dart';
import '../sesion.dart';
import '../tipografia.dart';
import '../widgets/tarjeta_banco.dart';
import 'dialogo_color.dart';
import 'pantalla_agregar_tarjeta.dart';
import 'pantalla_detalle_tarjeta.dart';

class PantallaBilletera extends StatefulWidget {
  const PantallaBilletera({super.key});

  @override
  State<PantallaBilletera> createState() => _EstadoBilletera();
}

class _EstadoBilletera extends State<PantallaBilletera> {
  List<Tarjeta> listaTarjetas = [];
  List<Pago> listaPagos = [];
  String nombreUsuario = '';

  @override
  void initState() {
    super.initState();
    cargarTodo();
  }

  Future<void> cargarTodo() async {
    final tarjetas = await leerTarjetas();
    final pagos = await leerPagos();
    final nombre = await leerNombreUsuario();
    if (!mounted) return;
    setState(() {
      listaTarjetas = tarjetas;
      listaPagos = pagos;
      nombreUsuario = nombre;
    });
  }

  List<Pago> pagosActivosDe(Tarjeta tarjeta) {
    return listaPagos
        .where((pago) => pago.idTarjeta == tarjeta.id && pago.estado != 'cancelada')
        .toList();
  }

  double calcularGastoTarjeta(Tarjeta tarjeta) {
    double total = 0;
    for (final pago in pagosActivosDe(tarjeta)) {
      total = total + pago.costo;
    }
    return total;
  }

  double get totalDelMes {
    double total = 0;
    for (final tarjeta in listaTarjetas) {
      total = total + calcularGastoTarjeta(tarjeta);
    }
    return total;
  }

  Future<void> irAAgregar() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => const PantallaAgregarTarjeta()),
    );
    cargarTodo();
  }

  Future<void> irADetalle(Tarjeta tarjeta) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => PantallaDetalleTarjeta(tarjeta: tarjeta)),
    );
    cargarTodo();
  }

  String textoTipo(String tipo) {
    if (tipo == 'debito') return 'Débito';
    if (tipo == 'billetera') return 'Billetera móvil';
    return 'Crédito';
  }

  Widget estadoVacio() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.credit_card, size: 48, color: colorTextoSecundario),
          const SizedBox(height: 16),
          Text(
            'Todavía no tenés tarjetas',
            style: Tipografia.textoCampo.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Agregá una para saber con qué pagás cada suscripción.',
            style: Tipografia.textoCampo.copyWith(color: colorTextoSecundario),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: irAAgregar,
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Agregar tarjeta'),
            style: ElevatedButton.styleFrom(minimumSize: const Size(0, 52)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (listaTarjetas.isEmpty) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                'Hola, $nombreUsuario',
                style: Tipografia.etiqueta.copyWith(
                  fontWeight: FontWeight.w400,
                  color: colorTextoSecundario,
                ),
              ),
              const SizedBox(height: 8),
              const Text('Mi billetera', style: Tipografia.titulo1),
              Expanded(child: estadoVacio()),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorFondo,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text(
                'Hola, $nombreUsuario',
                style: Tipografia.etiqueta.copyWith(
                  fontWeight: FontWeight.w400,
                  color: colorTextoSecundario,
                ),
              ),
              const SizedBox(height: 8),
              const Text('Mi billetera', style: Tipografia.titulo1),
              const SizedBox(height: 16),

              for (final tarjeta in listaTarjetas)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () => irADetalle(tarjeta),
                    borderRadius: BorderRadius.circular(18),
                    child: TarjetaBanco(
                      alias: tarjeta.alias,
                      tipo: textoTipo(tarjeta.tipo),
                      ultimosDigitos: tarjeta.ultimosDigitos,
                      color: hexaAColor(tarjeta.color),
                      textoAbajoIzquierda: pagosActivosDe(tarjeta).isEmpty
                          ? 'Sin pagos todavía'
                          : '${pagosActivosDe(tarjeta).length} suscripciones',
                      textoAbajoDerecha: pagosActivosDe(tarjeta).isEmpty
                          ? ''
                          : 'Bs ${calcularGastoTarjeta(tarjeta).toStringAsFixed(2)} /mes',
                    ),
                  ),
                ),

              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorBlanco,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colorBorde),
                ),
                child: Row(
                  children: [
                    Text('Total del mes', style: Tipografia.textoCampo),
                    const Spacer(),
                    Text(
                      'Bs ${totalDelMes.toStringAsFixed(2)}',
                      style: Tipografia.numerico.copyWith(fontSize: 15),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 16, bottom: 16),
        child: SizedBox(
          width: 56,
          height: 56,
          child: FloatingActionButton(
            backgroundColor: colorCoral,
            elevation: 0,
            shape: const CircleBorder(),
            onPressed: irAAgregar,
            child: const Icon(Icons.add, color: colorBlanco),
          ),
        ),
      ),
    );
  }
}
