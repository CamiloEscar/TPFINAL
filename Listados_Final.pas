unit Listados_Final;

interface 

uses
	crt,
	ABMC_Final,Configuracion_Final;

const
	ruta_Per='personas.dat'; 
	ruta_Est='Estancias.dat'; 

var
	archivo_est:fichero_est;

procedure menu_listados;

implementation 

procedure menu_listados;
var
	opcion:char;
	aux_condicion,encontrado:boolean;
	aux_denominacion:string;
	codigo_provincia:byte;
	ubicacion:integer;

begin
	TextColor(7); 
	TextBackground(3); 

	assign(archivo_per, ruta_Per); // assign: es la orden que se encarga de asignar un nombre físico al fichero que acabamos de declarar.
	reset(archivo_per); // reset: abre un fichero para lectura.
	orden_burbuja_I_Apellido (archivo_per); // ordenda los registros por Apellido
	close (archivo_per); 


	repeat
		clrscr; 
		writeln ('------------------------------------------');
		writeln ('-             menu Listados              -');
		writeln ('------------------------------------------');
		writeln ('- Elija una opción                       -');
		writeln ('------------------------------------------');
		writeln ('- 1 - Lista de estancias                 -');
		writeln ('------------------------------------------');
		writeln ('- 2 - Lista de estancias con piscina      ');
		writeln ('------------------------------------------');
		writeln ('- 3 - Estancias por provincia            -');
		writeln ('------------------------------------------');
		writeln ('- 4 - Volver al Menu Principal           -');
		writeln ('------------------------------------------');
		opcion:= readkey; 

		Case opcion of
			'1': begin
					assign(archivo_est, ruta_Est); // assign: es la orden que se encarga de asignar un nombre físico al fichero que acabamos de declarar.
					assign(archivo_per, ruta_Per);
					reset(archivo_est); // reset: abre un fichero para lectura.
					reset(archivo_per);
					listar_est (archivo_est); // Procedimiento para listar las provincias
					//mostrar_registro_per(reg:personas);
					cerrar_archivo_est (archivo_est);
					//cerrar_archivo_per (archivo_per);  
					writeln ('');
					writeln ('Pulse una tecla para continuar');
					readkey;
				end;
			'2': begin
					assign(archivo_est, ruta_Est); 
					reset(archivo_est); 
					listar_pil (archivo_est); // Procedimiento para listar las estancias con pileta
					cerrar_archivo_est (archivo_est); 
					writeln ('');
					writeln ('Pulse una tecla para continuar');
					readkey;
				end;
			'3': begin
					clrscr; 
					writeln ('Ingrese el codigo de Provincia');
					writeln ('');
					assign(archivo_est, ruta_Est); 
					reset(archivo_est); 
					listar_estancias(archivo_est); // Procedimiento para listar las provincias en forma horizontal
					writeln ('');
					readln (codigo_provincia);
					buscar_registro_est (archivo_est,registro_est,codigo_provincia,encontrado,ubicacion); // Busca a la estancia si está 
					mostrar_en_carga (archivo_est,registro_est,codigo_provincia,ubicacion,aux_denominacion); // Devuelve la denominación
					cerrar_archivo_est (archivo_est); 
					assign(archivo_per, ruta_Per); 
					reset(archivo_per); 
					listar_i_estancias(archivo_per,codigo_provincia,aux_denominacion); 
					close (archivo_per); 
					writeln ('');
					writeln ('Presione un tecla para volver al menu.');
					readkey;
				end;
			'4': begin // Salir del Menu, vuelve al menu principal
				end;
			else
				begin
					clrscr; 
					writeln ('Ingreso una opcion incorrecta, pulse una tecla para continuar');
					readkey;
				end;
			end;
	until (opcion= '4');
end;

begin
end.

