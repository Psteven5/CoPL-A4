# CoPL-A4
Group 44 - Kenji Opdam, Pieter Stevens (s3683591, s3588254)

The program works as intended by all 'must', 'should' and 'may' conditions,
except for the functionality to create a puzzle with a unique solution. Another
potential problem is that the solver is not able to solve very generated puzzle
since the solver can solve to about 7x7 puzzles within reasonable time while
the generator can generate way bigger puzzles.

To use this program the user should first open a swi-prolog shell from within
this directory and run '?- consult("main.pl").' to load the functors. The user
can then run 'main.' to see some examples of how to use this program. The user
can generate a puzzle using build_board/4 and automatically solve a puzzle
using solve/2. The generated board can be printed using print_board/1 Since
inputting a puzzle in the command line is tedious the user can input their
puzzle in a file and use read_file/2 create a board using the contents of that
file. The contents of the input file should be as shown below.

FILE CONTENTS  
X  
Y  
  
Board row 1  
Board row 2  
...  
Board row M  
END

Where X is the amount of tents per row, Y is the amount of tents per column,
and Board row 1..M are the rows of the board. An example file can be found in
puzzle.txt. The solution of a puzzle can be either printed to the console using
print_solution/2 or written to a file using write_file/3
