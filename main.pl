:- ['builder.pl'].
:- ['solver.pl'].

% a cell can be empty, a tree, or a tent
cells([empty, tree, tent]).

% print ASCII for cells instead of words to make it more readable
print_cell(empty) :- write('.').
print_cell(tree)  :- write('*').
print_cell(tent)  :- write('^').

% prints a row of a Tents and Trees puzzle board
print_row([]) :- !.
print_row([Hd | Tl]) :-
	print_cell(Hd), write(' '),
	print_row(Tl).

print_counts([]) :- !.
print_counts([Hd | Tl]) :-
	print(Hd), write('_'),
	print_counts(Tl).

% prints a Tents and Trees puzzle board
print_board(_, []) :- !.
print_board([Count | Tl1], [Row | Tl2]) :-
	print(Count), write('|'), print_row(Row), write('\n'),
	print_board(Tl1, Tl2).
print_board((_, _, CountsY, CountsX, Cells)) :-
	write('  '), print_counts(CountsX), write('\n'),
	print_board(CountsY, Cells).

main :-
	build_board(20, 20, 30, Board),
	print_board(Board).
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
%     Board = [[0, 0, 0, 0, 0, 1, 0],
%              [0, 0, 1, 0, 0, 1, 1],
%              [1, 0, 1, 0, 0, 0, 0],
%              [0, 0, 0, 0, 0, 0, 0],
%              [0, 0, 0, 0, 0, 1, 0],
%              [0, 0, 0, 0, 0, 0, 0],
%              [1, 0, 1, 0, 0, 0, 0]],
%     X = [2, 1, 2, 1, 0, 2, 1],
%     Y = [2, 1, 0, 2, 1, 2, 1],

%     nth0(0, Board, Row),
%     length(Board, N),
%     length(Row, M),
%     solve(N, M, X, Y, Board, Result),
%     print(Result).
