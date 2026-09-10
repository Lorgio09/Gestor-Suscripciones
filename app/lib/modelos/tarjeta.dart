class Tarjeta {
  int? id;
  String alias;
  String tipo;
  String ultimosDigitos;
  String color;

  Tarjeta({
    this.id,
    required this.alias,
    required this.tipo,
    required this.ultimosDigitos,
    required this.color,
  });

  Map<String, dynamic> aMapa() {
    return {
      'id': id,
      'alias': alias,
      'tipo': tipo,
      'ultimosDigitos': ultimosDigitos,
      'color': color,
    };
  }

  factory Tarjeta.desdeMapa(Map<String, dynamic> mapa) {
    return Tarjeta(
      id: mapa['id'],
      alias: mapa['alias'],
      tipo: mapa['tipo'],
      ultimosDigitos: mapa['ultimosDigitos'],
      color: mapa['color'],
    );
  }
}
