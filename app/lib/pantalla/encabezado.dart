import 'package:flutter/material.dart';
import '../colores.dart';
import '../tipografia.dart';

class Encabezado extends StatelessWidget {
  final String titulo;

  const Encabezado({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Row(
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
            child: const Icon(
              Icons.arrow_back_ios_new, 
              size: 14, 
              color: colorTexto 
            ),
          ),
        ),
        
        const SizedBox(width: 16), 
        
        Expanded( 
          child: Text(
            titulo, 
            style: Tipografia.titulo1, 
          ),
        ),
      ],
    );
  }
}