% helper.pl contains utility functions unrelated to the program
:- ['helper.pl'].
:- ['solver.pl'].

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
	% build_board(3, 3, 5, Board),
	% print_board(Board).
    % Board = [[0, 0, 1, 0, 0, 0, 1, 0],
    %          [1, 0, 0, 0, 0, 0, 0, 0],
    %          [0, 0, 0, 0, 1, 0, 0, 0],
    %          [0, 0, 1, 0, 0, 0, 0, 0],
    %          [0, 1, 0, 0, 0, 0, 0, 0],
    %          [0, 0, 0, 0, 0, 0, 1, 0],
    %          [0, 1, 1, 1, 0, 1, 0, 0],
    %          [0, 0, 0, 1, 0, 0, 0, 0]],
    % X = [3, 0, 2, 0, 2, 1, 3, 1],
    % Y = [3, 0, 3, 1, 1, 1, 2, 1],
    % Board = [[0, 1, 0],
    %          [1, 0, 1],
    %          [0, 1, 0]],
    % X = [2, 0, 2],
    % Y = [2, 0, 2],
    % Board = [[0, 1, 0, 0, 0], [0, 0, 0, 0, 1], [0, 1, 0, 1, 0], [0, 0, 0, 0, 1], [0, 0, 0, 0, 0]],
    % X = [2, 0, 2, 0, 1],
    % Y = [2, 0, 1, 0, 2],
    % Board = [[0, 0, 0, 1, 0, 0], [1, 1, 0, 0, 0, 1], [0, 0, 1, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 1, 0, 0, 1, 1], [0, 0, 0, 0, 0, 0]],
    % X = [3, 0, 2, 1, 1, 1],
    % Y = [1, 2, 1, 2, 0, 2],
    Board = [[0, 0, 0, 0, 0, 1, 0],
             [0, 0, 1, 0, 0, 1, 1],
             [1, 0, 1, 0, 0, 0, 0],
             [0, 0, 0, 0, 0, 0, 0],
             [0, 0, 0, 0, 0, 1, 0],
             [0, 0, 0, 0, 0, 0, 0],
             [1, 0, 1, 0, 0, 0, 0]],
    X = [2, 1, 2, 1, 0, 2, 1],
    Y = [2, 1, 0, 2, 1, 2, 1],

    nth0(0, Board, Row),
    length(Board, N),
    length(Row, M),
    solve(N, M, X, Y, Board, Result),
    print(Result).
