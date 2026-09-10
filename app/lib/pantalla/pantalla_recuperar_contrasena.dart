import 'package:flutter/material.dart';
import '../almacen/almacen_usuarios.dart';
import '../colores.dart';
import '../correo.dart';
import '../tipografia.dart';
import 'pantalla_codigo.dart';

class PantallaRecuperarContrasena extends StatefulWidget {
  const PantallaRecuperarContrasena({super.key});

  @override
  State<PantallaRecuperarContrasena> createState() => _EstadoRecuperarContrasena();
}

class _EstadoRecuperarContrasena extends State<PantallaRecuperarContrasena> {
  final controlCorreo = TextEditingController();

  bool enviando = false;
  String? errorCorreo;

  Future<void> enviarElCodigo() async {
    setState(() {
      errorCorreo = null;
    });

    if (!controlCorreo.text.contains('@')) {
      setState(() {
        errorCorreo = 'Escribí un correo válido';
      });
      return;
    }

    final usuario = await buscarUsuarioPorCorreo(controlCorreo.text);
    if (!mounted) return;

    if (usuario == null) {
      setState(() {
        errorCorreo = 'No hay ninguna cuenta con ese correo';
      });
      return;
    }

    setState(() {
      enviando = true;
    });

    final codigo = generarCodigo();
    try {
      await enviarCodigo(controlCorreo.text, codigo);
    } catch (falla) {
      if (!mounted) return;
      setState(() {
        enviando = false;
        errorCorreo = 'No pudimos mandar el correo, revisá tu conexión';
      });
      return;
    }

    if (!mounted) return;
    setState(() {
      enviando = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => PantallaCodigo(
          correo: controlCorreo.text,
          codigoEnviado: codigo,
        ),
      ),
    );
  }

  @override
  void dispose() {
    controlCorreo.dispose();
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
                    child: Text('Recuperar contraseña', style: Tipografia.titulo1),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Text(
                'Escribí el correo de tu cuenta y te mandamos un código de 4 dígitos.',
                style: Tipografia.textoCampo.copyWith(color: colorTextoSecundario),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Text('Correo', style: Tipografia.etiqueta),
                  Text(' *', style: Tipografia.etiqueta.copyWith(color: colorError)),
                ],
              ),
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
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: enviando ? null : enviarElCodigo,
                child: Text(enviando ? 'Enviando…' : 'Enviar código'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
