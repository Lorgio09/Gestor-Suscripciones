class Pago {
  int? id;
  String nombre;
  double costo;
  String fecha;
  String url;
  String estado;
  int? idTarjeta;
  int? idCategoria;
  String motivoCancelacion;
  String fechaInicio;
  String? fechaUltimoAviso;

  Pago({
    this.id,
    required this.nombre,
    required this.costo,
    required this.fecha,
    required this.url,
    this.estado = "activa",
    this.idTarjeta,
    this.idCategoria,
    this.motivoCancelacion = "",
    this.fechaInicio = "",
    this.fechaUltimoAviso,
  });

  Map<String, dynamic> aMapa() {
    return {
      'id': id,
      'nombre': nombre,
      'costo': costo,
      'fecha': fecha,
      'url': url,
      'estado': estado,
      'idTarjeta': idTarjeta,
      'idCategoria': idCategoria,
      'motivoCancelacion': motivoCancelacion,
      'fechaInicio': fechaInicio.isEmpty ? fecha : fechaInicio,
      'fechaUltimoAviso': fechaUltimoAviso,
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
      idTarjeta: mapa['idTarjeta'],
      idCategoria: mapa['idCategoria'],
      motivoCancelacion: mapa['motivoCancelacion'] ?? "",
      fechaInicio: mapa['fechaInicio'] ?? mapa['fecha'],
      fechaUltimoAviso: mapa['fechaUltimoAviso'],
    );
  }
}
