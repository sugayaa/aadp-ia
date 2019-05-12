
aadp(X) :- not(parede(X)).
%só para testes
%parede(1).
%parede(2).
%parede(5).
%parede(3).
%%%%%%%%
%
%
s(X, Y, Largura, Comprimento) :-            Y is (X + 1), not((Largura - 1) =:= mod(X, Largura)), not(parede((Y)));
                                            Y is (X - 1), not(0 =:= mod(X,Largura)), not(parede(Y));
                                            Y is (X + Largura), not((Comprimento - 1) =:= div(X, Comprimento)), not(parede(Y));
                                            Y is (X - Largura), not(0 =:= div(X,Comprimento)), not(parede(Y)).
%
%
%%%%%%%
sucessores(X,L) :- bagof(Y, s(X,Y,4,4),L),not(parede(X)).

estende([Estado|Caminho],ListaSucessores):- bagof([Sucessor,Estado|Caminho], (s(Estado,Sucessor),not(pertence(Sucessor,[Estado|Caminho]))), ListaSucessores),!.

estende(_,[]).

meta(7).
%aqui bobona
solucao_bl(Inicial,Solucao) :- bl([[Inicial]],Solucao).

%bl tem dois argumentos, o primeiro estado no primeiro argumento, e o segundo argumento retornará a solução
%essa tranqueira de notação é para pegarmos a primeira lista de F, cada lista de F contem o estado atual, e o caminho até ele
%no caso da primeira iteração tem uma lista = [posição_inicial| [] ] <- coloquei a lista vazia só para ficar mais claro
bl([[Estado|Caminho]|_],[Estado|Caminho]) :- meta(Estado).
%verifica se é a meta

bl([Primeiro|Outros], Solucao) :- estende(Primeiro,Sucessores), concatena(Outros,Sucessores,NovaFronteira), bl(NovaFronteira,Solucao). 
%isola primeiro estado, que é uma lista e denomina-o Primeiro, resto da lista de estados(listas) chama-se outros
%estende pega o primeiro estado, desse primeiro estado(lista), pega primeira posição que seria a posição atual, e aplica bagof(s), aquela nossa função de verificar adjacentes, o bagof retorna uma lista de listas que contem [nova_posicao,posição_atual|caminho]
%essa lista chama-se sucessores
%proxima função, concatena: pega essa lista de estados sucessores e concatena(insere no final) de Outros, lembrando que outros eram os próximos estados da nossa lista de bl, essa nova lista concatenada, ele chama de NovaFronteira
%ultima funcao, bl: chama bl para a nova fronteira, buscando a solução
%

