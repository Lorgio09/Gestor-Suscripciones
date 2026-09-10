import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../modelos/pago.dart';

Database? baseDatos;

const sqlTablaPagos = 'CREATE TABLE pagos ('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'nombre TEXT, '
    'costo REAL, '
    'fecha TEXT, '
    'url TEXT, '
    'estado TEXT, '
    'idTarjeta INTEGER, '
    'idCategoria INTEGER, '
    'motivoCancelacion TEXT, '
    'fechaInicio TEXT, '
    'fechaUltimoAviso TEXT)';

const sqlTablaUsuarios = 'CREATE TABLE usuarios ('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'nombre TEXT, '
    'correo TEXT, '
    'contrasena TEXT, '
    'avisosActivos INTEGER, '
    'diasAviso INTEGER, '
    'horaAviso TEXT, '
    'mensajeAviso TEXT)';

const mensajeAvisoPorDefecto =
    'Che, {servicio} te cobra {monto} el {fecha}. ¿Lo seguís usando?';

const nombreSinCategoria = 'Sin categoría';
const colorSinCategoria = '#B5A8A3';

const sqlTablaTarjetas = 'CREATE TABLE tarjetas ('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'alias TEXT, '
    'tipo TEXT, '
    'ultimosDigitos TEXT, '
    'color TEXT)';

const sqlTablaCategorias = 'CREATE TABLE categorias ('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'nombre TEXT, '
    'color TEXT)';

Future<void> sembrarSinCategoria(Database base) async {
  final filas = await base.query(
    'categorias',
    where: 'nombre = ?',
    whereArgs: [nombreSinCategoria],
  );
  if (filas.isNotEmpty) return;
  await base.insert('categorias', {
    'nombre': nombreSinCategoria,
    'color': colorSinCategoria,
  });
}

Future<Database> abrirBase() async {
  if (baseDatos != null) return baseDatos!;

  final ruta = join(await getDatabasesPath(), 'suscripciones.db');
  baseDatos = await openDatabase(
    ruta,
    version: 5,
    onCreate: (base, version) async {
      await base.execute(sqlTablaPagos);
      await base.execute(sqlTablaUsuarios);
      await base.execute(sqlTablaTarjetas);
      await base.execute(sqlTablaCategorias);
      await sembrarSinCategoria(base);
    },
    onUpgrade: (base, versionVieja, versionNueva) async {
      if (versionVieja < 2) {
        await base.execute(sqlTablaUsuarios);
      }
      if (versionVieja < 3) {
        await base.execute(sqlTablaTarjetas);
        await base.execute(sqlTablaCategorias);
        await base.execute('ALTER TABLE pagos ADD COLUMN idTarjeta INTEGER');
        await base.execute('ALTER TABLE pagos ADD COLUMN idCategoria INTEGER');
        await base.execute('ALTER TABLE pagos ADD COLUMN motivoCancelacion TEXT');
      }
      if (versionVieja < 4) {
        await base.execute('ALTER TABLE usuarios ADD COLUMN avisosActivos INTEGER');
        await base.execute('ALTER TABLE usuarios ADD COLUMN diasAviso INTEGER');
        await base.execute('ALTER TABLE usuarios ADD COLUMN horaAviso TEXT');
        await base.execute('ALTER TABLE usuarios ADD COLUMN mensajeAviso TEXT');
        await sembrarSinCategoria(base);
      }
      if (versionVieja < 5) {
        await base.execute('ALTER TABLE pagos ADD COLUMN fechaInicio TEXT');
        await base.execute('ALTER TABLE pagos ADD COLUMN fechaUltimoAviso TEXT');
        await base.execute('UPDATE pagos SET fechaInicio = fecha WHERE fechaInicio IS NULL');
      }
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
