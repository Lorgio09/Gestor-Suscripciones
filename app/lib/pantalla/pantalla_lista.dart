import 'package:flutter/material.dart';
import '../almacen/almacen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../colores.dart';
import '../modelos/pago.dart';
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

  void abrirUrl(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  String calcularProximoPago(String fecha) {
    final partes = fecha.split('/');
    if (partes.length != 3) return fecha;

    int dia = int.parse(partes[0]);
    int mes = int.parse(partes[1]);
    int anio = int.parse(partes[2]);

    mes = mes + 1;
    if (mes > 12) {
      mes = 1;
      anio = anio + 1;
    }

    final diaStr = dia.toString().padLeft(2, '0');
    final mesStr = mes.toString().padLeft(2, '0');
    return '$diaStr/$mesStr/$anio';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Suscripciones'),
      ),
      body: listaPagos.isEmpty
          ? const Center(
              child: Text(
                'No hay suscripciones registradas.',
                style: TextStyle(fontSize: 14, color: colorTextoSuave),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: listaPagos.length,
              itemBuilder: (contexto, i) {
                final pago = listaPagos[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: InkWell(
                    onTap: () => irADetalle(pago),
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                pago.nombre,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: colorTexto,
                                ),
                              ),
                              Text(
                                'Bs ${pago.costo.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: colorTexto,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Próximo pago: ${calcularProximoPago(pago.fecha)}',
                            style: const TextStyle(fontSize: 12, color: colorTextoSuave),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () => abrirUrl(pago.url),
                              child: const Text('Ir a pagar'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorAcento,
        onPressed: irARegistro,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}