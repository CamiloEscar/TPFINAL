unit Listados_Final;
{$codepage utf8}

interface // Parte pública, que se comparte

uses
	crt,
	ABMC_Final,Configuracion_Final;

const
	ruta_Per='personas.dat'; // ubicacion del archivo
	ruta_E='estadisticas.dat'; // ubicacion del archivo
	ruta_Est='Estancias.dat'; // ubicacion del archivo

var
	archivo_est:fichero_est;

procedure menu_listados;

implementation // Parte privada de la unit


// Procedimiento del Menú de Listados
procedure menu_listados;
var
	opcion:char;
	aux_condicion,encontrado:boolean;
	aux_denominacion:string;
	codigo_estancia:byte;
	ubicacion:integer;

begin
	TextColor(7); // Cambia color de Texto
	TextBackground(3); // Cambia color de Fondo

	assign(archivo_per, ruta_Per); // assign: es la orden que se encarga de asignar un nombre físico al fichero que acabamos de declarar.
	reset(archivo_per); // reset: abre un fichero para lectura.
	orden_burbuja_I_Apellido (archivo_per); // ordenda los registros por Apellido
	close (archivo_per); // cierra el archivo


	repeat
		clrscr; // Limpia la pantalla
		writeln ('------------------------------------------');
		writeln ('-             menu Listados              -');
		writeln ('------------------------------------------');
		writeln ('- Elija una opción                       -');
		writeln ('------------------------------------------');
		writeln ('- 1 - ESTANCIAS                          -');
		writeln ('------------------------------------------');
		writeln ('- Estancias Totales                      -');
		writeln ('------------------------------------------');
		writeln ('- 2 - Correctos                          -');
		writeln ('- 3 - Carga Incorrecta                   -');
		writeln ('------------------------------------------');
		writeln ('- 4 - Personas por Estancia              -');
		writeln ('------------------------------------------');
		writeln ('- 5 - Volver al Menu Principal           -');
		writeln ('------------------------------------------');
		opcion:= readkey; // Toma la opción con solo teclear 

		Case opcion of
			'1': begin
					assign(archivo_est, ruta_Est); // assign: es la orden que se encarga de asignar un nombre físico al fichero que acabamos de declarar.
					reset(archivo_est); // reset: abre un fichero para lectura.
					listar_est (archivo_est); // Procedimiento para listar las provincias
					cerrar_archivo_est (archivo_est); // Cierra el archivo
					writeln ('');
					writeln ('Pulse una tecla para continuar');
					readkey;
				end;
			'2': begin
					aux_condicion:=true; // Muestra los que están OK
					assign(archivo_per, ruta_Per); // assign: es la orden que se encarga de asignar un nombre físico al fichero que acabamos de declarar.
					reset(archivo_per); // reset: abre un fichero para lectura.
					listar_I (archivo_per,aux_condicion); // muestra la lista de todos los intectados true
					close (archivo_per); // Cierra el archivo
					writeln ('');
					writeln ('Presione un tecla para volver al menu.');
					readkey;
				end;
			'3': begin
					aux_condicion:=false; // Muestra los que están dados de Baja
					assign(archivo_per, ruta_Per); // assign: es la orden que se encarga de asignar un nombre físico al fichero que acabamos de declarar.
					reset(archivo_per); // reset: abre un fichero para lectura.
					listar_I (archivo_per,aux_condicion); // muestra la lista de todos los intectados true
					close (archivo_per); // Cierra el archivo
					writeln ('');
					writeln ('Presione un tecla para volver al menu.');
					readkey;
				end;
			'4': begin
					clrscr; // Limpia la pantalla
					writeln ('Ingrese el codigo de Provincia');
					writeln ('');
					assign(archivo_est, ruta_Est); // assign: es la orden que se encarga de asignar un nombre físico al fichero que acabamos de declarar.
					reset(archivo_est); // reset: abre un fichero para lectura.
					listar_estancias(archivo_est); // Procedimiento para listar las provincias en forma horizontal
					writeln ('');
					readln (codigo_estancia);
					buscar_registro_est (archivo_est,registro_est,codigo_estancia,encontrado,ubicacion); // Busca a la provincia si está 
					mostrar_en_carga (archivo_est,registro_est,codigo_estancia,ubicacion,aux_denominacion); // Devuelve la denominación
					cerrar_archivo_est (archivo_est); // Cierra el archivo
					assign(archivo_per, ruta_Per); // assign: es la orden que se encarga de asignar un nombre físico al fichero que acabamos de declarar.
					reset(archivo_per); // reset: abre un fichero para lectura.
					listar_i_estancias(archivo_per,codigo_estancia,aux_denominacion); // Procedimiento que lista pacientes por provincia
					close (archivo_per); // Cierra el archivo
					writeln ('');
					writeln ('Presione un tecla para volver al menu.');
					readkey;
				end;
			'5': begin // Salir del Menu, vuelve al menu principal
				end;
			else
				begin
					clrscr; // Limpia la pantalla
					writeln ('Ingreso una opcion incorrecta, pulse una tecla para continuar');
					readkey;
				end;
			end;
	until (opcion= '5');
end;

begin
end.

