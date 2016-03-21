Program IAL002_201402;
{ ***********************************************************
  *	Trabalho de IAL002 - Algoritmos e Logica de Programacao *
  *                                                         *
  * Titulo : Obtencao e Consistencia de Datas               *
  *                                                         *
  * Professor: Jose Paulo Ciscato                           *
  * Alunos:                                                 *
  *     Anderson Gomes da Silva      - 14201261             *
  *     Silvio luiz gualberto junior - 14211811             *
  *     Sergio luiz   donatti junior - 14201332             *
  *                                                         *
  ***********************************************************
 }
uses crt;
type vet            = array[1..3]  of integer;
type vetmes         = array[1..12] of integer;
type vetformatos    = array[1..5]  of string;
type vetseparadores = array[1..5]  of char;

VAR 
	dia, mes, ano, novoformato, i : integer;
	dataOK : boolean;
	resposta, respostaOutraData : char;
	formato : integer = 1;	
	separador  : char = '/';
	separadores : vetseparadores= ('/','/','-','.','.');
	componentes : vet;
	termos      : vet=(1,2,3);
	// formatoTipo : 5vet=( (1,2,3), (2,1,3), (1,2,3), (1,2,3), (3,2,1) ) ;
	mesDias : vetmes=(31,28,31,30,31,30,31,31,30,31,30,31);
	formatos : vetformatos = ( 'Britanico :DD/MM/AAAA'
							  ,'Americano :MM/DD/AAAA'
							  ,'Italiano  :DD-MM-AAAA'
							  ,'Germanico :DD.MM.AAAA'
							  ,'ANSI      :AAAA.MM.DD');
	exemplos : vetformatos = ('dd mm aaaa', 'mm dd aaaa', 'dd mm aaaa', 'dd mm aaaa', 'aaaa mm dd');

Procedure AtualizaComponentes(dia, mes, ano : integer);
	begin
		CASE formato of
			1,3,4 : begin
					componentes[termos[1]] := dia;
					componentes[termos[2]] := mes;
					componentes[termos[3]] := ano;
				end;
			2 : begin
					componentes[termos[1]] := mes;
					componentes[termos[2]] := dia;
					componentes[termos[3]] := ano;
				end;
			5 : begin
					componentes[termos[1]] := ano;
					componentes[termos[2]] := mes;					
					componentes[termos[3]] := dia;
				end;
		END;
	end;

Procedure ObterData(var dia, mes, ano : integer);
	begin
		CASE formato of
			1,3,4 : begin
					dia := componentes[termos[1]];
					mes := componentes[termos[2]];
					ano := componentes[termos[3]];
				end;
			2 : begin
					mes := componentes[termos[1]];
					dia := componentes[termos[2]];
					ano := componentes[termos[3]];
				end;
			5 : begin
					ano := componentes[termos[1]];
					mes := componentes[termos[2]];				
					dia := componentes[termos[3]];
				end;
		END;
	end;

Function Bissexto(ano : integer) : boolean;
	begin
		Bissexto := (  ( (ano mod 4 = 0) and (ano mod 100 <> 0) ) or (ano mod 400 = 0)  );
	end;

Procedure AjusteBissexto(ano : integer);
	begin
		mesDias[2] := 28;
		if Bissexto(ano) then
			mesDias[2] := 29;
	end;

Function ConsistirData(dia, mes, ano : integer) : boolean;
	begin
		AjusteBissexto(ano);
		ConsistirData := True;

		if not ((mes >= 1) and (mes <= 12)) then 
			ConsistirData := False;

		if not ((dia >= 1) and (dia <= mesDias[mes])) then 
			ConsistirData := False;
	end;

Procedure ImprimeData();
	begin
		writeln(componentes[termos[1]], separador, componentes[termos[2]], separador, componentes[termos[3]]);
	end;

Procedure DiaSeguinte( dia, mes, ano : integer);
	begin
		AjusteBissexto(ano);
		dia := dia +1;
		if dia > mesDias[mes] then
			begin
				dia := 1;
				mes := mes +1;
				if mes = 13 then
					begin
						mes := 1;
						ano := ano + 1 ;
					end	
			end;
		AtualizaComponentes(dia,mes,ano);
		ImprimeData();
	end;

Procedure DiaAnterior(dia, mes, ano : integer);
	begin
		AjusteBissexto(ano);
		dia := dia -1;
		if (dia < 1) then
			begin				
				mes := mes -1;				
				if (mes < 1) then
					begin
						ano := ano -1;						
						mes := 12;						
					end;
				dia := mesDias[mes];
			end;
		
		AtualizaComponentes(dia,mes,ano);
		ImprimeData();
	end;

Procedure MudaFormato(frm : integer);
	begin
		formato := frm;
		separador := separadores[formato];
		CASE formato of
			1,3,4 : begin
					termos[1] := 1;
					termos[2] := 2;
					termos[3] := 3;
				end;
			2 : begin
					termos[1] := 2;
					termos[2] := 1;
					termos[3] := 3;
				end;
			5 : begin
					termos[1] := 3;
					termos[2] := 2;
					termos[3] := 1;
				end;
		END;

		writeln('Formato alterado para ', formatos[frm]);
		writeln('');
	end;

BEGIN
	respostaOutraData := 's';
	while ( (respostaOutraData = 's') or (respostaOutraData = 'S') ) do
		BEGIN

			writeln('Deseja mudar o formato da data (S/N) ?');
			readln(resposta);
			if (resposta = 'S') or (resposta = 's') then
				begin
					repeat
						begin
							clrscr;
							for i := 1 to 5 do
							begin
								writeln('(',i,') - Formato ',formatos[i]);						
							end;						
							writeln('Digite o numero do formato desejado:');
							readln(novoformato);
						end			 	
					until ( (novoformato >= 1) and (novoformato <= 5) );
					
					MudaFormato(novoformato);
				end;
				
			dataOK := false;
			repeat
				begin				
					writeln('digite a data conforme exemplo: ', exemplos[formato], ':');
					readln(componentes[termos[1]],componentes[termos[2]],componentes[termos[3]]);

					ObterData(dia, mes, ano);
					if ConsistirData(dia,mes,ano) then 
						begin
							dataOK := true;
							write('Formato ',formatos[formato],' => ');ImprimeData();						
						 	write('            Data Dia Seguinte => ');DiaSeguinte(dia,mes,ano);
						 	write('            Data Dia Anterior => ');DiaAnterior(dia,mes,ano);
							if Bissexto(ano) then
								writeln('** (Ano Bissexto) **');
						end
					else
						writeln('Data informada invalida !!');
				end;
			until dataOK;


			writeln('Deseja informar outra data (S/N) ?');
			readln(respostaOutraData);
		END;
END.
