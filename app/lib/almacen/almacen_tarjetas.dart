import '../modelos/pago.dart';
import '../modelos/tarjeta.dart';
import 'almacen.dart';

Future<List<Tarjeta>> leerTarjetas() async {
  final base = await abrirBase();
  final filas = await base.query('tarjetas', orderBy: 'id');
  return filas.map((fila) => Tarjeta.desdeMapa(fila)).toList();
}

Future<Tarjeta?> buscarTarjeta(int id) async {
  final base = await abrirBase();
  final filas = await base.query('tarjetas', where: 'id = ?', whereArgs: [id]);
  if (filas.isEmpty) return null;
  return Tarjeta.desdeMapa(filas.first);
}

Future<Tarjeta> agregarTarjeta(Tarjeta nuevaTarjeta) async {
  final base = await abrirBase();
  final idGenerado = await base.insert('tarjetas', nuevaTarjeta.aMapa());
  nuevaTarjeta.id = idGenerado;
  return nuevaTarjeta;
}

Future<void> actualizarTarjeta(Tarjeta tarjetaEditada) async {
  final base = await abrirBase();
  await base.update(
    'tarjetas',
    tarjetaEditada.aMapa(),
    where: 'id = ?',
    whereArgs: [tarjetaEditada.id],
  );
}

Future<List<Pago>> pagosDeTarjeta(int idTarjeta) async {
  final base = await abrirBase();
  final filas = await base.query(
    'pagos',
    where: 'idTarjeta = ?',
    whereArgs: [idTarjeta],
    orderBy: 'id',
  );
  return filas.map((fila) => Pago.desdeMapa(fila)).toList();
}

Future<void> eliminarTarjeta(int id, int? idDestino) async {
  final base = await abrirBase();
  await base.update(
    'pagos',
    {'idTarjeta': idDestino},
    where: 'idTarjeta = ?',
    whereArgs: [id],
  );
  await base.delete('tarjetas', where: 'id = ?', whereArgs: [id]);
}

Future<void> marcarAvisoEnviado(int idPago, String fecha) async {
  final base = await abrirBase();
  await base.update(
    'pagos',
    {'fechaUltimoAviso': fecha},
    where: 'id = ?',
    whereArgs: [idPago],
  );
}
