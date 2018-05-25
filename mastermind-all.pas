program Mastermind;
uses crt;
var code:array[0..3] of byte;                       { Der versteckte Code }
    allesSchwarz:array[0..1] of byte;               { Referenz für 4 Schwarze und 0 weiße }
    brett:array[0..9,0..3] of byte;                 { Das Brett }
    antworten:array[0..9,0..1] of byte;             { Platz für Bewertungen }
    i,line,m,below,p,q,maxline:byte;
    nosuc:integer;
    gefunden,voll,raus,firstright,gleiche,codeok,alle7:boolean;


procedure Einlesen;    { Begrüßung // Einlesen des versteckten Codes }
begin
	writeln('-------------------------------------------------');
	writeln('| Mastermind-All                                |');
	writeln('| author: Christopher Bronner                   |');
	writeln('| email:  christopher.bronner@gmail.com         |');
	writeln('-------------------------------------------------');
end;


procedure AntwortenNull;
var j:integer;
begin
	for i:=0 to 9 do
		for j:=0 to 1 do
			antworten[i,j]:=0;
end;


procedure Schreibe(znr:integer);
begin
	writeln(znr,' || ',brett[znr,0],'   ',brett[znr,1],'   ',brett[znr,2],'   ',brett[znr,3],' || white: ',antworten[znr,0],', black: ',antworten[znr,1]);
end;



procedure ErsteZeileSchreiben;
begin 
	for i:=0 to 4 do
		brett[0,i]:=i;
end;


procedure bewerte(znr:integer);
var j:integer;
begin
  for i:=0 to 3 do
  begin

    for j:=0 to 3 do
      if (brett[znr,i]=code[j]) and (i<>j) then inc(antworten[znr,0]);  { weiße setzen }
                                  
    if brett[znr,i]=code[i] then inc(antworten[znr,1]);  { schwarze setzen }

  end;
end;


function konsistent(znr:integer):boolean;
var testantwort:array[0..1] of integer;
    j,k,r,znrbelow:integer;
begin
   konsistent:=true;
   znrbelow:=znr-1;

   for k:=0 to znrbelow do
   begin

   for r:=0 to 1 do testantwort[r]:=0;

         { Vergleiche kte Zeile mit dem in znr übergebenen Vorschlag }
       for i:=0 to 3 do
        begin
           for j:=0 to 3 do
              if (brett[k,i]=brett[znr,j]) and (i<>j) then inc(testantwort[0]); { weiße setzen }

              if brett[k,i]=brett[znr,i] then inc(testantwort[1]); { schwarze setzen } 
        end;
        

        for i:=0 to 1 do
            if testantwort[i]<>antworten[k,i] then konsistent:=false;  { Vergleiche }


   end;
end;


{ Hauptprogramm }
begin

Einlesen; { Begrüßung }

writeln('Program is cracking all possible combinations, please wait...');

nosuc:=0;
maxline:=0;

code[0]:=0;
code[1]:=1;
code[2]:=2;
code[3]:=2;

repeat

{ Farbkombinationen als Code vorgeben }
repeat 

  { Neuen Code erzeugen }
  inc(code[3]);
  if code[3]=8 then 
  begin
    code[3]:=0;
    inc(code[2]);
  end;
  if code[2]=8 then
  begin
    code[2]:=0;
    inc(code[1]);
  end;
  if code[1]=8 then
  begin
    code[1]:=0;
    inc(code[0]);
  end;

        { Checken dass keine gleichen dabei sind }
        codeok:=true;
        for p:=0 to 3 do for q:=0 to 3 do
                 if (code[q]=code[p]) and (p<>q) then codeok:=false;
 
until codeok=true;

  AntwortenNull;                { Setzt alle Elemente der Antwortmatrix auf 0 }
  ErsteZeileSchreiben;          { Schreibt 0 1 2 3 in die erste Zeile }
  allesSchwarz[0]:=0;           { Setzt die Referenz für die Lösung }
  allesSchwarz[1]:=4;

  bewerte(0);


  { Checke, ob schon die erste richtig war }
  firstright:=true;
  for i:=0 to 1 do 
         if antworten[0,i]<>allesSchwarz[i] then firstright:=false;


if firstright=false then
begin


  line:=0;


  repeat

    inc(line);
    below:=line-1;

    { Vorherige Zeile übernehmen }
    for m:=0 to 3 do brett[line,m]:=brett[below,m];

    raus:=false;
    gefunden:=false;
    voll:=false;

    repeat

      repeat
        { Durchlaufen }
        inc(brett[line,3]);

        { Überträge }
        if brett[line,3]=8 then
        begin
          brett[line,3]:=0;
          inc(brett[line,2]);
        end;
        if brett[line,2]=8 then
        begin
          brett[line,2]:=0;
          inc(brett[line,1]);
        end;
        if brett[line,1]=8 then
        begin
          brett[line,1]:=0;
          inc(brett[line,0]);
        end;
        if brett[line,0]=8 then
        begin
          brett[line,0]:=0;
        end;

        { Checken ob welche gleich sind }
        gleiche:=false;
        for p:=0 to 3 do for q:=0 to 3 do
                 if (brett[line,p]=brett[line,q]) and (p<>q) then gleiche:=true;

      until gleiche=false;

    until konsistent(line)=true;

    bewerte(line);


   
    { Gucken, obs schon die Lösung ist }
    gefunden:=true;
    for i:=0 to 1 do
          if antworten[line,i]<>allesSchwarz[i] then gefunden:=false;

    { ...oder ob das Brett voll ist }
    if line=9 then voll:=true;

    if voll=true then raus:=true;
    if gefunden=true then raus:=true;

    if line>maxline then maxline:=line;

   until raus=true;

if gefunden=false then 
begin
   writeln('Didnt find a way to crack ',code[0],'-',code[1],'-',code[2],'-',code[3],'. :(');
   inc(nosuc);
end;

end;

alle7:=true;
if code[0]<>7 then alle7:=false;
if code[1]<>6 then alle7:=false;
if code[2]<>5 then alle7:=false;
if code[3]<>4 then alle7:=false;

until alle7=true;

writeln('There were ',nosuc,' combinations the program couldnt crack!');
writeln('The hardest one was cracked in line ',maxline,' (Counting from 0).');

end.