document.addEventListener("DOMContentLoaded", function() {
    document.getElementById("formulario").addEventListener('submit', validarFormulario); 
});

function validarFormulario(evento) {
    evento.preventDefault();
    var fecha = document.getElementById('fechaNac').value;
    
    var year = parseInt(fecha.split('-')[0]);
    var month = parseInt(fecha.split('-')[1]);
    var day = parseInt(fecha.split('-')[2]);
    var usuario = document.getElementById('nome').value;
    if(usuario.length == 0) {
        alert('No has escrito nada en Nombre y Apellidos');
        return;
    }
    var monthDays = new Date(year,month,0).getDate();
    if(day>monthDays){
        alert('El día de la Fecha de Nacimiento no es válido');
        return;
    }
    if(month>12 || month<1){
        alert('El mes de la Fecha de Nacimiento no es válido');
        return;
    }
    if(year > new Date().getFullYear()){
        alert('El año de la Fecha de Nacimiento no es válido');
        return;
    }
    var numero = document.getElementById('udFamiliar').value;
    if (numero > 10||numero < 1) {
        alert('El número de constituyentes de la unidad familiar no es válido');
        return;
    }
    if(!(document.getElementById('hombre').checked ||document.getElementById('mujer').checked || document.getElementById('otro').checked))
    {
        alert('Debes de seleccionar alguno de los sexos.');
        return;
    }
}

function siguiente(){
    var nombre = document.getElementById('nome').value;
    var numero = document.getElementById('udFamiliar').value;
    var fecha = document.getElementById('fechaNac').value;
    var hombre = document.getElementById('hombre').checked ;
    var mujer = document.getElementById('mujer').checked ;

    var il = document.getElementById("perfil");

    var img = '';
    if(hombre){
        img = '/img/hombre.png';
    }
    else if(mujer)
    {  
        img = '/img/mujer.png';
    }
    else{
        img = '/img/otro.png';
    }
    il.innerHTML = '<li>'+nombre+' '+fecha+' '+numero+'<img class="imgli" src='+img+' alt=""></li>';

}