:- [prolog_flags].
:- [ambiente].
:- [funcoes].


%função de sucessão
s([[X|Caminho], AADP, Depositados, Path], [[Y|NewCaminho], NewAADP, NewDepositados, NewPath]) :-

                    %encontrou sujeira
                    Y is X, copyList(Depositados,NewDepositados), sujeira(S),
                    pertence(X, S), not(pertence(X,AADP)), not(pertence(X,Depositados)),
                    possoPegar(AADP), add_ultimo(X, AADP, NewAADP),
                    concatena([X|Caminho],Path,NewPath),esvazia(Caminho,NewCaminho),!;
                    %concatena(Caminho,Path,NewPath),esvazia(Caminho,NewCaminho),!;
                    
                    %encontrou lixeira
                    Y is X, concatena(Depositados,AADP,NewDepositados), lixeira(L),
                    pertence(X, L), naoVazio(AADP), esvazia(AADP, NewAADP),
                    %concatena(Caminho,Path,NewPath), esvazia(Caminho,NewCaminho),!;
                    concatena([X|Caminho],Path,NewPath), esvazia(Caminho,NewCaminho),!;

                    
 
                    %movimentacao
                    %esquerda
                    Y is (X + 1), not((10 - 1) =:= mod(X, 10)), parede(P),
                    not(pertence(Y, P)), insere_primeira(X,Caminho,NewCaminho),
                    staticEnv(Depositados, AADP, Path, NewDepositados, NewAADP, NewPath);

                    %direita
                    Y is (X - 1), not(0 =:= mod(X,10)), parede(P),
                    not(pertence(Y, P)), insere_primeira(X,Caminho,NewCaminho),
                    staticEnv(Depositados, AADP, Path, NewDepositados, NewAADP, NewPath);

                    %cima
                    Y is (X + 10), Y =< 49, parede(P), elevador(E),
                    not(pertence(Y, P)), pertence(Y, E), insere_primeira(X,Caminho,NewCaminho),
                    staticEnv(Depositados, AADP, Path, NewDepositados, NewAADP, NewPath);

                    %baixo
                    Y is (X - 10), Y >= 0, parede(P), elevador(E),
                    not(pertence(Y, P)), pertence(Y, E), insere_primeira(X,Caminho,NewCaminho),
                    staticEnv(Depositados, AADP, Path, NewDepositados, NewAADP, NewPath).


%função estende, consiste de um bagof com possíveis estados sucessores, e nova chamada de bl com NovaFronteira                    
estende([[Posicao|Caminho], AADP, Depositados,Path],ListaSucessores):- bagof([[NewPosicao|NewCaminho],NewAADP,NewDepositados,NewPath],(s([[Posicao|Caminho],AADP,Depositados,Path],[[NewPosicao|NewCaminho],NewAADP,NewDepositados,NewPath]), not(pertence(NewPosicao,NewCaminho))),ListaSucessores),!.
estende(_,[]).


%definição de meta
meta([D,A,L]) :- vazio(A), sujeira(S), conta(S, NS), conta(L,N), NS is N, docker(D).


%busca em 
solucao_bl(Inicial,[SolucaoInvertida, AADP, Depositados]) :- bl([[[Inicial],[],[],[]]],[Solucao, AADP, Depositados]), inverte(Solucao,SolucaoInvertida).
bl([[[Posicao|Caminho], AADP,Depositado,Path]|_],[FinalPath,AADP,Depositado]) :- meta([Posicao,AADP,Depositado]), concatena([Posicao|Caminho], Path, FinalPath).
bl([Primeiro|Outros], Solucao) :- estende(Primeiro,Sucessores), concatena(Outros,Sucessores,NovaFronteira), bl(NovaFronteira,Solucao).
