import 'package:flutter/material.dart';
import '../almacen/almacen.dart';
import 'package:url_launcher/url_launcher.dart';
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

  void irADetalle(int indice, Pago pago) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => PantallaDetalle(indice: indice, pago: pago),
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
          ? const Center(child: Text('No hay suscripciones registradas.'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: listaPagos.length,
              itemBuilder: (contexto, i) {
                final pago = listaPagos[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () => irADetalle(i, pago),
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                pago.nombre,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                'Bs ${pago.costo.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Proximo pago: ${calcularProximoPago(pago.fecha)}',
                            style: const TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          const SizedBox(height: 10),
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
        backgroundColor: const Color(0xFF444444),
        onPressed: irARegistro,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}