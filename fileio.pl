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

read_file(Result) :-
    open("input.txt", read, Input),
    % read and parse M
    read_line_to_codes(Input, Fst),
    code_to_int(Fst, 0, M),
    % read and parse N
    read_line_to_codes(Input, Snd),
    code_to_int(Snd, 0, N),
    % read and parse X
    read_line_to_codes(Input, Trd),
    code_list_to_int(Trd, X),
    % read and parse Y
    read_line_to_codes(Input, Fth),
    code_list_to_int(Fth, Y),
    % read the empty line
    read_line_to_codes(Input, []),
    % read and parse game grid
    read_board(Input, Board),
    close(Input),
    % check if the board is legal
    check_board(M, N, X, Y, Board),
    Result = (M, N, X, Y, Board).
