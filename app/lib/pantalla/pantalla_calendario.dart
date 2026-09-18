import 'package:flutter/material.dart';
import '../almacen/almacen.dart';
import '../colores.dart';
import '../formato.dart';
import '../modelos/pago.dart';
import '../tipografia.dart';
import 'encabezado.dart';
import 'pantalla_detalle.dart';
import 'pantalla_registro.dart';

const nombresMesLargo = [
  'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
  'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
];

const inicialesDia = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

String fechaDeDia(DateTime dia) {
  final numeroDia = dia.day.toString().padLeft(2, '0');
  final numeroMes = dia.month.toString().padLeft(2, '0');
  return '$numeroDia/$numeroMes/${dia.year}';
}

class PantallaCalendario extends StatefulWidget {
  const PantallaCalendario({super.key});

  @override
  State<PantallaCalendario> createState() => _EstadoCalendario();
}

class _EstadoCalendario extends State<PantallaCalendario> {
  List<Pago> listaPagos = [];
  DateTime mesMostrado = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? diaElegido;

  @override
  void initState() {
    super.initState();
    cargarPagos();
  }

  Future<void> cargarPagos() async {
    final pagos = await leerPagos();
    if (!mounted) return;
    setState(() {
      listaPagos = pagos.where((pago) => pago.estado != 'cancelada').toList();
    });
  }

  List<Pago> pagosDelDia(DateTime dia) {
    final delDia = <Pago>[];
    for (final pago in listaPagos) {
      final cobro = aFecha(calcularProximoPago(pago.fecha));
      if (cobro == null) continue;
      if (cobro.year == dia.year && cobro.month == dia.month && cobro.day == dia.day) {
        delDia.add(pago);
      }
    }
    return delDia;
  }

  List<Pago> get proximos {
    if (diaElegido != null) return pagosDelDia(diaElegido!);

    final ordenados = List<Pago>.from(listaPagos);
    ordenados.sort((uno, otro) {
      final diasUno = diasHastaCobro(calcularProximoPago(uno.fecha));
      final diasOtro = diasHastaCobro(calcularProximoPago(otro.fecha));
      return diasUno.compareTo(diasOtro);
    });
    return ordenados;
  }

  void cambiarMes(int cuantos) {
    setState(() {
      mesMostrado = DateTime(mesMostrado.year, mesMostrado.month + cuantos);
      diaElegido = null;
    });
  }

  void irADetalle(Pago pago) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => PantallaDetalle(pago: pago)),
    );
    cargarPagos();
  }

  void irARegistro() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => const PantallaRegistro()),
    );
    cargarPagos();
  }

  Widget celdaDia(int dia) {
    final fecha = DateTime(mesMostrado.year, mesMostrado.month, dia);
    final hoy = DateTime.now();
    final esHoy = fecha.year == hoy.year && fecha.month == hoy.month && fecha.day == hoy.day;
    final elegido = diaElegido != null &&
        diaElegido!.year == fecha.year &&
        diaElegido!.month == fecha.month &&
        diaElegido!.day == fecha.day;
    final cobros = pagosDelDia(fecha);

    return InkWell(
      onTap: () => setState(() => diaElegido = elegido ? null : fecha),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: elegido ? colorCoral : colorBlanco,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: esHoy && !elegido ? colorCoral : colorBorde),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dia.toString(),
              style: Tipografia.textoChico.copyWith(
                color: elegido ? colorBlanco : colorTexto,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final pago in cobros.take(3))
                    Container(
                      width: 5,
                      height: 5,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        color: elegido ? colorBlanco : colorDePago(pago),
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget grilla() {
    final primero = DateTime(mesMostrado.year, mesMostrado.month, 1);
    final diasDelMes = DateTime(mesMostrado.year, mesMostrado.month + 1, 0).day;
    final vacias = primero.weekday - 1;

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              tooltip: 'Mes anterior',
              onPressed: () => cambiarMes(-1),
              icon: const Icon(Icons.chevron_left, color: colorTexto),
            ),
            Expanded(
              child: Text(
                '${nombresMesLargo[mesMostrado.month - 1]} ${mesMostrado.year}',
                textAlign: TextAlign.center,
                style: Tipografia.textoCampoFuerte,
              ),
            ),
            IconButton(
              tooltip: 'Mes siguiente',
              onPressed: () => cambiarMes(1),
              icon: const Icon(Icons.chevron_right, color: colorTexto),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (final inicial in inicialesDia)
              Expanded(
                child: Text(
                  inicial,
                  textAlign: TextAlign.center,
                  style: Tipografia.textoAyuda,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          padding: EdgeInsets.zero,
          children: [
            for (int i = 0; i < vacias; i++) const SizedBox(),
            for (int dia = 1; dia <= diasDelMes; dia++) celdaDia(dia),
          ],
        ),
      ],
    );
  }

  Widget chipDias(Pago pago) {
    final dias = diasHastaCobro(calcularProximoPago(pago.fecha));

    Color fondo = colorDeshabilitado;
    Color letra = colorTextoSecundario;
    String texto = 'en $dias días';

    if (dias == 0) {
      fondo = colorCoralSuave;
      letra = colorCoral;
      texto = 'hoy';
    } else if (dias <= 7) {
      fondo = colorAvisoSuave;
      letra = colorAviso;
      if (dias == 1) texto = 'en 1 día';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(texto, style: Tipografia.textoAyuda.copyWith(color: letra)),
    );
  }

  Widget fila(Pago pago) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => irADetalle(pago),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorDePago(pago),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  inicialDe(pago.nombre),
                  style: Tipografia.numerico.copyWith(color: colorBlanco),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pago.nombre, style: Tipografia.textoCampoFuerte),
                    const SizedBox(height: 8),
                    Text(
                      'Bs ${pago.costo.toStringAsFixed(2)} · ${fechaCorta(calcularProximoPago(pago.fecha))}',
                      style: Tipografia.textoChico,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              chipDias(pago),
            ],
          ),
        ),
      ),
    );
  }

  Widget vacio() {
    return Column(
      children: [
        const SizedBox(height: 24),
        const Icon(Icons.calendar_today, size: 48, color: colorTextoSecundario),
        const SizedBox(height: 16),
        Text(
          'Todavía no registraste ninguna suscripción.',
          textAlign: TextAlign.center,
          style: Tipografia.textoAyuda,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: irARegistro,
          child: const Text('Registrar pago'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final lista = proximos;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              const Encabezado(titulo: 'Calendario de cobros'),
              const SizedBox(height: 24),

              if (listaPagos.isEmpty)
                vacio()
              else ...[
                grilla(),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        diaElegido == null
                            ? 'Próximos a vencer'
                            : 'Cobros del ${fechaCorta(fechaDeDia(diaElegido!))}',
                        style: Tipografia.etiqueta,
                      ),
                    ),
                    if (diaElegido != null)
                      TextButton(
                        onPressed: () => setState(() => diaElegido = null),
                        child: Text('Ver todos', style: Tipografia.textoAyuda),
                      ),
                  ],
                ),
                const SizedBox(height: 8),

                if (lista.isEmpty)
                  Text(
                    'Ese día no se cobra ninguna suscripción.',
                    style: Tipografia.textoAyuda,
                  )
                else
                  for (final pago in lista) fila(pago),
              ],

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
