import 'package:flutter/material.dart';
import '../almacen/almacen_usuarios.dart';
import '../colores.dart';
import '../modelos/usuario.dart';
import '../sesion.dart';
import '../tipografia.dart';
import 'encabezado.dart';

class PantallaEditarPerfil extends StatefulWidget {
  const PantallaEditarPerfil({super.key});

  @override
  State<PantallaEditarPerfil> createState() => _EstadoEditarPerfil();
}

class _EstadoEditarPerfil extends State<PantallaEditarPerfil> {
  final controlNombre = TextEditingController();
  final controlCorreo = TextEditingController();
  final controlContrasena = TextEditingController();

  Usuario? usuario;
  bool ocultarContrasena = true;
  String? errorNombre;
  String? errorCorreo;
  String? errorContrasena;

  @override
  void initState() {
    super.initState();
    cargarUsuario();
  }

  Future<void> cargarUsuario() async {
    final encontrado = await usuarioActual();
    if (!mounted) return;
    if (encontrado == null) return;
    setState(() {
      usuario = encontrado;
      controlNombre.text = encontrado.nombre;
      controlCorreo.text = encontrado.correo;
      controlContrasena.text = encontrado.contrasena;
    });
  }

  Future<void> guardarCambios() async {
    setState(() {
      errorNombre = controlNombre.text.isEmpty ? 'Este campo es obligatorio' : null;
      errorCorreo = controlCorreo.text.contains('@') ? null : 'Escribí un correo válido';
      errorContrasena =
          controlContrasena.text.length >= 6 ? null : 'Mínimo 6 caracteres';
    });
    if (errorNombre != null || errorCorreo != null || errorContrasena != null) return;
    if (usuario == null) return;

    usuario!.nombre = controlNombre.text;
    usuario!.correo = controlCorreo.text;
    usuario!.contrasena = controlContrasena.text;

    await actualizarUsuario(usuario!);
    await guardarSesion(controlNombre.text, controlCorreo.text);
    if (!mounted) return;
    Navigator.pop(context);
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
    controlCorreo.dispose();
    controlContrasena.dispose();
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
              const Encabezado(titulo: 'Editar perfil'),
              const SizedBox(height: 24),

              etiquetaObligatoria('Nombre'),
              const SizedBox(height: 8),
              TextField(
                controller: controlNombre,
                style: Tipografia.textoCampo,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline, color: colorTextoSecundario, size: 20),
                  errorText: errorNombre,
                ),
              ),
              const SizedBox(height: 16),

              etiquetaObligatoria('Correo'),
              const SizedBox(height: 8),
              TextField(
                controller: controlCorreo,
                keyboardType: TextInputType.emailAddress,
                style: Tipografia.textoCampo,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.mail_outline, color: colorTextoSecundario, size: 20),
                  errorText: errorCorreo,
                ),
              ),
              const SizedBox(height: 16),

              etiquetaObligatoria('Contraseña'),
              const SizedBox(height: 8),
              TextField(
                controller: controlContrasena,
                obscureText: ocultarContrasena,
                style: Tipografia.textoCampo,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline, color: colorTextoSecundario, size: 20),
                  errorText: errorContrasena,
                  suffixIcon: IconButton(
                    icon: Icon(
                      ocultarContrasena ? Icons.visibility_off : Icons.visibility,
                      color: colorTextoSecundario,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        ocultarContrasena = !ocultarContrasena;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: guardarCambios,
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
