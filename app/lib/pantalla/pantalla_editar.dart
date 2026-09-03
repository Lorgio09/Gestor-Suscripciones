import 'package:flutter/material.dart';
import '../almacen/almacen.dart';
import '../colores.dart';
import '../modelos/pago.dart';
import '../tipografia.dart';
import 'encabezado.dart';

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

  @override
  void initState() {
    super.initState();
    controlNombre = TextEditingController(text: widget.pago.nombre);
    controlCosto = TextEditingController(text: widget.pago.costo.toStringAsFixed(2));
    controlFecha = TextEditingController(text: widget.pago.fecha);
    controlUrl = TextEditingController(text: widget.pago.url);
  }

  bool validarFormulario() {
    setState(() {
      errorNombre = controlNombre.text.isEmpty ? 'Este campo es obligatorio' : null;
      errorFecha = controlFecha.text.isEmpty ? 'Este campo es obligatorio' : null;

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
        errorUrl == null;
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
        Text(texto, style: estiloEtiquetaCampo),
        Text(' *', style: estiloEtiquetaCampo.copyWith(color: colorError)),
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
              Encabezado(titulo: 'Editar suscripción'),
              const SizedBox(height: 24),

              etiquetaObligatoria('Servicio'),
              const SizedBox(height: 8),
              TextField(
                controller: controlNombre,
                style: estiloTextoCampo,
                decoration: InputDecoration(
                  hintText: 'Ej. Netflix',
                  errorText: errorNombre,
                  prefixIcon: const Icon(Icons.local_offer_outlined,
                      size: 16, color: colorSecundario),
                ),
              ),
              const SizedBox(height: 16),

              etiquetaObligatoria('Costo mensual'),
              const SizedBox(height: 8),
              TextField(
                controller: controlCosto,
                style: estiloTextoCampo,
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
                style: estiloTextoCampo,
                readOnly: true,
                onTap: seleccionarFecha,
                decoration: InputDecoration(
                  hintText: 'DD / MM / AAAA',
                  errorText: errorFecha,
                  prefixIcon: const Icon(Icons.calendar_today_outlined,
                      size: 16, color: colorSecundario),
                ),
              ),
              const SizedBox(height: 16),

              etiquetaObligatoria('URL para cancelar'),
              const SizedBox(height: 8),
              TextField(
                controller: controlUrl,
                style: estiloTextoCampo,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  hintText: 'https://...',
                  errorText: errorUrl,
                  prefixIcon: const Icon(Icons.link,
                      size: 16, color: colorSecundario),
                ),
              ),
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
