% builder.pl contains predicates for building valid Tents and Trees puzzles
:- ['builder.pl'].

% a cell can be empty, a tree, or a tent
cells([empty, tree, tent]).

% print ASCII for cells instead of words to make it more readable
print_cell(empty) :- write(' ').
print_cell(tree)  :- write('*').
print_cell(tent)  :- write('^').

% prints a row of a Tents and Trees puzzle board
print_row([]) :- !.
print_row([Hd | Tl]) :-
	print_cell(Hd), write(' '),
	print_row(Tl).

% prints a Tents and Trees puzzle board
print_board((_, _, [])) :- !.
print_board((_, _, [Hd | Tl])) :-
	print_row(Hd), write('\n'),
	print_board((_, _, Tl)).

main :-
	build_board(3, 3, 5, Board),
	print_board(Board).