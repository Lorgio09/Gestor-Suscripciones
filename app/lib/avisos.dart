import 'almacen/almacen.dart';
import 'almacen/almacen_tarjetas.dart';
import 'almacen/almacen_usuarios.dart';
import 'correo.dart';
import 'formato.dart';
import 'modelos/pago.dart';
import 'modelos/tarjeta.dart';

String armarMensaje(String plantilla, Pago pago, Tarjeta? tarjeta) {
  final proximo = calcularProximoPago(pago.fecha);
  final partes = proximo.split('/');
  final fechaCorta = partes.length == 3 ? '${partes[0]}/${partes[1]}' : proximo;

  return plantilla
      .replaceAll('{servicio}', pago.nombre)
      .replaceAll('{monto}', 'Bs ${pago.costo.toStringAsFixed(2)}')
      .replaceAll('{fecha}', fechaCorta)
      .replaceAll('{tarjeta}',
          tarjeta == null ? 'sin tarjeta' : '•••• ${tarjeta.ultimosDigitos}');
}

Future<void> revisarAvisos() async {
  final usuario = await usuarioActual();
  if (usuario == null) return;
  if (!usuario.avisosActivos) return;
  if (usuario.correo.isEmpty) return;

  final pagos = await leerPagos();

  for (final pago in pagos) {
    if (pago.estado == 'cancelada') continue;

    final proximo = calcularProximoPago(pago.fecha);
    final dias = diasHastaCobro(proximo);
    if (dias > usuario.diasAviso) continue;
    if (pago.fechaUltimoAviso == proximo) continue;

    Tarjeta? tarjeta;
    if (pago.idTarjeta != null) {
      tarjeta = await buscarTarjeta(pago.idTarjeta!);
    }

    try {
      await enviarCorreo(
        usuario.correo,
        '${pago.nombre} vence en $dias días',
        armarMensaje(usuario.mensajeAviso, pago, tarjeta),
      );
      await marcarAvisoEnviado(pago.id!, proximo);
    } catch (falla) {
      return;
    }
  }
}

Future<void> programarAvisosLocales() async {
  // Acá va flutter_local_notifications para que el aviso salga a la hora elegida.
}
