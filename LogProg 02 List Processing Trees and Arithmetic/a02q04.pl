% CS6374: Computational Logic - Assignment 02
% Rahul Nalawade [RSN170330]
% Date: 2018-02-01 

%------------------------------------------------
%i. Nth_traingular(N,T): T = N*(N-1)/2

% triangle(N,T): T is sum of first N natural numbers.
triangle(N,T) :- triangle(0,N,0,T).

triangle(I,N,A,T) :- 
    I < N, I1 is I+1,
    A1 is A+I1, triangle(I1,N,A1,T).

triangle(N,N,T,T).

%------------------------------------------------
%iii. between(I,J,K): K is an integer between the 
%   integers I and J inclusive.

between(I,J,J) :- I =< J.
between(I,J,K) :- I < J, J1 is J-1, between(I,J1,K).

%------------------------------------------------
%vi. min(List,least): least integer from List
%min([M|_],M) :- min([M|_],M).
min([M],M).
min([H|T],H) :- 
    min(T,M), H =< M.
min([H|T],M) :- 
    min(T,M), M < H.

%------------------------------------------------
%vii. length_itr(List,A,L): L is length of List, 
%   A being accumulator

lengthL([],0).
lengthL([H|T],L) :- length_itr([H|T],0,L).
length_itr([_|T],A,L) :- 
    A1 is A+1,
    length_itr(T,A1,L).

length_itr([],A,A).

%------------------------------------------------