import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../modelos/pago.dart';

Database? baseDatos;

Future<Database> abrirBase() async {
  if (baseDatos != null) return baseDatos!;

  final ruta = join(await getDatabasesPath(), 'suscripciones.db');
  baseDatos = await openDatabase(
    ruta,
    version: 1,
    onCreate: (base, version) async {
      await base.execute(
        'CREATE TABLE pagos ('
        'id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'nombre TEXT, '
        'costo REAL, '
        'fecha TEXT, '
        'url TEXT, '
        'estado TEXT)',
      );
    },
  );
  return baseDatos!;
}

Future<List<Pago>> leerPagos() async {
  final base = await abrirBase();
  final filas = await base.query('pagos', orderBy: 'id');
  return filas.map((fila) => Pago.desdeMapa(fila)).toList();
}

Future<Pago?> buscarPago(int id) async {
  final base = await abrirBase();
  final filas = await base.query('pagos', where: 'id = ?', whereArgs: [id]);
  if (filas.isEmpty) return null;
  return Pago.desdeMapa(filas.first);
}

Future<void> agregarPago(Pago nuevoPago) async {
  final base = await abrirBase();
  await base.insert('pagos', nuevoPago.aMapa());
}

Future<void> actualizarPago(int id, Pago pagoEditado) async {
  final base = await abrirBase();
  await base.update(
    'pagos',
    pagoEditado.aMapa(),
    where: 'id = ?',
    whereArgs: [id],
  );
}

Future<void> eliminarPago(int id) async {
  final base = await abrirBase();
  await base.delete('pagos', where: 'id = ?', whereArgs: [id]);
}
