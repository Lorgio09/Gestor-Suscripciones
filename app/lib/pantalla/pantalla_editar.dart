import 'package:flutter/material.dart';
import '../almacen/almacen.dart';
import '../modelos/pago.dart';

class PantallaEditar extends StatefulWidget {
  final int indice;
  final Pago pago;

  const PantallaEditar({super.key, required this.indice, required this.pago});

  @override
  State<PantallaEditar> createState() => _EstadoEditar();
}

class _EstadoEditar extends State<PantallaEditar> {
  late final TextEditingController controlNombre;
  late final TextEditingController controlCosto;
  late final TextEditingController controlFecha;
  late final TextEditingController controlUrl;
  String msjError = '';

  @override
  void initState() {
    super.initState();
    controlNombre = TextEditingController(text: widget.pago.nombre);
    controlCosto = TextEditingController(text: widget.pago.costo.toString());
    controlFecha = TextEditingController(text: widget.pago.fecha);
    controlUrl = TextEditingController(text: widget.pago.url);
  }

  bool validarFormulario() {
    if (controlNombre.text.isEmpty ||
        controlCosto.text.isEmpty ||
        controlFecha.text.isEmpty ||
        controlUrl.text.isEmpty) {
      setState(() {
        msjError = 'Todos los campos son obligatorios.';
      });
      return false;
    }
    if (!controlUrl.text.startsWith('http://') &&
        !controlUrl.text.startsWith('https://')) {
      setState(() {
        msjError = 'La URL debe empezar con http:// o https://';
      });
      return false;
    }
    setState(() {
      msjError = '';
    });
    return true;
  }

  Future<void> guardarCambios() async {
    if (!validarFormulario()) return;

    final pagoEditado = Pago(
      nombre: controlNombre.text,
      costo: double.tryParse(controlCosto.text) ?? 0,
      fecha: controlFecha.text,
      url: controlUrl.text,
      estado: widget.pago.estado,
    );

    await actualizarPago(widget.indice, pagoEditado);
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
      controlFecha.text = '$anio-$mes-$dia';
    }
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
        title: const Text('Editar suscripcion'),
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
                    const Text('Servicio', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                    const SizedBox(height: 6),
                    TextField(controller: controlNombre),
                    const SizedBox(height: 16),

                    const Text('Costo mensual (Bs)', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: controlCosto,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 16),

                    const Text('Fecha de pago', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: controlFecha,
                      readOnly: true,
                      onTap: seleccionarFecha,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.calendar_today, size: 18),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text('URL para cancelar', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                    const SizedBox(height: 6),
                    TextField(controller: controlUrl, keyboardType: TextInputType.url),
                    const SizedBox(height: 16),

                    if (msjError.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(msjError, style: const TextStyle(color: Colors.red, fontSize: 14)),
                      ),

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