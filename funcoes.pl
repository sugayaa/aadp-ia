%conta
conta([],0).
conta([_|Cauda], N) :- conta(Cauda, N1), N is N1 + 1.


%add final da lista
add_ultimo(Elem,[ ],[Elem]).
add_ultimo(Elem, [Cabeça|Cauda],[Cabeça|Cauda_Resultante]) :- add_ultimo(Elem,Cauda,Cauda_Resultante).


%verifica se elemento pertence à lista
pertence(Elem, [Elem|_]).
pertence(Elem, [_|Cauda]) :- pertence(Elem,Cauda).


%dadas duas listas, retorna concatenação em 3ª lista
concatena([],L2,L2).
concatena([Cab|Cauda], L2,[Cab|Resultado]) :- concatena(Cauda, L2, Resultado).
aadp(X) :- not(parede(X)).


%copia primeira lista na segunda lista
copyList([],[]).
copyList([Cab|Cauda],[Cab|Resultado]) :- copyList(Cauda,Resultado).


%esvazia lista e retorna numa segunda lista, vazia.
esvazia([],[]).
esvazia([_|Cauda],R) :- esvazia(Cauda, R).


%verifica se AADP pode pegar sujeira
possoPegar(X) :- conta(X,N), N < 2.


%verifica se AADP não está vazio
naoVazio(X) :- conta(X,N), N \== 0.


%verifica se AADP está vazio
vazio(X) :- conta(X,N), N == 0.


%copia duas listas para outras duas listas
%usada para manter o 'ambiente estático', ambiente seria AADP, Depositados e Path
staticEnv(A,B,C,D,E,F) :- copyList(A,D), copyList(B,E), copyList(C,F).


%insere um elemento na cabeça da uma lista, retorna numa outra lista
insere_primeira(X,Y,[X|Y]).
