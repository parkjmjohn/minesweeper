(** 
   Representation of the leaderboard of the game.

   This module represents the data stored in the leaderboard, including
   the user names and scores. It handles the generation of the leaderboard to 
   the user.
*)

(** [calculate_score b n t] is the calculating score algorithm. *)
val calculate_score : int -> int -> float -> string

(** [read_leaderboard] reads every line in the file. *)
val read_leaderboard : unit -> string list

(** [write_leaderboard_helper] adds the scores to the file. *)
val write_leaderboard_helper : string list -> out_channel -> unit

(** [write_leaderboard users scores] writes the score to the file. *)
val write_leaderboard : string -> string -> unit

(** [make_dict leaderbord acc dict] is a [dict] made from [leaderboard]. *)
val make_dict : string list -> Dictionary.t -> Dictionary.t

(** [string_list_to_int_list strlst] converts a string list of numbers 
    to an int list. *)
val string_list_to_int_list : string list -> int list

(** [int_list_to_string_list intlst] converts a int list to a string list. *)
val int_list_to_string_list : int list -> string list

(** [bubble_sort_helper lst] Checks if an element needs to change location. *)
val bubble_sort_helper : 'a list -> 'a list

(** [bubble_sort lst] Bubble sorts as long as the list is not sorted. *)
val bubble_sort : 'a list -> 'a list

(** [top_five_scores_helper intlst num] Returns the top five scores from a list 
    that is greater than 5 elements. *)
val top_five_scores_helper : int list -> int -> int list

(** [top_five_scores lst] checks how many elements are in the list, and returns
    the top 5 elements. *)
val top_five_scores : int list -> int list

(** [print_scores_helper num dict keys] Prints the ordering information of 
    the scoress. *)
val print_scores_helper : int -> Dictionary.t -> Dictionary.key list -> unit

(** [print_scores] Prints the top 5 scores given any list of scores. *)
val print_scores : unit -> unit