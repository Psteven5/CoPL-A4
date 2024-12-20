% helper.pl contains utility functions unrelated to the program
:- ['helper.pl'].

% find_trees_tents/6 gets the location of all trees or all tents
find_trees_tents(M, _, M, _, _, []).
find_trees_tents(M, N, R, N, Board, Result) :-
    NewR is R + 1,
    NewC is 0,
    find_trees_tents(M, N, NewR, NewC, Board, Result).
find_trees_tents(M, N, R, C, Board, Result) :-
    R < M,
    C < N,
    find(Board, Row, 0, R),
    % add the current location to the result if a tree is found
    ( find(Row, 1, 0, C) ->
        NewC is C + 1,
        find_trees_tents(M, N, R, NewC, Board, Tl),
        Result = [(R, C) | Tl]
    ;
        NewC is C + 1,
        find_trees_tents(M, N, R, NewC, Board, Tl),
        Result = Tl), !.

% adjacent_tree/3 checks if a location is adjacent to a tree
adjacent_tree(_, _, []) :- false.
adjacent_tree(R, C, [(Fst, Snd) | _]) :-
    ((R = Fst, (C =:= Snd+1; C =:= Snd-1)), !);
    ((C = Snd, (R =:= Fst+1; R =:= Fst-1)), !).
adjacent_tree(R, C, [_ | Tl]) :- adjacent_tree(R, C, Tl).

% adjacent_tent/3 checks if a location is adjacent to a tent
adjacent_tent(_, _, []) :- false.
adjacent_tent(R, C, [(Fst, Snd) | _]) :-
    (((R =:= Fst+1; R =:= Fst; R =:= Fst-1), (C =:= Snd+1; C =:= Snd-1)), !);
    (((R =:= Fst+1; R =:= Fst-1), C =:= Snd), !).
adjacent_tent(R, C, [_ | Tl]) :- adjacent_tent(R, C, Tl).

% count_tents_row/3 checks if the amount of tents in the current row is already full
count_tents_row(X, R, TentBoard) :-
    find(TentBoard, Row, 0, R),
    sum(Row, Sum),
    find(X, Total, 0, R),
    Sum < Total.

% count_tents_column/3 checks if the amount of tents in the current column is already full
count_tents_column(Y, C, TentBoard) :-
    get_col(TentBoard, C, Col),
    sum(Col, Sum),
    find(Y, Total, 0, C),
    Sum < Total.

% legal/8 checks if a tent can be placed at location (R, C)
legal(X, Y, Board, TentBoard, Trees, Tents, R, C) :-
    find(Board, Row, 0, R),
    find(Row, 0, 0, C),
    find(TentBoard, TentRow, 0, R),
    find(TentRow, 0, 0, C),
    adjacent_tree(R, C, Trees),
    not(adjacent_tent(R, C, Tents)),
    count_tents_row(X, R, TentBoard),
    count_tents_column(Y, C, TentBoard).

% get_legal_pos/10 finds all legal positions a tent can be placed at
get_legal_pos(M, _, M, _, _, _, _, _, _, []).
get_legal_pos(M, N, R, N, X, Y, Board, TentBoard, Trees, Result) :-
    NewR is R + 1,
    NewC is 0,
    get_legal_pos(M, N, NewR, NewC, X, Y, Board, TentBoard, Trees, Result).
get_legal_pos(M, N, R, C, X, Y, Board, TentBoard, Trees, Result) :-
    R < M,
    C < N,
    find_trees_tents(M, N, 0, 0, TentBoard, Tents),
    % add the current location to the result if it is a legal position
    ( legal(X, Y, Board, TentBoard, Trees, Tents, R, C) ->
        NewC is C + 1,
        get_legal_pos(M, N, R, NewC, X, Y, Board, TentBoard, Trees, Tl),
        Result = [(R, C) | Tl]
    ;
        NewC is C + 1,
        get_legal_pos(M, N, R, NewC, X, Y, Board, TentBoard, Trees, Tl),
        Result = Tl).

% find_adjacent_trees/6 is the main loop of find_adjacent_trees/5
find_adjacent_trees(_, _, _, _, [], []).
find_adjacent_trees(M, N, (R, C), Board, [(Fst, Snd) | Rest], Result) :-
    TreeR is R + Fst,
    TreeC is C + Snd,
    % adds location if it is in bounds and adjacent to a tree
    ( TreeR < M, TreeR >= 0, TreeC < N, TreeC >= 0,
      find(Board, Row, 0, TreeR), find(Row, 1, 0, TreeC) ->
        find_adjacent_trees(M, N, (R, C), Board, Rest, Tl),
        Result = [(TreeR, TreeC) | Tl]
    ;
        find_adjacent_trees(M, N, (R, C), Board, Rest, Tl),
        Result = Tl).

% find_adjacent_trees/5 gets all adjacent tree locations
find_adjacent_trees(M, N, Loc, Board, Result) :-
    Sides = [(-1, 0), (0, 1), (1, 0), (0, -1)],
    find_adjacent_trees(M, N, Loc, Board, Sides, Result).

% place_tent_row/3 creates the row with the new tent
place_tent_row(Row, C, Result) :-
    rm_idx(Row, C, Rest),
    insert(Rest, C, 1, Result).

% place_tent/3 places a tent on location (R, C)
place_tent(TentBoard, (R, C), Result) :-
    find(TentBoard, Row, 0, R),
    place_tent_row(Row, C, NewRow),
    rm_idx(TentBoard, R, Rest),
    insert(Rest, R, NewRow, Result).

% create_row/2 creates a list of zeroes of length N
create_row(0, []).
create_row(N, [0 | Tl]) :-
    N > 0,
    NewN is N - 1,
    create_row(NewN, Tl), !.

% create_board/3 creates a matrix of zeroes with M rows and N columns
create_board(0, _, []).
create_board(M, N, [Row | Tl]) :-
    M > 0,
    NewM is M - 1,
    create_row(N, Row),
    create_board(NewM, N, Tl), !.

% tree_count_board/3 counts the amount of trees in a matrix
tree_count_board([], 0).
tree_count_board([Hd | Tl], Sum) :-
    sum(Hd, RowCount),
    tree_count_board(Tl, TlSum),
    Sum is RowCount + TlSum.

% solve/8 is the main solver loop
solve(_, _, _, _, _, _, TentBoard, TreeCount, TreeCount, Result) :- Result = TentBoard.
solve(M, N, X, Y, Board, Trees, TentBoard, TreeCount, TentCount, Result) :-
    get_legal_pos(M, N, 0, 0, X, Y, Board, TentBoard, Trees, LegalPos),
    % run this functor for every legal position
    get_elems(Curr, LegalPos),
    find_adjacent_trees(M, N, Curr, Board, AdjTrees),
    % run this functor for every adjacent tree
    get_elems(Tree, AdjTrees),
    find(Trees, Tree, 0, Idx),
    rm_idx(Trees, Idx, NewTrees),
    place_tent(TentBoard, Curr, NewTentBoard),
    NewTentCount is TentCount + 1,
    solve(M, N, X, Y, Board, NewTrees, NewTentBoard, TreeCount, NewTentCount, Result), !.

% solve/2 initializes variables and starts the main solver loop
solve((M, N, X, Y, Board), Result) :-
    sum(X, XSum),
    sum(Y, YSum),
    % check if X and Y contain the same amount of tents
    XSum = YSum,
    tree_count_board(Board, TreeCount),
    % check if there are the same amount of tents and trees
    TreeCount = XSum,
    find_trees_tents(M, N, 0, 0, Board, Trees),
    create_board(M, N, TentBoard),
    solve(M, N, X, Y, Board, Trees, TentBoard, TreeCount, 0, Result).
