% CS6374: Computational Logic - Homework 03
% Rahul Nalawade [RSN170330]
% Date: 2018-02-22

%-------------------------------- Q6 ----------------------------------
search :- 
    write('D E M N O R S Y'), nl,
    Vars = [D,E,M,N,O,R,S,Y], 
    Values = [0,1,2,3,4,5,6,7,8,9],
    matchV2V(Values, Vars), 
    S > 0, M > 0,
        1000*S + 100*E + 10*N + D +
        1000*M + 100*O + 10*R + E =:= 
        10000*M + 1000*O + 100*N + 10*E + Y,
    writeList(Vars).

% matchV2V(L1,L2): produces all possible combinations of variables 
% of list L2, from list of values in L1. 
matchV2V(_, []).
matchV2V(Values, [Vr|Vrs]):- 
    select(Vr, Values, NewValues), 
    matchV2V(NewValues, Vrs).

% select(X,List,R): R is a List with one removed X
select(X,[X|T],T).
select(X,[H|T],[H|R]) :- %X \= H, 
    select(X,T,R).

% writes the List on a new-line
writeList([]) :- nl.
writeList([H|T]) :- write(H), write(' '), writeList(T).

%--------------------------- =:= OPERATOR -----------------------------
%?- 2+3 =:= 6-1.
%true.

%?- 2+3 is 6-1.
%false.

% TIP: If you just need arithmetic comparison, use =:=. 
% If you want to capture the result of an evaluation, use is.
