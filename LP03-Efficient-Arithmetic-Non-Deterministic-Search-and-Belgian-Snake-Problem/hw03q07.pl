% CS6374: Computational Logic - Homework 03
% Rahul Nalawade [RSN170330]
% Date: 2018-02-17

%-------------------------- Q7 ----------------------------
male(avraham). male(binyamin). male(chaim). male(david). male(elazar).

female(zvia). female(chana). female(ruth). female(sarah). female(tamar).

%female(X) :- \+ male(X).

% preferences of each person.
prefList(avraham,chana,tamar,zvia,ruth,sarah).
prefList(binyamin,zvia,chana,ruth,sarah,tamar).
prefList(chaim,chana,ruth,tamar,sarah,zvia).
prefList(david,zvia,ruth,chana,sarah,tamar).
prefList(elazar,tamar,ruth,chana,zvia,sarah).

prefList(zvia,elazar,avraham,david,binyamin,chaim).
prefList(chana,david,elazar,binyamin,avraham,chaim).
prefList(ruth,avraham,david,binyamin,chaim,elazar).
prefList(sarah,chaim,binyamin,david,avraham,elazar).
prefList(tamar,david,binyamin,chaim,elazar,avraham).

% dynamically marriages are updated.
:- dynamic married/2.
married(avraham,zvia).	married(binyamin,chana).
married(chaim,ruth).	married(david,sarah).
married(elazar,tamar). 

% preferred(X,Y,List): in list List, X is preferred 
% over Y, where prefList if of Z.
preferred(X,Y,List) :- 
	prefList(Z,P1,P2,P3,P4,P5),
	prefList(Z,P1,P2,P3,P4,P5)=..[prefList,Z|List],
	before(X,Y,List).

% unstable(X,Y): marriage of X and Y is unstable.
%unstable(X,Y) :- 
%	prefList(X,P1,P2,P3,P4,P5), prefList(Y,Q1,Q2,Q3,Q4,Q5),
%	prefList(X,P1,P2,P3,P4,P5)=..[prefList,X|Lx],
%	prefList(Y,Q1,Q2,Q3,Q4,Q5)=..[prefList,Y|Ly],
%	married(X,Y), preferred(Px,X,Ly), preferred(Py,Y,Lx),
%	married(Px,Py).

% unstable(X,Y): marriage of X and Y is unstable.
% if married(X,Y), married(P,Q), preferred(Q,Y,Lx), preferred(X,P,Lq).
unstable(X,Y) :- 
	married(X,Y), 
	prefList(X,X1,X2,X3,X4,X5)=..[prefList,X|Lx],
	preferred(Q,Y,Lx), married(P,Q),
	prefList(Q,Q1,Q2,Q3,Q4,Q5)=..[prefList,Q|Lq],
	preferred(X,P,Lq).

% unstable(X,Y): marriage of X and Y is unstable.
% if married(X,Y), married(P,Q), preferred(P,X,Ly), preferred(Y,Q,Lp).
unstable(X,Y) :- 
	married(X,Y),
	prefList(Y,Y1,Y2,Y3,Y4,Y5)=..[prefList,Y|Ly],
	preferred(P,X,Ly), married(P,Q),
	prefList(P,P1,P2,P3,P4,P5)=..[prefList,P|Lp],
	preferred(Y,Q,Lp).
	

% unstableMarriages(X,Y): set of all unstable marriages.
unstableMarriages(X,Y) :- 
	setof((X,Y), unstable(X,Y), Pairs),
	member((X,Y), Pairs).

% stablize(X,Y): stablize unstable marriage of X and Y.
% if married(X,Y), married(P,Q), preferred(Q,Y,Lx), preferred(X,P,Lq).
stablize(X,Y) :-
	married(X,Y),
	prefList(X,X1,X2,X3,X4,X5)=..[prefList,X|Lx],
	preferred(Q,Y,Lx), married(P,Q),
	prefList(Q,Q1,Q2,Q3,Q4,Q5)=..[prefList,Q|Lq],
	preferred(X,P,Lq),

	retract(married(X,Y)),retract(married(P,Q)), 
	assert(married(X,Q)),assert(married(P,Y)).

% stablize(X,Y): stablize unstable marriage of X and Y.
% if married(X,Y), married(P,Q), preferred(P,X,Ly), preferred(Y,Q,Lp).
stablize(X,Y) :-
	married(X,Y),
	prefList(Y,Y1,Y2,Y3,Y4,Y5)=..[prefList,Y|Ly],
	preferred(P,X,Ly), married(P,Q),
	prefList(P,P1,P2,P3,P4,P5)=..[prefList,P|Lp],
	preferred(Y,Q,Lp),
	
	retract(married(X,Y)),retract(married(P,Q)), 
	assert(married(X,Q)),assert(married(P,Y)).

% stablizeMarriages(X,Y): stablize all unstable marriages.
stablizeMarriages(X,Y) :-
	unstableMarriages(X,Y),
	stablize(X,Y).

stableMarriages :-
	(\+ unstableMarriages(X,Y) -> writeMarriages, !;
		stablizeMarriages(X,Y), stableMarriages).

writeMarriages :- 
	married(X,Y), write(X), write(' - '), write(Y), nl.

% TIP: you may need to call stablizeMarriages(X,Y) multiple
% times, until if fails to give a solution.

%-------------------- OLD PREDICATES ----------------------
% before(X,Y,List): X is before Y in List
before(X,Y,List) :- justBefore(X,Y,List).
before(X,Y,List) :- 
	justBefore(Z,Y,List), before(X,Z,List).

justBefore(X,Y,[X,Y|_]).
justBefore(X,Y,[_|T]) :- justBefore(X,Y,T).

% writes the List on a new-line
writeList([]) :- nl.
writeList([H|T]) :- write(H), write(' '), writeList(T).
%----------------------------------------------------------