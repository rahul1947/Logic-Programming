% CS6374: Computational Logic - Assignment 02
% Rahul Nalawade [RSN170330]
% Date: 2018-02-01 

%------------------------------------------------
member(X,[X|_]).
member(X,[_|Y]) :- member(X,Y).

%------------------------------------------------
prefix([],_).
prefix([H|X],[H|Y]) :- prefix(X,Y).

suffix(X,X).
suffix(X,[_|Y]) :- suffix(X,Y).

%------------------------------------------------
append([],Y,Y).
append([H|X],Y,[H|Z]) :- append(X,Y,Z).

%------------------------------------------------
% sublist(Sub,List): Sub is a sublist of List.

% a: suffix of a prefix
%sublist(Xs,Ys) :- prefix(Ps,Ys), suffix(Xs,Ps).

% b: prefix of a suffix 
%sublist(Xs,Ys) :- prefix(Xs,Ss), suffix(Ss,Ys).

% c: recursive definition of a sublist
sublist(Xs,Ys) :- prefix(Xs,Ys).
sublist(Xs,[_|Ys]) :- sublist(Xs,Ys).

%------------------------------------------------
subsequence([X|Xs],[X|Ys]) :- subsequence(Xs,Ys). 
subsequence(Xs,[_|Ys]) :- subsequence(Xs,Ys). 
subsequence([],_).

%------------------------------------------------
% before(X,Y,List): X is before Y in List
before(X,Y,[X,Y|_]).
before(X,Y,[_|T]) :- 
    before(X,Y,T).

% after(X,Y,List): X is after Y in List
after(X,Y,[Y,X|_]).
after(X,Y,[_|T]) :- 
    after(X,Y,T).

% adjacent(X,Y,List): X is adjacent to Y in List
adjacent(X,Y,List) :- 
    before(X,Y,List);
    after(X,Y,List).

% last(X,List): X is last element in List
last(X,[X]).
last(X,[_|T]) :- 
    last(X,T).

%------------------------------------------------
% double(L,LL): every element of L occure twice in LL
double([],[]).
double([H|T1],[H,H|T2]) :-
    double(T1,T2).

%------------------------------------------------
% reverse(List,Tsil): Tsil is the result of 
%   reversing the list List.

% a: Naive reverse

reverse([],[]).
reverse([X|Xs],Zs) :- reverse(Xs,Ys), append(Ys,[X],Zs).

% b: Reverse-accumulate
reverse(Xs,Ys) :- reverse(Xs,[],Ys).

reverse([X|Xs],Acc,Ys) :- reverse(Xs,[X|Acc],Ys).
reverse([],Ys,Ys).

%------------------------------------------------
