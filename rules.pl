idade(joao,5).
idade(ana,4).
idade(maria,5).
parent(eddard_stark, arya_stark).
parent(catelyn_stark, arya_stark).
%verifica se elemento pertence a lista
pertence(Elem,[Elem | _]).
pertence(Elem,[_ | Cauda]) :- pertence(Elem,Cauda).
%adicionar no final da lista
add_ultimo(Elem,[],[Elem]).
add_ultimo(Elem,[Cabeça|Cauda],[Cabeça|Cauda_Resultante]) :- add_ultimo(Elem,Cauda,Cauda_Resultante).
%retirar primeira ocorrencia do elemento
retirar_um_elemento(Elem,[Elem|Cauda],Cauda).
retirar_um_elemento(Elem,[Cabeça|Cauda],[Cabeça|Resultado]) :- retirar_um_elemento(Elem,Cauda,Resultado).
%remover todas as ocorrencias de um elemento da lista
remover_todos(Elem,[],[]).
remover_todos(Elem,[Elem|Cauda1],Resultado) :- remover_todos(Elem,Cauda1,Resultado).
remover_todos(Elem,[Cabeça|Cauda],[Cabeça|Cauda_Resposta]) :- Elem \== Cabeça, remover_todos(Elem,Cauda,Cauda_Resposta).
%concatenacao de duas listas
concatena([],L,L).
concatena([Cabeça|Cauda],L2,[Cabeça|Resultado]):-concatena(Cauda,L2,Resultado).

%buscassss



%s

s(X,[P1,[C1|L2]| Resto]):-retirar_um_elemento([C1|P1],X,Outros),retirar_um_elemento(L2,Outros,Resto),not((P1 = [],L2 = [])).

%definindo s generico, s das caixinhas


%estende
estende(_,[]).
estende([Estado|Caminho],ListaSucessores):-bagof([Sucessor,Estado|Caminho],(s(Estado,Sucessor),not(pertence(Sucessor,[Estado|Caminho]))),ListaSucessores),!.

%bfs
%encapsulamento
solucao_bl(Inicial,Solucao):-bl([[Inicial]],Solucao).

%caso primeiro estado de Fronteira for a meta
%if node is what we were looking for
bl([[Estado|Caminho]|_],[Estado|Caminho]):-meta(Estado).
%else, continua procurando
bl([Primeiro|Outros], Solucao) :- estende(Primeiro,Sucessores),concatena(Outros,Sucessores,NovaFronteira),bl(NovaFronteira,Solucao).
%Primeiro se refere a elemento(node|caminho)


%depthhhh first search
%encapsulamento_again
solucao_bp(Inicial,Solucao):-bp([],Inicial,Solucao).

%se current state is meta
bp(Caminho,Estado,[Estado|Caminho]) :- meta(Estado).
%else
bp(Caminho,Estado,Solucao) :- s(Estado,Sucessor),not(pertence(Sucessor,[Estado|Caminho])),bp([Estado|Caminho],Sucessor,Solucao).



