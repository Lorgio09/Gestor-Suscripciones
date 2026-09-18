import 'package:flutter/material.dart';
import '../colores.dart';
import '../formato.dart';
import '../modelos/pago.dart';
import '../tipografia.dart';

class PantallaSuscripcionCancelada extends StatelessWidget {
  final Pago pago;

  const PantallaSuscripcionCancelada({super.key, required this.pago});

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
              Center(
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
              const SizedBox(height: 24),
              Text(
                'Suscripción cancelada',
                textAlign: TextAlign.center,
                style: Tipografia.titulo1,
              ),
              const SizedBox(height: 8),
              Text(
                'Marcamos ${pago.nombre} como cancelada el ${fechaCorta(pago.fechaCancelacion ?? fechaDeHoy())}.',
                textAlign: TextAlign.center,
                style: Tipografia.textoCampo,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorExitoSuave,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'Te ahorrás Bs ${pago.costo.toStringAsFixed(2)} al mes',
                  textAlign: TextAlign.center,
                  style: Tipografia.numerico.copyWith(color: colorExito),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Si la volvés a contratar la podés reactivar desde el detalle.',
                textAlign: TextAlign.center,
                style: Tipografia.textoAyuda,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Volver al detalle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
