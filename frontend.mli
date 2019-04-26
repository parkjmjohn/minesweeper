(** 
   Representation of the frontend of the game.

   This module represents the data stored in the frontend, including
   the flags, bombs, revealed or not and nearby mines number. It handles
   the display of the game to the user.
*)

(** The type of the grid in the map. *)
type sqaure = New | Flag | Bomb | Reveal of int

(** The abstract type of values representing the map type. *)
type t = sqaure list list

(** [get_zeros bknd] is a list of the coordinates [(y,x)] of [Clear 0's] in 
    [bknd] where [y] is the row of a [Clear 0] in [bknd] and [x] is the column*)
val get_zeros: Backend.t-> (int * int) list

(** [has_won ftnd' bknd] is true if only [Bomb's] are not revealed in [ftnd']
    and no [Bomb's] are revealed in [ftnd'.]  *)
val has_won: t option -> Backend.t-> bool

(** [all_revealed lst ftnd] is true if every square of [ftnd] corresponding to a
    coordinate in [lst] is revealed, false if otherwise. *)
val all_revealed: (int * int) list -> t option->bool

(** [create n m] is the initial n by m map *)
val create_front: int -> int -> t

(** [timer] converts the game time to a string *)
val timer: float -> string

(** [ammend ftnd c1 c2 inp] Update the (c1, c2) position of the map to be inp.*)
val ammend: t -> int -> int -> sqaure -> t

(** [reveal_all bknd ftnd] reveal all the bombs and in the [ftnd] based on 
    [bknd]. *)
val reveal_all: int -> int -> Backend.t -> t

(** [reveal c1 c2 bknd ftnd] is the new frontend map after (c1,c2) being
    in the [ftnd] computed based on [bknd].*)
val reveal: int -> int -> Backend.t -> t option -> t option

(** [help bknd ftnd'] is [ftnd'] with an addtional random non-[Bomb] square 
    revealed.*)
val help: Backend.t ->t option -> t option

(** [flag c1 c2 inp] is the new frontend map with position (c1, c2) be flag;
    it is the original map [inp] if (c1, c2) is illegal. *)
val flag: int -> int -> t -> t option

(** [unflag c1 c2 inp] is the new frontend map with position (c1, c2) be an 
    unrevealed grid if it was flag; it is the original map [inp] if (c1, c2) is 
    illegal. *)
val unflag: int -> int -> t -> t option

(** [num_bomb btnd ftnd] is the number of bombs left that are not marked (the
    player might have marked a wrong grid) *)
val num_bomb: Backend.t -> t -> int

(** [print t] is used to print out the map to the terminal. *)
val print: t -> Backend.t -> float -> unit