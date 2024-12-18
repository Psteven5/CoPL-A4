% get the location of all trees
find_trees(Board, Result) :-
    findall((X, Y), (
        nth0(X, Board, Row),
        nth0(Y, Row, 1)
    ), Result).

solve_inner(M, N, X, Y, Board, TreeLocs, CurrTree, Result) :-
    print(TreeLocs), nl.

solve(M, N, X, Y, Board, Result) :-
    sum_list(X, XSum),
    sum_list(Y, YSum),
    XSum = YSum,
    tree_count_board(Board, 0, TreeCount),
    TreeCount = XSum,
    find_trees(Board, TreeLocs),
    solve_inner(M, N, X, Y, Board, TreeLocs, 0, Result).
