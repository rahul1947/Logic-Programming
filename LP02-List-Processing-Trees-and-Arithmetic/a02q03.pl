% CS6374: Computational Logic - Assignment 02
% Rahul Nalawade [RSN170330]
% Date: 2018-Feb-01 

%-------------- From Assignment 01 --------------
% Implement the programs discussed in class for plus, times, and 
% greater than using the successor representation of natural numbers.

nat(0).
nat(s(X)) :- nat(X).

% plus(X,Y,Z): Z = X + Y
plus(0,Y,Y) :- nat(Y).

% plus(Y,0,Y) :- nat(Y).
plus(s(X),Y,s(Z)) :- plus(X,Y,Z).

% times(X,Y,Z): Z = X*Y
times(0,Y,0) :- nat(Y).

times(s(X),Y,A) :- 
    times(X,Y,Z), plus(Z,Y,A).

% greaterthan(X,Y): X > Y
greaterthan(s(X),0) :- nat(X).
greaterthan(s(X),s(Y)) :- greaterthan(X,Y).

% lessthan(X,Y): X < Y
lessthan(0,s(X)) :- nat(X).
lessthan(s(X),s(Y)) :- lessthan(X,Y).

% Write a program for computing the quotient and remainder of two 
% numbers (use the successor representation of numbers).

% grteq(X,Y): X >= Y
grteq(0,0).
grteq(s(X),0) :- nat(X).
grteq(s(X),s(Y)) :- grteq(X,Y).

% minus(X,Y,Z): Z = X - Y
minus(Y,0,Y) :- nat(Y),!.
minus(s(X),s(Y),Z) :-
    grteq(s(X),s(Y)), minus(X,Y,Z).
% minus(X,Y,Z) :- plus(Y,Z,X).

% division(X,Y,Q,R): X = Y*Q + R
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

%---------------- Assignment 02 -----------------
% defining nodes
%X = node(s(s(s(0))), X2, X3).
%X1 is node(s(s(0)), X4, nil).
%X2 is node(s(s(s(s(s(s(0)))))), X5, X6).
%X3 is node(s(0), nil, nil).
%X4 is node(s(s(s(s(0)))), nil, X7).
%X5 is node(s(s(s(s(s(s(s(0))))))), nil, nil).
%X6 is node(s(s(s(s(s(0))))), nil, nil).
%X = node(s(s(s(s(s(s(s(0))))))), X, X).

tree(s(s(s(0))), tree(s(s(0)), tree(s(0), nil, nil), nil), tree(s(s(s(s(s(s(0)))))), tree(s(s(s(s(0)))), nil, tree(s(s(s(s(s(0))))), nil, nil)), tree(s(s(s(s(s(s(s(0))))))), nil, nil))).

% bin_tree(Tree): checks if Tree is Binary tree or not
bin_tree(nil).
bin_tree(tree(_,L,R)) :- 
    bin_tree(L), bin_tree(R).

% treeMember(X,node): is node member of tree rooted at X? 
treeMember(X,tree(X,_,_)).

treeMember(X,tree(Y,L,_)) :- 
    lessthan(X,Y), 
    treeMember(X,L).

treeMember(X,tree(Y,_,R)) :- 
    greaterthan(X,Y),
    treeMember(X,R).

%------------------- SumTree --------------------

sumTree(nil,0).

%sumTree(tree(X,nil,nil), X).

%sumTree(tree(X,nil,R),S) :- 
%   sumTree(R,R1), plus(R1,X,S).

%sumTree(tree(X,L,nil),S) :- 
%   sumTree(R,L1), plus(L1,X,S).
    
sumTree(tree(X,L,R),N) :- 
    sumTree(L,N1), sumTree(R,N2),
    plus(N1,N2,N0), plus(X,N0,N).

%------------------- deletion -------------------
% delete(E,T,Tn): delete the element E from SBT T 
%   to obtain SBT Tn.

% when E is leaf
deleteT(tree(X,nil,nil),T,Tn) :- 
    substituteT(tree(X,nil,nil),nil,T,Tn).

% when E has a single child
deleteT(tree(X,nil,R),T,Tn) :- 
    substituteT(tree(X,nil,R),R,T,Tn1),
    deleteT(R,Tn1,Tn).

deleteT(tree(X,L,nil),T,Tn) :- 
    substituteT(tree(X,L,nil),L,T,Tn1),
    deleteT(L,Tn1,Tn).

% when E has two children
deleteT(tree(X,L,R),T,Tn) :- 
    inOrderSuccessor(Xios,X,T),
    substitute(tree(X,L,R),tree(Xios,L,R),T,Tn1),
    deleteT(tree(Xios,L1,R1),Tn1,Tn).

% substitute(X,Y,TreeX,TreeY): TreeY is result of 
% replacing all occurrences of X in TreeX with Y.
substituteT(X,Y,nil,nil).

substituteT(X,Y,tree(M,ML,MR),tree(N,NL,NR))    :- 
    replace(X,Y,X,Y),
    substituteT(X,Y,ML,NL),
    substituteT(X,Y,MR,NR).

replace(X,Y,X,Y).
replace(X,Y,Z,Z) :- X \= Z.

% inorder(Tree,Iot): Iot is inorder traversal of Tree
inorder(tree(X,L,R), Xs) :-
    inorder(L,Ls), inorder(R,Rs), append(Ls,[X|Rs],Xs).
inorder(nil,[]).

% inOrderSuccessor(X,Y,T): X is inorder successor of Y
%   in tree T.
inOrderSuccessor(X,Y,Tree) :- 
    inorder(Tree,T),
    sublist([Y, X|Tails],T),
    nat(X), nat(Y).
    %succ(X,Y,T).

% succ(X,Y,List): X is after Y in List
succ(X,Y,[Y,X|_]) :- nat(X).
succ(X,Y,[_|T]) :- 
    succ(X,Y,T).

% sublist(Sub,List): Sub is a sublist of List.
% c: recursive definition of a sublist
sublist(Xs,Ys) :- prefix(Xs,Ys).
sublist(Xs,[Heads|Ys]) :- sublist(Xs,Ys).

%------------------------------------------------
