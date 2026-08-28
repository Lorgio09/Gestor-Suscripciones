# Persona v0.2

Selección del usuario, contexto, objetivo, dificultad y necesidad.

- **Usuario:** Compañero de estudio/trabajo del sector tecnológico.
- **Contexto:** Paga recurrentemente suscripciones a herramientas de software y plataformas educativas, además de levantar servidores en la nube para proyectos temporales.
- **Dificultad (Problema actual):** Terminó un proyecto académico, se olvidó de dar de baja el servicio de la nube que estaba usando y le cobraron un mes extra sin usarlo.
- **Objetivo a largo plazo:** Recibir un recordatorio a días configurables que ponga el usuario antes del próximo ciclo de facturación para decidir si cancela o mantiene el servicio.
- **Necesidad (Foco actual):** Un registro centralizado, rápido y simple donde anotar inmediatamente el servicio que acaba de pagar, su costo y la URL de gestión para no perderle el rastro.

# App map v0.3

Organización de las partes principales de la solución y marca del alcance.

**Mapa General Teórico (Visión a futuro):**
- [Pantalla A] Lista de Suscripciones
- [Pantalla B] Formulario de Registro
- [Pantalla C] Detalle de Suscripción
- [Pantalla D] Editar Suscripción

## ALCANCE DEL MVP

Para esta versión, el alcance cubre las cuatro pantallas A, B, C y D, logrando un CRUD completo (Crear, Leer, Actualizar, Borrar).

**Pantalla A — Lista de Suscripciones (pantalla_lista.dart):**
Muestra una lista de tarjetas con los pagos registrados. Cada tarjeta muestra el nombre del servicio, el costo mensual en Bs, la fecha del próximo pago (calculada automáticamente sumando un mes a la fecha de pago registrada) y un botón "Ir a pagar" que abre la URL del servicio en el navegador. Al tocar una tarjeta, el usuario navega a la pantalla de Detalle. Un botón flotante (+) permite registrar un nuevo pago.

**Pantalla B — Formulario de Registro (pantalla_registro.dart):**
Cuatro campos obligatorios, centrado en pantalla con ancho máximo de 400px.

**Pantalla C — Detalle de Suscripción (pantalla_detalle.dart):**
Muestra la información completa de una suscripción seleccionada desde la lista. Incluye botones para Editar (navega a Pantalla D), Eliminar (muestra diálogo de confirmación) e Ir a pagar (abre la URL).

**Pantalla D — Editar Suscripción (pantalla_editar.dart):**
Mismo formulario que la Pantalla B pero precargado con los datos actuales del pago. Al guardar, actualiza el registro en su misma posición sin crear uno nuevo.

**Diálogo de confirmación al eliminar:**
Al tocar Eliminar en la Pantalla C, aparece un AlertDialog preguntando "¿Eliminar [nombre]? Esta acción no se puede deshacer." con opciones Cancelar y Eliminar. Solo se borra si el usuario confirma.

### Cambios respecto a v0.1

- Se agrega el campo **Costo mensual**, necesario para que el usuario vea cuánto paga por cada servicio.
- Se agrega la columna **Próximo pago** en la lista, calculada automáticamente (fecha de pago + 1 mes). Esto responde directamente a la Dificultad de la Persona: "se olvidó de dar de baja el servicio".
- Se agregan las pantallas **Detalle** y **Editar** para completar el CRUD (el usuario puede ver, crear, modificar y eliminar sus suscripciones).
- Se cambia de tabla DateTable a lista de tarjetas para adaptar la interfaz a pantalla de celular.
- Se valida que la URL empiece con http:// o https:// antes de guardar.
- El calendario se muestra en español.

### Cambios respecto a versión web (v0.1 - v0.2)

Se migró de HTML/CSS/JavaScript a **Flutter (Dart)** para empaquetar como aplicación instalable (APK). Se reemplazó LocalStorage por **SharedPreferences** manteniendo el mismo contrato de datos. La lógica de negocio (leer, guardar, agregar, actualizar, eliminar) es idéntica.

**Nota técnica:** No hay servidor ni base de datos externa. Los datos se guardan localmente en el dispositivo con SharedPreferences. Si se desinstala la app, los datos se pierden. Es una decisión consciente del MVP.

**Limitación conocida:** Los datos viven en el dispositivo del usuario. No hay sincronización entre dispositivos.

# Flujo v0.2

## Tarea 1: Registrar un pago nuevo

1. El usuario abre la aplicación y ve la lista de suscripciones (vacía o con registros anteriores).
2. Toca el botón flotante (+).
3. La app muestra el formulario. El usuario escribe el nombre del servicio, pone el costo, selecciona la fecha del pago en el calendario y pega la URL del servicio.
4. Toca "Guardar pago".
5. La app vuelve a la lista y el nuevo pago aparece como tarjeta, con su próximo pago calculado automáticamente.

**Camino alterno A:** Si el usuario intenta guardar con algún campo vacío, el formulario muestra "Todos los campos son obligatorios" y no lo deja avanzar.

**Camino alterno B:** Si la URL no empieza con http:// o https://, el formulario muestra "La URL debe empezar con http:// o https://" y no guarda.

## Tarea 2: Editar una suscripción

1. El usuario toca una tarjeta de la lista.
2. Se abre la pantalla de Detalle con la información completa.
3. Toca el botón "Editar".
4. Se abre el formulario con los datos precargados. El usuario modifica lo que necesite.
5. Toca "Guardar cambios". La app vuelve a la lista con los datos actualizados.

## Tarea 3: Eliminar una suscripción

1. El usuario toca una tarjeta de la lista.
2. Se abre la pantalla de Detalle.
3. Toca el botón "Eliminar".
4. Aparece un diálogo preguntando si está seguro.
5. Si confirma, el pago se elimina y la lista se actualiza. Si cancela, vuelve al Detalle sin cambios.

## Tarea 4: Ir a pagar un servicio

1. El usuario ve una tarjeta en la lista con el botón "Ir a pagar".
2. Toca el botón.
3. Se abre el navegador del celular con la URL del servicio, donde el usuario puede gestionar o cancelar su suscripción.

# Tarea Clase 5: Jerarquía, Layout y Espaciado

**Enlace al Figma (Flujo actualizado):** 
(https://www.figma.com/design/wsr1LkxXeoTzQbnBXcAcCi/Untitled?node-id=15-15&t=C2CDo2vAqO5iFAsp-1)

### Registro de la Decisión y Prueba

**ANTES**
La pantalla de "Detalle de suscripción" parecía un formulario de edición porque usaba campos de texto (inputs) con bordes grises. La etiqueta "Servicio" competía visualmente con el nombre real de la suscripción. Además, los botones "Editar" y "Eliminar" tenían exactamente el mismo peso visual, por lo que ninguna acción destacaba sobre la otra.

**CAMBIO**
*   **Jerarquía y Layout:** Se reemplazaron los inputs por componentes de texto de solo lectura en Figma y en `pantalla_detalle.dart`. Se eliminó la etiqueta "Servicio" y se aumentó el tamaño del nombre de la suscripción para orientar al usuario.
*   **Espaciado (Regla de 8px):** Se aplicó una base de 8px (usando `SizedBox`). Hubo 8px entre etiquetas y valores, 16px para separar datos financieros (costo y fecha) y 32px para separar la información de los botones de acción.
*   **Acciones:** Se destacó la acción principal con un botón oscuro para "Editar", dejando "Eliminar" como una acción secundaria (botón con borde sin relleno).

**DESPUÉS**
Al mostrar la pantalla a una persona sin explicarle la interfaz, reconoció rápidamente el servicio por el título grande. Al preguntarle qué haría para modificar un dato, su vista se dirigió inmediatamente al botón oscuro de "Editar" sin dudar ni confundirse con el botón secundario.

**SIGUIENTE**
Se conservará esta estructura limpia de tarjeta de lectura y la escala de espaciado en múltiplos de 8px para futuras vistas de detalle.