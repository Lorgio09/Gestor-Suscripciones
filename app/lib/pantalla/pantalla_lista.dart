import 'package:flutter/material.dart';
import '../almacen/almacen.dart';
import '../colores.dart';
import '../formato.dart';
import '../modelos/pago.dart';
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

  @override
  void initState() {
    super.initState();
    cargarPagos();
  }

  Future<void> cargarPagos() async {
    final datos = await leerPagos(); 
    setState(() {
      listaPagos = datos;
    });
  }

  void irARegistro() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => const PantallaRegistro()),
    );
    cargarPagos();
  }

  void irADetalle(Pago pago) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => PantallaDetalle(pago: pago),
      ),
    );
    cargarPagos();
  }

  Widget armarTarjeta(Pago pago) {
    final proximo = calcularProximoPago(pago.fecha);
    final colorVencimiento = estaPorVencer(proximo) ? Colores.error : Colores.textoSecundario;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => irADetalle(pago),
        borderRadius: BorderRadius.circular(14), 
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colores.primario, 
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  inicialDe(pago.nombre), 
                  style: Tipografia.titulo1.copyWith(color: Colores.superficie, fontSize: 20),
                ),
              ),
              const SizedBox(width: 16),
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
                      'Vence el ${fechaCorta(proximo)}',
                      style: Tipografia.textoAyuda.copyWith(color: colorVencimiento),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Bs ${pago.costo.toStringAsFixed(2)}', style: Tipografia.numerico),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text('Mis suscripciones', style: Tipografia.titulo1),
              const SizedBox(height: 24),
              Expanded(
                child: listaPagos.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay suscripciones registradas.',
                          style: Tipografia.textoAyuda,
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: listaPagos.length,
                        itemBuilder: (contexto, i) => armarTarjeta(listaPagos[i]),
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
            backgroundColor: Colores.primario,
            elevation: 0,
            shape: const CircleBorder(),
            onPressed: irARegistro,
            child: const Icon(Icons.add, color: Colores.superficie),
          ),
        ),
      ),
    );
  }
}