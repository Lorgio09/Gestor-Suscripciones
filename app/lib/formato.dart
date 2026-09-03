import 'package:flutter/material.dart';
import 'colores.dart';

const nombresMes = [
  'ene', 'feb', 'mar', 'abr', 'may', 'jun',
  'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
];

String inicialDe(String nombre) {
  if (nombre.isEmpty) return '?';
  return nombre[0].toUpperCase();
}

Color colorPorNombre(String nombre) {
  int suma = 0;
  for (int i = 0; i < nombre.length; i++) {
    suma = suma + nombre.codeUnitAt(i);
  }
  return coloresIniciales[suma % coloresIniciales.length];
}

String calcularProximoPago(String fecha) {
  final partes = fecha.split('/');
  if (partes.length != 3) return fecha;

  int dia = int.parse(partes[0]);
  int mes = int.parse(partes[1]);
  int anio = int.parse(partes[2]);

  mes = mes + 1;
  if (mes > 12) {
    mes = 1;
    anio = anio + 1;
  }

  final diaStr = dia.toString().padLeft(2, '0');
  final mesStr = mes.toString().padLeft(2, '0');
  return '$diaStr/$mesStr/$anio';
}

String fechaCorta(String fecha) {
  final partes = fecha.split('/');
  if (partes.length != 3) return fecha;

  final dia = int.parse(partes[0]);
  final mes = int.parse(partes[1]);
  if (mes < 1 || mes > 12) return fecha;

  return '$dia ${nombresMes[mes - 1]}';
}

bool estaPorVencer(String fecha) {
  final partes = fecha.split('/');
  if (partes.length != 3) return false;

  final proximo = DateTime(
    int.parse(partes[2]),
    int.parse(partes[1]),
    int.parse(partes[0]),
  );
  final dias = proximo.difference(DateTime.now()).inDays;
  return dias >= 0 && dias <= 7;
}
