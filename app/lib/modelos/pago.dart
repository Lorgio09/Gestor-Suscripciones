import 'dart:convert';

class Pago {
  String nombre;
  double costo;
  String fecha;
  String url;
  String estado;

  Pago({
    required this.nombre,
    required this.costo,
    required this.fecha,
    required this.url,
    this.estado = "activa",
  });

  // objeto -> mapa (para guardar)
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'costo': costo,
      'fecha': fecha,
      'url': url,
      'estado': estado,
    };
  }

  // mapa -> objeto (al leer)
  factory Pago.fromJson(Map<String, dynamic> json) {
    return Pago(
      nombre: json['nombre'],
      costo: json['costo'],
      fecha: json['fecha'],
      url: json['url'],
      estado: json['estado'] ?? "activa",
    );
  }
}