import 'package:flutter/material.dart';
import '../almacen/almacen_usuarios.dart';
import '../colores.dart';
import '../sesion.dart';
import '../tipografia.dart';
import 'pantalla_crear_cuenta.dart';
import 'pantalla_principal.dart';
import 'pantalla_recuperar_contrasena.dart';

class PantallaIniciarSesion extends StatefulWidget {
  const PantallaIniciarSesion({super.key});

  @override
  State<PantallaIniciarSesion> createState() => _EstadoIniciarSesion();
}

class _EstadoIniciarSesion extends State<PantallaIniciarSesion> {
  final controlCorreo = TextEditingController();
  final controlContrasena = TextEditingController();

  bool ocultarContrasena = true;
  String? errorCorreo;
  String? errorContrasena;

  Future<void> iniciarSesion() async {
    setState(() {
      errorCorreo = controlCorreo.text.isEmpty ? 'Escribí tu correo' : null;
      errorContrasena = controlContrasena.text.isEmpty ? 'Escribí tu contraseña' : null;
    });
    if (errorCorreo != null || errorContrasena != null) return;

    final usuario = await validarUsuario(controlCorreo.text, controlContrasena.text);
    if (!mounted) return;

    if (usuario == null) {
      setState(() {
        errorContrasena = 'El correo o la contraseña no coinciden';
      });
      return;
    }

    await guardarSesion(usuario.nombre, usuario.correo);
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (ctx) => const PantallaPrincipal()),
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
              Center(
                child: Container(
                  width: 56,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    gradient: degradadoMarca,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.sync, color: colorBlanco, size: 28),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Iniciar sesión',
                style: Tipografia.titulo1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Entrá para ver tus suscripciones',
                style: Tipografia.textoCampo.copyWith(color: colorTextoSecundario),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              etiquetaObligatoria('Correo'),
              const SizedBox(height: 8),
              TextField(
                controller: controlCorreo,
                keyboardType: TextInputType.emailAddress,
                style: Tipografia.textoCampo,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.mail_outline, color: colorTextoSecundario, size: 20),
                  hintText: 'princesa@uagrm.edu.bo',
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
                onPressed: iniciarSesion,
                child: const Text('Iniciar sesión'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => const PantallaCrearCuenta()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorCoral,
                  side: const BorderSide(color: colorCoral),
                ),
                child: const Text('Crear cuenta'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => const PantallaRecuperarContrasena(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: colorCoral,
                  textStyle: Tipografia.etiqueta,
                ),
                child: const Text('¿Olvidaste tu contraseña?'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
