import 'package:flutter/material.dart';
import '../almacen/almacen.dart';
import '../almacen/almacen_categorias.dart';
import '../colores.dart';
import '../modelos/categoria.dart';
import '../modelos/pago.dart';
import '../tipografia.dart';
import 'dialogo_color.dart';
import 'encabezado.dart';
import 'pantalla_editar_categoria.dart';
import '../widgets/grafico_torta.dart';

class PantallaCategorias extends StatefulWidget {
  const PantallaCategorias({super.key});

  @override
  State<PantallaCategorias> createState() => _EstadoCategorias();
}

class _EstadoCategorias extends State<PantallaCategorias> {
  List<Categoria> listaCategorias = [];
  List<Pago> listaPagos = [];

  @override
  void initState() {
    super.initState();
    cargarTodo();
  }

  Future<void> cargarTodo() async {
    final categorias = await leerCategorias();
    final pagos = await leerPagos();
    if (!mounted) return;
    setState(() {
      listaCategorias = categorias;
      listaPagos = pagos;
    });
  }

  List<Pago> pagosDe(Categoria categoria) {
    return listaPagos.where((pago) => pago.idCategoria == categoria.id).toList();
  }

  double montoDe(Categoria categoria) {
    double total = 0;
    for (final pago in pagosDe(categoria)) {
      total = total + pago.costo;
    }
    return total;
  }

  List<Porcion> get porciones {
    final todas = <Porcion>[];
    for (final categoria in listaCategorias) {
      final monto = montoDe(categoria);
      if (monto <= 0) continue;
      todas.add(Porcion(
        etiqueta: categoria.nombre,
        color: hexaAColor(categoria.color),
        monto: monto,
      ));
    }
    return agruparEnOtros(todas);
  }

  Future<void> abrirEditar(Categoria? categoria) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => PantallaEditarCategoria(categoria: categoria),
      ),
    );
    cargarTodo();
  }

  Widget grafico() {
    final lista = porciones;

    return Container(
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
            'Gasto por categoría este mes',
            style: Tipografia.etiqueta,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          GraficoTorta(porciones: lista),
        ],
      ),
    );
  }

  Widget filaCategoria(Categoria categoria) {
    final fija = categoria.nombre == nombreSinCategoria;
    final cantidad = pagosDe(categoria).length;
    final color = hexaAColor(categoria.color);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: fija ? null : () => abrirEditar(categoria),
        borderRadius: BorderRadius.circular(14),
        child: Container(
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
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  fija ? Icons.lock_outline : Icons.sell_outlined,
                  size: 20,
                  color: color,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categoria.nombre,
                      style: Tipografia.textoCampo.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      fija
                          ? 'Fija · no se puede borrar'
                          : '$cantidad suscripciones · Bs ${montoDe(categoria).toStringAsFixed(2)}',
                      style: Tipografia.textoAyuda.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (!fija)
                const Icon(Icons.chevron_right, color: colorTextoSecundario),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              const Encabezado(titulo: 'Mis categorías'),
              const SizedBox(height: 24),

              grafico(),
              const SizedBox(height: 16),

              for (final categoria in listaCategorias) filaCategoria(categoria),

              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => abrirEditar(null),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Nueva categoría'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorCoral,
                  side: const BorderSide(color: colorCoral),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
