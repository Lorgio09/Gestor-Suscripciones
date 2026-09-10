class Categoria {
  int? id;
  String nombre;
  String color;

  Categoria({
    this.id,
    required this.nombre,
    required this.color,
  });

  Map<String, dynamic> aMapa() {
    return {
      'id': id,
      'nombre': nombre,
      'color': color,
    };
  }

  factory Categoria.desdeMapa(Map<String, dynamic> mapa) {
    return Categoria(
      id: mapa['id'],
      nombre: mapa['nombre'],
      color: mapa['color'],
    );
  }
}
