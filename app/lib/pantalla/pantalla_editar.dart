import 'package:flutter/material.dart';
import '../almacen/almacen.dart';
import '../almacen/almacen_tarjetas.dart';
import '../modelos/tarjeta.dart';
import '../widgets/borde_punteado.dart';
import '../colores.dart';
import '../modelos/pago.dart';
import '../tipografia.dart';
import 'encabezado.dart';
import 'pantalla_agregar_tarjeta.dart';

class PantallaEditar extends StatefulWidget {
  final Pago pago;

  const PantallaEditar({super.key, required this.pago});

  @override
  State<PantallaEditar> createState() => _EstadoEditar();
}

class _EstadoEditar extends State<PantallaEditar> {
  late final TextEditingController controlNombre;
  late final TextEditingController controlCosto;
  late final TextEditingController controlFecha;
  late final TextEditingController controlUrl;

  String? errorNombre;
  String? errorCosto;
  String? errorFecha;
  String? errorUrl;
  String? errorTarjeta;

  List<Tarjeta> listaTarjetas = [];
  int? idTarjetaElegida;

  @override
  void initState() {
    super.initState();
    controlNombre = TextEditingController(text: widget.pago.nombre);
    controlCosto = TextEditingController(text: widget.pago.costo.toStringAsFixed(2));
    controlFecha = TextEditingController(text: widget.pago.fecha);
    controlUrl = TextEditingController(text: widget.pago.url);
    idTarjetaElegida = widget.pago.idTarjeta;
    cargarTarjetas();
  }

  Future<void> cargarTarjetas() async {
    final datos = await leerTarjetas();
    if (!mounted) return;
    setState(() {
      listaTarjetas = datos;
    });
  }

  Future<void> irAAgregarTarjeta() async {
    final tarjetaNueva = await Navigator.push<Tarjeta>(
      context,
      MaterialPageRoute(builder: (ctx) => const PantallaAgregarTarjeta()),
    );
    if (!mounted) return;
    if (tarjetaNueva == null) return;
    setState(() {
      listaTarjetas.add(tarjetaNueva);
      idTarjetaElegida = tarjetaNueva.id;
      errorTarjeta = null;
    });
  }

  Widget chipTarjeta(Tarjeta tarjeta) {
    final elegida = idTarjetaElegida == tarjeta.id;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            idTarjetaElegida = tarjeta.id;
            errorTarjeta = null;
          });
        },
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: elegida ? colorCoral : colorBlanco,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: elegida ? colorCoral : colorBorde),
          ),
          child: Row(
            children: [
              Icon(
                Icons.credit_card,
                size: 16,
                color: elegida ? colorBlanco : colorTextoSecundario,
              ),
              const SizedBox(width: 8),
              Text(
                '•••• ${tarjeta.ultimosDigitos}',
                style: Tipografia.etiqueta.copyWith(
                  color: elegida ? colorBlanco : colorTexto,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validarFormulario() {
    setState(() {
      errorNombre = controlNombre.text.isEmpty ? 'Este campo es obligatorio' : null;
      errorFecha = controlFecha.text.isEmpty ? 'Este campo es obligatorio' : null;
      errorTarjeta = idTarjetaElegida == null ? 'Elegí una tarjeta' : null;

      if (controlCosto.text.isEmpty) {
        errorCosto = 'Este campo es obligatorio';
      } else if (double.tryParse(controlCosto.text) == null) {
        errorCosto = 'Ingrese un número, por ejemplo 51.90';
      } else {
        errorCosto = null;
      }

      if (controlUrl.text.isEmpty) {
        errorUrl = 'Este campo es obligatorio';
      } else if (!controlUrl.text.startsWith('http://') &&
          !controlUrl.text.startsWith('https://')) {
        errorUrl = 'Debe empezar con http:// o https://';
      } else {
        errorUrl = null;
      }
    });

    return errorNombre == null &&
        errorCosto == null &&
        errorFecha == null &&
        errorUrl == null &&
        errorTarjeta == null;
  }

  Future<void> guardarCambios() async {
    if (!validarFormulario()) return;

    final pagoEditado = Pago(
      id: widget.pago.id,
      nombre: controlNombre.text,
      costo: double.parse(controlCosto.text),
      fecha: controlFecha.text,
      url: controlUrl.text,
      estado: widget.pago.estado,
      idTarjeta: idTarjetaElegida,
      idCategoria: widget.pago.idCategoria,
      motivoCancelacion: widget.pago.motivoCancelacion,
    );

    await actualizarPago(widget.pago.id!, pagoEditado);
    if (mounted) Navigator.pop(context);
  }

  Future<void> seleccionarFecha() async {
    final fechaElegida = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: colorCoral, 
              onPrimary: Colors.white,
              onSurface: colorTexto,
            ),
          ),
          child: child!,
        );
      },
    );
    if (fechaElegida != null) {
      final dia = fechaElegida.day.toString().padLeft(2, '0');
      final mes = fechaElegida.month.toString().padLeft(2, '0');
      final anio = fechaElegida.year.toString();
      controlFecha.text = '$dia/$mes/$anio';
    }
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
    controlNombre.dispose();
    controlCosto.dispose();
    controlFecha.dispose();
    controlUrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Encabezado(titulo: 'Editar suscripción'),
              const SizedBox(height: 24),

              etiquetaObligatoria('Servicio'),
              const SizedBox(height: 8),
              TextField(
                controller: controlNombre,
                style: Tipografia.textoCampo,
                decoration: InputDecoration(
                  hintText: 'Ej. Netflix',
                  errorText: errorNombre,
                  prefixIcon: const Icon(Icons.local_offer_outlined,
                      size: 16, color: colorTextoSecundario),
                ),
              ),
              const SizedBox(height: 16),

              etiquetaObligatoria('Costo mensual'),
              const SizedBox(height: 8),
              TextField(
                controller: controlCosto,
                style: Tipografia.textoCampo,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: '0.00',
                  prefixText: 'Bs  ',
                  errorText: errorCosto,
                ),
              ),
              const SizedBox(height: 16),

              etiquetaObligatoria('Fecha de pago'),
              const SizedBox(height: 8),
              TextField(
                controller: controlFecha,
                style: Tipografia.textoCampo,
                readOnly: true,
                onTap: seleccionarFecha,
                decoration: InputDecoration(
                  hintText: 'DD / MM / AAAA',
                  errorText: errorFecha,
                  prefixIcon: const Icon(Icons.calendar_today_outlined,
                      size: 16, color: colorTextoSecundario),
                ),
              ),
              const SizedBox(height: 16),

              etiquetaObligatoria('URL para cancelar'),
              const SizedBox(height: 8),
              TextField(
                controller: controlUrl,
                style: Tipografia.textoCampo,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  hintText: 'https://...',
                  errorText: errorUrl,
                  prefixIcon: const Icon(Icons.link,
                      size: 16, color: colorTextoSecundario),
                ),
              ),
              const SizedBox(height: 16),

              etiquetaObligatoria('¿Con qué tarjeta pagás?'),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final tarjeta in listaTarjetas) chipTarjeta(tarjeta),
                    InkWell(
                      onTap: irAAgregarTarjeta,
                      borderRadius: BorderRadius.circular(18),
                      child: BordePunteado(
                        child: Container(
                          height: 36,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          alignment: Alignment.center,
                          child: Text(
                            '+ Agregar',
                            style: Tipografia.etiqueta.copyWith(color: colorCoral),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (errorTarjeta != null) ...[
                const SizedBox(height: 8),
                Text(
                  errorTarjeta!,
                  style: Tipografia.textoAyuda.copyWith(color: colorError),
                ),
              ],
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: guardarCambios,
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('Guardar cambios'),
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