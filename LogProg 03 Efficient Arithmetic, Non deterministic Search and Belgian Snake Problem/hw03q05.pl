% CS6374: Computational Logic - Homework 03
% Rahul Nalawade [RSN170330]
% Date: 2018-02-13

%-------------------------- Q5 ----------------------------
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
	X is Y+N; X is Y-N.
attack(X,N,[_|Ys]) :- 
	N1 is N+1, attack(X,N1,Ys).

% permutation(L1,P): P is a permutation of L1
permutation([],[]).
permutation(Xs,[Z|Zs]) :-
	select(Z,Xs,Ys), permutation(Ys,Zs).

% range(M,N,List): List is list of integers [M,N], M<N.
range(N,N,[N]).
range(M,N,[M|Ns]) :- 
	M < N, M1 is M+1, range(M1,N,Ns).

% select(X,List,R): R is a List with one removed X
select(X,[X|T],T).
select(X,[H|T],[H|R]) :- %X \= H, 
	select(X,T,R).

%----------------------------------------------------------