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
%meta(7).

%add final da lista
add_ultimo(Elem,[ ],[Elem]).
add_ultimo(Elem, [Cabeça|Cauda],[Cabeça|Cauda_Resultante]) :- add_ultimo(Elem,Cauda,Cauda_Resultante).
%é preciso definir oa que é parede
%setup %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pertence(Elem, [Elem|_]).
pertence(Elem, [_|Cauda]) :- pertence(Elem,Cauda).
%%%%
concatena([],L2,L2).
concatena([Cab|Cauda], L2,[Cab|Resultado]) :- concatena(Cauda, L2, Resultado).
aadp(X) :- not(parede(X)).
%só para testes
%parede(1).
%parede(2).
%parede(5).
%parede(3).
%%%%%%%%
%
%
/*
s(X, Y) :-          Y is (X + 1), not((10 - 1) =:= mod(X, 10)), not(parede((Y)));
                    Y is (X - 1), not(0 =:= mod(X,10)), not(parede(Y));
                    Y is (X + 10), not((5 - 1) =:= div(X, 5)), not(parede(Y));
                    Y is (X - 10), not(0 =:= div(X,5)), not(parede(Y)).
*/
copyList([],[]).
copyList([Cab|Cauda],[Cab|Resultado]) :- copyList(Cauda,Resultado).
%sujeira(3).
%lixeira(4).

esvazia([],[]).
esvazia([_|Cauda],R) :- esvazia(Cauda, R).

coletarSujeira([X,AADP,Depositados], [Y, NewAADP, NewDepositados]) :- Y is X, copyList(Depositados,NewDepositados), sujeira(X), not(pertence(X,AADP)), not(pertence(X,Depositados)), possoPegar(AADP), add_ultimo(X, AADP, NewAADP),!.

possoPegar(X) :- conta(X,N), N < 2.
naoVazio(X) :- conta(X,N), N \== 0.
vazio(X) :- conta(X,N), N == 0.
staticEnv(A,B,C,D) :- copyList(A,C), copyList(B,D).

/*
s([X,AADP,Depositados], [Y, NewAADP, NewDepositados]) :-
                    %encontrou sujeira
                    Y is X, copyList(Depositados,NewDepositados),
                    sujeira(X), not(pertence(X,AADP)), not(pertence(X,Depositados)),
                    possoPegar(AADP), add_ultimo(X, AADP, NewAADP), !;
                    %se encontrou sujeira e ainda nao pegou, pega e nao se move
                    
                    %encontrou lixeira
                    Y is X, concatena(Depositados,AADP,NewDepositados),
                    lixeira(X), naoVazio(AADP), esvazia(AADP, NewAADP), !;
                    %se encontrou lixeira e esvaziou, nao se move

                    %movimentacao
                    Y is (X + 1), not((10 - 1) =:= mod(X, 10)), not(parede((Y))), staticEnv(Depositados, AADP, NewDepositados, NewAADP);
                    Y is (X - 1), not(0 =:= mod(X,10)), not(parede(Y)), staticEnv(Depositados, AADP, NewDepositados, NewAADP);
                    Y is (X + 10), not((5 - 1) =:= div(X, 5)), not(parede(Y)), staticEnv(Depositados, AADP, NewDepositados, NewAADP);
                    Y is (X - 10), not(0 =:= div(X,5)), not(parede(Y)), staticEnv(Depositados, AADP, NewDepositados, NewAADP).
                */
%
%
%%%%%%%

plusEmpty(X,[[],X]).
insere_primeira(X,Y,[X|Y]).



s([[X|Caminho], AADP, Depositados], [[Y|NewCaminho], NewAADP, NewDepositados], Path) :-
                    
                    %encontrou sujeira
                    Y is X, copyList(Depositados,NewDepositados),
                    sujeira(X), not(pertence(X,AADP)), not(pertence(X,Depositados)),
                    possoPegar(AADP), add_ultimo(X, AADP, NewAADP),
                    concatena(Caminho,Path,Path),esvazia(Caminho,NewCaminho),!; %%%%%%%%%% adicionei isso aqui
                    %se encontrou sujeira e ainda nao pegou, pega e nao se move
                    
                    %encontrou lixeira
                    Y is X, concatena(Depositados,AADP,NewDepositados),
                    lixeira(X), naoVazio(AADP), esvazia(AADP, NewAADP),
                    concatena(Caminho,Path,Path), esvazia(Caminho,NewCaminho),!;
                    %se encontrou lixeira e esvaziou, nao se move
 
                    %movimentacao
                    %esquerda
                    Y is (X + 1), not((10 - 1) =:= mod(X, 10)),
                    not(parede((Y))), insere_primeira(X,Caminho,NewCaminho),
                    staticEnv(Depositados, AADP, NewDepositados, NewAADP);

                    %direita
                    Y is (X - 1), not(0 =:= mod(X,10)),
                    not(parede(Y)), insere_primeira(X,Caminho,NewCaminho),
                    staticEnv(Depositados, AADP, NewDepositados, NewAADP);

                    %cima
                    Y is (X + 10), not((5 - 1) =:= div(X, 5)),
                    not(parede(Y)), elevador(Y), insere_primeira(X,Caminho,NewCaminho),
                    staticEnv(Depositados, AADP, NewDepositados, NewAADP);

                    %baixo
                    Y is (X - 10), not(0 =:= div(X, 5)),
                    not(parede(Y)), elevador(Y), insere_primeira(X,Caminho,NewCaminho),
                    staticEnv(Depositados, AADP, NewDepositados, NewAADP).




s2([[X|Caminho], AADP, Depositados,Path], [[Y|NewCaminho], NewAADP, NewDepositados,NewPath]) :-
                    
                    %encontrou sujeira
                    Y is X, copyList(Depositados,NewDepositados),
                    sujeira(X), not(pertence(X,AADP)), not(pertence(X,Depositados)),
                    possoPegar(AADP), add_ultimo(X, AADP, NewAADP),
                    concatena(Caminho,Path,NewPath),esvazia(Caminho,NewCaminho),!; %%%%%%%%%% adicionei isso aqui
                    %se encontrou sujeira e ainda nao pegou, pega e nao se move
                    
                    %encontrou lixeira
                    Y is X, concatena(Depositados,AADP,NewDepositados),
                    lixeira(X), naoVazio(AADP), esvazia(AADP, NewAADP),
                    concatena(Caminho,Path,NewPath), esvazia(Caminho,NewCaminho),!;
                    %se encontrou lixeira e esvaziou, nao se move
 
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






%estende([[Posicao|Caminho], AADP, Depositados],ListaSucessores):- bagof([[NewPosicao,Posicao|Caminho],NewAADP,NewDepositados],  (s([Posicao,AADP,Depositados],[NewPosicao,NewAADP,NewDepositados]),not(pertence(NewPosicao,Caminho))), ListaSucessores),!.

estende([[Posicao|Caminho], AADP, Depositados,Path],ListaSucessores):- 
bagof(
[[NewPosicao|NewCaminho],NewAADP,NewDepositados,Path],
(s([[Posicao|Caminho],AADP,Depositados],[[NewPosicao|NewCaminho],NewAADP,NewDepositados], Path), not(pertence(NewPosicao,NewCaminho))),
ListaSucessores),!.
estende(_,[]).



estende2([[Posicao|Caminho], AADP, Depositados,Path],ListaSucessores):- 
bagof(
[[NewPosicao|NewCaminho],NewAADP,NewDepositados,NewPath],
(s2([[Posicao|Caminho],AADP,Depositados,Path],[[NewPosicao|NewCaminho],NewAADP,NewDepositados,NewPath]), not(pertence(NewPosicao,NewCaminho))),
ListaSucessores),!.
estende2(_,[]).
















meta([7,A,L]) :- vazio(A), conta(L,N), 2 is N.
%aqui bobona
%solucao_bl(Inicial,Solucao) :- bl([[Inicial]],Solucao).
solucao_bl(Inicial,Solucao)  :-  bl([[[Inicial],[],[]]],Solucao).

%bl tem dois argumentos, o primeiro estado no primeiro argumento, e o segundo argumento retornará a solução
%essa tranqueira de notação é para pegarmos a primeira lista de F, cada lista de F contem o estado atual, e o caminho até ele
%no caso da primeira iteração tem uma lista = [posição_inicial| [] ] <- coloquei a lista vazia só para ficar mais claro
%bl([[Estado|Caminho]|_],[Estado|Caminho]) :- meta(Estado).
%coloquei path
bl([[[Posicao|Caminho],AADP,Depositado,Path]|_],[FinalPath,AADP,Depositado]) :- meta([Posicao,AADP,Depositado]), concatena([Posicao|Caminho],Path,FinalPath).
%verifica se é a meta


 bl([Primeiro|Outros], Solucao) :-  estende(Primeiro,Sucessores), concatena(Outros,Sucessores,NovaFronteira),  bl(NovaFronteira,Solucao).
%isola primeiro estado, que é uma lista e denomina-o Primeiro, resto da lista de estados(listas) chama-se outros
%estende pega o primeiro estado, desse primeiro estado(lista), pega primeira posição que seria a posição atual, e aplica bagof(s), aquela nossa função de verificar adjacentes, o bagof retorna uma lista de listas que contem [nova_posicao,posição_atual|caminho]
%essa lista chama-se sucessores
%proxima função, concatena: pega essa lista de estados sucessores e concatena(insere no final) de Outros, lembrando que outros eram os próximos estados da nossa lista de bl, essa nova lista concatenada, ele chama de NovaFronteira
%ultima funcao, bl: chama bl para a nova fronteira, buscando a solução
%




solucao_bl2(Inicial,Solucao) :- bl2([[[Inicial],[],[],[]]],Solucao).
bl2([[[Posicao|Caminho], AADP,Depositado,Path]|_],[FinalPath,AADP,Depositado]) :- meta([Posicao,AADP,Depositado]), concatena([Posicao|Caminho], Path, FinalPath).
bl2([Primeiro|Outros], Solucao) :- estende2(Primeiro,Sucessores), concatena(Outros,Sucessores,NovaFronteira), bl2(NovaFronteira,Solucao).

