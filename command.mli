(** 
   Representation of the commands to input to the game.

   This module represents commands that user can make, including play the game,
   set the configuration of the game, initiate the AI and several other commands
   on the homepage or during the game.
*)

(** The type [coordinate] represents the location on the board*)
type coordinate = int * int

(** The type [config] represents the information needed to create custom 
    board. *)
type config = int list

(** The type [command] represents a player command that is decomposed
    into a verb and possibly an object phrase. *)
type command = 
  | Play (* of game *)
  | Make of config
  | AI of config
  | Restart
  | Scores
  | Flag of coordinate
  | Unflag of coordinate
  | Click of coordinate  
  | Help
  | Quit

(** Raised when an empty command is parsed. *)
exception Empty

(** Raised when a malformed command is encountered. *)
exception Malformed

(** Raised when an incorrect coordinate is entered. *)
exception Bound

(** The [form_coordinate] function takes in a the input after a flag 
    or a click command to produce the proper coordinate. *)
val form_coordinate : string list -> coordinate

(** [form_config strlst] takes in the in an input string list to produce
    the proper config. *)
val form_config : string list -> config

(** The [parse] function reads a command and categorize the command into
    the four different types for command. *)
val parse : string -> command
