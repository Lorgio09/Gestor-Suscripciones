const clave_pagos=["pagos"]


function leerPagos() {
    const datos= localStorage.getItem(clave_pagos)
    if (datos) {
        return JSON.parse(datos)
    }
    return []
}

function guardarPagos(lista){
    const datosString=JSON.stringify(lista)
    localStorage.setItem(clave_pagos,datosString)
}
