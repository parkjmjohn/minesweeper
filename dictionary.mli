(** 
   Representation of the dictionary of the leaderboard.

   This module convert the leaderboard data to an dictionary to handle the
   sorting and the display of the leaderbaord.
*)

(** [key] is the key type of the dictionary, which represents the score. *)
type key = string

(** [value] is the value type of the dictionary, which is a list of usernames. 
*)
type value = string list

(** [t] is the represents the dictionary, which is a key-value list. *)
type t = (key * value) list

(** [get_keys] takes a dictionary and returns a list containing only the keys. 
*)
val get_keys: t -> key list

(** [find k d] is [Some v] if [k] is bound to [v] in [d]; or if [k] is not 
    bound, then it is [None]. *)
val find: key -> t -> value option

(** [member k d] is [true] iff [k] is bound in [d]. *)
val member: key -> t -> bool

(** [remove k d] contains all the bindings of [d] except a binding for [k].  
    If [k] is not bound in [d], then [remove] returns a dictionary with the same 
    bindings as [d]. *)
val remove : key -> t -> t

(** [insert k v d] is [d] with [k] bound to a username list with the new [v] 
    added. *)
val insert: key -> string -> t -> t