import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../colores.dart';
import '../correo.dart';
import '../tipografia.dart';
import 'pantalla_nueva_contrasena.dart';

class PantallaCodigo extends StatefulWidget {
  final String correo;
  final String codigoEnviado;

  const PantallaCodigo({
    super.key,
    required this.correo,
    required this.codigoEnviado,
  });

  @override
  State<PantallaCodigo> createState() => _EstadoCodigo();
}

class _EstadoCodigo extends State<PantallaCodigo> {
  final controles = List.generate(4, (i) => TextEditingController());
  final focos = List.generate(4, (i) => FocusNode());

  late String codigoActual;
  String? errorCodigo;

  @override
  void initState() {
    super.initState();
    codigoActual = widget.codigoEnviado;
  }

  String get codigoEscrito {
    return controles.map((control) => control.text).join();
  }

  void moverFoco(int posicion, String texto) {
    if (texto.isNotEmpty && posicion < 3) {
      focos[posicion + 1].requestFocus();
    }
    if (texto.isEmpty && posicion > 0) {
      focos[posicion - 1].requestFocus();
    }
  }

  void continuar() {
    if (codigoEscrito.length < 4) {
      setState(() {
        errorCodigo = 'Completá los 4 dígitos';
      });
      return;
    }
    if (codigoEscrito != codigoActual) {
      setState(() {
        errorCodigo = 'El código no coincide';
      });
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => PantallaNuevaContrasena(correo: widget.correo),
      ),
    );
  }

  Future<void> reenviar() async {
    final nuevoCodigo = generarCodigo();
    try {
      await enviarCodigo(widget.correo, nuevoCodigo);
    } catch (falla) {
      if (!mounted) return;
      setState(() {
        errorCodigo = 'No pudimos reenviar el correo';
      });
      return;
    }

    if (!mounted) return;
    setState(() {
      codigoActual = nuevoCodigo;
      errorCodigo = null;
      for (final control in controles) {
        control.clear();
      }
    });
    focos[0].requestFocus();
  }

  Widget cajaDigito(int posicion) {
    return SizedBox(
      width: 48,
      height: 56,
      child: TextField(
        controller: controles[posicion],
        focusNode: focos[posicion],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: Tipografia.numerico.copyWith(fontSize: 22),
        onChanged: (texto) => moverFoco(posicion, texto),
        decoration: const InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (final control in controles) {
      control.dispose();
    }
    for (final foco in focos) {
      foco.dispose();
    }
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
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colorBlanco,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: colorBorde),
                      ),
                      child: const Icon(Icons.chevron_left, size: 20, color: colorTexto),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('Escribí el código', style: Tipografia.titulo1),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              RichText(
                text: TextSpan(
                  text: 'Te mandamos un código de 4 dígitos a\n',
                  style: Tipografia.textoCampo.copyWith(
                    color: colorTextoSecundario,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                      text: widget.correo,
                      style: Tipografia.textoCampo.copyWith(color: colorTexto),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  cajaDigito(0),
                  const SizedBox(width: 12),
                  cajaDigito(1),
                  const SizedBox(width: 12),
                  cajaDigito(2),
                  const SizedBox(width: 12),
                  cajaDigito(3),
                ],
              ),

              if (errorCodigo != null) ...[
                const SizedBox(height: 8),
                Text(
                  errorCodigo!,
                  style: Tipografia.textoAyuda.copyWith(color: colorError),
                  textAlign: TextAlign.center,
                ),
              ],

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: continuar,
                child: const Text('Continuar'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: reenviar,
                style: TextButton.styleFrom(
                  foregroundColor: colorCoral,
                  textStyle: Tipografia.etiqueta,
                ),
                child: const Text('Reenviar código'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
