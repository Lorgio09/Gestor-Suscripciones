import 'package:flutter/material.dart';
import '../colores.dart';
import '../tipografia.dart';

class PantallaRecuperarContrasena extends StatefulWidget {
  final String correoDestino;

  const PantallaRecuperarContrasena({
    super.key,
    this.correoDestino = 'princesa@uagrm.edu.bo', 
  });

  @override
  State<PantallaRecuperarContrasena> createState() => _EstadoRecuperarContrasena();
}

class _EstadoRecuperarContrasena extends State<PantallaRecuperarContrasena> {
  bool _ocultarNuevaPassword = true;
  bool _ocultarRepetirPassword = true;

  Widget _construirEtiqueta(String texto) {
    return Row(
      children: [
        Text(texto, style: Tipografia.etiqueta),
        Text(' *', style: Tipografia.etiqueta.copyWith(color: Colores.error)),
      ],
    );
  }

  Widget _construirCirculo(bool lleno) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: lleno ? Colores.primario : Colors.transparent,
        border: lleno 
            ? null 
            : Border.all(color: Colores.primario, width: 2), 
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
              const SizedBox(height: 16),
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colores.superficie, 
                        shape: BoxShape.circle,
                        border: Border.all(color: Colores.borde),
                      ),
                      child: const Icon(
                        Icons.chevron_left,
                        size: 20,
                        color: Colores.textoPrincipal,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Recuperar contraseña',
                    style: Tipografia.titulo1,
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              RichText(
                text: TextSpan(
                  text: 'Te mandamos un código de 4 dígitos a\n',
                  style: Tipografia.textoCampo.copyWith(
                    color: Colores.textoSecundario,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                      text: widget.correoDestino,
                      style: Tipografia.textoCampo.copyWith(
                        fontWeight: FontWeight.bold, 
                        color: Colores.textoPrincipal,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _construirCirculo(true),
                  const SizedBox(width: 12), 
                  _construirCirculo(true),
                  const SizedBox(width: 12),
                  _construirCirculo(true),
                  const SizedBox(width: 12),
                  _construirCirculo(false),
                ],
              ),
              
              const SizedBox(height: 24),
              
              _construirEtiqueta('Nueva contraseña'),
              const SizedBox(height: 8),
              TextFormField(
                obscureText: _ocultarNuevaPassword,
                style: Tipografia.textoCampo,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline, color: Colores.textoSecundario, size: 20),
                  hintText: 'Mínimo 6 caracteres',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _ocultarNuevaPassword ? Icons.visibility_off : Icons.visibility,
                      color: Colores.textoSecundario,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _ocultarNuevaPassword = !_ocultarNuevaPassword;
                      });
                    },
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Campo: Repetir contraseña
              _construirEtiqueta('Repetir contraseña'),
              const SizedBox(height: 8),
              TextFormField(
                obscureText: _ocultarRepetirPassword,
                style: Tipografia.textoCampo,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline, color: Colores.textoSecundario, size: 20),
                  hintText: 'Tiene que ser igual',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _ocultarRepetirPassword ? Icons.visibility_off : Icons.visibility,
                      color: Colores.textoSecundario,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _ocultarRepetirPassword = !_ocultarRepetirPassword;
                      });
                    },
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              SizedBox(
                height: 51,
                child: ElevatedButton(
                  onPressed: () {
                  },
                  child: const Text('Guardar contraseña'),
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