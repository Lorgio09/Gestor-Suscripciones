import '../modelos/categoria.dart';
import 'almacen.dart';

Future<List<Categoria>> leerCategorias() async {
  final base = await abrirBase();
  final filas = await base.query('categorias', orderBy: 'id');
  return filas.map((fila) => Categoria.desdeMapa(fila)).toList();
}

Future<Categoria?> buscarCategoria(int id) async {
  final base = await abrirBase();
  final filas = await base.query('categorias', where: 'id = ?', whereArgs: [id]);
  if (filas.isEmpty) return null;
  return Categoria.desdeMapa(filas.first);
}

Future<Categoria?> buscarSinCategoria() async {
  final base = await abrirBase();
  final filas = await base.query(
    'categorias',
    where: 'nombre = ?',
    whereArgs: [nombreSinCategoria],
  );
  if (filas.isEmpty) return null;
  return Categoria.desdeMapa(filas.first);
}

Future<Categoria> agregarCategoria(Categoria nuevaCategoria) async {
  final base = await abrirBase();
  final idGenerado = await base.insert('categorias', nuevaCategoria.aMapa());
  nuevaCategoria.id = idGenerado;
  return nuevaCategoria;
}

Future<void> actualizarCategoria(Categoria categoriaEditada) async {
  final base = await abrirBase();
  await base.update(
    'categorias',
    categoriaEditada.aMapa(),
    where: 'id = ?',
    whereArgs: [categoriaEditada.id],
  );
}

Future<void> eliminarCategoria(int id, int idDestino) async {
  final base = await abrirBase();
  await base.update(
    'pagos',
    {'idCategoria': idDestino},
    where: 'idCategoria = ?',
    whereArgs: [id],
  );
  await base.delete('categorias', where: 'id = ?', whereArgs: [id]);
}

Future<void> asignarCategoria(int idPago, int? idCategoria) async {
  final base = await abrirBase();
  await base.update(
    'pagos',
    {'idCategoria': idCategoria},
    where: 'id = ?',
    whereArgs: [idPago],
  );
}
