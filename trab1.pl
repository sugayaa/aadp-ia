%objetos: aadp, lixeira, sujeiras, dock_station, elevadores, paredes
%[[[],[],[parede],[],[],[elevador],[],[],[],[]],
% [[],[],[parede],[],[],[elevador],[],[lixeira],[],[]],
% [[],[],[parede],[],[],[elevador],[],[],[],[]],
% [[],[],[parede],[],[sujeira],[elevador],[],[],[],[]],
% [[],[],[parede],[],[],[elevador],[],[aadp],[],[dock]]]


vazio(aadp).
cenario(sujo).0

%tratar existência da sujeira
pegou(aadp, Sujeira) :- (move(aadp, direita); move(aadp,  esquerda)), existe(Sujeira).

%tratar caso todas as sujeiras (mais de uma)
cenario(sujo) :- not(pegou(aadp, Sujeira)).
not(cenario(sujo)) :- pegou(aadp, Sujeira).

not(vazio(aadp)) :- pegou(aadp, Sujeira).
deposita(aadp, Lixeira) :- not(vazio(aadp)). #tratar caso 2 sujeiras
vazio(aadp) :- pegou(aadp, Sujeira), deposita(aadp, Lixeira).

%tratar parede() e elevador()
move(aadp, direita); move(aadp, esquerda) :- not(parede()).
move(aadp, cima); move(aadp, baixo) :- elevador().

entra(aadp, dock) :- vazio(aadp), not(cenario(sujo)).
