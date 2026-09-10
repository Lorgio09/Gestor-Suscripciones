import 'package:flutter/material.dart';
import '../colores.dart';
import '../sesion.dart';
import '../tipografia.dart';
import 'pantalla_iniciar_sesion.dart';
import 'pantalla_principal.dart';

class PantallaCarga extends StatefulWidget {
  const PantallaCarga({super.key});

  @override
  State<PantallaCarga> createState() => _EstadoCarga();
}

class _EstadoCarga extends State<PantallaCarga> {
  bool sesionLeida = false;
  bool tieneSesion = false;
  String nombreUsuario = '';

  @override
  void initState() {
    super.initState();
    leerSesion();
  }

  Future<void> leerSesion() async {
    final activa = await haySesionActiva();
    final nombre = await leerNombreUsuario();
    if (!mounted) return;
    setState(() {
      tieneSesion = activa;
      nombreUsuario = nombre;
      sesionLeida = true;
    });
  }

  void entrarALaApp() {
    if (tieneSesion) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (ctx) => const PantallaPrincipal()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (ctx) => const PantallaIniciarSesion()),
      );
    }
  }

  String get lema {
    if (tieneSesion) return 'Hola de nuevo, $nombreUsuario';
    return 'Tus pagos, siempre bajo control';
  }

  String get estado {
    if (tieneSesion) return 'Cargando tus suscripciones…';
    return 'Preparando todo para tus suscripciones…';
  }

  Duration get duracion {
    if (tieneSesion) return const Duration(milliseconds: 1500);
    return const Duration(milliseconds: 2500);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: degradadoMarca),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorBlanco.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(Icons.refresh, color: colorBlanco, size: 40),
              ),
              const SizedBox(height: 24),
              Text(
                'Suscrip',
                style: Tipografia.titulo1.copyWith(
                  fontSize: 30,
                  color: colorBlanco,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                lema,
                style: Tipografia.textoCampo.copyWith(color: colorBlanco),
              ),
              const SizedBox(height: 24),
              if (sesionLeida)
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: duracion,
                  onEnd: entrarALaApp,
                  builder: (ctx, avance, hijo) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: SizedBox(
                        width: 180,
                        height: 4,
                        child: LinearProgressIndicator(
                          value: avance,
                          backgroundColor: colorBlanco.withValues(alpha: 0.35),
                          valueColor: const AlwaysStoppedAnimation<Color>(colorBlanco),
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 16),
              Text(
                estado,
                style: Tipografia.textoAyuda.copyWith(color: colorBlanco),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
