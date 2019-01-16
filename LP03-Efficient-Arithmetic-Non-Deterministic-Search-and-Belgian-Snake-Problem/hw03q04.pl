% CS6374: Computational Logic - Homework 03
% Rahul Nalawade [RSN170330]
% Date: 2018-02-14

%-------------------------- Q4 ----------------------------
% snake(Pattern,Row,Column): represents belgian snake 
% in Pattern forming a rectangle.
snake(_,_,[]).

snake(P,R,[C]) :- 
    makeFull(P,R,C,_), writeList(C).

snake(P,R,[C1,C2|Cs]) :- 
    makeFull(P,R,C1,P1),
    makeFull(P1,R,Temp,P2),
    reverse(Temp,C2),
    writeList(C1), writeList(C2),
    snake(P2,R,Cs).

%----------------------------------------------------------
% rotate([a,b,c],[b,c,a]) is true.
rotate([],[]).
rotate([X|T],R) :-
    append(T,[X],R).

% makeFull(Pattern,Row,R,Pn): Fills Row with cyclic 
% patterns to give R, with Pn as the last rotation. 
makeFull(Plast,[],[],Plast).
makeFull([P|Ps],[_|Rs],[P|Ls],Plast) :- 
    rotate([P|Ps],Pnext),
    makeFull(Pnext,Rs,Ls,Plast).

% writes the List on a new-line
writeList([]) :- nl.
writeList([H|T]) :- write(H), write(' '), writeList(T).

%-------------------- OLD PREDICATES ----------------------
% append(X,Y,Z): appends Y to X to give Z.
append([],[],[]).
append(Y,[],Y).
append([],Y,Y).
append([H|X],Y,[H|Z]) :- append(X,Y,Z).

% b: Reverse-accumulate
reverse(Xs,Ys) :- reverse(Xs,[],Ys).

reverse([X|Xs],Acc,Ys) :- reverse(Xs,[X|Acc],Ys).
reverse([],Ys,Ys).

%----------------------------------------------------------