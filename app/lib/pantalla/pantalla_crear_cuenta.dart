import 'package:flutter/material.dart';
import '../almacen/almacen_usuarios.dart';
import '../colores.dart';
import '../modelos/usuario.dart';
import '../sesion.dart';
import '../tipografia.dart';
import 'pantalla_cuenta_creada.dart';

class PantallaCrearCuenta extends StatefulWidget {
  const PantallaCrearCuenta({super.key});

  @override
  State<PantallaCrearCuenta> createState() => _EstadoCrearCuenta();
}

class _EstadoCrearCuenta extends State<PantallaCrearCuenta> {
  final controlNombre = TextEditingController();
  final controlCorreo = TextEditingController();
  final controlContrasena = TextEditingController();

  bool ocultarContrasena = true;
  String? errorCorreo;

  @override
  void initState() {
    super.initState();
    controlNombre.addListener(refrescar);
    controlCorreo.addListener(refrescar);
    controlContrasena.addListener(refrescar);
  }

  void refrescar() {
    setState(() {});
  }

  bool get datosValidos {
    return controlNombre.text.isNotEmpty &&
        controlCorreo.text.contains('@') &&
        controlContrasena.text.length >= 6;
  }

  Future<void> crearCuenta() async {
    final repetido = await buscarUsuarioPorCorreo(controlCorreo.text);
    if (!mounted) return;

    if (repetido != null) {
      setState(() {
        errorCorreo = 'Ese correo ya tiene una cuenta';
      });
      return;
    }

    final nuevoUsuario = Usuario(
      nombre: controlNombre.text,
      correo: controlCorreo.text,
      contrasena: controlContrasena.text,
    );
    await crearUsuario(nuevoUsuario);
    await guardarSesion(controlNombre.text, controlCorreo.text);
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (ctx) => PantallaCuentaCreada(nombre: controlNombre.text),
      ),
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
    controlNombre.dispose();
    controlCorreo.dispose();
    controlContrasena.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final faltan = 6 - controlContrasena.text.length;

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
                'Crear cuenta',
                style: Tipografia.titulo1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              etiquetaObligatoria('Nombre'),
              const SizedBox(height: 8),
              TextField(
                controller: controlNombre,
                style: Tipografia.textoCampo,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline, color: colorTextoSecundario, size: 20),
                  hintText: 'Princesa',
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
                  hintText: 'Mínimo 6 caracteres',
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
              const SizedBox(height: 8),
              Text(
                faltan > 0
                    ? 'Mínimo 6 caracteres · te faltan $faltan'
                    : 'Contraseña lista',
                style: Tipografia.textoAyuda,
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: datosValidos ? crearCuenta : null,
                child: const Text('Crear cuenta'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: colorCoral,
                  textStyle: Tipografia.etiqueta,
                ),
                child: const Text('Ya tengo cuenta'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
