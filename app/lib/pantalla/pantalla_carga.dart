import 'package:flutter/material.dart';
import '../colores.dart';
import '../tipografia.dart';
import 'pantalla_lista.dart';
import 'pantalla_iniciar_sesion.dart';

class PantallaCarga extends StatefulWidget {
  final bool tieneSesion;
  final String nombreUsuario;

  const PantallaCarga({
    super.key, 
    this.tieneSesion = false,
    this.nombreUsuario = '', 
  });

  @override
  State<PantallaCarga> createState() => _EstadoPantallaCarga();
}

class _EstadoPantallaCarga extends State<PantallaCarga> {
  
  @override
  void initState() {
    super.initState();
    _navegarSiguientePantalla();
  }

  Future<void> _navegarSiguientePantalla() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    
    if (!mounted) return;

    if (widget.tieneSesion) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PantallaLista()), 
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PantallaIniciarSesion()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: Colores.degradadoFondo, 
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colores.superficie.withOpacity(0.22),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.refresh,
                  color: Colores.superficie,
                  size: 36,
                ),
              ),
              
              const SizedBox(height: 24),
              
              Text(
                'Suscrip',
                style: Tipografia.titulo1.copyWith(
                  fontSize: 28,
                  color: Colores.superficie,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                widget.tieneSesion ? 'Hola de nuevo, ${widget.nombreUsuario}' : 'Tus pagos, siempre bajo control',
                style: Tipografia.textoCampo.copyWith(
                  fontSize: 13,
                  color: Colores.superficie.withOpacity(0.9),
                ),
              ),
              
              const SizedBox(height: 40),
              
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: SizedBox(
                  width: 160,
                  height: 4,
                  child: LinearProgressIndicator(
                    value: 0.35, 
                    backgroundColor: Colores.superficie.withOpacity(0.35),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colores.superficie),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              Text(
                widget.tieneSesion ? 'Cargando tus suscripciones...' : 'Preparando todo para tus suscripciones...',
                style: Tipografia.textoAyuda.copyWith(
                  fontSize: 12,
                  color: Colores.superficie.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}