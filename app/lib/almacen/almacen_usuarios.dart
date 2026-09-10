import '../modelos/usuario.dart';
import '../sesion.dart';
import 'almacen.dart';

Future<void> crearUsuario(Usuario nuevoUsuario) async {
  final base = await abrirBase();
  await base.insert('usuarios', nuevoUsuario.aMapa());
}

Future<Usuario?> buscarUsuarioPorCorreo(String correo) async {
  final base = await abrirBase();
  final filas = await base.query(
    'usuarios',
    where: 'correo = ?',
    whereArgs: [correo],
  );
  if (filas.isEmpty) return null;
  return Usuario.desdeMapa(filas.first);
}

Future<Usuario?> validarUsuario(String correo, String contrasena) async {
  final base = await abrirBase();
  final filas = await base.query(
    'usuarios',
    where: 'correo = ? AND contrasena = ?',
    whereArgs: [correo, contrasena],
  );
  if (filas.isEmpty) return null;
  return Usuario.desdeMapa(filas.first);
}

Future<void> actualizarContrasena(String correo, String nuevaContrasena) async {
  final base = await abrirBase();
  await base.update(
    'usuarios',
    {'contrasena': nuevaContrasena},
    where: 'correo = ?',
    whereArgs: [correo],
  );
}

Future<void> actualizarUsuario(Usuario usuarioEditado) async {
  final base = await abrirBase();
  await base.update(
    'usuarios',
    usuarioEditado.aMapa(),
    where: 'id = ?',
    whereArgs: [usuarioEditado.id],
  );
}

Future<void> actualizarAvisos(
  int idUsuario,
  bool avisosActivos,
  int diasAviso,
  String horaAviso,
  String mensajeAviso,
) async {
  final base = await abrirBase();
  await base.update(
    'usuarios',
    {
      'avisosActivos': avisosActivos ? 1 : 0,
      'diasAviso': diasAviso,
      'horaAviso': horaAviso,
      'mensajeAviso': mensajeAviso,
    },
    where: 'id = ?',
    whereArgs: [idUsuario],
  );
}

Future<Usuario?> usuarioActual() async {
  final correo = await leerCorreoUsuario();
  if (correo.isNotEmpty) {
    final porCorreo = await buscarUsuarioPorCorreo(correo);
    if (porCorreo != null) return porCorreo;
  }

  final base = await abrirBase();
  final filas = await base.query('usuarios', orderBy: 'id', limit: 1);
  if (filas.isEmpty) return null;
  return Usuario.desdeMapa(filas.first);
}
