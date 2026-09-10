import 'dart:math';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'secretos.dart';

String generarCodigo() {
  final azar = Random();
  return (1000 + azar.nextInt(9000)).toString();
}

Future<void> enviarCorreo(String destino, String asunto, String cuerpo) async {
  final servidor = gmail(correoApp, claveApp);

  final mensaje = Message()
    ..from = Address(correoApp, 'Suscrip')
    ..recipients.add(destino)
    ..subject = asunto
    ..text = cuerpo;

  await send(mensaje, servidor);
}

Future<void> enviarCodigo(String destino, String codigo) async {
  await enviarCorreo(
    destino,
    'Tu código para recuperar la contraseña',
    'Tu código es $codigo\n\n'
        'Escribilo en la app para poder cambiar tu contraseña.',
  );
}
