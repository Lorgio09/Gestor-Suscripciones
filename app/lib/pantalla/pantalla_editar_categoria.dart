import 'package:flutter/material.dart';
import '../almacen/almacen.dart';
import '../almacen/almacen_categorias.dart';
import '../colores.dart';
import '../formato.dart';
import '../modelos/categoria.dart';
import '../modelos/pago.dart';
import '../tipografia.dart';
import 'dialogo_color.dart';
import 'encabezado.dart';
import 'hoja_reasignar.dart';

const coloresCategoria = [
  Color(0xFFF26B5B),
  Color(0xFF1F4E8C),
  Color(0xFF2E7D4F),
  Color(0xFF7B2CBF),
  Color(0xFFD98A1E),
  Color(0xFF2B2B2B),
];

class PantallaEditarCategoria extends StatefulWidget {
  final Categoria? categoria;

  const PantallaEditarCategoria({super.key, this.categoria});

  @override
  State<PantallaEditarCategoria> createState() => _EstadoEditarCategoria();
}

class _EstadoEditarCategoria extends State<PantallaEditarCategoria> {
  final controlNombre = TextEditingController();

  List<Pago> listaPagos = [];
  List<Categoria> listaCategorias = [];
  List<int> idsMarcados = [];
  List<Color> coloresDisponibles = List.from(coloresCategoria);
  Color colorElegido = coloresCategoria.first;
  String? errorNombre;

  @override
  void initState() {
    super.initState();
    if (widget.categoria != null) {
      controlNombre.text = widget.categoria!.nombre;
      colorElegido = hexaAColor(widget.categoria!.color);
      if (!coloresDisponibles.contains(colorElegido)) {
        coloresDisponibles.add(colorElegido);
      }
    }
    cargarTodo();
  }

  Future<void> cargarTodo() async {
    final pagos = await leerPagos();
    final categorias = await leerCategorias();
    if (!mounted) return;
    setState(() {
      listaPagos = pagos;
      listaCategorias = categorias;
      idsMarcados = pagos
          .where((pago) => pago.idCategoria == widget.categoria?.id)
          .map((pago) => pago.id!)
          .toList();
    });
  }

  String nombreCategoriaDe(Pago pago) {
    for (final categoria in listaCategorias) {
      if (categoria.id == pago.idCategoria) return categoria.nombre;
    }
    return '';
  }

  Future<void> abrirSelectorColor() async {
    final color = await elegirColor(context, colorElegido);
    if (color == null) return;
    setState(() {
      if (!coloresDisponibles.contains(color)) {
        coloresDisponibles.add(color);
      }
      colorElegido = color;
    });
  }

  Future<void> guardar() async {
    setState(() {
      errorNombre = controlNombre.text.isEmpty ? 'Este campo es obligatorio' : null;
    });
    if (errorNombre != null) return;

    int idCategoria;
    if (widget.categoria == null) {
      final creada = await agregarCategoria(Categoria(
        nombre: controlNombre.text,
        color: colorAHexa(colorElegido),
      ));
      idCategoria = creada.id!;
    } else {
      widget.categoria!.nombre = controlNombre.text;
      widget.categoria!.color = colorAHexa(colorElegido);
      await actualizarCategoria(widget.categoria!);
      idCategoria = widget.categoria!.id!;
    }

    for (final pago in listaPagos) {
      final marcado = idsMarcados.contains(pago.id);
      if (marcado) {
        await asignarCategoria(pago.id!, idCategoria);
      } else if (pago.idCategoria == idCategoria) {
        await asignarCategoria(pago.id!, null);
      }
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> eliminar() async {
    final categoria = widget.categoria;
    if (categoria == null) return;

    final adentro = listaPagos.where((pago) => pago.idCategoria == categoria.id).toList();

    if (adentro.isEmpty) {
      final confirmado = await showDialog<bool>(
        context: context,
        builder: (contexto) => AlertDialog(
          backgroundColor: colorBlanco,
          title: Text('¿Eliminar ${categoria.nombre}?', style: Tipografia.titulo1),
          content: Text('No tiene suscripciones.', style: Tipografia.textoCampo),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(contexto, false),
              child: Text('Cancelar', style: Tipografia.textoAyuda),
            ),
            TextButton(
              onPressed: () => Navigator.pop(contexto, true),
              child: Text(
                'Eliminar',
                style: Tipografia.etiqueta.copyWith(color: colorError),
              ),
            ),
          ],
        ),
      );
      if (confirmado != true) return;
      final sinCategoria = await buscarSinCategoria();
      await eliminarCategoria(categoria.id!, sinCategoria!.id!);
      if (!mounted) return;
      Navigator.pop(context);
      return;
    }

    final sinCategoria = await buscarSinCategoria();
    if (!mounted) return;

    final opciones = listaCategorias
        .where((otra) => otra.id != categoria.id)
        .map((otra) => OpcionDestino(
              id: otra.id!,
              nombre: otra.nombre,
              color: hexaAColor(otra.color),
            ))
        .toList();

    final idDestino = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: colorBlanco,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (contexto) => HojaReasignar(
        titulo: '¿Eliminar ${categoria.nombre}?',
        texto: 'Tiene ${adentro.length} suscripciones. '
            'Los pagos no se borran: elegí a dónde pasarlos.',
        opciones: opciones,
        idPorDefecto: sinCategoria!.id!,
      ),
    );

    if (idDestino == null) return;
    await eliminarCategoria(categoria.id!, idDestino);
    if (!mounted) return;
    Navigator.pop(context);
  }

  Widget circuloColor(Color color) {
    final elegido = colorElegido == color;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () => setState(() => colorElegido = color),
        customBorder: const CircleBorder(),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: elegido ? Border.all(color: colorTexto, width: 3) : null,
          ),
        ),
      ),
    );
  }

  Widget filaPago(Pago pago) {
    final marcado = idsMarcados.contains(pago.id);
    final otra = nombreCategoriaDe(pago);
    final esDeOtra = pago.idCategoria != null &&
        pago.idCategoria != widget.categoria?.id &&
        otra.isNotEmpty;

    return InkWell(
      onTap: () {
        setState(() {
          if (marcado) {
            idsMarcados.remove(pago.id);
          } else {
            idsMarcados.add(pago.id!);
          }
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: marcado ? colorCoral : colorBlanco,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: marcado ? colorCoral : colorBorde),
              ),
              child: marcado
                  ? const Icon(Icons.check, size: 14, color: colorBlanco)
                  : null,
            ),
            const SizedBox(width: 12),
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
                  if (esDeOtra) ...[
                    const SizedBox(height: 8),
                    Text(
                      'En $otra',
                      style: Tipografia.textoAyuda.copyWith(fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Bs ${pago.costo.toStringAsFixed(2)}',
              style: Tipografia.numerico.copyWith(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controlNombre.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final esNueva = widget.categoria == null;
    final esFija = widget.categoria?.nombre == nombreSinCategoria;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Encabezado(titulo: esNueva ? 'Nueva categoría' : 'Editar categoría'),
              const SizedBox(height: 24),

              Row(
                children: [
                  Text('Nombre', style: Tipografia.etiqueta),
                  Text(' *', style: Tipografia.etiqueta.copyWith(color: colorError)),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controlNombre,
                style: Tipografia.textoCampo,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.sell_outlined, color: colorTextoSecundario, size: 20),
                  hintText: 'Entretenimiento',
                  errorText: errorNombre,
                ),
              ),
              const SizedBox(height: 16),

              Text('Color', style: Tipografia.etiqueta),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final color in coloresDisponibles) circuloColor(color),
                    InkWell(
                      onTap: abrirSelectorColor,
                      customBorder: const CircleBorder(),
                      child: Container(
                        width: 34,
                        height: 34,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colorBlanco,
                          shape: BoxShape.circle,
                          border: Border.all(color: colorBorde),
                        ),
                        child: const Icon(Icons.add, size: 18, color: colorTextoSecundario),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Text('Suscripciones en esta categoría', style: Tipografia.etiqueta),
              const SizedBox(height: 8),
              if (listaPagos.isEmpty)
                Text('Todavía no registraste ninguna.', style: Tipografia.textoAyuda)
              else
                for (final pago in listaPagos) filaPago(pago),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: guardar,
                child: const Text('Guardar'),
              ),

              if (!esNueva && !esFija) ...[
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: eliminar,
                    style: TextButton.styleFrom(
                      foregroundColor: colorError,
                      textStyle: Tipografia.etiqueta,
                    ),
                    child: const Text('Eliminar categoría'),
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
