:- ['helper.pl'].

% code_to_int/2 gets the integer value from a code or list of codes
code_to_int([], Acc, Num) :- Num is Acc.
code_to_int([Code | Tl], Acc, Num) :-
    % 9 is 57 and 0 is 48 so numbers should be between 57 and 48
    Code =< 57, Code >= 48,
    NewAcc is (Acc * 10) + (Code - 48),
    code_to_int(Tl, NewAcc, Num), !.

% code_list_to_int parses the codes of a comma separated list into a list of integers
code_list_to_int([Fst | Rest], Result) :-
    % the first digit should be 91 which is the code for [
    Fst is 91,
    code_list_to_int(Rest, Result), !.
code_list_to_int(Input, Result) :-
    % split at 44 which is the code for a comma
    split_at(Input, 44, Codes, Rest),
    code_list_to_int(Rest, NextResult),
    code_to_int(Codes, 0, Num),
    Result = [Num | NextResult].
code_list_to_int(Input, Result) :-
    % The last digit should be 93 which is the code for ]
    split_at(Input, 93, Codes, _),
    code_to_int(Codes, 0, Num),
    Result = [Num].

% read_board/2 reads the rest of the file which should be the board
read_board(Input, Board) :-
    read_line_to_codes(Input, Codes),
    % parse the rows
    code_list_to_int(Codes, Row),
    read_board(Input, RestBoard),
    Board = [Row | RestBoard], !.
% stop when reading end_of_file
read_board(Input, []) :-
    read_line_to_codes(Input, end_of_file).

% read_file/2 reads and parses a puzzle from File into Result
read_file(File, Result) :-
    open(File, read, Input),
    % read and parse X
    read_line_to_codes(Input, Fst),
    code_list_to_int(Fst, X),
    % read and parse Y
    read_line_to_codes(Input, Snd),
    code_list_to_int(Snd, Y),
    % read the empty line
    read_line_to_codes(Input, []),
    % read and parse game grid
    read_board(Input, Board),
    close(Input),
    % check if the board is legal
    list_len(X, M),
    list_len(Y, N),
    check_board(M, N, X, Y, Board),
    Result = (X, Y, Board).

% write the row and column counts
write_counts(_, []) :- !.
write_counts(Output, [Hd | Tl]) :-
	write(Output, Hd), write(Output, '_'),
	write_counts(Output, Tl).

% write ASCII for cells instead of words to make it more readable
write_cell(Output, 0, 0) :- write(Output, '.').
write_cell(Output, 1, 0)  :- write(Output, '*').
write_cell(Output, 0, 1)  :- write(Output, '^').

% writes a row of a Tents and Trees solution board
write_row(_, [], []) :- !.
write_row(Output, [Hd | Tl], [TentHd | TentTl]) :-
	write_cell(Output, Hd, TentHd), write(Output, ' '),
	write_row(Output, Tl, TentTl).

% writes a Tents and Trees puzzle solution
write_solution(_, _, [], []) :- !.
write_solution(Output, [Count | Tl1], [Row | Tl2], [TentRow | TentTl]) :-
	write(Output, Count), write(Output, '|'), write_row(Output, Row, TentRow), write(Output, '\n'),
	write_solution(Output, Tl1, Tl2, TentTl).
write_solution(Output, (CountsY, CountsX, Cells), TentBoard) :-
	write(Output, '  '), write_counts(Output, CountsX), write(Output, '\n'),
	write_solution(Output, CountsY, Cells, TentBoard), !.

% write_file/2 writes Solution into File
write_file(File, Board, Solution) :-
    open(File, write, Output),
    % write the lines of Board to output.txt
    write_solution(Output, Board, Solution),
    close(Output).
