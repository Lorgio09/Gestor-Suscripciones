import 'package:shared_preferences/shared_preferences.dart';

Future<void> guardarSesion(String nombre, String correo) async {
  final preferencias = await SharedPreferences.getInstance();
  await preferencias.setBool('sesionActiva', true);
  await preferencias.setString('nombreUsuario', nombre);
  await preferencias.setString('correoUsuario', correo);
}

Future<bool> haySesionActiva() async {
  final preferencias = await SharedPreferences.getInstance();
  return preferencias.getBool('sesionActiva') ?? false;
}

Future<String> leerNombreUsuario() async {
  final preferencias = await SharedPreferences.getInstance();
  return preferencias.getString('nombreUsuario') ?? '';
}

Future<void> cerrarSesion() async {
  final preferencias = await SharedPreferences.getInstance();
  await preferencias.setBool('sesionActiva', false);
}

Future<String> leerCorreoUsuario() async {
  final preferencias = await SharedPreferences.getInstance();
  return preferencias.getString('correoUsuario') ?? '';
}
