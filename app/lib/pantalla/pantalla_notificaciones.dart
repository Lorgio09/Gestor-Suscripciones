import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../almacen/almacen_usuarios.dart';
import '../avisos.dart';
import '../correo.dart';
import '../colores.dart';
import '../modelos/usuario.dart';
import '../tipografia.dart';
import 'encabezado.dart';

const variablesMensaje = ['{servicio}', '{monto}', '{fecha}', '{tarjeta}'];

class FormateadorVariables extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue anterior,
    TextEditingValue nuevo,
  ) {
    for (final variable in variablesMensaje) {
      if (anterior.text.contains(variable) && !nuevo.text.contains(variable)) {
        return anterior;
      }
    }
    return nuevo;
  }
}

class ControlMensaje extends TextEditingController {
  ControlMensaje({super.text});

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final trozos = <TextSpan>[];
    final patron = RegExp(r'\{(servicio|monto|fecha|tarjeta)\}');

    text.splitMapJoin(
      patron,
      onMatch: (coincidencia) {
        trozos.add(TextSpan(
          text: coincidencia[0],
          style: (style ?? const TextStyle()).copyWith(
            color: colorCoral,
            backgroundColor: colorCoralSuave,
            fontWeight: FontWeight.w600,
          ),
        ));
        return '';
      },
      onNonMatch: (suelto) {
        trozos.add(TextSpan(text: suelto, style: style));
        return '';
      },
    );

    return TextSpan(children: trozos);
  }
}

class PantallaNotificaciones extends StatefulWidget {
  const PantallaNotificaciones({super.key});

  @override
  State<PantallaNotificaciones> createState() => _EstadoNotificaciones();
}

class _EstadoNotificaciones extends State<PantallaNotificaciones> {
  late ControlMensaje controlMensaje;

  Usuario? usuario;
  bool avisosActivos = true;
  int diasAviso = 3;
  String horaAviso = '09:00';

  @override
  void initState() {
    super.initState();
    controlMensaje = ControlMensaje();
    controlMensaje.addListener(refrescar);
    cargarUsuario();
  }

  void refrescar() {
    setState(() {});
  }

  Future<void> cargarUsuario() async {
    final encontrado = await usuarioActual();
    if (!mounted) return;
    if (encontrado == null) return;
    setState(() {
      usuario = encontrado;
      avisosActivos = encontrado.avisosActivos;
      diasAviso = encontrado.diasAviso;
      horaAviso = encontrado.horaAviso;
      controlMensaje.text = encontrado.mensajeAviso;
    });
  }

  String get mensajeConEjemplos {
    return controlMensaje.text
        .replaceAll('{servicio}', 'Netflix')
        .replaceAll('{monto}', 'Bs 30.00')
        .replaceAll('{fecha}', '31/08')
        .replaceAll('{tarjeta}', '•••• 4521');
  }

  void insertarVariable(String variable) {
    final posicion = controlMensaje.selection.baseOffset;
    final texto = controlMensaje.text;

    if (posicion < 0) {
      controlMensaje.text = texto + variable;
      return;
    }

    controlMensaje.text =
        texto.substring(0, posicion) + variable + texto.substring(posicion);
    controlMensaje.selection = TextSelection.collapsed(
      offset: posicion + variable.length,
    );
  }

  Future<void> elegirHora() async {
    final partes = horaAviso.split(':');
    final horaElegida = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(partes[0]),
        minute: int.parse(partes[1]),
      ),
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
    if (horaElegida == null) return;
    setState(() {
      horaAviso = '${horaElegida.hour.toString().padLeft(2, '0')}:'
          '${horaElegida.minute.toString().padLeft(2, '0')}';
    });
  }

  Future<void> guardar() async {
    if (usuario == null) return;
    await actualizarAvisos(
      usuario!.id!,
      avisosActivos,
      diasAviso,
      horaAviso,
      controlMensaje.text,
    );
    await programarAvisosLocales();
    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> enviarPrueba() async {
    if (usuario == null) return;
    String aviso = 'Te mandamos el correo de prueba';
    try {
      await enviarCorreo(
        usuario!.correo,
        'Netflix vence en $diasAviso días',
        mensajeConEjemplos,
      );
    } catch (falla) {
      aviso = 'No se pudo enviar';
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(aviso, style: Tipografia.textoCampo.copyWith(color: colorBlanco))),
    );
  }

  Widget chipDias(int dias) {
    final elegido = diasAviso == dias;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: avisosActivos ? () => setState(() => diasAviso = dias) : null,
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
            dias == 1 ? '1 día' : '$dias días',
            style: Tipografia.etiqueta.copyWith(
              color: elegido ? colorBlanco : colorTexto,
            ),
          ),
        ),
      ),
    );
  }

  Widget chipVariable(String variable) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: avisosActivos ? () => insertarVariable(variable) : null,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: colorCoralSuave,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            variable,
            style: Tipografia.textoAyuda.copyWith(
              fontSize: 11,
              color: colorCoral,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget vistaPrevia() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorBlanco,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorBorde),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorCoral,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.sync, size: 20, color: colorBlanco),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Suscrip · ahora',
                  style: Tipografia.textoAyuda.copyWith(fontSize: 11),
                ),
                const SizedBox(height: 8),
                Text(
                  'Netflix vence en $diasAviso días',
                  style: Tipografia.textoCampo.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(mensajeConEjemplos, style: Tipografia.textoCampo),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controlMensaje.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorApagado = avisosActivos ? colorTexto : colorPlaceholder;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              const Encabezado(titulo: 'Notificaciones'),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorBlanco,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colorBorde),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recordarme antes de cada cobro',
                            style: Tipografia.etiqueta,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Se aplica a todas las suscripciones',
                            style: Tipografia.textoAyuda.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Switch(
                      value: avisosActivos,
                      activeThumbColor: colorCoral,
                      onChanged: (valor) => setState(() => avisosActivos = valor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                '¿Cuántos días antes?',
                style: Tipografia.etiqueta.copyWith(color: colorApagado),
              ),
              const SizedBox(height: 8),
              Row(
                children: [chipDias(1), chipDias(3), chipDias(7)],
              ),
              const SizedBox(height: 16),

              Text(
                '¿A qué hora?',
                style: Tipografia.etiqueta.copyWith(color: colorApagado),
              ),
              const SizedBox(height: 8),
              TextField(
                readOnly: true,
                enabled: avisosActivos,
                onTap: elegirHora,
                controller: TextEditingController(text: horaAviso),
                style: Tipografia.textoCampo,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.access_time, color: colorTextoSecundario, size: 20),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'Mensaje',
                style: Tipografia.etiqueta.copyWith(color: colorApagado),
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 88),
                child: TextField(
                  controller: controlMensaje,
                  enabled: avisosActivos,
                  maxLines: null,
                  minLines: 3,
                  style: Tipografia.textoCampo,
                  inputFormatters: [FormateadorVariables()],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tocá una variable para insertarla:',
                style: Tipografia.textoAyuda.copyWith(fontSize: 11),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final variable in variablesMensaje) chipVariable(variable),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'Así se va a ver',
                style: Tipografia.etiqueta.copyWith(color: colorApagado),
              ),
              const SizedBox(height: 8),
              vistaPrevia(),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: usuario == null ? null : enviarPrueba,
                icon: const Icon(Icons.send_outlined, size: 16),
                label: const Text('Enviarme una prueba'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorCoral,
                  side: const BorderSide(color: colorCoral),
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: guardar,
                child: const Text('Guardar'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
