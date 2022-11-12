unit Dueño_estancia;

interface

uses
    crt, Fecha_Final;

const
    ruta_Per='Personas.dat';
    ruta_Est='Estancias.dat';

type 
    personas = record
        id:integer;
        apellidoynombre:string[30];
        dni:string[8];
        calle:string[20];
        numero:string[8];
        piso:string[3];
        departamento:string[3];
        cp:string[8];
        ciudad:string[30];
        num_telefono:string[13];
        email:string[50];
        dia_nacimiento:word;
        mes_nacimiento:word;
        anio_nacimiento:word;
        condicion:boolean;
        codigo_persona:integer;
    end;

	Estancias = record
		codigo_provincia:byte;
		denominacion:string[30];
		pileta:string[30];
		cap_maxima:integer;
	end;    

fichero_per= file of personas;
fichero_est= file of estancias; 

var
	archivo_per:fichero_per;
	archivo_est:fichero_est;
	registro_per:personas;
	registro_est:estancias;
	pileta:string[30];

procedure crear_archivo(var archivo:file; ruta_archivo:string);
procedure menu_ABMC;
procedure menu_configuracion;
procedure listar_estancias(var arch:fichero_est);
procedure cerrar_archivo_est(var arch:fichero_est);
procedure listar_est(var arch:fichero_est);
procedure listar_pil(var arch:fichero_est);
procedure orden_burbuja_I_Apellido (var arch:fichero_per);

implementation // Parte privada de la unit

// Procedimiento para dibujar la Plantilla
procedure plantilla;
begin
	TextColor (7); 
	TextBackground (3); 
	writeln ('--------------------------------------------------------------------------------');//01
	writeln ('- ID/Nombre de la estancia:          est                                             -');//02
	writeln ('--------------------------------------------------------------------------------');//03
	writeln ('- Apellido y nombres del dueño: 		est      per       							 -');//04
	writeln ('- DNI:                             per      						                 -');//05
	writeln ('- Fecha de Nacimiento:                per                                         -');//06
	writeln ('--------------------------------------------------------------------------------');//07
	writeln ('- Domicilio                                                                    -');//08
	writeln ('--------------------------------------------------------------------------------');//09
	writeln ('- Calle:                                                   Numero:             -');//10
	writeln ('- Piso:                                                      Dpto:             -');//11
	writeln ('- Codigo Postal:                                                               -');//12
	writeln ('- Ciudad:                                                                      -');//13
	writeln ('- Provincia:                                                                   -');//14
	writeln ('- Telefono:                                                                    -');//15
	writeln ('- E-mail:                                                                      -');//16
	writeln ('--------------------------------------------------------------------------------');//17
	writeln ('- Cap max:                 est                                                 -');//18
	writeln ('--------------------------------------------------------------------------------');//19
	writeln ('- Pileta:                   est                                                   -');//20
	writeln ('-                                                                              -');//21
	writeln ('--------------------------------------------------------------------------------');//22
end;

// Procedimiento para crear el archivo
procedure crear_archivo(var archivo:file; ruta_archivo:string);
begin
	assign(archivo, ruta_archivo); // assign: es la orden que se encarga de asignar un nombre físico al fichero que acabamos de declarar. Asignamos el tipo y ruta de archivo a Archivo.
	{$I-} 
	reset(archivo); 
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
	close(archivo); 
end;
// Procedimiento para abrir el archivo
procedure abrir_archivo_est (var arch:fichero_est);
begin
	assign(arch, ruta_Est); // assign: es la orden que se encarga de asignar un nombre físico al fichero que acabamos de declarar.
	reset(arch); 
end;
// Procedimiento para cerrar el archivo
procedure cerrar_archivo_est(var arch:fichero_est);
begin
	close(arch); 
end;
// Procedimiento para guardar un registro ingresado
procedure guardar_registro_est(var arch:fichero_est;reg:estancias);
begin
	seek(arch,filesize(arch)); // Se posiciona en la última posición del registro
	write(arch,reg); 
end;
// Procedimiento para abrir el archivo 
procedure abrir_archivo_per(var arch:fichero_per);
begin
	assign(arch, ruta_Per); 
	reset(arch); 
end;
// Procedimiento para cerrar el archivo 
procedure cerrar_archivo_per(var arch:fichero_per);
begin
	close(arch); 
end;
// Procedimiento para guardar el registro 
procedure guardar_registro_per(var arch:fichero_per;reg:personas);
begin
	seek(arch,filesize(arch)); // Se posiciona en la última posición del registro
	write(arch,reg); 
end;
// Procedimiento para leer el registro 
procedure leer_registro_per(var arch:fichero_per; var reg:personas; pos:integer);
begin
	seek(arch,pos); 
	read(arch,reg); 
end;

// Procedimiento para mostrar los registros
procedure mostrar_registro_est(reg:estancias);
begin
	gotoxy (1,3+reg.codigo_provincia);
	writeln ('                                                     ');
	gotoxy (3,3+reg.codigo_provincia);
	writeln(reg.codigo_provincia);
	gotoxy (8,3+reg.codigo_provincia);
	writeln(reg.denominacion);
	gotoxy (42,3+reg.codigo_provincia);
	writeln(reg.pileta);
	gotoxy (60,3+reg.codigo_provincia);
	writeln(reg.cap_maxima);
end;

// Procedimiento para mostrar el registro buscado
procedure mostrar_registro_cargado(var arch:fichero_per; reg:personas; id:string; ubi:integer);
begin
	seek (arch,ubi); // Se posiciona en el registro con posición ubi
	read (arch,reg); 
	if id=reg.id then
		Begin
			TextColor (10);
			with reg do
				begin
					gotoxy(24,2);
					writeln (reg.id);
					gotoxy(8,4);
					writeln (reg.dni);
					gotoxy(23,5) ;
					writeln (reg.apellidoynombre);
					gotoxy(24,6) ;
					writeln (reg.dia_nacimiento);
					gotoxy(27,6) ;
					writeln (reg.mes_nacimiento);
					gotoxy(30,6) ;
					writeln (reg.anio_nacimiento);
					gotoxy(10,10);
					writeln (reg.calle);
					gotoxy(68,10);
					writeln (reg.numero);
					gotoxy(9,11);
					writeln (reg.piso);
					gotoxy(68,11);
					writeln (reg.departamento);
					gotoxy(18,12);
					writeln (reg.cp);
					gotoxy(11,13);
					writeln (reg.ciudad);
					gotoxy(14,14);
					writeln (reg.codigo_provincia);
					gotoxy(13,15);
					writeln (reg.num_telefono);
					gotoxy(11,16);
					writeln (reg.email);
				end;
		end;
end;

// Procedimiento de busqueda binaria
procedure busqueda_binaria (var arch:fichero_per; documento:string; var pos:integer);
var
	reg: personas;
	PRI,ULT,MED:integer;
begin
	PRI:=0;
	ULT:= filesize(arch)-1;
	pos := -1;
	while (pos = -1) and (PRI<= ULT) do
		begin
			MED:= (PRI + ULT) div 2;
			seek(arch,MED); // Se posiciona en el registro con posición MED
			read(arch,reg); 
			if reg.dni = documento then 
				pos:= MED
			else
				if reg.dni > documento then 
				ULT:= MED -1
			else 
				PRI:= MED +1;
		end;
	if pos <> -1 then
		begin
			mostrar_registro_cargado_I(archivo_per,registro_per,documento,pos);
		end;
end;

// Procedimiento para modificar los datos del personas
procedure modificar_alta_baja(var arch:fichero_per;var arch:fichero_est;pos:integer; verdad:boolean);
var
	reg:personas;
begin
	seek(arch,pos); 
	read(arch,reg);
	reg.condicion:=verdad;
	seek(arch,pos); 
	write(arch,reg);
end;

// Procedimiento para cargar las estancias
procedure cargar_registro(var reg:estancias; var reg:personas; var documento:string; var prov:byte;var ubic:integer);
var
	cantidad_estancias:byte;
	validar_fecha:boolean;
	ubicacion:integer;
	encontrado:boolean;
	aux_denominacion:string[30];
begin
	validar_fecha:=false;
	ubic:=-1;
	clrscr; 
	plantilla; // llama al procedimiento para dibujar la plantilla
	TextColor (10); 
	gotoxy(1,26);
	writeln ('Ingrese el DNI del dueño de la estancia:                                                              ');
	gotoxy(8,4); 
	readln (documento);
	busqueda_binaria(archivo_per,documento,ubic);    
	listar_est (archivo_est); // llama al procedimiento listar y muestra las estancias ya ingresadas
	listar_pil (archivo_est);
	with reg do
    	if ubic=-1 then
		begin
			with reg do
				begin
                    codigo_provincia:= filesize(archivo_est)+1; 
					id:= filesize(archivo_per)+1;
					gotoxy(24,2);
					writeln (id);
                    dni:=documento;
                    writeln ('Ingrese ID/nombre de la Estancia                   ');
			        gotoxy(8,3+codigo_provincia);
			        readln(denominacion);
                    gotoxy(1,24) ;
					writeln ('Ingrese el Apellido y Nombre del dueño:                                                    ');
					gotoxy(23,5) ;
					readln(apellidoynombre);    
                    repeat
						gotoxy(1,24) ;
						writeln ('Ingrese el día de la Fecha de Nacimiento                                        ');
						readln(dia_nacimiento);
						gotoxy(1,25);
						writeln ('                                                                                ');
						gotoxy(1,24) ;
						writeln ('Ingrese el mes de la Fecha de Nacimiento                                        ');
						readln(mes_nacimiento);
						gotoxy(1,25);
						writeln ('                                                                                ');
						gotoxy(1,24) ;
						writeln ('Ingrese el anio de la Fecha de Nacimiento                                       ');
						readln(anio_nacimiento);
						gotoxy(1,25);
						writeln ('                                                                                ');
						fecha_correcta (dia_nacimiento,mes_nacimiento,anio_nacimiento,validar_fecha);
						if validar_fecha=true then
							comparar_fecha (dia_nacimiento,mes_nacimiento,anio_nacimiento,validar_fecha);
						if validar_fecha=false then
							begin
								gotoxy(1,24) ;
								writeln('la fecha ingresada es incorrecta                                                 ');
								readkey;
							end;
					until validar_fecha=true;
					gotoxy(24,6);
					writeln (dia_nacimiento,'/',mes_nacimiento,'/',anio_nacimiento);
					gotoxy(1,24) ;
					writeln ('Ingrese la calle                                                                ');
					gotoxy(10,10);
					readln(calle);
					gotoxy(1,24) ;
					writeln ('Ingrese el numero del domicilio                                                 ');
					gotoxy(68,10);
					readln(numero);
					gotoxy(1,24) ;
					writeln ('Ingrese el piso                                                                 ');
					gotoxy(9,11);
					readln(piso);
					gotoxy(1,24) ;
					writeln ('Ingrese el departamento o nº de casa                                            ');
					gotoxy(68,11);
					readln(departamento);
					gotoxy(1,24) ;
					writeln ('Ingrese el código postal                                                        ');
					gotoxy(18,12);
					readln(cp);
					gotoxy(1,24) ;
					writeln ('Ingrese la ciudad                                                               ');
					gotoxy(11,13);
					readln(ciudad);
					gotoxy(1,24) ;
					writeln ('Ingrese la provincia sugun las opciones: 1 al 23                                ');
					writeln ('');
                    assign(archivo_est, ruta_Est); 
					reset(archivo_est); 
					listar_estancias(archivo_est);
					cantidad_estancias:=(filesize(archivo_est));
					gotoxy(14,14);
					readln(codigo_provincia);
					prov:=codigo_provincia;
                    gotoxy (18,14);
					writeln (aux_denominacion);
					cerrar_archivo_est (archivo_est);
					gotoxy(1,24) ;
					writeln ('Ingrese el numero de telefono                                                   ');
					writeln ('                                                                                                                       ');
					writeln ('                                                                                                                       ');
					writeln ('                                                                                                                       ');
					writeln ('                                                                                                                       ');
					writeln ('                                                                                                                       ');
					gotoxy(13,15);
					readln(num_telefono);
					gotoxy(1,24) ;
					writeln ('Ingrese el correo electrónico                                                   ');
					gotoxy(11,16);
					readln(email);
					condicion:=true;
                    writeln ('Ingrese si tiene pileta                         ');
                    gotoxy(42,3+codigo_provincia);
                    readln(pileta);
                    gotoxy(1,40);
                    writeln ('Ingrese la capacidad maxima                     ');
                    gotoxy(45,3+codigo_provincia);
                    readln(cap_maxima);                                                            
				end;
		end;
end;

// Procedimiento para modificar registros
procedure modificar_registro(var reg:estancias; var reg:personas; var documento:string; var prov:byte;var ubic:integer););
var
	cantidad_estancias:byte;
	validar_fecha:boolean;
	ubicacion:integer;
	encontrado:boolean;
	aux_denominacion:string[30];

begin
	validar_fecha:=false;
	clrscr;
	plantilla;
	TextColor (10);
	gotoxy(1,24); 
	writeln ('Para modificar:			                                                                 ');
	writeln ('Ingrese el DNI del dueño de la estancia                                                                  ');
	gotoxy(8,4); 
	readln (documento);                    
	with reg do
		begin
            codigo_provincia:= ubic+1; 
            id:= ubic+1;
			gotoxy(24,2);
			writeln (id);
			dni:=documento;
            writeln ('Ingrese ID/nombre de la Estancia                   ');
            gotoxy(8,3+codigo_provincia);
            readln(denominacion);
            gotoxy(1,24) ;
            writeln ('Ingrese el Apellido y Nombre del dueño:                                                    ');
            gotoxy(23,5) ;
            readln(apellidoynombre);    
			gotoxy(1,24) ;
			repeat
				gotoxy(1,24) ;
				writeln ('Ingrese el día de la Fecha de Nacimiento                                        ');
				readln(dia_nacimiento);
				gotoxy(1,25);
				writeln ('                                                                                ');
				gotoxy(1,24) ;
				writeln ('Ingrese el mes de la Fecha de Nacimiento                                        ');
				readln(mes_nacimiento);
				gotoxy(1,25);
				writeln ('                                                                                ');
				gotoxy(1,24) ;
				writeln ('Ingrese el anio de la Fecha de Nacimiento                                       ');
				readln(anio_nacimiento);
				gotoxy(1,25);
				writeln ('                                                                                ');
				fecha_correcta (dia_nacimiento,mes_nacimiento,anio_nacimiento,validar_fecha);
				if validar_fecha=true then
					comparar_fecha (dia_nacimiento,mes_nacimiento,anio_nacimiento,validar_fecha);
				if validar_fecha=false then
					begin
						gotoxy(1,24) ;
						writeln('la fecha ingresada es incorrecta                                                 ');
						readkey;
					end;
			until validar_fecha=true;
			gotoxy(24,6);
			writeln (dia_nacimiento,'/',mes_nacimiento,'/',anio_nacimiento);
			gotoxy(1,24) ;
			writeln ('Ingrese la calle                                                                ');
			gotoxy(10,10);
			readln(calle);
			gotoxy(1,24) ;
			writeln ('Ingrese la numeracion del domicilio                                             ');
			gotoxy(68,10);
			readln(numero);
			gotoxy(1,24) ;
			writeln ('Ingrese el piso                                                                 ');
			gotoxy(9,11);
			readln(piso);
			gotoxy(1,24) ;
			writeln ('Ingrese el departamento o nº de casa                                            ');
			gotoxy(68,11);
			readln(departamento);
			gotoxy(1,24) ;
			writeln ('Ingrese el código postal                                                        ');
			gotoxy(18,12);
			readln(cp);
			gotoxy(1,24) ;
			writeln ('Ingrese la ciudad                                                               ');
			gotoxy(11,13);
			readln(ciudad);
            writeln ('Ingrese la provincia sugun las opciones: 1 al 23                                ');
            writeln ('');
            assign(archivo_est, ruta_Est); 
            reset(archivo_est); 
            listar_estancias(archivo_est);
            cantidad_estancias:=(filesize(archivo_est));
            gotoxy(14,14);
            readln(codigo_provincia);
            prov:=codigo_provincia;
			gotoxy (18,14);
			writeln (aux_denominacion);
			cerrar_archivo_est (archivo_est);
			gotoxy(1,24) ;
			writeln ('Ingrese el numero de telefono                                                   ');
			writeln ('                                                                                                                       ');
			writeln ('                                                                                                                       ');
			writeln ('                                                                                                                       ');
			writeln ('                                                                                                                       ');
			writeln ('                                                                                                                       ');
			gotoxy(13,15);
			readln(num_telefono);
			gotoxy(1,24) ;
			writeln ('Ingrese el correo electrónico                                                   ');
			gotoxy(11,16);
			readln(email);
			condicion:=true;
		end;
	seek(archivo_per,ubic); 
	write(archivo_per,reg);
end;

// Procedimiento del Menú ABMC
procedure menu_ABMC;
var
	opcion,ingresar:char;
	aux_dni:string[8];
	aux_condicion:boolean;
	aux_provincia:byte;
	ubicacion:integer;

begin
	repeat
		abrir_archivo_per (archivo_per); 
		abrir_archivo_est (archivo_est); 
		cerrar_archivo_per (archivo_per); 
		cerrar_archivo_est (archivo_est); 

		TextColor(7); 
		TextBackground(3); 

		aux_dni:='';
		aux_provincia:=0;
		aux_condicion:=false;
		ingresar:='s';
		ubicacion:=-1;
		clrscr; 
		writeln ('------------------------------------------');
		writeln ('-                 MENU                   -');
		writeln ('------------------------------------------');
		writeln ('- Elija una opción                       -');
		writeln ('------------------------------------------');
		writeln ('- 1 - Dar de alta                        -');
		writeln ('- 2 - Dar de baja                        -');
		writeln ('- 3 - Modificar                          -');
		writeln ('- 4 - Consulta                           -');
		writeln ('------------------------------------------');
		writeln ('- 5 - Volver al Menu Principal           -');
		writeln ('------------------------------------------');
		opcion:= readkey; 

		Case opcion of
			'1': begin // Alta de dueño
					repeat
						abrir_archivo_per (archivo_per);
                        abrir_archivo_est (archivo_est); 
						cargar_registro (registro_per, registro_est,aux_dni,aux_provincia,ubicacion); // Carga los datos de un registro
						if ubicacion<>-1 then // si ya existe muestra los datos
							begin
								mostrar_registro_cargado (archivo_per,registro_per,aux_dni,ubicacion); // Procedimiento Para mostrar los datos
                                mostrar_registro_est(reg:estancias);
								gotoxy(1,24) ;
								writeln ('Ese DNI ya está cargado, pulse para continuar              ');
								readkey;
								ingresar:='N';
							end;
						if ubicacion=-1 then // Si no existe sigue cargando los otros datos
							begin
								guardar_registro_per (archivo_per,registro_per); // Guarda el registro
                                guardar_registro_est(archivo_est,registro_est);
							end;
						cerrar_archivo_per (archivo_per);
                        cerrar_archivo_est (archivo_est); 
					until ingresar <> 'S'; // Sale si es distinto de S
				end;
			'2': begin // Baja de persona
					clrscr; 
					abrir_archivo_per (archivo_per);
                    abrir_archivo_est (archivo_est); 
					Plantilla; // Procedimiento que dibuja la plantilla
					gotoxy(1,24);
					writeln ('Para dar de baja ingrese el DNI: ');
					gotoxy(8,4); 
					readln (aux_dni);
					busqueda_binaria (archivo_per,aux_dni,ubicacion); // Procedimiento de busqueda binaria
					if ubicacion = -1 then
						begin
							gotoxy(1,24); 
							writeln ('No se encuentra ninguna persona con ese DNI');
						end;
					if ubicacion <> -1 then
						begin
							gotoxy(1,24);
							writeln ('Dara de Baja a esta persona (S/N)');
							ingresar:= readkey; 
							ingresar:=upcase(ingresar); // Pasa a mayúscula
							if Ingresar='S' then
								begin
									aux_condicion:=false;
									modificar_alta_baja (archivo_per, archivo_est, ubicacion,aux_condicion); // Cambia la condición true a false
								end;
						end;
					cerrar_archivo_per (archivo_per);
                    cerrar_archivo_est (archivo_est);  
				end;
			'3': begin // Modificación de visitante
					clrscr; 
					abrir_archivo_per (archivo_per);
                    abrir_archivo_est (archivo_est); 
					Plantilla; 
					gotoxy(1,24);
					writeln ('Para la modificacion, ingrese el DNI: ');
					gotoxy(8,4); 
					readln (aux_dni);
					busqueda_binaria (archivo_per,aux_dni,ubicacion); // Procedimiento de busqueda binaria
					if ubicacion = -1 then
						begin
							gotoxy(1,24); 
							writeln ('No se encuentra ninguna persona con ese DNI');
						end;
					if ubicacion <> -1 then
						begin
							gotoxy(1,24);
							writeln ('quiere modificar a esta persona (S/N)');
							ingresar:= readkey; 
							ingresar:=upcase(ingresar); // Pasa a mayúscula
							if Ingresar='S' then
								begin
									modificar_registro (registro_per, registro_est,aux_dni,aux_provincia,ubicacion); // Muestra los datos a modificar
								end;
						end;
					cerrar_archivo_per (archivo_per);
                    cerrar_archivo_est (archivo_est); 
				end;
			'4': begin // Buscar un visitante 
					clrscr; 
					abrir_archivo_per (archivo_per);
                    abrir_archivo_est (archivo_est);  
					plantilla; 
					gotoxy(1,24);
					writeln ('Para buscar ingrese el DNI ');
					gotoxy(8,4); 
					readln (aux_dni);
					busqueda_binaria (archivo_per,aux_dni,ubicacion); // Procedimiento de busqueda binaria
					gotoxy(1,24);
					writeln ('                                               ');
					if ubicacion = -1 then
						begin
							gotoxy(1,24); 
							writeln ('No se encuentra ninguna persona con ese DNI');
						end;
					gotoxy(1,27); 
					writeln ('Presione un tecla para volver al menu.');
					cerrar_archivo_per (archivo_per);
                    cerrar_archivo_per (archivo_est); 
					readkey;
				end;
			'5': begin // Salir del Menu, vuelve al menu principal
				end;
			else
				begin
					clrscr; 
					writeln ('Ingreso una opcion incorrecta, pulse una tecla para continuar');
					readkey;
				end;
			end;
	until (opcion= '5');
end;

begin
end.
