unit ABMC;

interface 

uses 
	crt,Provincia,Fecha;

const
	ruta_Per='personasprueba.dat'; 
	ruta_P='provinciasprueba.dat';
    
type
	estancia = record
		id:integer;
		apellidoynombre:string[30]; 
		dni:string[8];
		calle:string[20];
		numero:string[8];
		piso:string[3];
		departamento:string[3];
		cp:integer;
		ciudad:string[30]; 
		codigo_provincia:byte;
		cantidad_provincia:byte;
		num_telefono:string[13]; 
		email:string[50]; 
		dia_nacimiento:word;
		mes_nacimiento:word;
		anio_nacimiento:word; 
		condicion:boolean;
		denominacion:string[30];
		pileta:integer;
		cap_maxima:string[4];
	end;

fichero_per= file of estancia;
fichero_P= file of provincias; 

var
archivo_per:fichero_per;
archivo_P:fichero_P;
registro_per:estancia;
registro_P:provincias;

procedure plantilla;
procedure plantilla_estancia;

procedure crear_archivo			(var archivo:file; ruta_archivo:string);
procedure abrir_archivo_per		(var arch:fichero_per);
procedure cerrar_archivo_per	(var arch:fichero_per);

procedure guardar_registro_per	(var arch:fichero_per; reg:estancia);
procedure leer_registro_per		(var arch:fichero_per; var reg:estancia; pos:integer);
procedure mostrar_registro_per	(var arch:fichero_per; reg:estancia; documento:string; ubi:integer);

procedure busqueda_binaria 		(var arch:fichero_per; documento:string; var pos:integer);

procedure mostrar_registro_por_estancia	(reg:estancia);
procedure mostrar_registro_por_pileta	(reg:estancia);

procedure listar_est			(var arch:fichero_per);
procedure listar_por_estancia	(var arch:fichero_per);
procedure listar_estancia_pile	(var arch:fichero_per);
procedure orden_burbuja_per 	(var arch:fichero_per);

procedure modificar_alta_baja	(var arch:fichero_per; pos: integer; verdad: boolean);
procedure buscar_modificar		(var arch:fichero_per; documento:string; var encon:boolean);
procedure cargar_registro_per	(var reg:estancia; var documento:string; var prov:byte;var ubic:integer);
procedure modificar_registro_per(var reg:estancia; var documento:string; var prov:byte; ubic:integer);
procedure menu_ABMC;

implementation // Parte privada de la unit

// Procedimiento para dibujar la Plantilla
procedure plantilla;
begin
	TextColor (7); 
	TextBackground (0); 
	writeln ('--------------------------------------------------------------------------------');//01
	writeln ('- DNI:________                           						                  ');//05
	writeln ('--------------------------------------------------------------------------------');//03
	writeln ('- Nombre de la estancia:                                                        ');//02
	writeln ('- Apellido y nombres del dueno: 		             							  ');//04
	writeln ('- Fecha de Nacimiento:                                                          ');//06
	writeln ('--------------------------------------------------------------------------------');//07
	writeln ('- Domicilio                                                                     ');//08
	writeln ('--------------------------------------------------------------------------------');//09
	writeln ('- Calle:                                                   Numero:              ');//10
	writeln ('- Piso:                                                      Dpto:              ');//11
	writeln ('- Codigo Postal:                                                                ');//12
	writeln ('- Ciudad:                                                                       ');//13
	writeln ('- Provincia:                                                                    ');//14
	writeln ('- Telefono:                                                                     ');//15
	writeln ('- E-mail:                                                                       ');//16
	writeln ('- Pileta:                                                                       ');//16
	writeln ('- Cap max:                                                                      ');//16
	writeln ('--------------------------------------------------------------------------------');//17
	writeln ('- Datos extra:                                                                  ');//18
	writeln ('--------------------------------------------------------------------------------');//19
	writeln ('- Estado:                                                                       ');//20
	writeln ('-                                                                               ');//21
	writeln ('--------------------------------------------------------------------------------');//22
end;

// Procedimiento que crea la plantilla a mostrar
procedure plantilla_estancia;
begin
	TextColor (7);
	TextBackground (0);
	writeln ('-N  	     -provincias          - Pileta            Cap max      ');
	writeln ('                                                             ');
end;

// Procedimiento para crear el archivo
procedure crear_archivo(var archivo:file; ruta_archivo:string);
begin
	assign(archivo, ruta_archivo);  //Asignamos el tipo y ruta de archivo a Archivo.
	reset(archivo); 
	if ioresult <> 0 then // Si IOResult es distinto de 0, significa que el archivo no existe.
		begin
			writeln(ruta_archivo,'. No existe. Se creará el archivo.'); // Si el archivo no existe lo creamos y abrimos con rewrite.
			rewrite(archivo);
		end
	else
	begin
		writeln('Cargando: ', ruta_archivo);
	end;
	close(archivo); 
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
procedure guardar_registro_per(var arch:fichero_per;reg:estancia);
begin
	seek(arch,filesize(arch)); // Se posiciona en la última posición del registro
	write(arch,reg); 
end;

// Procedimiento para leer el registro 
procedure leer_registro_per(var arch:fichero_per; var reg:estancia; pos:integer);
begin
	seek(arch,pos); 
	read(arch,reg); 
end;

// Procedimiento para mostrar el registro buscado
procedure mostrar_registro_per(var arch:fichero_per; reg:estancia; documento:string; ubi:integer);
begin
	seek (arch,ubi); // Se posiciona en el registro con posición ubi
	read (arch,reg); 
	if documento=reg.dni then
		Begin
			TextColor (10);
			with reg do
				begin
					gotoxy(24,2);
					writeln (reg.id);
					gotoxy(7,2);
					writeln (reg.dni);
					gotoxy(25,4);
					writeln(reg.denominacion);
					gotoxy(32,5) ;
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
					gotoxy(11,16);
					writeln (reg.pileta);
					gotoxy(11,16);
					writeln (reg.cap_maxima);
				end;
		end;
end;

// Procedimiento de busqueda binaria
procedure busqueda_binaria (var arch:fichero_per; documento:string; var pos:integer);
var
	reg: estancia;
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
					mostrar_registro_per(archivo_per,registro_per,documento,pos);
				end;
end;

// Procedimiento para mostrar los personas
procedure mostrar_registro_per(reg:estancia);
begin
	writeln ('codigo prov ',reg.codigo_provincia,', de ',reg.apellidoynombre,', Estancia: ',reg.denominacion);
end;

// Procedimiento para mostrar los personas
procedure mostrar_registro_por_estancia(reg:estancia);
begin
	writeln (reg.denominacion, ': dueno de estancia ',reg.apellidoynombre, ' y su dni es: ', reg.dni);
end;

// Procedimiento para mostrar los personas
procedure mostrar_registro_por_pileta(reg:estancia);
begin
	writeln (reg.codigo_provincia, ' N° prov', ', Estancia: ',reg.denominacion, reg.dni,', ',reg.apellidoynombre);
end;

// Procedimiento para listar las provincias
procedure listar_est(var arch:fichero_per);
var
	reg:estancia;
begin
	clrscr;
	plantilla_estancia; // Procedimiento para dibujar la plantilla
	reset(arch);
	while not (eof(arch)) do
		begin
			read (arch,reg);
			mostrar_registro_per(reg); // Procedimiento para para mostrar cada registro
		end;
end;

// Procedimiento para listar las provincias
procedure listar_por_estancia(var arch:fichero_per);
var
	reg:estancia;
begin
	clrscr;
	plantilla_estancia; // Procedimiento para dibujar la plantilla
	reset(arch);
	while not (eof(arch)) do
		begin
			read (arch,reg);
			mostrar_registro_por_estancia(reg); // Procedimiento para para mostrar cada registro
		end;
end;

// Procedimiento para listar las provincias
procedure listar_estancia_pile(var arch:fichero_per);
var
	reg:estancia;
begin
	clrscr;
	plantilla_estancia; // Procedimiento para dibujar la plantilla
	reset(arch);
	while not (eof(arch)) do
		begin
			read (arch,reg);
			if reg.pileta=1 then
				mostrar_registro_por_pileta (reg);
		end;
end;

// Procedimiento para ordenar las provincias en forma alfabética
procedure orden_burbuja_per (var arch:fichero_per);
var 
	reg1,reg2:estancia;
	lim,i,j:integer;
begin

	lim:= filesize(arch)-1;
	for i:= 1 to lim - 1 do
		for j:= 0 to lim - i do
			begin
				seek(arch,J); // Se posiciona en el registro con posición J
				read(arch,reg1); 
				seek(arch,j+1); // Se posiciona en el registro con posición J+1
				read(arch,reg2); 
				if reg1.denominacion > reg2.denominacion then
					begin
						seek(arch,j+1);  // Se posiciona en el registro con posición J+1
						write(arch,reg1); 
						seek(arch,j);  // Se posiciona en el registro con posición J
						write(arch,reg2); 
					end;
			end;
end;

// Procedimiento para modificar los datos del personas
procedure modificar_alta_baja(var arch: fichero_per; pos: integer; verdad: boolean);
var
  reg: estancia;
  i:integer;
begin
	for i:= 0 to filesize(arch)-1 do
		begin
			seek (arch, pos); // Se posiciona en el registro con posición pos
			read (arch, reg);
			reg.condicion := verdad;
			seek (arch, pos);
			write (arch, reg);
		end;
end;

// Procedimiento para buscar persona para modificar
procedure buscar_modificar(var arch:fichero_per; documento:string; var encon:boolean);
var
	reg:estancia; 
	i: integer;
begin
	for i:=0 to filesize(arch)-1 do
		begin
			leer_registro_per (arch,reg,i);
			if documento=reg.dni then
				begin
					encon:=true;
					mostrar_registro_per(arch,reg, documento,i);
				end;
		end;
end;

// Procedimiento para cargar registros
procedure cargar_registro_per(var reg:estancia; var documento:string; var prov:byte;var ubic:integer);
var
	cantidad_provincias:byte;
	validar_fecha:boolean;
	ubicacion:integer;
	encontrado:boolean;
	aux_denominacion:string[30];
begin
	validar_fecha:=false;
	ubic:=-1;
	clrscr;
	plantilla;
	TextColor (10);
	gotoxy(1,26); 
	writeln ('Ingrese el DNI del duenio de la estancia:			 ');
	gotoxy(7,2); 
	readln (documento);
	busqueda_binaria(archivo_per,documento,ubic);
	if ubic=-1 then
		begin
			with reg do
				begin 
					id:= filesize(archivo_per)+1;
					gotoxy(2,60);
					writeln (id);
					dni:=documento;
					gotoxy(1,26) ;
					writeln ('Ingrese Nombre de la Estancia        										           ');
					gotoxy(25,4);
					readln(reg.denominacion);
					gotoxy(1,26) ;
					writeln ('Ingrese el Apellido y Nombre del dueno:       	');
					gotoxy(35,5) ;
					readln(apellidoynombre);
					repeat
						gotoxy(1,26) ;
						writeln ('Ingrese el dia de la Fecha de Nacimiento                                        ');
						readln(dia_nacimiento);
						gotoxy(1,27);
						writeln ('                                                                                ');
						gotoxy(1,26) ;
						writeln ('Ingrese el mes de la Fecha de Nacimiento                                        ');
						readln(mes_nacimiento);
						gotoxy(1,27);
						writeln ('                                                                                ');
						gotoxy(1,26) ;
						writeln ('Ingrese el anio de la Fecha de Nacimiento                                       ');
						readln(anio_nacimiento);
						gotoxy(1,27);
						writeln ('                                                                                ');
						fecha_correcta (dia_nacimiento,mes_nacimiento,anio_nacimiento,validar_fecha);
						if validar_fecha=true then
							comparar_fecha (dia_nacimiento,mes_nacimiento,anio_nacimiento,validar_fecha);
						if validar_fecha=false then
							begin
								gotoxy(1,26) ;
								writeln('la fecha ingresada es incorrecta                                                 ');
								readkey;
							end;
					until validar_fecha=true;
					gotoxy(24,6);
					writeln (dia_nacimiento,'/',mes_nacimiento,'/',anio_nacimiento);
					gotoxy(1,26) ;
					writeln ('Ingrese la calle                                                                ');
					gotoxy(10,10);
					readln(calle);
					gotoxy(1,26) ;
					writeln ('Ingrese el numero del domicilio                                                 ');
					gotoxy(68,10);
					readln(numero);
					gotoxy(1,26) ;
					writeln ('Ingrese el piso                                                                 ');
					gotoxy(9,11);
					readln(piso);
					gotoxy(1,26) ;
					writeln ('Ingrese el departamento o num de casa                                           ');
					gotoxy(68,11);
					readln(departamento);
					gotoxy(1,26) ;
					writeln ('Ingrese el codigo postal                                                        ');
					gotoxy(18,12);
					readln(cp);
					gotoxy(1,26) ;
					writeln ('Ingrese la ciudad                                                               ');
					gotoxy(11,13);
					readln(ciudad);
					gotoxy(1,26) ;
					repeat
						gotoxy(1,26) ;
						writeln ('Ingrese la provincia sugun las opciones: 1 - 2 - 3...                           ');
						writeln ('');
						assign(archivo_P, ruta_P); // assign: es la orden que se encarga de asignar un nombre físico al fichero que acabamos de declarar.
						reset(archivo_P); // reset: abre un fichero para lectura.
						listar_provincias(archivo_P);
						cantidad_provincias:=(filesize(archivo_P));
						gotoxy(14,14);
						readln(codigo_provincia);
						prov:=codigo_provincia;
					until (codigo_provincia >0) and (codigo_provincia <= cantidad_provincias);
					buscar_registro_P (archivo_P,registro_P,codigo_provincia,encontrado,ubicacion);
					mostrar_en_carga (archivo_P,registro_P,codigo_provincia,ubicacion,aux_denominacion);
					gotoxy (18,14);
					writeln (aux_denominacion);
					cerrar_archivo_P (archivo_P);
					gotoxy(1,26) ;
					writeln ('Ingrese el numero de telefono                                                   ');
					gotoxy(13,15);
					readln(num_telefono);
					gotoxy(1,26) ;
					writeln ('Ingrese el correo electrónico                                                   ');
					gotoxy(11,16);
					readln(email);
					gotoxy(1,26) ;
					writeln ('Ingrese si tiene pileta  1-si 0-no                       ');
					gotoxy(11,17);
					//gotoxy(42,3+codigo_provincia);
					readln(pileta);
					gotoxy(1,26);
					writeln ('Ingrese la capacidad maxima                     ');
					gotoxy(11,18);
					//gotoxy(45,3+codigo_provincia);
					readln(cap_maxima);
					condicion:=true;
				end;
		end;
end;

// Procedimiento para modificar registros
procedure modificar_registro_per(var reg:estancia; var documento:string; var prov:byte; ubic:integer);
var
	cantidad_provincias:byte;
	validar_fecha:boolean;
	ubicacion:integer;
	encontrado:boolean;
	aux_denominacion:string[30];
begin
	validar_fecha:=false;
	clrscr;
	plantilla;
	TextColor (10);
	gotoxy(1,26); 
	writeln ('Para modificar:			                                                                 ');
	writeln ('Ingrese el DNI del dueño de la estancia                                                    ');
	gotoxy(7,2); 
	readln (documento);
	with reg do
		begin 
			id:= ubic+1;
			gotoxy(24,2);
			writeln (id);
			dni:=documento;
			gotoxy(1,26) ;
			writeln ('Ingrese el Apellido y Nombre del dueño                                              ');
			gotoxy(23,5) ;
			readln(apellidoynombre);
			gotoxy(1,26) ;
			repeat
				gotoxy(1,26) ;
				writeln ('Ingrese el dia de la Fecha de Nacimiento                                        ');
				readln(dia_nacimiento);
				gotoxy(1,25);
				writeln ('                                                                                ');
				gotoxy(1,26) ;
				writeln ('Ingrese el mes de la Fecha de Nacimiento                                        ');
				readln(mes_nacimiento);
				gotoxy(1,25);
				writeln ('                                                                                ');
				gotoxy(1,26) ;
				writeln ('Ingrese el anio de la Fecha de Nacimiento                                       ');
				readln(anio_nacimiento);
				gotoxy(1,25);
				writeln ('                                                                                ');
				fecha_correcta (dia_nacimiento,mes_nacimiento,anio_nacimiento,validar_fecha);
				if validar_fecha=true then
					comparar_fecha (dia_nacimiento,mes_nacimiento,anio_nacimiento,validar_fecha);
				if validar_fecha=false then
					begin
						gotoxy(1,26) ;
						writeln('la fecha ingresada es incorrecta                                                 ');
						readkey;
					end;
			until validar_fecha=true;
			gotoxy(24,6);
			writeln (dia_nacimiento,'/',mes_nacimiento,'/',anio_nacimiento);
			gotoxy(1,26) ;
			writeln ('Ingrese la calle                                                                ');
			gotoxy(10,10);
			readln(calle);
			gotoxy(1,26) ;
			writeln ('Ingrese la numeracion del domicilio                                             ');
			gotoxy(68,10);
			readln(numero);
			gotoxy(1,26) ;
			writeln ('Ingrese el piso                                                                 ');
			gotoxy(9,11);
			readln(piso);
			gotoxy(1,26) ;
			writeln ('Ingrese el departamento o num de casa                                            ');
			gotoxy(68,11);
			readln(departamento);
			gotoxy(1,26) ;
			writeln ('Ingrese el codigo postal                                                        ');
			gotoxy(18,12);
			readln(cp);
			gotoxy(1,26) ;
			writeln ('Ingrese la ciudad                                                               ');
			gotoxy(11,13);
			readln(ciudad);
			repeat
						gotoxy(1,26) ;
						writeln ('Ingrese la provincia sugun las opciones: 1 - 2 - 3...                           ');
						writeln ('');
						assign(archivo_P, ruta_P); // assign: es la orden que se encarga de asignar un nombre físico al fichero que acabamos de declarar.
						reset(archivo_P); // reset: abre un fichero para lectura.
						listar_provincias(archivo_P);
						cantidad_provincias:=(filesize(archivo_P));
						gotoxy(14,14);
						readln(codigo_provincia);
						prov:=codigo_provincia;
					until (codigo_provincia >0) and (codigo_provincia <= cantidad_provincias);
					buscar_registro_P (archivo_P,registro_P,codigo_provincia,encontrado,ubicacion);
					mostrar_en_carga (archivo_P,registro_P,codigo_provincia,ubicacion,aux_denominacion);
			gotoxy (18,14);
			writeln (aux_denominacion);
			cerrar_archivo_P (archivo_P);
			gotoxy(1,26) ;
			writeln ('Ingrese el numero de telefono                                                   ');
			writeln ('                                                                                                                       ');
			writeln ('                                                                                                                       ');
			writeln ('                                                                                                                       ');
			writeln ('                                                                                                                       ');
			writeln ('                                                                                                                       ');
			gotoxy(13,15);
			readln(num_telefono);
			gotoxy(1,26) ;
			writeln ('Ingrese el correo electrónico                                                   ');
			gotoxy(11,16);
			readln(email);
			condicion:=true;
			writeln ('Ingrese si tiene pileta                         ');
			gotoxy(42,3+codigo_provincia);
			readln(pileta);
			gotoxy(1,40);
			writeln ('Ingrese la capacidad maxima                     ');
			gotoxy(12,17);
			gotoxy(45,3+codigo_provincia);
			readln(cap_maxima);
		end;
	seek(archivo_per,ubic); 
	write(archivo_per,reg);
end;

// Procedimiento del Menú ABMC
procedure menu_ABMC;
var
	opcion,ingresar:char;
	aux_dni:string[8];
	aux_provincia:byte;
	ubicacion:integer;
	aux_condicion,encontrado:boolean;
	aux_denominacion:string;
	codigo_provincia:byte;
begin
	repeat
		abrir_archivo_per (archivo_per); 
		orden_burbuja_per (archivo_per); // ordenda los registros por abecedario
		cerrar_archivo_per (archivo_per); 

		TextColor(7); 
		TextBackground(0); 

		aux_dni:='';
		aux_provincia:=0;
		aux_condicion:=false;
		ingresar:='s';
		ubicacion:=-1;

		clrscr; 
		writeln ('------------------------------------------');
		writeln ('                  MENU                    ');
		writeln ('------------------------------------------');
		writeln ('  Elija una opcion                        ');
		writeln ('------------------------------------------');
		writeln ('  1 - Dar de alta a una estancia          ');
		writeln ('  2 - Dar de baja a una estancia          ');
		writeln ('  3 - Modificar                           ');
		writeln ('  4 - Consulta - buscar duenio	        ');
		writeln ('  5 - Lista estancia alfabetico  		    ');
		writeln ('  6 - Lista por provincia			        ');
		writeln ('  7 - provincias con piscinas		        ');
		writeln ('  8 - Alta un dado de Baja                ');
		writeln ('------------------------------------------');
		writeln ('  9 - Volver al Menu Principal            ');
		writeln ('------------------------------------------');
		opcion:= readkey; 

		Case opcion of
			'1': begin // Alta de dueño
					repeat
						clrscr;
						abrir_archivo_per (archivo_per); 
						cargar_registro_per (registro_per,aux_dni,aux_provincia,ubicacion); // Carga los datos de un registro
						if ubicacion<>-1 then // si ya existe muestra los datos
							begin
								mostrar_registro_per (archivo_per,registro_per,aux_dni,ubicacion); // Procedimiento Para mostrar los datos

								gotoxy(1,26) ;
								writeln ('Ese DNI ya esta cargado, pulse para continuar              ');
								readkey;
								ingresar:='N';
							end;
						if ubicacion=-1 then // Si no existe sigue cargando los otros datos
							begin
								guardar_registro_per (archivo_per,registro_per); // Guarda el registro
							end;
						cerrar_archivo_per (archivo_per); 
					until ingresar <> 'S'; // Sale si es distinto de S
				end;
			'2': begin // Baja de persona
					clrscr; 
					abrir_archivo_per (archivo_per); 
					Plantilla; // Procedimiento que dibuja la plantilla
					gotoxy(1,26);
					writeln ('Para dar de baja a un duenio de estancia ingrese el DNI: ');
					gotoxy(7,2); 
					readln (aux_dni);
					busqueda_binaria (archivo_per,aux_dni,ubicacion); // Procedimiento de busqueda binaria
					if ubicacion = -1 then
						begin
							gotoxy(1,26); 
							writeln ('No se encuentra ninguna persona con ese DNI');
						end;
					if ubicacion <> -1 then
						begin
							gotoxy(1,26);
							writeln ('Dara de Baja a esta persona (S/N)');
							ingresar:= readkey; // Toma la opción con solo teclear 
							ingresar:=upcase(ingresar); // Pasa a mayúscula
							if ingresar = 'S' then
								begin
									aux_condicion:=false;
									modificar_alta_baja (archivo_per,ubicacion,aux_condicion); // Cambia la condición true a false
								end;
						end;
					cerrar_archivo_per (archivo_per); 
				end;
			'3': begin // Modificación de duenio de estancia
					clrscr; 
					abrir_archivo_per (archivo_per); 
					Plantilla; 
					gotoxy(1,26);
					writeln ('Para la modificacion del dueno, ingrese el DNI: ');
					gotoxy(7,2); 
					readln (aux_dni);
					busqueda_binaria (archivo_per,aux_dni,ubicacion); // Procedimiento de busqueda binaria
					if ubicacion = -1 then
						begin
							gotoxy(1,26); 
							writeln ('No se encuentra ninguna persona con ese DNI');
						end;
					if ubicacion <> -1 then
						begin
							gotoxy(1,26);
							writeln ('quiere modificar a esta persona (S/N)');
							ingresar:= readkey; 
							ingresar:=upcase(ingresar); // Pasa a mayúscula
							if Ingresar='S' then
								begin
									modificar_registro_per (registro_per,aux_dni,aux_provincia,ubicacion); // Muestra los datos a modificar
								end;
						end;
					cerrar_archivo_per (archivo_per); 
				end;
			'4': begin // Buscar un duenio de estancia 
					clrscr; 
					abrir_archivo_per (archivo_per); 
					plantilla; 
					gotoxy(1,26);
					writeln ('Para buscar un dueno ingrese el DNI ');
					gotoxy(7,2); 
					readln (aux_dni);
					busqueda_binaria (archivo_per,aux_dni,ubicacion); // Procedimiento de busqueda binaria
					gotoxy(1,26);
					writeln ('                                               ');
					if ubicacion = -1 then
						begin
							gotoxy(1,26); 
							writeln ('No se encuentra ninguna persona con ese DNI');
						end;
					gotoxy(1,27); 
					writeln ('Presione un tecla para volver al menu.');
					cerrar_archivo_per (archivo_per); 
					readkey;
				end;
			'5': begin // Buscar estancia forma alfabetica 
					clrscr;
					writeln ('Lista de provincias por orden');
					writeln ('');
					abrir_archivo_per (archivo_per); 
					plantilla_estancia; 
					gotoxy(7,2); 
					listar_por_estancia(archivo_per);
					gotoxy(1,26);
					writeln ('                                               ');
					gotoxy(1,27); 
					writeln ('Presione un tecla para volver al menu.');
					cerrar_archivo_per (archivo_per); 
					readkey;
				end;
			'6': begin // lista estancia por provincia //NO ANDAAAAAAAAAAAAAAA
					clrscr; // Limpia la pantalla
					writeln ('Ingrese el codigo de Provincia');
					writeln ('');
					assign(archivo_P, ruta_P); // assign: es la orden que se encarga de asignar un nombre físico al fichero que acabamos de declarar.
					reset(archivo_P); // reset: abre un fichero para lectura.
					listar_provincias(archivo_P); // Procedimiento para listar las provincias en forma horizontal
					writeln ('');
					readln (codigo_provincia);
					buscar_registro_P (archivo_P,registro_P,codigo_provincia,encontrado,ubicacion); // Busca a la provincia si está 
					mostrar_en_carga (archivo_P,registro_P,codigo_provincia,ubicacion,aux_denominacion); // Devuelve la denominación
					cerrar_archivo_P (archivo_P); // Cierra el archivo
					assign(archivo_per, ruta_Per); // assign: es la orden que se encarga de asignar un nombre físico al fichero que acabamos de declarar.
					reset(archivo_per); // reset: abre un fichero para lectura.
					close (archivo_per); // Cierra el archivo
					writeln ('');
					writeln ('Presione un tecla para volver al menu.');
					readkey;
				end;	
			'7': begin // lista de provincias con piscinas 
					clrscr;
					writeln ('provincias con piscina');
					writeln ('');
					abrir_archivo_per (archivo_per); 
					plantilla_estancia; 
					gotoxy(7,2); 
					listar_estancia_pile (archivo_per); // Procedimiento para listar las provincias con pileta
					gotoxy(1,26);
					writeln ('                                               ');
					gotoxy(1,27); 
					writeln ('Presione un tecla para volver al menu.');
					cerrar_archivo_per (archivo_per); 
					readkey;
				end;
			'8': begin // Alta de infectado y estadistica que había sido dado de baja
					clrscr; 
					abrir_archivo_per (archivo_per); // abre el archivo
					Plantilla; // Procedimiento que dibuja la plantilla
					gotoxy(1,26);
					writeln ('Para dar de alta a un duenio de estancia ingrese el DNI: ');
					gotoxy(7,2); 
					readln (aux_dni);
					busqueda_binaria (archivo_per,aux_dni,ubicacion); // Procedimiento de busqueda binaria
					if ubicacion = -1 then
						begin
							gotoxy(1,26); 
							writeln ('No se encuentra ninguna persona con ese DNI');
						end;
					if ubicacion <> -1 then
						begin
							gotoxy(1,26);
							writeln ('Dara de Alta a esta persona? (S/N)');
							ingresar:= readkey; // Toma la opción con solo teclear 
							ingresar:=upcase(ingresar); // Pasa a mayúscula
							if ingresar = 'S' then
								begin
									aux_condicion:=true;
									modificar_alta_baja (archivo_per,ubicacion,aux_condicion); // Cambia la condición false a true
								end;
						end;
					cerrar_archivo_per (archivo_per); 
				end;
			'9': begin // Salir del Menu, vuelve al menu principal
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
end.
