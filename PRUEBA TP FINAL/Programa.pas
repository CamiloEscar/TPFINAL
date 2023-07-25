program Programa;

uses 
	crt, Menu, ABMC, Provincia;

const
	ruta_Per='personasprueba.dat'; 
	ruta_P='provinciasprueba.dat'; 

var
	opcion:char;
	archivo_per:fichero_per;
	archivo_P:fichero_P;

begin

	crear_archivo (archivo_per,ruta_Per); // llama al procedimiento de la unit ABMC
	crear_archivo (archivo_P,ruta_P); // llama al procedimiento de la unit Configuracion
	delay (1500); // Lapso de Reloj. Da tiempo para leer si se están creando o cargando los archivos

	repeat
		TextColor (7); 
		TextBackground (0); 
		clrscr; 
		menu_principal(opcion); // llama al procedimiento de la unit Menu_Principal

		case opcion of // Se obtiene la opción desde el procedimiento de la unit Menu_Principal

			'1': menu_configuracion; // llama al procedimiento de la unit Configuracion de estancias
			'2': menu_ABMC; // llama al procedimiento de la unit ABMC

		end

	until (opcion='0'); // Sale del programa

end.
