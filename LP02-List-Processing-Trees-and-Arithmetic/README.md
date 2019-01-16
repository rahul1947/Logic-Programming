## Logic Programming 02: List Processing, Trees and Arithmetic

- [Rahul Nalawade](https://github.com/rahul1947)
- 2018-Feb-01 

**Problem: 1** Solve the following exercises (exercises 3.2.1 (i), (ii), (iii), and (iv) from the book - *The Art of Prolog*).

- i. A variant of Program 3.14 for sublist is defined by the following three rules: 
```
subsequence([X|Xs],[X|Ys]) :-­ subsequence(Xs,Ys). 
subsequence(Xs,[Y|Ys]) :­- subsequence(Xs,Ys). 
subsequence([],Ys). 
```
Explain why this program has different meaning from the following Program 3.14: 
```
% sublist(Sub,List): Sub is a sublist of List.

% a: suffix of a prefix
sublist(Xs,Ys) :- prefix(Ps,Ys), suffix(Xs,Ps).

% b: prefix of a suffix 
sublist(Xs,Ys) :- prefix(Xs,Ss), suffix(Ss,Ys).

% c: recursive definition of a sublist
sublist(Xs,Ys) :- prefix(Xs,Ys).
sublist(Xs,[Y|Ys]) :- sublist(Xs,Ys).

Program 3.14 Determining sublist of lists
```

- ii. Write recursive programs for adjacent and last that have the same meaning as the predicates defined in the text in terms of append. 

- iii. Write a program for double(List,ListList), where every element in the List appears twice in ListList. 

`E.g., double([1,2,3],[1,1,2,2,3,3]) is true.`

- iv. Compute the size of the proof tree as a function of the size of the input list for Programs 3.16a and 3.16b defining reverse. 
```
% reverse(List,Tsil): Tsil is the result of reversing the list List.

% a: Naive reverse

reverse([],[]).
reverse([X|Xs],Zs) :- 
	reverse(Xs,Ys), 
	append(Ys,[X],Zs).

% b: Reverse-accumulate
reverse(Xs,Ys) :- 
	reverse(Xs,[],Ys).

reverse([X|Xs],Acc,Ys) :- 
	reverse(Xs,[X|Acc],Ys).
reverse([],Ys,Ys).

Program 3.16 Reversing a list
```

**Solution:** [Program 01](https://github.com/rahul1947/Logic-Programming/blob/master/LP02-List-Processing-Trees-and-Arithmetic/a02q01.pl)

**Problem 2:** Solve the following exercises (exercises 3.3.1 (i), (ii), (iii), (v), (vi), (vii) from the book).

- i. Write a program for substitute(X,Y,L1,L2), where L2 is the result of substituting Y for all occurrences of X in L1, e.g.,
`substitute(a,x,[a,b,a,c],[x,b,x,c]) is true`, whereas `substitute(a,x,[a,b,a,c],[a,b,x,c]) is false`.

- ii. What is the meaning of the variant of the select: 
```
select(X,[X|Xs],Xs).
select(X,[Y|Ys],[Y|Zs]) :- X != Y, select(X,Ys,Zs).
```

- iii. Write a program for no_doubles(L1,L2), where L2 is the result of removing all duplicate elements from L1, e.g.,
`no_doubles([a,b,c,b],[a,c,b]) is true`. (Hint: use member.)

- v. Write a program for merge sort.

- vi. Write a program for kth_largest(Xs,K) that implements the linear algorithm for finding the kth largest element K of a list Xs. The algorithm has following steps:

   1. Break the list into the groups of five elements. 
   2. Efficiently find the median of each of the groups, which can be done with a fixed no of comparisons.
   3. Recursively find the median of the medians.
   4. Partition the original list with respect to the median of medians.
   5. Recursively find the kth largest element in the appropriate smaller list.

- vii. Write a program for the relation better_poker_hand(Hand1,Hand2,Hand) that succeeds when Hand is better poker hand between Hand1 and Hand2. For those unfamiliar with this card game, here are some rules of poker necessary for answering this exercise:

	(a) The order of cards is 2,3,4,5,6,7,8,9,10,jack,queen,king,ace.

	(b) Each hand consists of five cards.

	(c) The rank of hands in ascending order is no pairs < one pair < two pairs < three of a kind < ﬂush < straight < full house < four of a kind < straight flush.

	(d) Where two cards have the same rank, the higher denomination wins, for example, a pair of kings beats a pair of 7's.

Hints: 

	1. Represent a poker hand by a list of terms of the form card(Suit,Value). For example a hand consisting of the 2 of clubs, the 5 of spades, the queen of hearts, the queen of diamonds, and the 7 of spades would be represented by the list 
	[card(clubs,2), card(spades,5), card(hearts,queen), card(diamonds,queen), card(spades,7)]. 
	
	2. It may be helpful to deﬁne relations such as 
	has-flush(Hand), which is true if all the cards in Hand are of the same suit; 
	has-full-house(Hand), which is true if Hand has three cards with the same value but in different suits, and the other two cards have the same different value; and 
	has_straight(Hand),which is true if Hand has cards with consecutive values.  
	
	3. The number of cases to consider is reduced if the hand is first sorted.

**Solution:** [Program 02](https://github.com/rahul1947/Logic-Programming/blob/master/LP02-List-Processing-Trees-and-Arithmetic/a02q02.pl) and for Better-Poker-Hand [Poker](https://github.com/rahul1947/Logic-Programming/blob/master/LP02-List-Processing-Trees-and-Arithmetic/pokerA2.pl)


**Problem 3:** Given the sorted binary tree (SBT) representation discussed in class, define the following functions - 
```
sumtree(T,N): N is the sum of elements in SBT T (use succ arithmetic).
delete(E,T,Tn): delete the element E from SBT T to obtain SBT Tn.
```

**Solution:** [Sorted Binary Tree](https://github.com/rahul1947/Logic-Programming/blob/master/LP02-List-Processing-Trees-and-Arithmetic/a02q03.pl)


**Problem 4:** Solve the following exercises (exercises 8.3.1 (i), (iii), (vi), (vii) from the book).

- i. Write an iterative version for triangle(N,T), posed as Exercise 8.2(i).
```
Exercise 8.2
(i) The Nth triangular number is the sum of the numbers up to and including N. Write a program for the relation triangle (N ,T), where '1' is the Nth triangular number. (Hint: Adapt Program 8.2.)

%factorial(N,F): F is the integer N factorial.

factoria1(N,F) :-
	N > 0, N1 is N-1, factorial(N1,F1), F is N*F1.
factorial(0,1). 

Program 8.2 Computing the factorial of a number 
```

- iii. Rewrite Program 8.5 so that the successive integers are generated in descending order.
```
% between(I,J,K): K is an integer between the integers I and J inclusive.

between(I,J,I) :- I <= J.
between(I,J,K) :- I < J, I1 is I+1, between(I1,J,K).

Program 8.5 Generating a range of integers
```

- vi. Write a program to find the minimum of a list of integers.

- vii. Rewrite Program 8.11 for ﬁnding the length of a list so that it is iterative. (Hint: Use a counter, as in Program 8.3.)
```
% length(Xs,N): N is the length of the list Xs. 

length([X|Xe],N) :- length(Xs,N1), N is N1+1.
Length([],0).

Program 8.11 Finding the length of a list

% factorial(N,F): F is the integer N factorial.

factorial(N,F) :- factorial(0,N,1,F).

factorial(I,N,T,F) :- 
	I < N, I1 is I+1, T1 is T*I1, factorial(I1,N,T1,F).
factorial(N,N,F,F).

Program 8.3 An iterative factorial
```

**Solution:** [Program 04](https://github.com/rahul1947/Logic-Programming/blob/master/LP02-List-Processing-Trees-and-Arithmetic/a02q04.pl)


**NOTE:**
- You can find almost all the solution in [Report](https://github.com/rahul1947/Logic-Programming/blob/master/LP02-List-Processing-Trees-and-Arithmetic/CS6374-HW03-rsn170330.pdf) for all of the above problems. 

- All the images/ screenshots are saved in [img](https://github.com/rahul1947/Logic-Programming/tree/master/LP02-List-Processing-Trees-and-Arithmetic/img) directory, containing demo of few predicates.
