:- set_prolog_flag(answer_write_options,
                   [ quoted(true),
                     portray(true),
                     spacing(next_argument)
                   ]).
%conta
conta([],0).
conta([_|Cauda], N) :- conta(Cauda, N1), N is N1 + 1.

elevador(2).
elevador(12).
elevador(22).
elevador(32).
elevador(42).
elevador(7).
elevador(17).
elevador(27).
elevador(37).
elevador(47).

sujeira(3).
sujeira(46).
lixeira(4).
parede(6).
parede(-33).

%add final da lista
add_ultimo(Elem,[ ],[Elem]).
add_ultimo(Elem, [Cabeça|Cauda],[Cabeça|Cauda_Resultante]) :- add_ultimo(Elem,Cauda,Cauda_Resultante).

pertence(Elem, [Elem|_]).
pertence(Elem, [_|Cauda]) :- pertence(Elem,Cauda).

concatena([],L2,L2).
concatena([Cab|Cauda], L2,[Cab|Resultado]) :- concatena(Cauda, L2, Resultado).
aadp(X) :- not(parede(X)).

copyList([],[]).
copyList([Cab|Cauda],[Cab|Resultado]) :- copyList(Cauda,Resultado).

esvazia([],[]).
esvazia([_|Cauda],R) :- esvazia(Cauda, R).

coletarSujeira([X,AADP,Depositados], [Y, NewAADP, NewDepositados]) :- Y is X, copyList(Depositados,NewDepositados), sujeira(X), not(pertence(X,AADP)), not(pertence(X,Depositados)), possoPegar(AADP), add_ultimo(X, AADP, NewAADP),!.

possoPegar(X) :- conta(X,N), N < 2.
naoVazio(X) :- conta(X,N), N \== 0.
vazio(X) :- conta(X,N), N == 0.
staticEnv(A,B,C,D) :- copyList(A,C), copyList(B,D).

plusEmpty(X,[[],X]).
insere_primeira(X,Y,[X|Y]).


s([[X|Caminho], AADP, Depositados,Path], [[Y|NewCaminho], NewAADP, NewDepositados,NewPath]) :-
                    

                    %encontrou sujeira
                    Y is X, copyList(Depositados,NewDepositados),
                    sujeira(X), not(pertence(X,AADP)), not(pertence(X,Depositados)),
                    possoPegar(AADP), add_ultimo(X, AADP, NewAADP),
                    concatena(Caminho,Path,NewPath),esvazia(Caminho,NewCaminho),!;
                    
                    %encontrou lixeira
                    Y is X, concatena(Depositados,AADP,NewDepositados),
                    lixeira(X), naoVazio(AADP), esvazia(AADP, NewAADP),
                    concatena(Caminho,Path,NewPath), esvazia(Caminho,NewCaminho),!;
                    
 
                    %movimentacao
                    %esquerda
                    Y is (X + 1), not((10 - 1) =:= mod(X, 10)),
                    not(parede((Y))), insere_primeira(X,Caminho,NewCaminho),
                    staticEnv(Depositados, AADP, NewDepositados, NewAADP),
                    copyList(Path,NewPath);

                    %direita
                    Y is (X - 1), not(0 =:= mod(X,10)),
                    not(parede(Y)), insere_primeira(X,Caminho,NewCaminho),
                    staticEnv(Depositados, AADP, NewDepositados, NewAADP),
                    copyList(Path,NewPath);

                    %cima
                    Y is (X + 10), not((5 - 1) =:= div(X, 5)),
                    not(parede(Y)), elevador(Y), insere_primeira(X,Caminho,NewCaminho),
                    staticEnv(Depositados, AADP, NewDepositados, NewAADP),
                    copyList(Path,NewPath);

                    %baixo
                    Y is (X - 10), not(0 =:= div(X, 5)),
                    not(parede(Y)), elevador(Y), insere_primeira(X,Caminho,NewCaminho),
                    staticEnv(Depositados, AADP, NewDepositados, NewAADP),
                    copyList(Path,NewPath).

estende([[Posicao|Caminho], AADP, Depositados,Path],ListaSucessores):- bagof([[NewPosicao|NewCaminho],NewAADP,NewDepositados,NewPath],(s([[Posicao|Caminho],AADP,Depositados,Path],[[NewPosicao|NewCaminho],NewAADP,NewDepositados,NewPath]), not(pertence(NewPosicao,NewCaminho))),ListaSucessores),!.
estende(_,[]).


meta([7,A,L]) :- vazio(A), conta(L,N), 2 is N.

solucao_bl(Inicial,Solucao) :- bl([[[Inicial],[],[],[]]],Solucao).
bl([[[Posicao|Caminho], AADP,Depositado,Path]|_],[FinalPath,AADP,Depositado]) :- meta([Posicao,AADP,Depositado]), concatena([Posicao|Caminho], Path, FinalPath).
bl([Primeiro|Outros], Solucao) :- estende(Primeiro,Sucessores), concatena(Outros,Sucessores,NovaFronteira), bl(NovaFronteira,Solucao).
