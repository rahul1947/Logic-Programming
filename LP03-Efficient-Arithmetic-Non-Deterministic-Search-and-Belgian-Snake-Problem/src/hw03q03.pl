% CS6374: Computational Logic - Homework 03
% Rahul Nalawade [RSN170330]
% Date: 2018-02-21

%------------------------- Q3 -----------------------------
%i. Define the system predicate \== using == and the 
% cut-fail combination.
notEq(X,Y) :- 
    neg(X==Y).

neg(P) :- P, !, fail.
neg(_).
%----------------------------------------------------------
%ii. Define nonvar using var and the cut-fail combination.

nonVar(Term):- var(Term), !, fail.
nonVar(Term):-
    neg(var(Term)).

%----------------------------------------------------------