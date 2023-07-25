unit Menu;

interface 

uses 
	wincrt,crt,graph;

procedure Menu_principal (var opc:char);

implementation 

var
	drive,modo:integer;

procedure initgrafico;
begin
	drive:=detect;
	initgraph(drive,modo,'');
end;

procedure menu_principal (var opc:char);
begin
	initgrafico; // Procedimiento para abrir la parte gráfica
	setcolor (3); 
	Rectangle (5,5,805,255); 
	Rectangle (6,6,804,254); 
	Rectangle (7,7,803,253); 
	Rectangle (8,8,802,252); 
	Rectangle (9,9,801,251); 
	Rectangle (10,10,800,250); 
	line (10,50,800,50); 
	line (10,51,800,51); 
	line (10,52,800,52); 
	line (10,83,800,83); 
	line (10,84,800,84); 
	line (10,85,800,85); 
	setcolor (9); 
	SetTextStyle (2,0,2); 
	OutTextXY (50,22,'Sistema Estadistico de Estancias'); 
	OutTextXY (110,60,'Elija una de las opciones del menu');
	setcolor (10); 
	OutTextXY (20,100,'1 - Alta/Modificacion de Provincia');
	OutTextXY (20,160,'2 - Alta/Baja/Modif/Cons de Dueno de estancia');
	setcolor (4); 
	OutTextXY (20,220,'0 - Salir');
	OutTextXY (20,325,'FUNDAMENTOS'); 
	OutTextXY (220,325,'DE');
	OutTextXY (250,325,'PROGRAMACION');
	SetTextStyle (6,0,2); 
	setcolor (7); 
	OutTextXY (20,375,'LICENCIATURA EN SISTEMAS DE INFORMACION');
	setcolor (7); 
	SetTextStyle (5,0,2); 
	OutTextXY (20,425,'DOCENTES:');
	OutTextXY (180,425,'ING. ROSSANA SOSA ZITTO');
	OutTextXY (180,450,'LIC. JULIAN ESCALANTE');
	setcolor (5); 
	SetTextStyle (5,0,2); 
	OutTextXY (20,500,'ALUMNO:');
	OutTextXY (150,500,'ESCAR CAMILO');
	SetTextStyle (5,0,2);
	setcolor (6); 
	OutTextXY (225,550,'TELEFONO DE CONTACTO MINISTERIO DE TURISMO C.DEL.U:');
	OutTextXY (1050,550,'03442 42-5820');
	SetTextStyle (5,0,2);  
	setcolor (1); 

	opc:=readkey; 
	if opc in ['1'..'2'] then // si la opción está en el conjunto correcta
		else // si la opción NO está en el conjunto correcta
			begin
				setcolor (9); 
				OutTextXY (20,300,'Opcion incorrecta');
				delay (2000) 
			end;
	closegraph; 
end;

begin
end.
