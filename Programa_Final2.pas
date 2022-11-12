program Programa_Final;


uses 
	crt,
	Menu_principal_Final, Duenio_estancia, Listados_Final; 

const
	ruta_Per='Personas.dat'; 
	ruta_Est='Estancias.dat'; 

var
	opcion:char;
	archivo_per:fichero_per;
	archivo_est:fichero_est;

begin

	crear_archivo (archivo_per,ruta_Per); // llama al procedimiento de la unit ABMC
	crear_archivo (archivo_est,ruta_Est); // llama al procedimiento de la unit Configuracion
	delay (1500); // Lapso de Reloj. Da tiempo para leer si se están creando o cargando los archivos

	repeat
		TextColor (7); 
		TextBackground (3); 
		clrscr; 
		menu_principal(opcion); // llama al procedimiento de la unit Menu_Principal

		case opcion of // Se obtiene la opción desde el procedimiento de la unit Menu_Principal

			'1': Duenio_estancia; // llama al procedimiento de la unit ABMC
			'2': listados; // llama al procedimiento de la unit Listados
			'3': configuracion; // llama al procedimiento de la unit Configuracion de estancias

		end

	until (opcion='4'); // Sale del programa

end.
