import 'package:flutter/material.dart';
import '../colores.dart';
import '../tipografia.dart';

class PantallaCrearCuenta extends StatefulWidget {
  const PantallaCrearCuenta({super.key});

  @override
  State<PantallaCrearCuenta> createState() => _PantallaCrearCuentaState();
}

class _PantallaCrearCuentaState extends State<PantallaCrearCuenta> {
  bool _ocultarPassword = true;
  Widget _construirEtiqueta(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0), 
      child: RichText(
        text: TextSpan(
          text: texto,
          style: Tipografia.etiqueta,
          children: const [
            TextSpan(
              text: ' *',
              style: TextStyle(color: Colores.error),
            ),
          ],
        ),
      ),
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
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              
              const SizedBox(height: 16), 
              
              const Text(
                'Crear cuenta',
                style: Tipografia.titulo1,
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 24), 
              
              _construirEtiqueta('Nombre'),
              TextFormField(
                style: Tipografia.textoCampo,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person, color: Colores.textoSecundario, size: 20),
                  hintText: 'Princesa',
                ),
              ),
              
              const SizedBox(height: 16), 
              
              _construirEtiqueta('Correo'),
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
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: const BorderSide(color: Colores.error),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: const BorderSide(color: Colores.error),
                  ),
                ),
              ),
              
              const SizedBox(height: 8), 
              
              const Text(
                'Mínimo 6 caracteres · llevás 4',
                style: Tipografia.textoAyuda,
              ),
              
              const SizedBox(height: 24), 
              
              SizedBox(
                height: 51, 
                child: ElevatedButton(
                  onPressed: null, 
                  child: const Text('Crear cuenta'),
                ),
              ),
              
              const SizedBox(height: 16), 

              TextButton(
                onPressed: () {
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colores.primario,
                  textStyle: Tipografia.etiqueta, 
                ),
                child: const Text('Ya tengo cuenta'),
              ),
              
              const SizedBox(height: 24), // Espaciado final
            ],
          ),
        ),
      ),
    );
  }
}