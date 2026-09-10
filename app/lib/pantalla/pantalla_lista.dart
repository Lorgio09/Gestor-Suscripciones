import 'package:flutter/material.dart';
import '../almacen/almacen.dart';
import '../avisos.dart';
import '../almacen/almacen_tarjetas.dart';
import '../colores.dart';
import '../formato.dart';
import '../modelos/pago.dart';
import '../modelos/tarjeta.dart';
import '../sesion.dart';
import '../tipografia.dart';
import 'pantalla_registro.dart';
import 'pantalla_detalle.dart';

class PantallaLista extends StatefulWidget {
  const PantallaLista({super.key});

  @override
  State<PantallaLista> createState() => _EstadoLista();
}

class _EstadoLista extends State<PantallaLista> {
  List<Pago> listaPagos = [];
  List<Tarjeta> listaTarjetas = [];
  String nombreUsuario = '';

  @override
  void initState() {
    super.initState();
    cargarTodo();
  }

  Future<void> cargarTodo() async {
    final pagos = await leerPagos();
    final tarjetas = await leerTarjetas();
    final nombre = await leerNombreUsuario();
    if (!mounted) return;
    setState(() {
      listaPagos = pagos;
      listaTarjetas = tarjetas;
      nombreUsuario = nombre;
    });

    revisarAvisos();
  }

  double get gastoMensual {
    double total = 0;
    for (final pago in listaPagos) {
      total = total + pago.costo;
    }
    return total;
  }

  int get diasParaElProximoCobro {
    int menor = 999;
    for (final pago in listaPagos) {
      final dias = diasHastaCobro(calcularProximoPago(pago.fecha));
      if (dias < menor) menor = dias;
    }
    if (menor == 999) return 0;
    return menor;
  }

  Tarjeta? tarjetaDe(Pago pago) {
    if (pago.idTarjeta == null) return null;
    for (final tarjeta in listaTarjetas) {
      if (tarjeta.id == pago.idTarjeta) return tarjeta;
    }
    return null;
  }

  void irARegistro() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => const PantallaRegistro()),
    );
    cargarTodo();
  }

  void irADetalle(Pago pago) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => PantallaDetalle(pago: pago)),
    );
    cargarTodo();
  }

  Widget resumen() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        gradient: degradadoMarca,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gasto mensual total',
            style: Tipografia.textoAyuda.copyWith(fontSize: 12, color: colorBlanco),
          ),
          const SizedBox(height: 8),
          Text(
            'Bs ${gastoMensual.toStringAsFixed(2)}',
            style: Tipografia.numerico.copyWith(fontSize: 30, color: colorBlanco),
          ),
          const SizedBox(height: 8),
          Text(
            '${listaPagos.length} activas · próximo cobro en $diasParaElProximoCobro días',
            style: Tipografia.textoAyuda.copyWith(fontSize: 12, color: colorBlanco),
          ),
        ],
      ),
    );
  }

  Widget fila(Pago pago) {
    final proximo = calcularProximoPago(pago.fecha);
    final tarjeta = tarjetaDe(pago);

    String detalle = 'Vence el ${fechaCorta(proximo)}';
    if (tarjeta != null) {
      detalle = '$detalle · •••• ${tarjeta.ultimosDigitos}';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => irADetalle(pago),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                      detalle,
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
                    'Bs ${pago.costo.toStringAsFixed(2)}',
                    style: Tipografia.numerico.copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  Text('/mes', style: Tipografia.textoAyuda),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
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
              const Text('Mis suscripciones', style: Tipografia.titulo1),
              const SizedBox(height: 16),

              resumen(),
              const SizedBox(height: 16),

              Expanded(
                child: listaPagos.isEmpty
                    ? Center(
                        child: Text(
                          'No hay suscripciones registradas.',
                          style: Tipografia.textoAyuda,
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: listaPagos.length,
                        itemBuilder: (contexto, i) => fila(listaPagos[i]),
                      ),
              ),
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
            onPressed: irARegistro,
            child: const Icon(Icons.add, color: colorBlanco),
          ),
        ),
      ),
    );
  }
}
