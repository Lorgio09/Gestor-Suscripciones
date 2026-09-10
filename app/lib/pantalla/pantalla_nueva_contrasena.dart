import 'package:flutter/material.dart';
import '../almacen/almacen_usuarios.dart';
import '../colores.dart';
import '../tipografia.dart';
import 'pantalla_iniciar_sesion.dart';

class PantallaNuevaContrasena extends StatefulWidget {
  final String correo;

  const PantallaNuevaContrasena({super.key, required this.correo});

  @override
  State<PantallaNuevaContrasena> createState() => _EstadoNuevaContrasena();
}

class _EstadoNuevaContrasena extends State<PantallaNuevaContrasena> {
  final controlNueva = TextEditingController();
  final controlRepetir = TextEditingController();

  bool ocultarNueva = true;
  bool ocultarRepetir = true;
  String? errorNueva;
  String? errorRepetir;

  Future<void> guardarContrasena() async {
    setState(() {
      errorNueva = controlNueva.text.length < 6 ? 'Mínimo 6 caracteres' : null;
      errorRepetir = controlRepetir.text == controlNueva.text
          ? null
          : 'Las dos contraseñas tienen que ser iguales';
    });
    if (errorNueva != null || errorRepetir != null) return;

    await actualizarContrasena(widget.correo, controlNueva.text);
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (ctx) => const PantallaIniciarSesion()),
      (ruta) => false,
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
    controlNueva.dispose();
    controlRepetir.dispose();
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
                    child: Text('Nueva contraseña', style: Tipografia.titulo1),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              etiquetaObligatoria('Nueva contraseña'),
              const SizedBox(height: 8),
              TextField(
                controller: controlNueva,
                obscureText: ocultarNueva,
                style: Tipografia.textoCampo,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline, color: colorTextoSecundario, size: 20),
                  hintText: 'Mínimo 6 caracteres',
                  errorText: errorNueva,
                  suffixIcon: IconButton(
                    icon: Icon(
                      ocultarNueva ? Icons.visibility_off : Icons.visibility,
                      color: colorTextoSecundario,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        ocultarNueva = !ocultarNueva;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              etiquetaObligatoria('Repetir contraseña'),
              const SizedBox(height: 8),
              TextField(
                controller: controlRepetir,
                obscureText: ocultarRepetir,
                style: Tipografia.textoCampo,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline, color: colorTextoSecundario, size: 20),
                  hintText: 'Tiene que ser igual',
                  errorText: errorRepetir,
                  suffixIcon: IconButton(
                    icon: Icon(
                      ocultarRepetir ? Icons.visibility_off : Icons.visibility,
                      color: colorTextoSecundario,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        ocultarRepetir = !ocultarRepetir;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: guardarContrasena,
                child: const Text('Guardar contraseña'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
