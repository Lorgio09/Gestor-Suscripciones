// Capturamos el <tbody> del HTML
const tablaCuerpo = document.getElementById("tablaCuerpo");

function pintarTabla() {
    // Traemos los datos usando la función que ya armaste en almacen.js
    const lista = leerPagos();

    // Limpiamos la tabla
    tablaCuerpo.innerHTML = "";

    // Si no hay nada, mostramos un mensaje básico
    if (lista.length === 0) {
        tablaCuerpo.innerHTML = "<tr><td colspan='3'>No hay suscripciones registradas.</td></tr>";
        return; 
    }

    // Recorremos el arreglo y dibujamos cada fila
    for (let i = 0; i < lista.length; i++) {
        const pago = lista[i]; 
        const fila = document.createElement("tr");

        fila.innerHTML = `
            <td>${pago.nombre}</td>
            <td>${pago.fecha}</td>
            <td><a href="${pago.url}" target="_blank">Ir a cancelar</a></td>
        `;

        tablaCuerpo.appendChild(fila);
    }
}

// Ejecutamos la función apenas cargue la página
pintarTabla();