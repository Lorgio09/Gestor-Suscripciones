import 'package:flutter/material.dart';
import '../colores.dart';
import '../tipografia.dart';
import 'pantalla_principal.dart';

class PantallaCuentaCreada extends StatelessWidget {
  final String nombre;

  const PantallaCuentaCreada({super.key, required this.nombre});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutBack,
                builder: (ctx, escala, hijo) {
                  return Transform.scale(scale: escala, child: hijo);
                },
                child: Center(
                  child: Container(
                    width: 96,
                    height: 96,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: colorExitoSuave,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, color: colorExito, size: 48),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Cuenta creada',
                style: Tipografia.titulo1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Bienvenida, $nombre. Ya podés registrar tu primera suscripción.',
                style: Tipografia.textoCampo.copyWith(color: colorTextoSecundario),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (ctx) => const PantallaPrincipal()),
                    (ruta) => false,
                  );
                },
                child: const Text('Ir a mis suscripciones'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
