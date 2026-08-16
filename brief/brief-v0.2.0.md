# Brief v0.2.0 - Gestor de Suscripciones

*Contexto del problema a resolver: El gasto de los usuarios está fragmentado y es invisible. Cada suscripción se cobra en una fecha distinta, con montos pequeños. El usuario necesita identificar rápidamente el próximo cobro inmediato para decidir si lo deja pasar o lo corta.*

## Hipótesis
Si mostramos de forma clara la próxima suscripción por cobrarse (incluyendo su monto, la fecha exacta y la acción a seguir), entonces la persona podrá decidir si la mantiene o la cancela en cuestión de minutos, reduciendo así sus gastos involuntarios.

## Alcance
**Lo que entra en la primera versión:**
* Mostrar la próxima suscripción por vencer, detallando su monto y fecha.
* Ver el total mensual y anual acumulado de todas las suscripciones registradas.
* Opción manual para marcar una suscripción como "para cancelar" o "cancelada".

**Lo que queda fuera:**
* Conexión con bancos o detección automática de cobros en tarjetas.
* Ejecución de la cancelación real del pago dentro de la app.
* Soporte para múltiples monedas con conversión automática.
* Gestión de cuentas compartidas o familiares.

## Preguntas abiertas
1. ¿Qué información específica necesita ver la persona para convencerse de cancelar: el costo anual acumulado, la última vez que usó el servicio, o solo el monto mensual?
2. ¿Con cuánta anticipación necesita el aviso del próximo cobro para poder reaccionar (un mes, una semana, 3 días)?
3. ¿Por qué canal prefiere recibir esta alerta de cobro: como notificación del celular, un correo electrónico, o solo un aviso visual al entrar a la app?
