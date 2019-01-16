% CS6374: Computational Logic - Homework 05
% Rahul Nalawade [RSN170330]
% Date: 2018-03-26

:- use_module(library(clpfd)).

%-------------------------- Q1 ----------------------------
% queens(N,Queens): Queens is a placement that solves 
% the N queens problem, represented as a permutation of 
% the list of numbers [1,2,3,..,N].

queens(N,Qs) :- 
	range(1,N,Ns), permutation(Ns,Qs), safe(Qs).

% The placement Qs is safe/ valid.
safe([]).
safe([Q|Qs]) :- 
	safe(Qs), \+ attack(Q,Qs).

attack(X,Xs) :- attack(X,1,Xs).
attack(X,N,[Y|_]) :- 
	X #= Y+N; X #= Y-N.
attack(X,N,[_|Ys]) :- 
	N1 #= N+1, attack(X,N1,Ys).

% permutation(L1,P): P is a permutation of L1
permutation([],[]).
permutation(Xs,[Z|Zs]) :-
	select(Z,Xs,Ys), permutation(Ys,Zs).

% range(M,N,List): List is list of integers [M,N], M<N.
range(N,N,[N]).
range(M,N,[M|Ns]) :- 
	M #< N, M1 #= M+1, range(M1,N,Ns).

% select(X,List,R): R #= a List with one removed X
select(X,[X|T],T).
select(X,[H|T],[H|R]) :- %X \= H, 
	select(X,T,R).

%----------------------------------------------------------
% n_queens(N,Queens), label(Queens) same as 
% queens(N,Queens), but USING CLPFD inbuilt functions.

n_queens(N, Qs) :-
	length(Qs, N),
	%in place of range and premutation.
	Qs ins 1..N,
	safe_queens(Qs).

safe_queens([]).
safe_queens([Q|Qs]) :- 
	safe_queens(Qs, Q, 1), 
	safe_queens(Qs).

safe_queens([], _, _).
safe_queens([Q|Qs], Q0, D0) :- 
	%not in same row
	Q0 #\= Q,
	%diagonally safe
	abs(Q0 - Q) #\= D0,
	D1 #= D0 + 1,
	%recursive check
	safe_queens(Qs, Q0, D1).

%----------------------- COMMANDS -------------------------

%$ queens(4,Q).
%$ n_queens(4,Q), label(Q).

%---------------------- REFERRENCE ------------------------

% *IMPORTANT*
% http://www.swi-prolog.org/pldoc/man?section=clpfd-predicate-index
% http://www.swi-prolog.org/pldoc/man?section=clpfd

%---------------------- WHY CLPFD? ------------------------

% http://www.swi-prolog.org/man/clpfd.html
%?- X = 1+2.
%X = 1+2.
%
%?- X #= 1+2.
%X = 3.
%
%?- 3 #= X+2.
%X = 1.
%
%?- 3 = X+2.
%false.
%
%?- 2+3 =:= 6-1.
%true.

%----------------------------------------------------------