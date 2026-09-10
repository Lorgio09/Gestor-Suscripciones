import '../almacen/almacen.dart';

class Usuario {
  int? id;
  String nombre;
  String correo;
  String contrasena;
  bool avisosActivos;
  int diasAviso;
  String horaAviso;
  String mensajeAviso;

  Usuario({
    this.id,
    required this.nombre,
    required this.correo,
    required this.contrasena,
    this.avisosActivos = true,
    this.diasAviso = 3,
    this.horaAviso = '09:00',
    this.mensajeAviso = mensajeAvisoPorDefecto,
  });

  Map<String, dynamic> aMapa() {
    return {
      'id': id,
      'nombre': nombre,
      'correo': correo,
      'contrasena': contrasena,
      'avisosActivos': avisosActivos ? 1 : 0,
      'diasAviso': diasAviso,
      'horaAviso': horaAviso,
      'mensajeAviso': mensajeAviso,
    };
  }

  factory Usuario.desdeMapa(Map<String, dynamic> mapa) {
    return Usuario(
      id: mapa['id'],
      nombre: mapa['nombre'],
      correo: mapa['correo'],
      contrasena: mapa['contrasena'],
      avisosActivos: (mapa['avisosActivos'] ?? 1) == 1,
      diasAviso: mapa['diasAviso'] ?? 3,
      horaAviso: mapa['horaAviso'] ?? '09:00',
      mensajeAviso: mapa['mensajeAviso'] ?? mensajeAvisoPorDefecto,
    );
  }
}
