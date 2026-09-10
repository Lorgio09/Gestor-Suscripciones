import 'package:flutter/material.dart';
import '../almacen/almacen.dart';
import '../almacen/almacen_tarjetas.dart';
import '../colores.dart';
import '../modelos/pago.dart';
import '../modelos/tarjeta.dart';
import '../tipografia.dart';
import 'encabezado.dart';
import 'pantalla_agregar_tarjeta.dart';
import '../widgets/borde_punteado.dart';

class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({super.key});

  @override
  State<PantallaRegistro> createState() => _EstadoRegistro();
}

class _EstadoRegistro extends State<PantallaRegistro> {
  final controlNombre = TextEditingController();
  final controlCosto = TextEditingController();
  final controlFecha = TextEditingController();
  final controlUrl = TextEditingController();

  List<Tarjeta> listaTarjetas = [];
  int? idTarjetaElegida;

  String? errorNombre;
  String? errorCosto;
  String? errorFecha;
  String? errorUrl;
  String? errorTarjeta;

  @override
  void initState() {
    super.initState();
    controlNombre.addListener(refrescar);
    controlCosto.addListener(refrescar);
    controlFecha.addListener(refrescar);
    controlUrl.addListener(refrescar);
    cargarTarjetas();
  }

  void refrescar() {
    setState(() {});
  }

  Future<void> cargarTarjetas() async {
    final datos = await leerTarjetas();
    if (!mounted) return;
    setState(() {
      listaTarjetas = datos;
    });
  }

  bool get camposCompletos {
    return controlNombre.text.isNotEmpty &&
        controlCosto.text.isNotEmpty &&
        controlFecha.text.isNotEmpty &&
        controlUrl.text.isNotEmpty &&
        idTarjetaElegida != null;
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

  Future<void> guardarNuevoPago() async {
    if (!validarFormulario()) return;

    final nuevoPago = Pago(
      nombre: controlNombre.text,
      costo: double.parse(controlCosto.text),
      fecha: controlFecha.text,
      url: controlUrl.text,
      idTarjeta: idTarjetaElegida,
      fechaInicio: controlFecha.text,
    );

    await agregarPago(nuevoPago);
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
              onPrimary: colorBlanco,
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

  Widget chipAgregar() {
    return InkWell(
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
              const Encabezado(titulo: 'Registrar pago'),
              const SizedBox(height: 24),

              etiquetaObligatoria('Servicio'),
              const SizedBox(height: 8),
              TextField(
                controller: controlNombre,
                style: Tipografia.textoCampo,
                decoration: InputDecoration(
                  hintText: 'Ej. Netflix',
                  errorText: errorNombre,
                  prefixIcon: const Icon(Icons.sell_outlined, size: 20, color: colorTextoSecundario),
                ),
              ),
              const SizedBox(height: 16),

              etiquetaObligatoria('Costo mensual'),
              const SizedBox(height: 8),
              TextField(
                controller: controlCosto,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: Tipografia.textoCampo,
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
                readOnly: true,
                onTap: seleccionarFecha,
                style: Tipografia.textoCampo,
                decoration: InputDecoration(
                  hintText: 'DD / MM / AAAA',
                  errorText: errorFecha,
                  prefixIcon: const Icon(Icons.calendar_today, size: 20, color: colorTextoSecundario),
                ),
              ),
              const SizedBox(height: 16),

              etiquetaObligatoria('URL para cancelar'),
              const SizedBox(height: 8),
              TextField(
                controller: controlUrl,
                keyboardType: TextInputType.url,
                style: Tipografia.textoCampo,
                decoration: InputDecoration(
                  hintText: 'https://...',
                  errorText: errorUrl,
                  prefixIcon: const Icon(Icons.link, size: 20, color: colorTextoSecundario),
                ),
              ),
              const SizedBox(height: 16),

              etiquetaObligatoria('¿Con qué tarjeta pagaste?'),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final tarjeta in listaTarjetas) chipTarjeta(tarjeta),
                    chipAgregar(),
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
                child: ElevatedButton(
                  onPressed: camposCompletos ? guardarNuevoPago : null,
                  child: const Text('Guardar pago'),
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
