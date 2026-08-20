# Persona v0.1

Selección del usuario, contexto, objetivo, dificultad y necesidad.

- **Usuario:** Compañero de estudio/trabajo del sector tecnológico.
- **Contexto:** Paga recurrentemente suscripciones a herramientas de software y plataformas educativas, además de levantar servidores en la nube para proyectos temporales.
- **Dificultad (Problema actual):** Terminó un proyecto académico, se olvidó de dar de baja el servicio de la nube que estaba usando y le cobraron un mes extra sin usarlo.
- **Objetivo a largo plazo:** Recibir un recordatorio a días configurables que ponga el usuario antes del próximo ciclo de facturación para decidir si cancela o mantiene el servicio.
- **Necesidad (Foco actual):** Un registro centralizado, rápido y simple donde anotar inmediatamente el servicio que acaba de pagar, su costo y la URL de gestión para no perderle el rastro.

# App map v0.1

Organización de las partes principales de la solución y marca del alcance.

**Mapa General Teórico (Visión a futuro):**
- [Pantalla A] Lista de Suscripciones (Dashboard)
- [Pantalla B] Formulario de Registro

##  ALCANCE DEL MVP

Para esta primera versión, el alcance se reduce exclusivamente a las Pantallas A y B.

**Pantalla principal:** Muestra una tabla con los pagos registrados, con las columnas Servicio, Costo, Fecha de pago y Acción. La columna Acción contiene el enlace directo a la URL de gestión del servicio.

**Formulario de Ingreso :** Cuatro campos obligatorios.

| Campo | Tipo de input | Ejemplo |
|---|---|---|
| Nombre del servicio | Input Text | AWS Nube Proyecto Final |
| Costo mensual | Input Number | 21.90 |
| Fecha en la que se realizó el pago | Input Date | 2026-08-19 |
| URL del servicio para cancelar después | Input URL | https://console.aws.amazon.com |


# Flujo v0.1

El camino normal de una sola tarea (Registrar un pago con su URL).

**Tarea:** Registrar el pago recién hecho de un servicio de software.

1. El usuario abre la aplicación y visualiza la pantalla principal (vacía o con registros anteriores).
2. Hace clic en el botón visible "Registrar Nuevo Pago".
3. La interfaz muestra el formulario simple. El usuario escribe el nombre de la herramienta, pone el costo, selecciona la fecha del pago y pega la URL directa donde hizo el pago.
4. El usuario hace clic en "Guardar".
5. El sistema vuelve a la pantalla principal y ahora el usuario ve su nuevo registro en la lista, confirmando que la información y la URL están guardadas.

**Camino alterno:** Si el usuario intenta guardar con algún campo vacío, el formulario muestra el mensaje "Todos los campos son obligatorios" y no lo deja avanzar hasta completarlos.