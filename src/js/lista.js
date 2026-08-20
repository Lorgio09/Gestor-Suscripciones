
const tablaCuerpo = document.getElementById("tablaCuerpo");

function pintarTabla() {
   
    const lista = leerPagos();

    
    tablaCuerpo.innerHTML = "";

    
    if (lista.length === 0) {
        tablaCuerpo.innerHTML = "<tr><td colspan='3'>No hay suscripciones registradas.</td></tr>";
        return; 
    }

  
    for (let i = 0; i < lista.length; i++) {
        const pago = lista[i]; 
        const fila = document.createElement("tr");

        fila.innerHTML = `
            <td>${pago.nombre}</td>
            <td>$${pago.costo}</td>
            <td>${pago.fecha}</td>
            <td><a href="${pago.url}" target="_blank">Ir a cancelar</a></td>
        `;

        tablaCuerpo.appendChild(fila);
    }
}


pintarTabla();