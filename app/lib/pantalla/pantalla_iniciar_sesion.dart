import 'package:flutter/material.dart';
import '../colores.dart';
import '../tipografia.dart';
import 'pantalla_registro.dart';
import 'pantalla_lista.dart';
import 'pantalla_crear_cuenta.dart';
import 'pantalla_recuperar_contrasena.dart';

class PantallaIniciarSesion extends StatefulWidget {
  const PantallaIniciarSesion({super.key});

  @override
  State<PantallaIniciarSesion> createState() => _EstadoIniciarSesion();
}

class _EstadoIniciarSesion extends State<PantallaIniciarSesion> {
  bool _ocultarPassword = true;
  String? errorDatos;
  
  Widget _construirEtiqueta(String texto) {
    return Row(
      children: [
        Text(texto, style: Tipografia.etiqueta),
        Text(' *', style: Tipografia.etiqueta.copyWith(color: Colores.error)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0), 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24), 
              
              Center(
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colores.primario,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.refresh, 
                    color: Colores.superficie, 
                    size: 28,
                  ),
                ),
              ),
              
              const SizedBox(height: 16), 
              
              // Título
              const Text(
                'Iniciar sesión',
                style: Tipografia.titulo1,
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8), 
              
              Text(
                'Entrá para ver tus suscripciones',
                style: Tipografia.textoCampo.copyWith(color: Colores.textoSecundario),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 24), 
              _construirEtiqueta('Correo'),
              const SizedBox(height: 8),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                style: Tipografia.textoCampo,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.mail_outline, color: Colores.textoSecundario, size: 20),
                  hintText: 'princesa@uagrm.edu.bo',
                ),
              ),
              
              const SizedBox(height: 16), 
              
              _construirEtiqueta('Contraseña'),
              const SizedBox(height: 8),
              TextFormField(
                obscureText: _ocultarPassword,
                style: Tipografia.textoCampo,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline, color: Colores.textoSecundario, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _ocultarPassword ? Icons.visibility_off : Icons.visibility,
                      color: Colores.textoSecundario,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _ocultarPassword = !_ocultarPassword;
                      });
                    },
                  ),
                  errorText: errorDatos, 
                ),
              ),
              
              const SizedBox(height: 24),
              
              SizedBox(
                height: 51,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const PantallaLista()),
                    );
                  },
                  child: const Text('Iniciar sesión'),
                ),
              ),
              
              const SizedBox(height: 8), 
              
              SizedBox(
                height: 47,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PantallaCrearCuenta()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colores.primario,
                    side: const BorderSide(color: Colores.primario),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Crear cuenta'),
                ),
              ),
              
              const SizedBox(height: 16), 
              
              TextButton(
                onPressed: () {
                  // Navega a la pantalla de Recuperar Contraseña
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PantallaRecuperarContrasena(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colores.primario,
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