:- ['builder.pl'].
:- ['solver.pl'].
:- ['fileio.pl'].

% print ASCII for cells instead of words to make it more readable
print_cell(0) :- write('.').
print_cell(1)  :- write('*').
print_cell(2)  :- write('^').

% prints a row of a Tents and Trees puzzle board
print_row([]) :- !.
print_row([Hd | Tl]) :-
	print_cell(Hd), write(' '),
	print_row(Tl).

% write the row and column counts
print_counts([]) :- !.
print_counts([Hd | Tl]) :-
	print(Hd), write('_'),
	print_counts(Tl).

% prints a Tents and Trees puzzle board
print_board(_, []) :- !.
print_board([Count | Tl1], [Row | Tl2]) :-
	print(Count), write('|'), print_row(Row), write('\n'),
	print_board(Tl1, Tl2).
print_board((CountsY, CountsX, Cells)) :-
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
print_solution((CountsY, CountsX, Cells), TentBoard) :-
	write('  '), print_counts(CountsX), write('\n'),
	print_solution(CountsY, Cells, TentBoard), !.

main :-
    % example 1
    writeln("Build_board/4 can generate a solvable board: "),
	build_board(7, 7, 9, Board1),
    print_board(Board1),
    write('\n'),
    % example 2
    writeln("It can even generate a very big board: "),
	build_board(20, 20, 30, Board2),
    print_board(Board2),
    write('\n'),
    % example 3
    writeln("solve/2 can solve a given puzzle: "),
    build_board(7, 7, 7, Board3),
    print_board(Board3),
    solve(Board3, Solution3),
    print_solution(Board3, Solution3),
    write('\n'),
    % example 4
    writeln("read_file/2 can read from the given file and create a Board"),
    read_file("puzzle.txt", Board4),
    print_board(Board4),
    write('\n'),
    % example 5
    writeln("write_file/3 can write a given solution to the given file"),
    solve(Board4, Solution4),
    print_solution(Board4, Solution4),
    write_file("solution.txt", Board4, Solution4).
