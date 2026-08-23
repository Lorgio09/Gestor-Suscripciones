import 'package:flutter/material.dart';
import '../almacen/almacen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../modelos/pago.dart';
import 'pantalla_registro.dart';
import 'pantalla_editar.dart';

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

  void confirmarEliminar(int indice) {
    showDialog(
      context: context,
      builder: (contexto) => AlertDialog(
        title: const Text('Eliminar suscripcion'),
        content: Text('¿Eliminar "${listaPagos[indice].nombre}"? Esta accion no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contexto),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(contexto);
              await eliminarPago(indice);
              cargarPagos();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void abrirUrl(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  String formatearFecha(String fecha) {
    final partes = fecha.split('-');
    if (partes.length == 3) {
      return '${partes[2]}/${partes[1]}/${partes[0]}';
    }
    return fecha;
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

  void irAEditar(int indice, Pago pago) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => PantallaEditar(indice: indice, pago: pago),
      ),
    );
    cargarPagos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Suscripciones'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: irARegistro,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Registrar nuevo pago'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: Card(
            child: listaPagos.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(child: Text('No hay suscripciones registradas.')),
                  )
                : DataTable(
                    columnSpacing: 20,
                    horizontalMargin: 16,
                    columns: const [
                      DataColumn(label: Text('Servicio')),
                      DataColumn(label: Text('Costo')),
                      DataColumn(label: Text('Proximo pago')),
                      DataColumn(label: Text('Accion')),
                    ],
                    rows: List.generate(listaPagos.length, (i) {
                      final pago = listaPagos[i];
                      return DataRow(cells: [
                        DataCell(Text(pago.nombre)),
                        DataCell(Text('Bs ${pago.costo.toStringAsFixed(2)}')),
                        DataCell(Text(calcularProximoPago(pago.fecha))),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () => abrirUrl(pago.url),
                                child: const Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Icon(Icons.open_in_new, size: 16, color: Colors.blue),
                                ),
                              ),
                              InkWell(
                                onTap: () => irAEditar(i, pago),
                                child: const Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Icon(Icons.edit, size: 16),
                                ),
                              ),
                              InkWell(
                                onTap: () => confirmarEliminar(i),
                                child: const Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Icon(Icons.delete, size: 16, color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]);
                    }),
                  ),
          ),
        ),
      ),
    );
  }
}