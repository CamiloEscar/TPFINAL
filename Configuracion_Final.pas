unit Configuracion_Final;
{$codepage utf8}

interface // Parte pública, que se comparte

uses 
	crt;

const
	ruta_Est='Estancias.dat';

type

	Estancias = record
		codigo_estancia:byte;
		denominacion:string[30];
		pileta:string[30];
	end;

fichero_est= file of Estancias;

var
	archivo_est:fichero_est;
	registro_est:Estancias;

procedure crear_archivo(var archivo:file; ruta_archivo:string);
procedure menu_configuracion;
procedure listar_estancias(var arch:fichero_est);
procedure cerrar_archivo_est(var arch:fichero_est);
procedure listar_est(var arch:fichero_est);
procedure mostrar_en_carga (var arch:fichero_est; reg:estancias; cod_estancia:byte; ubi:integer;var aux_denominacion:string);
procedure buscar_registro_est (var arch:fichero_est; reg:estancias; cod_estancia:byte; var encont:boolean; var ubic:integer);

implementation // Parte privada de la unit

// Procedimiento que crea la plantilla a mostrar
procedure plantilla_estancia;
begin
	TextColor (7);
	TextBackground (3);
			//         1         2         3         4         5         6
			//123456789012345678901234567890123456789012345678901234567890
	writeln ('-------------------------------------------------------');//01
	writeln ('-    - Estancias                       - Pileta       -');//02
	writeln ('-------------------------------------------------------');//03
	writeln ('-    -                                 -              -');//03
end;

// Procedimiento para crear el archivo de provincias
procedure crear_archivo(var archivo:file; ruta_archivo:string);
begin
	assign(archivo, ruta_archivo); // assign: es la orden que se encarga de asignar un nombre físico al fichero que acabamos de declarar. Asignamos el tipo y ruta de archivo a Archivo.
	{$I-} 
	reset(archivo); // reset: abre un fichero para lectura.
	{$I+}
	if ioresult <> 0 then // Si IOResult es distinto de 0, significa que el archivo no existe.
		begin
			writeln(ruta_archivo,'. No existe. Se creará el archivo.'); // muestra en pantalla que se está creando el archivo
			rewrite(archivo); // Si el archivo no existe lo creamos y abrimos con rewrite.
		end
	else
	begin
		writeln('Cargando: ', ruta_archivo); // muetra en pantalla si se esta cargando
	end;
	close(archivo); // cierra el archivo
end;

// Procedimiento para abrir el archivo
procedure abrir_archivo_est (var arch:fichero_est);
begin
	assign(arch, ruta_Est); // assign: es la orden que se encarga de asignar un nombre físico al fichero que acabamos de declarar.
	reset(arch); // reset: abre un fichero para lectura.
end;

// Procedimiento para cerrar el archivo
procedure cerrar_archivo_est(var arch:fichero_est);
begin
	close(arch); // cierra el archivo
end;

// Procedimiento para guardar un registro ingresado
procedure guardar_registro_est(var arch:fichero_est;reg:estancias);
begin
	seek(arch,filesize(arch)); // Se posiciona en la última posición del registro
	write(arch,reg); // Escribe al archivo
end;

// Procedimiento para mostrar los registros
procedure mostrar_registro_est(reg:estancias);
begin
	gotoxy (1,3+reg.codigo_estancia);
	writeln ('-    -                                 -              -');
	gotoxy (3,3+reg.codigo_estancia);
	writeln(reg.codigo_estancia);
	gotoxy (8,3+reg.codigo_estancia);
	writeln(reg.denominacion);

end;

// Procedimiento para modificar un registro
procedure modificar_registro_est (var reg:estancias;ubi:integer);
begin
	gotoxy(1,10);
	writeln ('Ingrese el dueño de la  estancia              ');
	gotoxy (3,6);
	readln (reg.codigo_estancia);
	gotoxy(1,10);
	writeln ('Ingrese Nombre de la Estancia                   ');
	gotoxy(8,6);
	readln(reg.denominacion);
	gotoxy(1,10);
	seek(archivo_est,ubi); // Se posiciona en el registro con posición ubi
	write(archivo_est,reg); // sobreescribe el registro
end;

// Procedimiento que al ingresar el cod devuelve la denominación de la provincia
procedure mostrar_en_carga (var arch:fichero_est; reg:estancias; cod_estancia:byte; ubi:integer;var aux_denominacion:string);
begin
	seek (arch,ubi); // Se posiciona en el registro con posición ubi
	read (arch,reg); // lee el archivo
	if cod_estancia=reg.codigo_estancia then
		aux_denominacion:=reg.denominacion;
end;

// Procedimiento para mostrar el registro buscado
procedure mostrar_buscado_est (var arch:fichero_est; reg:estancias; cod_est:byte; ubi:integer);
begin
	seek (arch,ubi); // Se posiciona en el registro con posición ubi
	read (arch,reg); // lee el archivo
	if cod_est=reg.codigo_estancia then
		begin
			gotoxy (3,4);
			writeln(reg.codigo_estancia);
			gotoxy (8,4);
			writeln(reg.denominacion);
		end;
end;

// Procedimiento para listar las provincias
procedure listar_est(var arch:fichero_est);
var
	reg:estancias;
begin
	clrscr;
	plantilla_estancia; // Procedimiento para dibujar la plantilla
	reset(arch);
	while not (eof(arch)) do
		begin
			read (arch,reg);
			mostrar_registro_est(reg); // Procedimiento para para mostrar cada registro
		end;
end;

// Procedimiento para leer los registros del archivo
procedure leer_registro_est(var arch:fichero_est; var reg:estancias; pos:integer);
begin
	seek(arch,pos);
	read(arch,reg);
end;

// Procedimiento busca si cod está ingresado y devuelve la ubicación
procedure buscar_registro_est (var arch:fichero_est; reg:estancias; cod_estancia:byte; var encont:boolean; var ubic:integer);
var
	i: integer;
begin
for i:=0 to filesize(arch)-1 do
	begin
		leer_registro_est (arch,reg,i); // Procedimiento para leer los registros del archivo
		if cod_estancia=reg.codigo_estancia then
			Begin
				encont:=true;
				ubic:=i;
			end;
	end;
end;

// Procedimiento para mostrar las provincias pero en forma horizontal
procedure mostrar_registro_estancias(reg:estancias);
begin
	write(reg.codigo_estancia,'-',reg.denominacion,'  ');
end;

// Procedimiento para listar las provincias
procedure listar_estancias(var arch:fichero_est);
var
	reg:estancias;
	i:byte;
begin
	i:=0;
	reset(arch);
	while not (eof(arch)) do
		begin
			read (arch,reg);
			if i=7 then // Va haciendo grupos de 7 provincias por renglón
				begin
					writeln('');
					i:=0;
				end;
			inc(i);
			mostrar_registro_estancias(reg); // Procedimiento para mostrar las provincias pero en forma horizontal 
		end;
end;

// Procedimiento para cargar las provincias
procedure cargar_registro_est(var reg:estancias);
begin
	clrscr; // Limpia la pantalla
	plantilla_estancia; // llama al procedimiento para dibujar la plantilla
	TextColor (10); // Cambia color de Texto
	gotoxy(1,26);
	listar_est (archivo_est); // llama al procedimiento listar y muestra las provincias ya ingresadas
	with reg do
		begin
			codigo_estancia:= filesize(archivo_est)+1;
			gotoxy(3,3+codigo_estancia);
			gotoxy(1,3+codigo_estancia);
			writeln ('-    -                                 -              -');
			gotoxy(3,3+codigo_estancia);
			writeln (codigo_estancia);
			gotoxy(1,29);
			writeln ('Ingrese Nombre de la Estancia                  ');
			gotoxy(8,3+codigo_estancia);
			readln(denominacion);
			gotoxy(1,29);

		end;
end;

// Procedimiento para ordenar las provincias en forma alfabética
procedure orden_burbuja_est (var arch:fichero_est);
var 
	reg1,reg2:estancias;
	lim,i,j:integer;
begin

	lim:= filesize(arch)-1;
	for i:= 1 to lim - 1 do
		for j:= 0 to lim - i do
			begin
				seek(arch,J); // Se posiciona en el registro con posición J
				read(arch,reg1); // lee el archivo
				seek(arch,j+1); // Se posiciona en el registro con posición J+1
				read(arch,reg2); // lee el archivo
				if reg1.denominacion > reg2.denominacion then
					begin
						seek(arch,j+1);  // Se posiciona en el registro con posición J+1
						write(arch,reg1); // Escribe al archivo
						seek(arch,j);  // Se posiciona en el registro con posición J
						write(arch,reg2); // Escribe al archivo
					end;
			end;
end;

// Procedimiento del menu de opciones
procedure menu_configuracion;
var
	opcion,seguir:char;
	aux_estancia:byte;
	ubicacion:integer;
	encontrado:boolean;
begin
	abrir_archivo_est (archivo_est); // abre el archivo
	orden_burbuja_est (archivo_est); // ordenda los registros por abecedario
	cerrar_archivo_est (archivo_est); // cierra el archivo

	TextColor(7); // Cambia color de Texto
	TextBackground(3); // Cambia color de Fondo
	repeat
		ubicacion:=-1;
		encontrado:=false;
		clrscr; // Limpia la pantalla
		writeln ('------------------------------------------');
		writeln ('-          menu configuracion            -');
		writeln ('------------------------------------------');
		writeln ('- Elija una opción                       -');
		writeln ('------------------------------------------');
		writeln ('- 1 - Alta Estancia                      -');
		writeln ('- 2 - Modificar Estancia                 -');
		writeln ('------------------------------------------');
		writeln ('- 3 - Volver al Menu Principal           -');
		writeln ('------------------------------------------');
		opcion:= readkey; // Toma la opción con solo teclear 
		Case opcion of
			'1': begin // Opción que muestra las provincias 
					repeat
						abrir_archivo_est (archivo_est); // abre el archivo
						cargar_registro_est (registro_est); // Carga los datos de un registro
						guardar_registro_est (archivo_est,registro_est); // Guarda el registro
						cerrar_archivo_est (archivo_est); // cierra el archivo
						gotoxy(1,29) ;
						writeln ('desea ingresar otra estancia (S/N)');
						seguir:=readkey; // Toma la opción con solo teclear 
						seguir:=upcase(seguir); // Pasa a mayúscula
					until seguir <> 'S';
				end;
			'2':begin // opción para modificar una provincia
					clrscr; // Limpia la pantalla
					plantilla_estancia; // Procedimiento para dibujar la plantilla
					abrir_archivo_est (archivo_est); // Abre el archivo de provincias
					listar_est (archivo_est); // muestra la lista de provincias
					writeln ('');
					writeln ('Elija la estancia a modificar.');
					readln (aux_estancia);
					clrscr; // Limpia la pantalla
					buscar_registro_est (archivo_est,registro_est,aux_estancia,encontrado,ubicacion); // busca si está la provincia
					if encontrado then
						begin
							plantilla_estancia; // Procedimiento para dibujar la plantilla
							mostrar_buscado_est (archivo_est,registro_est,aux_estancia,ubicacion); // muestra la provincia buscada
							gotoxy(1,10);
							writeln ('quiere modificar esta estancia (S/N)');
							seguir:= readkey; // Toma la opción con solo teclear 
							seguir:=upcase(seguir); // Pasa a mayúscula
							if seguir='S' then
								begin
									modificar_registro_est (registro_est,ubicacion); // Procedimiento para modificar un registro
								end;
						end;
					cerrar_archivo_est (archivo_est); // cierra el archivo
				end;
			'3': begin // Salir del Menu, vuelve al menu principal
				end;
			else
				begin
					clrscr; // Limpia la pantalla
					writeln ('Ingreso una opcion incorrecta, pulse una tecla para continuar');
					readkey;
				end;
			end;
	until (opcion= '3');
end;

begin
end.
