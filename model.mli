(** This module creates an AI that could takes in a backend and frontend to 
    automatically play the game. 
*)

(** action is a variant that symbolizes what the next step of action the AI has 
    to do. *)
type action = Click | Flag | Working

(** coordinate is the return type of the AI algorithm, specifying the sqaure to 
    press on and what action associated with it. *)
type coordinate = int * int * action

(** [get_nth grid m n] returns the mth row nth column element of the 2D grid. *)
val get_nth: Frontend.sqaure list list -> int -> int -> Frontend.sqaure

(** [get_num rvl] returns the number of bombs surrounding the input square; 
    returns -1 if it is not a revealed number. *)
val get_num: Frontend.sqaure -> int

(** [check_token front m n token] checks if the mth row nth column is of type 
    token. *)
val check_token: Frontend.sqaure list list -> int -> int -> 
  Frontend.sqaure -> int

(** [count_surround_token front m n token] counts the number of surrouding 
    quares of type token. *)
val count_surround_token: Frontend.sqaure list list -> int -> int -> 
  Frontend.sqaure -> int

(** [find_empty_square front m n] finds an new square surrouding the mth row 
    nth column. *)
val find_empty_square: Frontend.sqaure list list -> int -> int -> int * int

(** [get_grid front] is the main AI algorithm that takes in a frontend and 
    returns the next step. *)
val get_grid: Frontend.t -> coordinate

(** [find_random front] finds a random new unclicked square and returns it. *)
val find_random: Frontend.t -> int * int

(** [take_out ft] changes the type t option to a type t. *)
val take_out: Frontend.t option -> Frontend.t

(** [check_flag ft x y] checks if this square is a flag. *)
val check_flag: Frontend.t -> int -> int -> int

(** [count_flag ft] counts the number of flags in the frontend. *)
val count_flag: Frontend.t -> int

(** [has_bomb ft] checks if the game has encountered a bomb and therefore been 
    lost. *)
val has_bomb: Frontend.t -> bool

(** [has_new ft] checks if the frontend still has new unclicked sqaures. *)
val has_new: Frontend.t -> bool

(** [is_ai_won ftnd bknd] check if the AI has won the game. *)
val is_ai_won: Frontend.t -> Backend.t -> bool

(** [is_ai_lose ftnd] check if the AI has lost the game. *)
val is_ai_lose: Frontend.t -> bool

(** [play m n b t] is the main loop that is called when the AI starts playing 
    the game. *)
val play: int -> int -> int -> float -> unit