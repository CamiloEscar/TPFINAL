unit ABMC_Final;

interface 

uses 
	crt,Configuracion_Final,Fecha_Final;

const
	ruta_Per='Personas.dat'; 
	ruta_P='provincias.dat';
	direccion_PROV = 'ARCHIVO_PROVINCIA.DAT';
 
    n=23;
    
type
	t_cadena30=string[40];
	vector_str = array [1..23] of t_cadena30;
	vector_long = array [1..23] of longInt;

	t_domicilio=record
		numero, piso:integer;
		ciudad, calle, provincia:t_cadena30;
		CP:integer;
	end;

	personas = record
		id:integer;
		apellidoynombre:string[30]; 
		dni:string[8];
		calle:string[20];
		numero:string[8];
		piso:string[3];
		departamento:string[3];
		cp:integer;
		ciudad:string[30]; 
		provincia:t_cadena30;
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
		CODIGO_PROVINCIA2:integer;

	end;

	PROVINCIA = RECORD
	DENOMINACION:t_cadena30;
	CODIGO_PROVINCIA:integer;
	TELEFONO:integer;
	end;

ARCHIVO_PROVINCIA = file of PROVINCIA;
fichero_per= file of personas;
fichero_P= file of provincias; 

var
	archivo_per:fichero_per;
	archivo_P:fichero_P;
	registro_per:personas;
	registro_P:provincias;

Procedure Inicializar_Vector_str(Var V:vector_str);
procedure inicializar_vector_long (var v:vector_long);
procedure cargar_codigo_provincia (var prov: vector_str); 
procedure telefono_provincia (var vec:vector_long);

PROCEDURE CREAR_A_PROV(VAR A_prov:ARCHIVO_PROVINCIA);
PROCEDURE ABRIR_PROV (VAR A_PROV:ARCHIVO_PROVINCIA);
PROCEDURE CERRAR_PROV(VAR A_PROV:ARCHIVO_PROVINCIA);
procedure leer_provincia (var a_prov:archivo_provincia; pos:integer; var reg_prov:provincia);
procedure guardar_provincia (var a_prov:archivo_provincia; pos:integer; var reg_prov:provincia);
//procedure Inicializar_personas (Var registro_per:personas);
procedure inicializar_provincias (var reg_prov:provincia);
procedure cargar_provincia (var a_prov:archivo_provincia); 
Procedure MOSTRAR_REG_PROV (var reg_prov:provincia);
procedure bbin_provincia (var A_PROV : archivo_provincia; buscado:integer;var pos:integer);
procedure burbuja_provincias(var A_PROV : Archivo_Provincia;lim:integer);

procedure crear_archivo(var archivo:file; ruta_archivo:string);
procedure menu_ABMC;
procedure cantidad_personas_provincia (var arch:fichero_per;cod_est:byte; var cant:integer);
procedure listar_I(var arch:fichero_per;verdadero:boolean);
procedure listar_i_provincias(var arch:fichero_per; auxCodProv:byte;aux_denominacion:string);
procedure orden_burbuja_I_Apellido (var arch:fichero_per);
procedure listar_per(var arch:fichero_per);
//procedure cargar_codigo_provincia (var arch: fichero_P); 


implementation // Parte privada de la unit

// Procedimiento para dibujar la Plantilla
procedure plantilla;
begin
	TextColor (7); 
	TextBackground (0); 
	writeln ('--------------------------------------------------------------------------------');//01
	writeln ('- DNI:________                           						                 -');//05
	writeln ('--------------------------------------------------------------------------------');//03
	writeln ('- Nombre de la estancia:                                                       -');//02
	writeln ('- Apellido y nombres del dueno: 		             							 -');//04
	writeln ('- Fecha de Nacimiento:                                                         -');//06
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
	writeln ('- Datos extra:                                                                 -');//18
	writeln ('--------------------------------------------------------------------------------');//19
	writeln ('- Estado:                                                                      -');//20
	writeln ('-                                                                              -');//21
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
	{$I-} 
	reset(archivo); 
	{$I+}
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
procedure guardar_registro_per(var arch:fichero_per;reg:personas);
begin
	seek(arch,filesize(arch)); // Se posiciona en la última posición del registro
	write(arch,reg); 
end;

{Procedure Inicializar_personas (Var registro_per:personas);
begin
  with personas do
	begin
		cp:=0;
		//provincia:=0;
		pileta:=0;
	end;
end;}

// Procedimiento para leer el registro 
procedure leer_registro_per(var arch:fichero_per; var reg:personas; pos:integer);
begin
	seek(arch,pos); 
	read(arch,reg); 
end;

Procedure Inicializar_Vector_str(Var V:vector_str);
Var j:integer;
Begin
For j:= 1 to n do
    V[j]:=' ';
End;

Procedure inicializar_vector_long(Var V:vector_long);
Var j:integer;
Begin
For j:= 1 to n do
    V[j]:=0;
End;

procedure cargar_codigo_provincia (var prov: vector_str); 
begin
PROV[1]:='JUJUY';
PROV[2]:='SALTA';
PROV[3]:='FORMOSA';
PROV[4]:='CHACO';
PROV[5]:='MISIONES';
PROV[6]:='CORRINETES';
PROV[7]:='TUCUMAN';
PROV[8]:='SANTIAGO DEL ESTERO';
PROV[9]:='CATAMARCA';
PROV[10]:='LA RIOJA';
PROV[11]:='SAN JUAN';
PROV[12]:='CORDOBA';
PROV[13]:='SANTA FE';
PROV[14]:='ENTRE RIOS';
PROV[15]:='MENDOZA';
PROV[16]:='SAN LUIS';
PROV[17]:='BUENOS AIRES';
PROV[18]:='LA PAMPA';
PROV[19]:='NEUQUEN';
PROV[20]:='RIO NEGRO';
PROV[21]:='CHUBUT';
PROV[22]:='SANTA CRUZ';
PROV[23]:='TIERRA DEL FUEGO';
end;

procedure telefono_provincia (var vec:vector_long);
begin
vec[1]:=015687;
vec[2]:=025687;
vec[3]:=035687;
vec[4]:=045687;
vec[5]:=055687;
vec[6]:=065687;
vec[7]:=075687;
vec[8]:=085687;
vec[9]:=095687;
vec[10]:=0105687;
vec[11]:=0115687;
vec[12]:=0125687;
vec[13]:=0135687;
vec[14]:=0145687;
vec[15]:=0155687;
vec[16]:=0165687;
vec[17]:=0175687;
vec[18]:=0185687;
vec[19]:=0195687;
vec[20]:=0205687;
vec[21]:=0215687;
vec[22]:=0225687;
vec[23]:=0235687;
end;

PROCEDURE CREAR_A_PROV(VAR A_prov:ARCHIVO_PROVINCIA);
begin
  ASSIGN(A_prov,direccion_PROV);
  {$I-}
  RESET (A_PROV);
  {$I+}
  if (IOResult <> 0) then
	reWRITE(A_prov);
	close(A_prov);
end;

PROCEDURE ABRIR_PROV (VAR A_PROV:ARCHIVO_PROVINCIA);
BEGIN
ASSIGN(A_PROV,direccion_PROV);
RESET(A_PROV);
END;

PROCEDURE CERRAR_PROV(VAR A_PROV:ARCHIVO_PROVINCIA);
BEGIN
CLOSE(A_PROV);
END;

procedure leer_provincia (var a_prov:archivo_provincia; pos:integer; var reg_prov:provincia);
begin
seek (A_prov, pos);
Read (a_prov, reg_prov);
end;

procedure guardar_provincia (var a_prov:archivo_provincia; pos:integer; var reg_prov:provincia);
begin
seek (A_prov, pos);
write (a_prov, reg_prov);
end;

procedure inicializar_provincias (var reg_prov:provincia);
begin 
  with reg_prov do
  begin
    DENOMINACION:='';
    codigo_provincia:=0;
    TELEFONO:=0;
  end;  
end;

procedure cargar_provincia (var A_PROV:Archivo_Provincia);
var vec:vector_long;
pos, i:integer;
v:vector_str;
reg_prov:provincia;

begin
inicializar_vector_str(v);
cargar_codigo_provincia(v);
inicializar_vector_long(vec);
telefono_provincia(vec);
with reg_prov do
  begin
  for i:= 0 to 23 do
  begin
    pos:=i;
    codigo_provincia:=pos;
    DENOMINACION:=v[pos];
    telefono:=vec[pos];

    guardar_provincia (A_prov, pos, reg_prov);
  end;
  end;
end;

Procedure MOSTRAR_REG_PROV (var reg_prov:provincia);
BEGIN	
with reg_prov do
  begin
    writeln ('la denominacion es: ',denominacion);
    writeln ('el codigo de provincia ',codigo_provincia);
    writeln ('su telefono es: ',telefono);
  end;
end;

procedure burbuja_provincias(var A_PROV : Archivo_Provincia;lim:integer);
VAR reg_prov, aux_prov:provincia;
pos, i, J:INTEGER;
BEGIN
FOR I:= 1 TO LIM - 1 DO
FOR J:= 0 TO LIM - I DO
BEGIN
  pos:=j;
  leer_provincia (a_prov, pos, reg_prov);
  inc(pos);
  leer_provincia (a_prov, pos, aux_prov);
  IF (Reg_prov.codigo_provincia > aux_prov.codigo_provincia) THEN
  BEGIN
    guardar_provincia (a_prov, pos, reg_prov);
    dec(pos);
    guardar_provincia (A_prov, pos, aux_prov);
    END;
END;
END;

procedure bbin_provincia (var A_PROV : archivo_provincia; buscado:integer ;var pos:integer);
var
primero, ultimo, medio:integer;
reg_prov : provincia;
begin
primero:=0;
ultimo:=filesize(A_PROV)-1;
pos:=-1;
while ((pos = -1) and (primero<=ultimo)) do
  begin
  medio:=(primero+ultimo) div 2;
  leer_provincia (A_prov,medio,reg_prov);
  if (reg_prov.codigo_provincia=buscado) then
    pos:= medio
  else if (reg_prov.codigo_provincia>buscado) then
    ultimo:=medio-1
  else primero:=medio+1
  end;
end;

procedure cantidad_personas_provincia (var arch:fichero_per;cod_est:byte; var cant:integer);
var
	reg:personas;
begin
	cant:=0;
	reset(arch);
	while not (eof(arch))do
		begin
			read (arch,Reg);
			if reg.condicion=true then
				if (reg.codigo_provincia=cod_est) then
					inc(Cant)
		end;
end;


// Procedimiento para mostrar el registro buscado
procedure mostrar_registro_cargado_I(var arch:fichero_per; reg:personas; documento:string; ubi:integer);
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

// Procedimiento para ordenar por apellido
procedure orden_burbuja_I_Apellido (var arch:fichero_per);
var 
	reg1,reg2:personas;
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
				if reg1.apellidoynombre > reg2.apellidoynombre then
					begin
						seek(arch,j+1);  // Se posiciona en el registro con posición J+1
						write(arch,reg1); 
						seek(arch,j);  // Se posiciona en el registro con posición J
						write(arch,reg2); 
					end;
			end;
end;


// Procedimiento para mostrar los registros
procedure mostrar_registro_per_Provincia(registro:personas);
begin
	writeln (registro.dni,', ', registro.apellidoynombre);
end;

// Procedimiento para listar personas
procedure listar_i_provincias(var arch:fichero_per; auxCodProv:byte;aux_denominacion:string);
var
	reg:personas;
begin
	clrscr;
	reset(arch);
	writeln ('listado de personas en: ',aux_denominacion);
	writeln ('');
	while not (eof(arch))do
		begin
			read (arch,Reg);
			if reg.condicion=true then
				if reg.codigo_provincia=auxCodProv then
					mostrar_registro_per_Provincia(reg);
		end;
end;

// Procedimiento para mostrar los personas
procedure mostrar_registro_per(reg:personas);
begin
	writeln ('codigo prov ',reg.codigo_provincia,', de ',reg.apellidoynombre,', Estancia: ',reg.denominacion);
end;

// Procedimiento para mostrar los personas
procedure mostrar_registro_por_estancia(reg:personas);
begin
	writeln (reg.denominacion, ': dueno de estancia ',reg.apellidoynombre, ' y su dni es: ', reg.dni);
end;

// Procedimiento para mostrar los personas
procedure mostrar_registro_por_prov(reg:personas);
begin
	writeln (reg.codigo_provincia, ' N° prov', ', Estancia: ',reg.denominacion, reg.dni,', ',reg.apellidoynombre);
end;

// Procedimiento para mostrar los personas
procedure mostrar_registro_por_pileta(reg:personas);
begin
	writeln (reg.codigo_provincia, ' N° prov', ', Estancia: ',reg.denominacion, reg.dni,', ',reg.apellidoynombre);
end;

// Procedimiento para listar los personas true o false
procedure listar_I(var arch:fichero_per;verdadero:boolean);
var
	reg:personas;
begin
	clrscr;
	reset(arch);
	writeln ('listado de personas de condición: ',verdadero);
	writeln ('');
	while not (eof(arch))do
		begin
			read (arch,Reg);
			if verdadero=true then
				if reg.condicion=true then
					mostrar_registro_per (reg);
			if verdadero=false then
				if reg.condicion=false then
					mostrar_registro_per(reg);
		end;
end;


// Procedimiento para listar las provincias
procedure listar_est(var arch:fichero_per);
var
	reg:personas;
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
	reg:personas;
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
procedure listar_estancia_por_provincia(var arch:fichero_per);
var
	reg:personas;
begin
	clrscr;
	plantilla_estancia; // Procedimiento para dibujar la plantilla
	reset(arch);
	while not (eof(arch)) do
		begin
			read (arch,reg);
			mostrar_registro_por_prov(reg); // Procedimiento para para mostrar cada registro
		end;
end;

// Procedimiento para listar las provincias
procedure listar_estancia_por_pileta(var arch:fichero_per);
var
	reg:personas;
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
	reg1,reg2:personas;
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
// Procedimiento para buscar una persona por DNI
procedure buscar(var arch:fichero_per; documento:string);
var
	reg:personas; 
	i: integer;
begin
	for i:=0 to filesize(arch)-1 do
		begin
			leer_registro_per (arch,reg,i);
			if documento=reg.dni then
				mostrar_registro_per (reg)
		end;
end;

// Procedimiento para modificar los datos del personas
procedure modificar_alta_baja(var arch:fichero_per;pos:integer; verdad:boolean);
var
	reg:personas;
begin
	seek(arch,pos); 
	read(arch,reg);
	reg.condicion:=verdad;
	seek(arch,pos); 
	write(arch,reg);
end;


// Procedimiento para buscar persona para modificar
procedure buscar_modificar(var arch:fichero_per; documento:string; var encon:boolean);
var
	reg:personas; 
	i: integer;
begin
	for i:=0 to filesize(arch)-1 do
		begin
			leer_registro_per (arch,reg,i);
			if documento=reg.dni then
				begin
					encon:=true;
					mostrar_registro_cargado_I(arch,reg, documento,i);
				end;
		end;
end;


// Procedimiento para cargar registros
procedure cargar_registro_per(var reg:personas; var documento:string; var prov:byte;var ubic:integer);
var
	vec:vector_long;
	v:vector_str;i:1..23;
	cantidad_provincias:byte;
	validar_fecha:boolean;
	ubicacion:integer;
	encontrado:boolean;
	aux_denominacion:string[30];
	
	


begin
	validar_fecha:=false;
	ubic:=-1;
	//cp:=reg;
	clrscr;
	plantilla;
	TextColor (10);
	gotoxy(1,24); 
	writeln ('Ingrese el DNI del duenio de la estancia:								');
	gotoxy(7,2); 
	readln (documento);
	busqueda_binaria(archivo_per,documento,ubic);
	inicializar_vector_str(v);
	cargar_codigo_provincia(v);
	if ubic=-1 then
		begin
			with reg do
				begin 
					id:= filesize(archivo_per)+1;
					gotoxy(2,60);
					writeln (id);
					dni:=documento;
					gotoxy(1,24) ;
					writeln ('Ingrese Nombre de la Estancia                   ');
					gotoxy(25,4);
					readln(reg.denominacion);
					gotoxy(1,24) ;
					writeln ('Ingrese el Apellido y Nombre del dueno:                                              ');
					gotoxy(35,5) ;
					readln(apellidoynombre);
					repeat
						gotoxy(1,24) ;
						writeln ('Ingrese el dia de la Fecha de Nacimiento                                        ');
						readln(dia_nacimiento);
						gotoxy(24,6);
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
					writeln ('Ingrese el departamento o num de casa                                           ');
					gotoxy(68,11);
					readln(departamento);
					gotoxy(1,24) ;
					writeln ('Ingrese el codigo postal                                                        ');
					gotoxy(18,12);
					readln(cp);
					gotoxy(1,24) ;
					writeln ('Ingrese la ciudad                                                               ');
					gotoxy(11,13);
					readln(ciudad);
					gotoxy(1,24) ;
					repeat
						gotoxy(1,24) ;
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
					gotoxy(1,24) ;
					writeln ('Ingrese el numero de telefono                                                   ');
					gotoxy(13,15);
					readln(num_telefono);
					gotoxy(1,24) ;
					writeln ('Ingrese el correo electrónico                                                   ');
					gotoxy(11,16);
					readln(email);
					condicion:=true;
					writeln ('Ingrese si tiene pileta  1-si 0-no                       ');
					gotoxy(11,17);
					gotoxy(42,3+codigo_provincia);
					readln(pileta);
					gotoxy(1,24);
					writeln ('Ingrese la capacidad maxima                     ');
					gotoxy(11,18);
					gotoxy(45,3+codigo_provincia);
					readln(cap_maxima);
				end;
		end;
end;

// Procedimiento para modificar registros
procedure modificar_registro_per(var reg:personas; var documento:string; var prov:byte; ubic:integer);
var
	v:vector_str;i:1..23;
	cantidad_provincias:byte;
	validar_fecha:boolean;
	ubicacion:integer;
	encontrado:boolean;
	aux_denominacion:string[30];


begin
	validar_fecha:=false;
	clrscr;
	//cp:=reg;
	plantilla;
	TextColor (10);
	gotoxy(1,24); 
	writeln ('Para modificar:			                                                                 ');
	writeln ('Ingrese el DNI del dueño de la estancia                                                    ');
	gotoxy(7,2); 
	readln (documento);
	inicializar_vector_str(v);
	cargar_codigo_provincia(v);
	with reg do
		begin 
			id:= ubic+1;
			gotoxy(24,2);
			writeln (id);
			dni:=documento;
			gotoxy(1,24) ;
			writeln ('Ingrese el Apellido y Nombre del dueño                                              ');
			gotoxy(23,5) ;
			readln(apellidoynombre);
			gotoxy(1,24) ;
			repeat
				gotoxy(1,24) ;
				writeln ('Ingrese el dia de la Fecha de Nacimiento                                        ');
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
			writeln ('Ingrese el departamento o num de casa                                            ');
			gotoxy(68,11);
			readln(departamento);
			gotoxy(1,24) ;
			writeln ('Ingrese el codigo postal                                                        ');
			gotoxy(18,12);
			readln(cp);
			gotoxy(1,24) ;
			writeln ('Ingrese la ciudad                                                               ');
			gotoxy(11,13);
			readln(ciudad);
			repeat
						gotoxy(1,24) ;
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
			gotoxy(12,17);
			gotoxy(45,3+codigo_provincia);
			readln(cap_maxima);
		end;
	seek(archivo_per,ubic); 
	write(archivo_per,reg);
end;



procedure listar_per(var arch:fichero_per);
var
	reg:personas;
begin
	clrscr;
	plantilla; // Procedimiento para dibujar la plantilla
	reset(arch);
	while not (eof(arch)) do
		begin
			read (arch,reg);
			mostrar_registro_per(reg); // Procedimiento para para mostrar cada registro
		end;
end;

// Procedimiento del Menú ABMC
procedure menu_ABMC;
var
	REG_prov:PROVINCIA;
	opcion,ingresar:char;
	aux_dni:string[8];

	aux_provincia:byte;
	ubicacion:integer;
	busqueda_prov, pos_prov, pos_est:integer;
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
		writeln ('- 1 - Dar de alta a una estancia          ');
		writeln ('- 2 - Dar de baja a una estancia          ');
		writeln ('- 3 - Modificar                           ');
		writeln ('- 4 - Consulta - buscar duenio	        ');
		writeln ('- 5 - Lista estancia alfabetico  		    ');
		writeln ('- 6 - Lista por provincia			        ');
		writeln ('- 7 - provincias con piscinas		        ');
		writeln ('------------------------------------------');
		writeln ('- 8 - Volver al Menu Principal            ');
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
								mostrar_registro_cargado_I (archivo_per,registro_per,aux_dni,ubicacion); // Procedimiento Para mostrar los datos

								gotoxy(1,24) ;
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
					gotoxy(1,24);
					writeln ('Para dar de baja a un duenio de estancia ingrese el DNI: ');
					gotoxy(7,2); 
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
									modificar_alta_baja (archivo_per,ubicacion,aux_condicion); // Cambia la condición true a false
								end;
						end;
					cerrar_archivo_per (archivo_per); 
				end;
			'3': begin // Modificación de duenio de estancia
					clrscr; 
					abrir_archivo_per (archivo_per); 
					Plantilla; 
					gotoxy(1,24);
					writeln ('Para la modificacion del dueno, ingrese el DNI: ');
					gotoxy(7,2); 
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
									modificar_registro_per (registro_per,aux_dni,aux_provincia,ubicacion); // Muestra los datos a modificar
								end;
						end;
					cerrar_archivo_per (archivo_per); 
				end;
			'4': begin // Buscar un duenio de estancia 
					clrscr; 
					abrir_archivo_per (archivo_per); 
					plantilla; 
					gotoxy(1,24);
					writeln ('Para buscar un dueno ingrese el DNI ');
					gotoxy(7,2); 
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
					readkey;
				end;
			'5': begin // Buscar estancia forma alfabetica 
					clrscr;
					writeln ('Lista de provincias por orden');
					writeln ('');
					//assign(archivo_per, ruta_Per); // assign: es la orden que se encarga de asignar un nombre físico al fichero que acabamos de declarar.
					//reset(archivo_per); // reset: abre un fichero para lectura.
					abrir_archivo_per (archivo_per); 
					plantilla_estancia; 
					gotoxy(7,2); 
					listar_por_estancia(archivo_per);
					gotoxy(1,24);
					writeln ('                                               ');
					gotoxy(1,27); 
					writeln ('Presione un tecla para volver al menu.');
					cerrar_archivo_per (archivo_per); 
					//close (archivo_per); // Cierra el archivo
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
					//listar_I_Provincia(archivo_per,codigo_provincia,aux_denominacion); // Procedimiento que lista pacientes por provincia
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
					listar_estancia_por_pileta (archivo_per); // Procedimiento para listar las provincias con pileta
					gotoxy(1,24);
					writeln ('                                               ');
					gotoxy(1,27); 
					writeln ('Presione un tecla para volver al menu.');
					cerrar_archivo_per (archivo_per); 
					readkey;
				end;													
			'8': begin // Salir del Menu, vuelve al menu principal
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
