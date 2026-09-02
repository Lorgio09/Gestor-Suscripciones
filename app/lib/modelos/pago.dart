class Pago {
  int? id;
  String nombre;
  double costo;
  String fecha;
  String url;
  String estado;

  Pago({
    this.id,
    required this.nombre,
    required this.costo,
    required this.fecha,
    required this.url,
    this.estado = "activa",
  });

  Map<String, dynamic> aMapa() {
    return {
      'id': id,
      'nombre': nombre,
      'costo': costo,
      'fecha': fecha,
      'url': url,
      'estado': estado,
    };
  }

  factory Pago.desdeMapa(Map<String, dynamic> mapa) {
    return Pago(
      id: mapa['id'],
      nombre: mapa['nombre'],
      costo: (mapa['costo'] as num).toDouble(),
      fecha: mapa['fecha'],
      url: mapa['url'],
      estado: mapa['estado'] ?? "activa",
    );
  }
}
