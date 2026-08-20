
const tablaCuerpo = document.getElementById("tablaCuerpo");

function pintarTabla() {

    const lista = leerPagos();

    
    tablaCuerpo.innerHTML = "";

    
    if (lista.length === 0) {
        //colspan=4 porque hay 4 columnas, también lo centramos
        tablaCuerpo.innerHTML = `
            <tr>
                <td colspan='4' class='text-center py-4 text-muted'>
                    No hay suscripciones registradas.
                </td>
            </tr>
        `;
        return; 
    }


    for (let i = 0; i < lista.length; i++) {
        const pago = lista[i]; 
        const fila = document.createElement("tr");
        // añadiendo estilo Bootstrap
        fila.innerHTML = `
            <td class="ps-4 fw-bold text-dark">${pago.nombre}</td>
            <td>$${pago.costo}</td>
            <td class="text-muted">${pago.fecha}</td>
            <td class="text-end pe-4">
                <a href="${pago.url}" target="_blank" class="btn btn-outline-danger btn-sm">
                Ir a cancelar
                </a>
            </td>
        `;

        tablaCuerpo.appendChild(fila);
    }
}


pintarTabla();