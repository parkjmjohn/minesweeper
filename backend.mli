(* This module creates the backend of the game regarding board size and bomb placements.
   The variant square is the building block of the board, and it can either be a Bomb or Clear of x, with x being the
   number of bombs surrounding it.
   Type t represents the board itself, implemented as a list of list of squares.
*)

type square = Bomb | Clear of int

type t = square list list 

(** [bknd_get bknd c1 c2] istheelement of  [bknd] in column [c2] of row [c1]. *)
val bknd_get: t -> int -> int -> square

(** [bknd_get_rand_nonbomb bknd] is a random square in [bknd] which does
    not contain a [Bomb] as an entry.*)
val bknd_get_rand_nonbomb: t -> (int * int)

(** [replace lst pos a]
    Helper function that replaces the position pos of the list lst to a
    Input: the old list: 'a list, the position: int, and the new value: 'a
    Output: the new list: 'a list 
*)
val replace: 'a list -> int -> 'a -> 'a list

(** [check_bomb b x y]
    Checks whether this tile is a bomb or not, accepts out of bounds coordinates
    Input: the board b: t, row coordinates x: int, and column coordinates y: int   
    Output: whether it's a bomb or not: bool
*)
val check_bomb: t -> int -> int -> int

(* [clear_area clicked_1 clicked_2 x y n m b] returns whether the input 
   coordinate is in the nine surrounding squares of the first clicked square *)
val clear_area: int -> int -> int -> int -> int -> int -> int -> bool

(** [count_bomb b] return the true number of bombs in the board *)
val count_bomb: t -> int

(** [check_bomb_surround b x y]
    Checks how many bombs surround the input coordinate, does not accept out of 
    bounds coordinates
    Input: the board b: t, row coordinates x: int, and column coordinates y: int   
    Output: the number of bombs surrounding the tile: int
*)
val check_bomb_surround: t -> int -> int -> int

(* [update_board b n_count m_count n m]
   Recurrsivly updates the board of Bombs and Clear 0 to the final version of 
   the board with Clear x, x being the number of bombs surrounding the tile.
   Input: the board b: t, current row coordinates n_count: int, current column 
   coordinates m_count: int, the row length n: int, and the column length m: int   
   Output: the final version of the board: t
*)
val update_board: t -> int -> int -> int -> int -> t

(** [create x]
    Creates the board with n = 5 rows, m = 5 columns, and b = 10 bombs
    each tile is either a Bomb of a Clear of int, with the int being how many
    bombs surround it. The board is a list of rows.
    Input: unit
    Output the board: t
*)
val create: unit -> int -> int -> int -> int -> int -> t
