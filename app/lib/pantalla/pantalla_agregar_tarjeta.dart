import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../almacen/almacen_tarjetas.dart';
import '../colores.dart';
import '../modelos/tarjeta.dart';
import '../tipografia.dart';
import '../widgets/tarjeta_banco.dart';
import 'dialogo_color.dart';
import 'encabezado.dart';
import 'hoja_reasignar.dart';

class PantallaAgregarTarjeta extends StatefulWidget {
  final Tarjeta? tarjeta;

  const PantallaAgregarTarjeta({super.key, this.tarjeta});

  @override
  State<PantallaAgregarTarjeta> createState() => _EstadoAgregarTarjeta();
}

class _EstadoAgregarTarjeta extends State<PantallaAgregarTarjeta> {
  final controlAlias = TextEditingController();
  final controlDigitos = TextEditingController();

  String tipoElegido = 'credito';
  Color colorElegido = coloresTarjeta.first;
  List<Color> coloresDisponibles = List.from(coloresTarjeta);

  @override
  void initState() {
    super.initState();
    controlAlias.addListener(refrescar);
    controlDigitos.addListener(refrescar);

    final tarjeta = widget.tarjeta;
    if (tarjeta != null) {
      controlAlias.text = tarjeta.alias;
      controlDigitos.text = tarjeta.ultimosDigitos;
      tipoElegido = tarjeta.tipo;
      colorElegido = hexaAColor(tarjeta.color);
      if (!coloresDisponibles.contains(colorElegido)) {
        coloresDisponibles.add(colorElegido);
      }
    }
  }

  void refrescar() {
    setState(() {});
  }

  bool get esEdicion => widget.tarjeta != null;

  bool get datosValidos {
    return controlAlias.text.isNotEmpty && controlDigitos.text.length == 4;
  }

  String get textoTipo {
    if (tipoElegido == 'debito') return 'Débito';
    if (tipoElegido == 'billetera') return 'Billetera móvil';
    return 'Crédito';
  }

  String get digitosPrevios {
    if (controlDigitos.text.isEmpty) return '0000';
    return controlDigitos.text.padRight(4, '0');
  }

  Future<void> elegirOtroColor() async {
    final color = await elegirColor(context, colorElegido);
    if (color == null) return;
    setState(() {
      if (!coloresDisponibles.contains(color)) {
        coloresDisponibles.add(color);
      }
      colorElegido = color;
    });
  }

  Future<void> guardarTarjeta() async {
    if (esEdicion) {
      widget.tarjeta!.alias = controlAlias.text;
      widget.tarjeta!.tipo = tipoElegido;
      widget.tarjeta!.ultimosDigitos = controlDigitos.text;
      widget.tarjeta!.color = colorAHexa(colorElegido);
      await actualizarTarjeta(widget.tarjeta!);
      if (!mounted) return;
      Navigator.pop(context);
      return;
    }

    final guardada = await agregarTarjeta(Tarjeta(
      alias: controlAlias.text,
      tipo: tipoElegido,
      ultimosDigitos: controlDigitos.text,
      color: colorAHexa(colorElegido),
    ));
    if (!mounted) return;
    Navigator.pop(context, guardada);
  }

  Future<void> eliminar() async {
    final tarjeta = widget.tarjeta;
    if (tarjeta == null) return;

    final adentro = await pagosDeTarjeta(tarjeta.id!);
    if (!mounted) return;

    if (adentro.isEmpty) {
      final confirmado = await showDialog<bool>(
        context: context,
        builder: (contexto) => AlertDialog(
          backgroundColor: colorBlanco,
          title: Text(
            '¿Eliminar ${tarjeta.alias} •••• ${tarjeta.ultimosDigitos}?',
            style: Tipografia.titulo1.copyWith(fontSize: 18),
          ),
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
      await eliminarTarjeta(tarjeta.id!, null);
      if (!mounted) return;
      Navigator.pop(context);
      return;
    }

    final otras = await leerTarjetas();
    if (!mounted) return;

    final opciones = <OpcionDestino>[
      OpcionDestino(id: 0, nombre: 'Sin tarjeta', color: colorTextoSecundario),
    ];
    for (final otra in otras) {
      if (otra.id == tarjeta.id) continue;
      opciones.add(OpcionDestino(
        id: otra.id!,
        nombre: '${otra.alias} •••• ${otra.ultimosDigitos}',
        color: hexaAColor(otra.color),
      ));
    }

    final idDestino = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: colorBlanco,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (contexto) => HojaReasignar(
        titulo: '¿Eliminar ${tarjeta.alias} •••• ${tarjeta.ultimosDigitos}?',
        texto: 'Tiene ${adentro.length} suscripciones. '
            'Los pagos no se borran: elegí a qué tarjeta pasarlos.',
        opciones: opciones,
        idPorDefecto: 0,
      ),
    );

    if (idDestino == null) return;
    await eliminarTarjeta(tarjeta.id!, idDestino == 0 ? null : idDestino);
    if (!mounted) return;
    Navigator.pop(context);
  }

  Widget chipTipo(String valor, String texto) {
    final elegido = tipoElegido == valor;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () => setState(() => tipoElegido = valor),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: elegido ? colorCoral : colorBlanco,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: elegido ? colorCoral : colorBorde),
          ),
          child: Text(
            texto,
            style: Tipografia.etiqueta.copyWith(
              color: elegido ? colorBlanco : colorTexto,
            ),
          ),
        ),
      ),
    );
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

  Widget etiquetaObligatoria(String texto) {
    return Row(
      children: [
        Text(texto, style: Tipografia.etiqueta),
        Text(' *', style: Tipografia.etiqueta.copyWith(color: colorError)),
      ],
    );
  }

  @override
  void dispose() {
    controlAlias.dispose();
    controlDigitos.dispose();
    super.dispose();
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
              Encabezado(titulo: esEdicion ? 'Editar tarjeta' : 'Agregar tarjeta'),
              const SizedBox(height: 24),

              TarjetaBanco(
                alias: controlAlias.text.isEmpty ? 'Tu banco' : controlAlias.text,
                tipo: textoTipo,
                ultimosDigitos: digitosPrevios,
                color: colorElegido,
                textoAbajoIzquierda: 'Vista previa',
                alto: 132,
              ),
              const SizedBox(height: 24),

              etiquetaObligatoria('Nombre'),
              const SizedBox(height: 8),
              TextField(
                controller: controlAlias,
                style: Tipografia.textoCampo,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.account_balance, color: colorTextoSecundario, size: 20),
                  hintText: 'BCP, Yape, Soles…',
                ),
              ),
              const SizedBox(height: 16),

              Text('Tipo', style: Tipografia.etiqueta),
              const SizedBox(height: 8),
              Row(
                children: [
                  chipTipo('credito', 'Crédito'),
                  chipTipo('debito', 'Débito'),
                  chipTipo('billetera', 'Billetera móvil'),
                ],
              ),
              const SizedBox(height: 16),

              etiquetaObligatoria('Últimos 4 dígitos'),
              const SizedBox(height: 8),
              TextField(
                controller: controlDigitos,
                keyboardType: TextInputType.number,
                maxLength: 4,
                style: Tipografia.textoCampo,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  counterText: '',
                  prefixIcon: Icon(Icons.tag, color: colorTextoSecundario, size: 20),
                  hintText: '4521',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Solo los últimos cuatro. No guardamos el número completo.',
                style: Tipografia.textoAyuda,
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
                      onTap: elegirOtroColor,
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
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: datosValidos ? guardarTarjeta : null,
                child: Text(esEdicion ? 'Guardar cambios' : 'Guardar tarjeta'),
              ),

              if (esEdicion) ...[
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: eliminar,
                    style: TextButton.styleFrom(
                      foregroundColor: colorError,
                      textStyle: Tipografia.etiqueta,
                    ),
                    child: const Text('Eliminar tarjeta'),
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
