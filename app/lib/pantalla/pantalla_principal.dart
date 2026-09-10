import 'package:flutter/material.dart';
import '../colores.dart';
import 'pantalla_billetera.dart';
import 'pantalla_lista.dart';
import 'pantalla_perfil.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _EstadoPrincipal();
}

class _EstadoPrincipal extends State<PantallaPrincipal> {
  int pestanaElegida = 0;

  @override
  Widget build(BuildContext context) {
    final pantallas = [
      const PantallaLista(),
      const PantallaBilletera(),
      const PantallaPerfil(),
    ];

    return Scaffold(
      body: pantallas[pestanaElegida],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pestanaElegida,
        onTap: (indice) => setState(() => pestanaElegida = indice),
        backgroundColor: colorBlanco,
        selectedItemColor: colorCoral,
        unselectedItemColor: colorTextoSecundario,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Billetera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
