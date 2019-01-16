% You are given three complete lists of facts of the form:
% course(math), course(graphs), ..., student(john), student(mary), ..., took(john,math), took(mary,graphs), ...

% Students can graduate only if they have taken all the courses in the first list. Write a program that, given the above information, determines which students can graduate. Make sure that, given the following sample knowledge base, 
% student(john). student(mary).
% course(graphs). course(math).
% took(john,math). took(john,graphs). took(mary,graphs).

% your program is able to conclude 
% can_graduate(john).
% -can_graduate(mary).

course(math).
course(graphs).

student(john). 
student(mary).

took(john,graphs).
took(john,math).
took(mary,graphs).

-took(Student,Course) :-
    student(Student), 
    course(Course),
    not took(Student,Course).

-can_graduate(Student) :- 
    student(Student),
    course(Course),
    -took(Student,Course).

can_graduate(Student) :-
    student(Student),
    not -can_graduate(Student).
