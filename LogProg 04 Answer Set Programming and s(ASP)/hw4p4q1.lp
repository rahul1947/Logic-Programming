% CS6374: Computational Logic - Homework 04
% Rahul Nalawade [RSN170330]
% Date: 2018-03-25

node(1). node(2). node(3). node(4). node(5).

edge(1,2). 
edge(1,3). 
edge(2,4). 
edge(2,5). 
edge(3,4). 
edge(3,5).

%% each node is assigned a color
color(X,red):- not color(X,green), not color(X, yellow).
color(X,yellow):- not color(X,green), not color(X, red).
color(X,green):- not color(X,red), not color(X, yellow).

%% constraint checking
:- edge(X,Y), color(X,C), color(Y,C).

%----------------------------------------------------------

%graphColors is [color(1,C1), color(2,C2), color(3,C3), color(4,C4), color(5,C5)].
%?- color(1,C1), color(2,C2), color(3,C3), color(4,C4), color(5,C5).

%rahul:sasp-1.1.0$ ./sasp test/graphcoloring.lp