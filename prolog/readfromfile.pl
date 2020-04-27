:- use_module(library(apply)).
:- use_module(library(csv)).

get_rows_data(File, Lists):-
  csv_read_file(File, Rows, []),
  rows_to_lists(Rows, Lists).

rows_to_lists(Rows, Lists):-
  maplist(row_to_list, Rows, Lists).

row_to_list(Row, List):-
  Row =.. [row|List].


buildAvailableMales([], []):- !.
buildAvailableMales([ [H|_]|OtherEmployees ], [H = none|Matches]):-
	buildAvailableMales(OtherEmployees, Matches).


findStableMatch :-
	get_rows_data('input/coop_e_10x10.csv', Employees),
	get_rows_data('input/coop_s_10x10.csv', Students),
	write("Employees" = Employees),
	nl, nl,
	write("Students" = Students),
	buildAvailableMales(Employees, AvailableMales),
	nl, nl,
	write("Matches" = AvailableMales),
	galeShapley(Employees, AvailableMales, Matches),
	nl, nl,
	write("Matches" = Matches), 
	outputToFile(Matches).


galeShapley([], [], []):- !. 
galeShapley([[E|[Student|_]]|OtherEmployees],[X=none|Others],[X=Student|OtherMatches]):-
	E == X,
	% trace,
	galeShapley(OtherEmployees, Others, OtherMatches).
	% isNotMatched(Student, OtherMatches).

outputToFile(Matches):-
    open('output/matches_prolog.csv', write, Stream),
    write(Stream,Matches),
    close(Stream).

% check if pair is invalid
isNotMatched(_, []).
isNotMatched(Student, [_=S|Matches]):-
	Student \== S,
	isNotMatched(Student, Matches).
