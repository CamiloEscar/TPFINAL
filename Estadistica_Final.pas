unit Estadistica_Final;
{$codepage utf8}

interface // Parte pública, que se comparte

uses 
	crt,
	Configuracion_Final,ABMC_Final;

const
	ruta_Per='personas.dat'; // ubicacion del archivo
	ruta_E='estadisticas.dat'; // ubicacion del archivo
	ruta_Est='Estancias.dat'; // ubicacion del archivo

type
	fichero_per= file of Personas;
	fichero_E= file of estadisticas;
	fichero_est= file of Estancias; 

var
	archivo_per:fichero_per;
	archivo_E:fichero_E;
	archivo_est:fichero_est;
	registro_per:personas;
	registro_E:estadisticas;
	registro_est:estancias;

procedure menu_estadistica;

implementation // Parte privada de la unit 

procedure menu_estadistica;
var
	opcion:char;
	porciento1, porciento2, porciento3:real;
	ubicacion,cantidad,cantidad1,cantidad2,cantidad3:integer;
	codigo_provincia:byte;
	encontrado:boolean;
	aux_denominacion,valor0,valor1,valor2,valor3:string[30];

begin
	TextColor(7); // Cambia color de Texto
	TextBackground(3); // Cambia color de Fondo

	repeat

		porciento1:=0;
		porciento2:=0;
		porciento3:=0;
		cantidad:=0;
		cantidad1:=0;
		cantidad2:=0;
		cantidad3:=0;

		clrscr; // Limpia la pantalla
		writeln ('------------------------------------------');
		writeln ('-            Menu estadistica            -');
		writeln ('------------------------------------------');
		writeln ('- Elija una opción                       -');
		writeln ('------------------------------------------');
		writeln ('- Estadistica Estancias                  -');
		writeln ('- 1 - Estado de 		                   -');
		writeln ('- 2 - Forma de                           -');
		writeln ('- 3 - Por edad                           -');
		writeln ('------------------------------------------');
		writeln ('- Estadistica Nacional de estancias      -');
		writeln ('- 4 - Estado de                          -');
		writeln ('- 5 - Forma de                           -');
		writeln ('- 6 - Por edad                           -');
		writeln ('------------------------------------------');
		writeln ('- 7 - Volver al Menu Principal           -');
		writeln ('------------------------------------------');
		opcion:= readkey; // Toma la opción con solo teclear 

		if opcion in ['1','2','3'] then
			begin
				clrscr; // Limpia la pantalla
				writeln ('Ingrese el codigo de Provincia');
				writeln ('');
				assign(archivo_est, ruta_Est); // assign: es la orden que se encarga de asignar un nombre físico al fichero que acabamos de declarar.
				reset(archivo_est); // reset: abre un fichero para lectura.
				listar_estancias(archivo_est); // Procedimiento que lista las provincias en forma horizontal
				writeln ('');
				readln (codigo_estancia);
				buscar_registro_est (archivo_est,registro_est,codigo_estancia,encontrado,ubicacion); // busca la provincia si está
				mostrar_en_carga (archivo_est,registro_est,codigo_estancia,ubicacion,aux_denominacion); // devuelve la denominación
				cerrar_archivo_est (archivo_est); // Cierra el archivo
				assign(archivo_per, ruta_Per); // assign: es la orden que se encarga de asignar un nombre físico al fichero que acabamos de declarar.
				reset(archivo_per); // reset: abre un fichero para lectura.
				cantidad_personas_estancia (archivo_per,codigo_estancia,cantidad); // Procedimiento Cuantos contagiados hay
			end
		else 
			if opcion in ['4','5','6'] then
				begin
					aux_denominacion:='Argentina';
					assign(archivo_per, ruta_Per); // assign: es la orden que se encarga de asignar un nombre físico al fichero que acabamos de declarar.
					reset(archivo_per); // reset: abre un fichero para lectura.
					{cantidad_personas_estancia (archivo_per,cantidad); // Procedimiento Cuantos contagiados hay}
				end;

		Case opcion of

			// opciones para una provincia elegida
			'1': begin
					assign(archivo_E, ruta_E); // assign: es la orden que se encarga de asignar un nombre físico al fichero que acabamos de declarar.
					reset(archivo_E); // reset: abre un fichero para lectura.
					cantidad_estado_estancias (archivo_E,codigo_estancia,cantidad1,cantidad2,cantidad3); // Procedimiento Estado de contagio
					close(archivo_E); // Cierra el archivo
				end;
			'2': begin
					assign(archivo_E, ruta_E); // assign: es la orden que se encarga de asignar un nombre físico al fichero que acabamos de declarar.
					reset(archivo_E); // reset: abre un fichero para lectura.
					cantidad_forma_estancia (archivo_E,codigo_estancia,cantidad1,cantidad2,cantidad3); // Procedimiento forma de contagio
					close(archivo_E); // Cierra el archivo
				end;
			'3': begin
					cantidad_edad_estancia (archivo_per,codigo_estancia,cantidad1,cantidad2,cantidad3); // Procedimiento que calcula la edad de cada sector
				end;

			// opciones para todo el país
			'4': begin
					assign(archivo_E, ruta_E); // assign: es la orden que se encarga de asignar un nombre físico al fichero que acabamos de declarar.
					reset(archivo_E); // reset: abre un fichero para lectura.
					cantidad_estado_nacional (archivo_E,cantidad1,cantidad2,cantidad3); // Procedimiento Estado de contagio
					close(archivo_E); // Cierra el archivo
				end;
			'5': begin
					assign(archivo_E, ruta_E); // assign: es la orden que se encarga de asignar un nombre físico al fichero que acabamos de declarar.
					reset(archivo_E); // reset: abre un fichero para lectura.
					cantidad_forma_nacional (archivo_E,cantidad1,cantidad2,cantidad3); // Procedimiento forma de contagio
					close(archivo_E); // Cierra el archivo
				end;
			'6': begin
					//cantidad_edad_nacional(archivo_per,cantidad1,cantidad2,cantidad3); // Procedimiento que calcula la edad de cada sector
				end;

			// Para salir
			'7': begin // Salir del Menu, vuelve al menu principal
				end;
			else // Si la opción es erronea
				begin
					clrscr; // Limpia la pantalla
					writeln ('Ingreso una opcion incorrecta, pulse una tecla para continuar');
					readkey;
				end;
			end;

			if opcion in ['1'..'6'] then // Si la opción está dentro del conjunto
				begin
					close(archivo_per); // Cierra el archivo
					
					if Cantidad >0 then
						begin
							porciento1:=(cantidad1*100/Cantidad);
							porciento2:=(cantidad2*100/Cantidad);
							porciento3:=(cantidad3*100/Cantidad);
							str(cantidad,valor0) ; // Cierra el archivo
							str(cantidad1,valor1); // Cierra el archivo
							str(cantidad2,valor2); // Cierra el archivo
							str(cantidad3,valor3); // Cierra el archivo
							//circulo(porciento1, porciento2, porciento3,aux_denominacion,opcion,valor0,valor1,valor2,valor3); // Procedimiento del gráfico de porcentajes
						end
						else
							begin
								clrscr; // Limpia la pantalla
								writeln ('No hay datos ingresados para esa opcion');
								writeln ('Presione una tecla para continuar');
								readkey;
							end;
				end;

	until (opcion= '7');
end;

begin
end.
