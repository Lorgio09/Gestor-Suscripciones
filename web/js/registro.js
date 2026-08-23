const formPago  = document.getElementById("formPago");
const inpNombre = document.getElementById("inpNombre");
const inpFecha  = document.getElementById("inpFecha");
const inpUrl    = document.getElementById("inpUrl");
const msjError  = document.getElementById("msjError");
const inpCosto = document.getElementById("inpCosto");

// Devuelve true si los 3 tienen algo
function validarForm() {
    if (inpNombre.value === "" || inpCosto.value === "" || inpFecha.value === "" || inpUrl.value === "") {
        msjError.textContent = "Todos los campos son obligatorios.";
        return false;
    }
    msjError.textContent = "";
    return true;
}

// Arma el objeto lo agrega a la lista y vuelve al inicio
function agregarPago() {
    const lista = leerPagos();

    const nuevoPago = {
        nombre: inpNombre.value,
        costo:  Number(inpCosto.value),
        fecha:  inpFecha.value,
        url:    inpUrl.value
    };

    lista.push(nuevoPago);
    guardarPagos(lista);

    window.location.href = "index.html";
}

formPago.addEventListener("submit", function (evento) {
    evento.preventDefault();
    if (validarForm()) {
        agregarPago();
    }
});