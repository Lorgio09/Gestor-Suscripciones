import 'package:flutter/material.dart';
import '../almacen/almacen.dart';
import '../colores.dart';
import '../modelos/pago.dart';

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
        Text(
          texto,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: colorTexto,
          ),
        ),
        const Text(' *', style: TextStyle(fontSize: 14, color: colorError)),
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
      appBar: AppBar(
        title: const Text('Editar suscripción'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Datos de la suscripción',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorTexto,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Los campos con * son obligatorios',
                      style: TextStyle(fontSize: 12, color: colorTextoSuave),
                    ),
                    const SizedBox(height: 20),

                    etiquetaObligatoria('Servicio'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controlNombre,
                      decoration: InputDecoration(errorText: errorNombre),
                    ),
                    const SizedBox(height: 16),

                    etiquetaObligatoria('Costo mensual (Bs)'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controlCosto,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(errorText: errorCosto),
                    ),
                    const SizedBox(height: 16),

                    etiquetaObligatoria('Fecha de pago'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controlFecha,
                      readOnly: true,
                      onTap: seleccionarFecha,
                      decoration: InputDecoration(
                        errorText: errorFecha,
                        suffixIcon: const Icon(Icons.calendar_today, size: 18),
                      ),
                    ),
                    const SizedBox(height: 16),

                    etiquetaObligatoria('URL para cancelar'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controlUrl,
                      keyboardType: TextInputType.url,
                      decoration: InputDecoration(errorText: errorUrl),
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: guardarCambios,
                        child: const Text('Guardar cambios'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
