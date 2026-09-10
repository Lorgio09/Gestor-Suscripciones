import 'package:flutter/material.dart';
import '../almacen/almacen_categorias.dart';
import '../almacen/almacen_usuarios.dart';
import '../colores.dart';
import '../modelos/usuario.dart';
import '../sesion.dart';
import '../tipografia.dart';
import 'pantalla_carga.dart';
import 'pantalla_categorias.dart';
import 'pantalla_editar_perfil.dart';
import 'pantalla_notificaciones.dart';

class PantallaPerfil extends StatefulWidget {
  const PantallaPerfil({super.key});

  @override
  State<PantallaPerfil> createState() => _EstadoPerfil();
}

class _EstadoPerfil extends State<PantallaPerfil> {
  Usuario? usuario;
  String nombresCategorias = '';

  @override
  void initState() {
    super.initState();
    cargarTodo();
  }

  Future<void> cargarTodo() async {
    final encontrado = await usuarioActual();
    final categorias = await leerCategorias();
    if (!mounted) return;
    setState(() {
      usuario = encontrado;
      nombresCategorias = categorias.map((categoria) => categoria.nombre).join(', ');
    });
  }

  String get iniciales {
    if (usuario == null || usuario!.nombre.isEmpty) return '?';
    final partes = usuario!.nombre.trim().split(' ');
    if (partes.length == 1) return partes[0][0].toUpperCase();
    return (partes[0][0] + partes[1][0]).toUpperCase();
  }

  String get resumenAvisos {
    if (usuario == null) return '';
    if (!usuario!.avisosActivos) return 'Desactivadas';
    return 'Aviso ${usuario!.diasAviso} días antes · ${usuario!.horaAviso}';
  }

  Future<void> abrir(Widget pantalla) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => pantalla),
    );
    cargarTodo();
  }

  void confirmarCerrarSesion() {
    showDialog(
      context: context,
      builder: (contexto) => AlertDialog(
        backgroundColor: colorBlanco,
        title: Text('Cerrar sesión', style: Tipografia.titulo1),
        content: Text(
          '¿Querés salir de tu cuenta? Tus suscripciones quedan guardadas.',
          style: Tipografia.textoCampo,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contexto),
            child: Text('Cancelar', style: Tipografia.textoAyuda),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(contexto);
              await cerrarSesion();
              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (ctx) => const PantallaCarga()),
                (ruta) => false,
              );
            },
            child: Text(
              'Cerrar sesión',
              style: Tipografia.etiqueta.copyWith(color: colorError),
            ),
          ),
        ],
      ),
    );
  }

  Widget opcion(String titulo, String subtitulo, VoidCallback alTocar) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: alTocar,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorBlanco,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colorBorde),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: Tipografia.textoCampo.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitulo,
                      style: Tipografia.textoAyuda.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.chevron_right, color: colorTextoSecundario),
            ],
          ),
        ),
      ),
    );
  }

  Widget tarjetaMotivacion() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorCoral,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pequeñas decisiones hoy,\ngrandes metas mañana.',
                  style: Tipografia.textoCampo.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorBlanco,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tu tranquilidad financiera, en tus manos.',
                  style: Tipografia.textoAyuda.copyWith(fontSize: 12, color: colorBlanco),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.flag_outlined, size: 48, color: colorBlanco),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            const Text('Mi perfil', style: Tipografia.titulo1),
            const SizedBox(height: 8),
            Text(
              'Tu espacio, tus suscripciones',
              style: Tipografia.textoCampo.copyWith(color: colorTextoSecundario),
            ),
            const SizedBox(height: 24),

            Center(
              child: Container(
                width: 72,
                height: 72,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: colorCoral,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  iniciales,
                  style: Tipografia.titulo1.copyWith(color: colorBlanco),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              usuario == null ? '' : usuario!.nombre,
              style: Tipografia.titulo1.copyWith(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              usuario == null ? '' : usuario!.correo,
              style: Tipografia.textoCampo.copyWith(color: colorTextoSecundario),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            opcion(
              'Editar perfil',
              'Nombre, correo y contraseña',
              () => abrir(const PantallaEditarPerfil()),
            ),
            opcion(
              'Mis categorías',
              nombresCategorias,
              () => abrir(const PantallaCategorias()),
            ),
            opcion(
              'Notificaciones',
              resumenAvisos,
              () => abrir(const PantallaNotificaciones()),
            ),

            const SizedBox(height: 16),
            tarjetaMotivacion(),
            const SizedBox(height: 16),

            InkWell(
              onTap: confirmarCerrarSesion,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorBlanco,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colorBorde),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.logout, size: 20, color: colorError),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Cerrar sesión',
                        style: Tipografia.textoCampo.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorError,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
