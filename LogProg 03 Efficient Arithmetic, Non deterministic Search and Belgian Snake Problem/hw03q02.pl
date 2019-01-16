% CS6374: Computational Logic - Homework 03
% Rahul Nalawade [RSN170330]
% Date: 2018-02-12 

%------------------------- Q2 -----------------------------
%i. occurrences(Sub,Term,N): N is the no of occurrences
%	of subterm Sub in Term. Assume that Term is ground.
occurrences(Sub,Term,N) :- 
	occurrences(Sub,Term,0,N).

occurrences(Term,Term,N,R) :- 
	N1 is N+1, 
	compound(Term), !,
	Term=..[_|Args], occurrencesList(Term,Args,N1,R).

occurrences(Sub,Term,N,R) :- 
	compound(Term), !,
	Term=..[_|Args], occurrencesList(Sub,Args,N,R).

occurrences(Term,Term,N,N1) :- N1 is N+1.
occurrences(_,_,N,N).

occurrencesList(_,[],N,N).
occurrencesList(Sub,[Arg|Args], N, N2) :- 
	occurrencesList(Sub,Args,N,N1), 
	occurrences(Sub,Arg,N1,N2).

% subterm(Sub,Term): Sub is subterm of the ground term 
%	Term.
subterm(Term,Term). 
subterm(Sub,Term) :- 
	compound(Term), functor(Term,_,N), 
	subterm(N,Sub,Term).

subterm(N,Sub,Term) :- 
	N > 1, N1 is N-1, subterm(N1,Sub,Term).

subterm(N,Sub,Term) :- 
	arg(N,Term,Arg), subterm(Sub,Arg).

%----------------------------------------------------------
% ?- functor(length([a,c,e,r],5), length,M).
% M = 2.

% ?- functor(length(_), F, M).
% F = length,
% M = 1.

% ?- functor(length([a,c,e,r],5), length,2).
% true.

% ?- arg(2,length([m,n],X),2).
% X = 2.

% ?- arg(2,length([m,n],2),X).
% X = 2.

%----------------------------------------------------------
%ii. position(Subterm,Term,Position): Position is a list 
% of argument positions identifying Subterm within Term.
position(Sub,Sub,[]).
position(Sub,Term,[N|T]) :- 
	compound(Term), arg(N,Term,Arg), 
	subterm(Sub,Arg), position(Sub,Arg,T).

%----------------------------------------------------------
%iv. functor and arg using UNIV
functr(Term, F, N) :- 
	Term=..[F|T], length(T,N).

argUV(N,Term,Arg) :- 
	Term=..[_|T], nth1(N,T,Arg).

%----------------------------------------------------------
%v. Rewrite Program 9.3 for substitute so that it uses univ.
% substitute(Old,New,OldTerm,NewTerm): NewTerm is the result
% of replacing all occurrences of Old in OldTerm by New.

substitute(Old,New,Old,New).

substitute(Old,_,Term,Term) :- 
	constant(Term), Term \== Old.

substitute(Old,New,Term,Term1) :- 
	compound(Term), functor(Term,F,N), 
	functor(Term1,F,N), substitute(N,Old,New,Term,Term1).

substitute(N,Old,New,Term,Term1) :-
	N > 0, arg(N,Term,Arg), 
	substitute(Old,New,Arg,Arg1),
	arg(N,Term1,Arg1), N1 is N-1, 
	substitute(N1,Old,New,Term,Term1).

substitute(0,_,_,_,_).

constant(X) :- atomic(X).

%----------------------------------------------------------
% sub2(Old,New,TermO,TermN): other version of substitute, using UNIV.
% Substituting Old from TermO, with New to give TermN.

sub2(Old,New,Old,New).
sub2(Old,_,Term,Term) :- 
	constant(Term), Term \== Old.

sub2(Old,New,TermO,TermN) :- 
	TermO =.. [Old|T],
	TermN =.. [New|T].

sub2(Old,New,TermO,TermN) :- 
	functor(TermO,F,N), functor(TermN,F,N),
	TermO =.. Lo, TermN =.. Ln,
	nth1(I,Lo,Old), nth1(I,Ln,New),
	length(Lo,G), I1 is I-1, I2 is I+1,
	( I \= G -> 
		slice(Lo,1,I1,L), slice(Ln,1,I1,L),
		slice(Lo,I2,G,R), slice(Ln,I2,G,R);
		slice(Lo,1,I1,L), slice(Ln,1,I1,L)).

%-------------------- OLD PREDICATES ----------------------
% slice(L1,I,K,L2): L2 is the list of the elements of L1 
% between index I and index K (both included).
% (list,integer,integer,list) (?,+,+,?)

slice([X|_],1,1,[X]).
slice([X|Xs],1,K,[X|Ys]) :- K > 1, 
	K1 is K-1, slice(Xs,1,K1,Ys).
slice([_|Xs],I,K,Ys) :- I > 1, 
	I1 is I-1, K1 is K-1, slice(Xs,I1,K1,Ys).

%----------------------------------------------------------