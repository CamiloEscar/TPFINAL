program Programa_BacKGaMmon;


uses 
	crt,
	Menu_principal_Final, ABMC_Final, Listados_Final, Estadistica_Final, // opciones iniciales de unit
	Caratula_Final, Salir_Final, Configuracion_Final; // opciones agregadas de unit
	// Fecha_BacKGaMmon, // unit agregada que no está utilizada acá

const
	ruta_Per='Personas.dat'; // ubicacion del archivo
	ruta_E='estadisticas.dat'; // ubicacion del archivo
	ruta_Est='Estancias.dat'; // ubicacion del archivo

var
	opcion:char;
	archivo_per:fichero_per;
	archivo_E:fichero_E;
	archivo_est:fichero_est;

begin
	caratula; // llama al procedimiento de la unit Caratula_BacKGaMmon

	crear_archivo (archivo_per,ruta_Per); // llama al procedimiento de la unit ABMC_BacKGaMmon
	crear_archivo (archivo_E,ruta_E); // llama al procedimiento de la unit ABMC_BacKGaMmon 
	crear_archivo (archivo_est,ruta_Est); // llama al procedimiento de la unit Configuracion_BacKGaMmon
	delay (1500); // Lapso de Reloj. Da tiempo para leer si se están creando o cargando los archivos

	repeat
		TextColor (7); // Cambia color de Texto
		TextBackground (3); // Cambia color de Fondo
		clrscr; // Limpia la pantalla
		menu_principal(opcion); // llama al procedimiento de la unit Menu_Principal_BacKGaMmon

		case opcion of // Se optiene la opción desde el procedimiento de la unit Menu_Principal_BacKGaMmon

			'1': menu_ABMC; // llama al procedimiento de la unit ABMC_BacKGaMmon
			'2': menu_listados; // llama al procedimiento de la unit Listados_BacKGaMmon
			'3': menu_estadistica; // llama al procedimiento de la unit Estadistica_BacKGaMmon
			'4': menu_configuracion; // llama al procedimiento de la unit Configuracion_BacKGaMmon
			//'5': salida; // llama al procedimiento de la unit Salir_BacKGaMmon

			// Si es incorrecta la opción, en la unit Menu_Principal_BacKGaMmon muestra el error

		end

	until (opcion='5'); // Sale del programa

end.
