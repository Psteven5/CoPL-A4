% helper.pl contains utility functions unrelated to the program
:- ['helper.pl'].

% get the location of all trees or all tents
find_trees_tents(Board, Result) :-
    findall((R, C), (
        nth0(R, Board, Row),
        nth0(C, Row, 1)
    ), Result).

% check if a location is adjecent to a tree
adjecent_tree(_, _, []) :- false.
adjecent_tree(R, C, [(Fst, Snd) | _]) :-
    ((R = Fst, (C =:= Snd+1; C =:= Snd-1)), !);
    ((C = Snd, (R =:= Fst+1; R =:= Fst-1)), !).
adjecent_tree(R, C, [_ | Tl]) :- adjecent_tree(R, C, Tl).

% check if a location is adjecent to a tent
adjecent_tent(_, _, []) :- false.
adjecent_tent(R, C, [(Fst, Snd) | _]) :-
    (((R =:= Fst+1; R =:= Fst; R =:= Fst-1), (C =:= Snd+1; C =:= Snd-1)), !);
    (((R =:= Fst+1; R =:= Fst-1), (C =:= Snd+1; C =:= Snd; C =:= Snd-1)), !).
adjecent_tent(R, C, [_ | Tl]) :- adjecent_tree(R, C, Tl).

% returns if the amount of tents in the current row is already full
count_tents_row(X, R, TentBoard) :-
    nth0(R, TentBoard, Row),
    sum_list(Row, Sum),
    nth0(R, X, Total),
    Sum < Total.

% returns if the amount of tents in the current column is already full
count_tents_column(Y, C, TentBoard) :-
    maplist(nth0(C), TentBoard, Col),
    sum_list(Col, Sum),
    nth0(C, Y, Total),
    Sum < Total.

% checks if a tent can be placed at location (R, C)
legal(X, Y, Board, TentBoard, Trees, Tents, R, C) :-
    nth0(R, Board, Row),
    nth0(C, Row, 0),
    nth0(R, TentBoard, TentRow),
    nth0(C, TentRow, 0),
    adjecent_tree(R, C, Trees),
    not(adjecent_tent(R, C, Tents)),
    count_tents_row(X, R, TentBoard),
    count_tents_column(Y, C, TentBoard).

% finds all legal positions a tent can be placed at
get_legal_pos(X, Y, Board, TentBoard, Trees, Result) :-
    findall((R, C), (
        nth0(R, Board, Row),
        nth0(C, Row, _),
        find_trees_tents(TentBoard, Tents),
        legal(X, Y, Board, TentBoard, Trees, Tents, R, C)
    ), Result).

% get all adjecent tree locations
find_adjacent_trees((Fst, Snd), Board, Result) :-
    findall((R, C), (
        nth0(R, Board, Row),
        nth0(C, Row, 1),
        ((R = Fst, (C =:= Snd+1; C =:= Snd-1));
        (C = Snd, (R =:= Fst+1; R =:= Fst-1)))
    ), Result).

rm_idx(0, [_ | Tl], Tl).
rm_idx(Idx, [Hd | Tl], [Hd | NewTl]) :-
    Idx > 0,
    NextIdx is Idx - 1,
    rm_idx(NextIdx, Tl, NewTl).

% create the row with the new tent
place_tent_row(Row, C, Result) :-
    rm_idx(C, Row, Rest),
    nth0(C, Result, 1, Rest).

% place a tent on location (R, C)
place_tent(TentBoard, (R, C), Result) :-
    nth0(R, TentBoard, Row),
    place_tent_row(Row, C, NewRow),
    rm_idx(R, TentBoard, Rest),
    nth0(R, Result, NewRow, Rest).

solve_inner(_, _, _, _, TentBoard, TreeCount, TreeCount, Result) :- copy_term(TentBoard, Result).
solve_inner(X, Y, Board, Trees, TentBoard, TreeCount, TentCount, Result) :-
    get_legal_pos(X, Y, Board, TentBoard, Trees, LegalPos),
    member(Curr, LegalPos),
    find_adjacent_trees(Curr, Board, AdjTrees),
    member(Tree, AdjTrees),
    delete(Trees, Tree, NewTrees),
    place_tent(TentBoard, Curr, NewTentBoard),
    NewTentCount is TentCount + 1,
    solve_inner(X, Y, Board, NewTrees, NewTentBoard, TreeCount, NewTentCount, Result), !.

create_row(N, List) :-
    length(Row, N),
    maplist(=(0), Row),
    List = Row.

create_board(M, N, Result) :-
    length(Result, M),
    maplist(create_row(N), Result).

solve(M, N, X, Y, Board, Result) :-
    sum_list(X, XSum),
    sum_list(Y, YSum),
    XSum = YSum,
    tree_count_board(Board, 0, TreeCount),
    TreeCount = XSum,
    find_trees_tents(Board, Trees),
    create_board(M, N, TentBoard),
    solve_inner(X, Y, Board, Trees, TentBoard, TreeCount, 0, Result).
