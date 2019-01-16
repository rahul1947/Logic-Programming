% CS6374: Computational Logic - Assignment 01
% Rahul Nalawade [RSN170330]
% Date: 2018-01-21 

%-------------------------------- Q6 --------------------------------

% Implement the programs discussed in class for plus, times, and 
% greater than using the successor representation of natural numbers.

nat(0).
nat(s(X)) :- nat(X).

% plus(X,Y,Z): Z = X + Y
plus(0,Y,Y) :- nat(Y).

% plus(Y,0,Y) :- nat(Y).

plus(s(X),Y,s(Z)) :- plus(X,Y,Z).

times(0,Y,0) :- nat(Y).

times(s(X),Y,A) :- 
    times(X,Y,Z), plus(Z,Y,A).

greaterthan(s(X),0) :- nat(X).

greaterthan(s(X),s(Y)) :- greaterthan(X,Y).

lessthan(0,s(X)) :- nat(X).

lessthan(s(X),s(Y)) :- lessthan(X,Y).

%-------------------------------- Q7 --------------------------------

% Use the definition of plus and times to implement the factorial 
% function. Will the factorial function work in the opposite 
% direction?

factorial(0,s(0)).

factorial(s(X),Y) :- 
    greaterthan(s(X),0),  
    factorial(X,Z),
    times(s(X),Z,Y).

% Yes, factorial function would work in opposite direction, 
% as shown with tail-recursion predicate fact(N,F) below.

fact(0,s(0)).

fact(s(X),Y) :- fact(s(X),s(0),Y).

fact(0,Y,Y). 

fact(s(X),A,Y) :- 
    greaterthan(s(X),0),
    times(s(X),A,Z),
    fact(X,Z,Y).

%-------------------------------- Q8 --------------------------------

% Write a program for computing the quotient and remainder of two 
% numbers (use the successor representation of numbers).


grteq(0,0).

grteq(s(X),0) :- nat(X).

grteq(s(X),s(Y)) :- grteq(X,Y).

minus(Y,0,Y) :- nat(Y),!.

minus(s(X),s(Y),Z) :-
    grteq(s(X),s(Y)), minus(X,Y,Z).

% minus(X,Y,Z) :- plus(Y,Z,X).

division(X,0,undefined,Q) :- nat(X), nat(Q).

division(0,s(Y),0,0) :- nat(Y).

division(X,Y,0,X) :- 
    X \== 0, Y \== 0, lessthan(X,Y).

division(X,Y,Q,R) :- 
    greaterthan(Y,0),
    grteq(X,Y),
    minus(X,Y,Z),
    division(Z,Y,W,R),
    plus(W,s(0),Q).

%-------------------------------- Q9 --------------------------------

% Write a logic program to define the relation fib(N,F) to determine 
% the Nth Fibonacci no (use the successor representation of numbers).

fib(0, s(0)) :- !.

fib(s(0), s(0)) :- !.

fib(s(s(X)), F) :-
    greaterthan(s(s(X)),s(0)),
    fib(s(X), F1),
    fib(X,F2),
    plus(F1,F2,F).

%--------------------------------------------------------------------
