%conta
conta([],0).
conta([_|Cauda], N) :- conta(Cauda, N1), N is N1 + 1.

%add final da lista
add_ultimo(Elem,[ ],[Elem]).
add_ultimo(Elem, [Cabeça|Cauda],[Cabeça|Cauda_Resultante]) :- add_ultimo(Elem,Cauda,Cauda_Resultante).
%é preciso definir oa que é parede
parede(-33).
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
sujeira(3).
lixeira(4).

esvazia([],[]).
esvazia([_|Cauda],R) :- esvazia(Cauda, R).

coletarSujeira([X,AADP,Depositados], [Y, NewAADP, NewDepositados]) :- Y is X, copyList(Depositados,NewDepositados), sujeira(X), not(pertence(X,AADP)), not(pertence(X,Depositados)), possoPegar(AADP), add_ultimo(X, AADP, NewAADP),!.

possoPegar(X) :- conta(X,N), N < 2.
naoVazio(X) :- conta(X,N), N \== 0.
vazio(X) :- conta(X,N), N == 0.
staticEnvironment(A,B,C,D) :- copyList(A,C), copyList(B,D).

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
                    Y is (X + 1), not((10 - 1) =:= mod(X, 10)), not(parede((Y))), staticEnvironment(Depositados, AADP, NewDepositados, NewAADP);
                    Y is (X - 1), not(0 =:= mod(X,10)), not(parede(Y)), staticEnvironment(Depositados, AADP, NewDepositados, NewAADP);
                    Y is (X + 10), not((5 - 1) =:= div(X, 5)), not(parede(Y)), staticEnvironment(Depositados, AADP, NewDepositados, NewAADP);
                    Y is (X - 10), not(0 =:= div(X,5)), not(parede(Y)), staticEnvironment(Depositados, AADP, NewDepositados, NewAADP).
%
%
%%%%%%%

%my3([X1,X2,X3],[Y1,Y2,Y3]) :- Y1 is X1 + 1, Y2 is X2 + 1, Y3 is X3 + 1.
sucessores(X,L) :- bagof(Y, s(X,Y,4,4),L),not(parede(X)).

estende([[Posicao|Caminho], AADP, Depositados],ListaSucessores):- bagof([[NewPosicao,Posicao|Caminho],NewAADP,NewDepositados],  (s([Posicao,AADP,Depositados],[NewPosicao,NewAADP,NewDepositados]),not(pertence(NewPosicao,Caminho))), ListaSucessores),!.
estende(_,[]).
%estende([[Estado|Caminho]|Ambiente],ListaSucessores):- bagof([[Sucessor,Estado|Caminho]|Ambiente],  (s(Estado,Sucessor),not(pertence(Sucessor,[Estado|Caminho]))), ListaSucessores),!.

%estende([Estado|Caminho],ListaSucessores):- bagof([Sucessor,Estado|Caminho], (s(Estado,Sucessor),not(pertence(Sucessor,[Estado|Caminho]))), ListaSucessores),!.

%estende(_,[]).

%meta(7).
meta([7,A,L]) :- vazio(A), conta(L,N), 1 is N.
%aqui bobona
%solucao_bl(Inicial,Solucao) :- bl([[Inicial]],Solucao).
solucao_bl(Inicial,Solucao) :- bl([[[Inicial],[],[]]],Solucao).

%bl tem dois argumentos, o primeiro estado no primeiro argumento, e o segundo argumento retornará a solução
%essa tranqueira de notação é para pegarmos a primeira lista de F, cada lista de F contem o estado atual, e o caminho até ele
%no caso da primeira iteração tem uma lista = [posição_inicial| [] ] <- coloquei a lista vazia só para ficar mais claro
%bl([[Estado|Caminho]|_],[Estado|Caminho]) :- meta(Estado).
bl([[[Posicao|Caminho],AADP,Depositado]|_],[[Posicao|Caminho],AADP,Depositado]) :- meta([Posicao,AADP,Depositado]).
%verifica se é a meta

bl([Primeiro|Outros], Solucao) :- estende(Primeiro,Sucessores), concatena(Outros,Sucessores,NovaFronteira), bl(NovaFronteira,Solucao).
%bl([Primeiro|Outros], Solucao) :- estende(Primeiro,Sucessores), concatena(Outros,Sucessores,NovaFronteira), bl(NovaFronteira,Solucao).
%isola primeiro estado, que é uma lista e denomina-o Primeiro, resto da lista de estados(listas) chama-se outros
%estende pega o primeiro estado, desse primeiro estado(lista), pega primeira posição que seria a posição atual, e aplica bagof(s), aquela nossa função de verificar adjacentes, o bagof retorna uma lista de listas que contem [nova_posicao,posição_atual|caminho]
%essa lista chama-se sucessores
%proxima função, concatena: pega essa lista de estados sucessores e concatena(insere no final) de Outros, lembrando que outros eram os próximos estados da nossa lista de bl, essa nova lista concatenada, ele chama de NovaFronteira
%ultima funcao, bl: chama bl para a nova fronteira, buscando a solução
%
