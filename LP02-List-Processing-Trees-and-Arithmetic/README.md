## Logic Programming 02: List Processing, Trees and Arithmetic

- [Rahul Nalawade](https://github.com/rahul1947)
- 2018-Feb-01 

**Problem: 1** Solve the following exercises (exercises 3.2.1 (i), (ii), (iii), and (iv) from the book - *The Art of Prolog*).

i. A variant of Program 3.14 for sublist is defined by the following three rules: 
```
subsequence([X|Xs],[X|Ys]) :-­ subsequence(Xs,Ys). 
subsequence(Xs,[Y|Ys]) :­- subsequence(Xs,Ys). 
subsequence([],Ys). 
```
Explain why this program has different meaning from the following Program 3.14: 
```
% sublist(Sub,List): Sub is a sublist of List.
% a: suffix of a prefix
sublist(Xs,Ys) :­ prefix(Ps,Ys), suffix(Xs,Ps).
% b: prefix of a suffix 
sublist(Xs,Ys) :­ prefix(Xs,Ss), suffix(Ss,Ys).
% c: recursive definition of a sublist
sublist(Xs,Ys) :­ prefix(Xs,Ys).
sublist(Xs,[Y|Ys]) :­ sublist(Xs,Ys).
```
Program 3.14 Determining sublist of lists

ii. Write recursive programs for adjacent and last that have the same meaning as the predicates defined in the text in terms of append. 

iii. Write a program for double(List,ListList), where every element in the List appears twice in ListList. 
`E.g., double([1,2,3],[1,1,2,2,3,3]) is true.`

iv. Compute the size of the proof tree as a function of the size of the input list for Programs 3.16a and 3.16b defining reverse. 
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





















**Solution:** 
- [Report](https://github.com/rahul1947/Logic-Programming/blob/master/LP02-List-Processing-Trees-and-Arithmetic/CS6374-HW03-rsn170330.pdf)

All the images/ screenshots are saved in [img](https://github.com/rahul1947/Logic-Programming/tree/master/LP02-List-Processing-Trees-and-Arithmetic/img) directory, containing demo of few predicates.
