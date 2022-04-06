unit Caratula_Final;
{$codepage utf8}

interface // Parte pública, que se comparte

uses 
	wincrt,crt,graph;

procedure Caratula;

implementation // Parte privada de la unit

var
	drive,modo:integer;

procedure initgrafico;
begin
	drive:=detect;
	initgraph(drive,modo,'');
end;

procedure Caratula;
begin
	initgrafico; // Procedimiento para abrir la parte gráfica
	setcolor (3); // Cambia el color de los gráficos
	Rectangle (0,0,640,480); // Forma un rectángulo
	Rectangle (5,5,635,475); // Forma un rectángulo
	SetTextStyle (2,0,4); // Cambia la forma y tamaño de la letra
	OutTextXY (130,20,'FUNDAMENTOS'); // Posiciona a que distancia del margen Izquierdo y a que altura comienza el texto
	OutTextXY (280,60,'DE');
	OutTextXY (110,100,'PROGRAMACION');
	SetTextStyle (6,0,2); // Cambia la forma y tamaño de la letra
	setcolor (4); // Cambia el color de los gráficos
	OutTextXY (10,150,'Licenciatura en Sistemas de Informacion');
	OutTextXY (210,180,'Primer Anio');
	setcolor (6); // Cambia el color de los gráficos
	SetTextStyle (5,0,1); // Cambia la forma y tamaño de la letra
	OutTextXY (20,220,'Docentes:');
	OutTextXY (100,220,'Esp. Ing. Rossana Sosa Zitto');
	setcolor (8); // Cambia el color de los gráficos
	SetTextStyle (3,0,1); // Cambia la forma y tamaño de la letra
	OutTextXY (20,300,'Grupo:');
	OutTextXY (80,300,'ESCAR CAMILO');
	SetTextStyle (1,0,6); // Cambia la forma y tamaño de la letra
	setcolor (13); // Cambia el color de los gráficos
	setcolor (15); // Cambia el color de los gráficos
	delay (3500); // Lapso de Reloj
	closegraph; // Cierra el modo gráfico
end;

begin
end.
