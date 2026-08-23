import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../modelos/pago.dart';

const clavePagos = "pagos";

Future<List<Pago>> leerPagos() async {
  final prefs = await SharedPreferences.getInstance();
  final texto = prefs.getString(clavePagos);
  if (texto == null) return [];
  final List<dynamic> listaJson = jsonDecode(texto);
  return listaJson.map((item) => Pago.fromJson(item)).toList();
}

Future<void> guardarPagos(List<Pago> lista) async {
  final prefs = await SharedPreferences.getInstance();
  final texto = jsonEncode(lista.map((p) => p.toJson()).toList());
  await prefs.setString(clavePagos, texto);
}

Future<void> agregarPago(Pago nuevoPago) async {
  final lista = await leerPagos();
  lista.add(nuevoPago);
  await guardarPagos(lista);
}

Future<void> actualizarPago(int indice, Pago pagoEditado) async {
  final lista = await leerPagos();
  lista[indice] = pagoEditado;
  await guardarPagos(lista);
}

Future<void> eliminarPago(int indice) async {
  final lista = await leerPagos();
  lista.removeAt(indice);
  await guardarPagos(lista);
}