:- ['builder.pl'].
:- ['solver.pl'].

% print ASCII for cells instead of words to make it more readable
print_cell(0) :- write('.').
print_cell(1)  :- write('*').
print_cell(2)  :- write('^').

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

% print ASCII for cells instead of words to make it more readable
print_cell(0, 0) :- write('.').
print_cell(1, 0)  :- write('*').
print_cell(0, 1)  :- write('^').

% prints a row of a Tents and Trees solution board
print_row([], []) :- !.
print_row([Hd | Tl], [TentHd | TentTl]) :-
	print_cell(Hd, TentHd), write(' '),
	print_row(Tl, TentTl).

% prints a Tents and Trees puzzle solution
print_solution(_, [], []) :- !.
print_solution([Count | Tl1], [Row | Tl2], [TentRow | TentTl]) :-
	print(Count), write('|'), print_row(Row, TentRow), write('\n'),
	print_solution(Tl1, Tl2, TentTl).
print_solution((_, _, CountsY, CountsX, Cells), TentBoard) :-
	write('  '), print_counts(CountsX), write('\n'),
	print_solution(CountsY, Cells, TentBoard), !.

main :-
	% build_board(7, 7, 9, Board),
    X = [2, 1, 2, 1, 0, 2, 1],
    Y = [2, 1, 0, 2, 1, 2, 1],
    Board = (7, 7, X, Y,
            [[0, 0, 0, 0, 0, 1, 0],
             [0, 0, 1, 0, 0, 1, 1],
             [1, 0, 1, 0, 0, 0, 0],
             [0, 0, 0, 0, 0, 0, 0],
             [0, 0, 0, 0, 0, 1, 0],
             [0, 0, 0, 0, 0, 0, 0],
             [1, 0, 1, 0, 0, 0, 0]]),
    % X = [2, 0, 1, 1],
    % Y = [0, 1, 1, 2],
    % Board = (4, 4, X, Y,
    %          [[0, 0, 1, 0],
    %          [0, 0, 1, 1],
    %          [0, 0, 0, 1],
    %          [0, 0, 0, 0]]),
    writeln(Board),
	print_board(Board),
    solve(Board, Tents),
    writeln(Tents),
    print_solution(Board, Tents).
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
