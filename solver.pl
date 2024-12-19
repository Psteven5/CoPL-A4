% get the location of all trees or all tents
find_trees_tents(Board, Result) :-
    findall((PosX, PosY), (
        nth0(PosX, Board, Row),
        nth0(PosY, Row, 1)
    ), Result).

% check if a location is adjecent to a tree
adjecent_tree(_, _, []) :- false.
adjecent_tree(PosX, PosY, [(Fst, Snd) | _]) :-
    ((PosX = Fst, (PosY =:= Snd+1; PosY =:= Snd-1)), !);
    ((PosY = Snd, (PosX =:= Fst+1; PosX =:= Fst-1)), !).
adjecent_tree(PosX, PosY, [_ | Tail]) :- adjecent_tree(PosX, PosY, Tail).

% check if a location is adjecent to a tent
adjecent_tent(_, _, []) :- false.
adjecent_tent(PosX, PosY, [(Fst, Snd) | _]) :-
    (((PosX =:= Fst+1; PosX =:= Fst; PosX =:= Fst-1), (PosY =:= Snd+1; PosY =:= Snd-1)), !);
    (((PosX =:= Fst+1; PosX =:= Fst-1), (PosY =:= Snd+1; PosY =:= Snd; PosY =:= Snd-1)), !).
adjecent_tent(PosX, PosY, [_ | Tail]) :- adjecent_tree(PosX, PosY, Tail).

% returns if the amount of tents in the current row is already full
count_tents_row(X, PosX, TentBoard) :-
    nth0(PosX, TentBoard, Row),
    sum_list(Row, Sum),
    nth0(PosX, X, Total),
    write("ROWCOUNT: "),
    write(Sum),
    write(" "),
    write(Total), nl,
    Sum < Total.

% returns if the amount of tents in the current column is already full
count_tents_column(Y, PosY, TentBoard) :-
    maplist(nth0(PosY), TentBoard, Col),
    sum_list(Col, Sum),
    nth0(PosY, Y, Total),
    write("COLUMNCOUNT: "),
    write(Sum),
    write(" "),
    write(Total), nl,
    Sum < Total.

% checks if a tent can be placed at location (PosX, PosY)
legal(X, Y, Board, TentBoard, Trees, Tents, PosX, PosY) :-
    write(PosX),
    write(", "),
    write(PosY), nl,
    nth0(PosX, Board, Row),
    nth0(PosY, Row, 0),
    nth0(PosX, TentBoard, TentRow),
    nth0(PosY, TentRow, 0),
    adjecent_tree(PosX, PosY, Trees),
    not(adjecent_tent(PosX, PosY, Tents)),
    count_tents_row(X, PosX, TentBoard),
    count_tents_column(Y, PosY, TentBoard).

% finds all legal positions a tent can be placed at
get_legal_pos(X, Y, Board, TentBoard, Trees, Result) :-
    findall((PosX, PosY), (
        nth0(PosX, Board, Row),
        nth0(PosY, Row, _),
        find_trees_tents(TentBoard, Tents),
        legal(X, Y, Board, TentBoard, Trees, Tents, PosX, PosY)
    ), Result).

solve_inner(M, N, X, Y, Board, Trees, CurrTree, TentBoard) :-
    get_legal_pos(X, Y, Board, TentBoard, Trees, LegalPos),
    write(LegalPos), nl.

create_row(N, List) :-
    length(Row, N),
    maplist(=(0), Row),
    List = Row.

create_board(M, N, Result) :-
    length(Result, M),
    maplist(create_row(N), Result).

solve(M, N, X, Y, Board, Result) :-
    write("SOLVER"), nl,
    write(Board), nl,
    sum_list(X, XSum),
    sum_list(Y, YSum),
    XSum = YSum,
    tree_count_board(Board, 0, TreeCount),
    TreeCount = XSum,
    find_trees_tents(Board, Trees),
    write(Trees), nl,
    create_board(M, N, Result),
    write(Result), nl,
    solve_inner(M, N, X, Y, Board, Trees, 0, Result),
    write("END SOLVER"), nl.
