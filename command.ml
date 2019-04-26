(* type game = int * int * int *)

type coordinate = int * int
type config = int list

type command = 
  | Play
  | Make of config
  | AI of config
  | Restart
  | Scores
  | Flag of coordinate
  | Unflag of coordinate
  | Click of coordinate
  | Help
  | Quit

exception Empty

exception Malformed

exception Bound

let form_coordinate lst = 
  match lst with 
  | [a; b] -> 
    begin 
      try
        let x = Pervasives.int_of_string a in
        let y = Pervasives.int_of_string b in
        (x, y)
      with _ -> raise (Malformed)
    end
  | _ -> raise (Malformed)

let form_config = function
  | [r; c; b] -> let r = int_of_string r in let c = int_of_string c 
    in let b = int_of_string b in if r > 0 && c > 0 && b > 0 && b < r * c
    then [r; c; b] else raise (Malformed)
  | _ -> raise (Malformed)

let parse input = 
  let lwr_case = String.lowercase_ascii input in
  let words = String.split_on_char ' ' lwr_case in
  match words with
  | [] -> raise (Empty)
  | h::[] -> 
    if h = "" then raise (Empty)
    else if h = "make" then Play
    else if h = "leaderboard" then Scores
    else if h = "help" then Help
    else if h = "quit" then Quit 
    else if h = "restart" then Restart
    else raise (Malformed)
  | h::t -> 
    if h = "make" then Make(form_config t)
    else if h = "AI" || h = "ai" then AI(form_config t)
    else if h = "flag" then Flag(form_coordinate t)
    else if h = "unflag" then Unflag(form_coordinate t)
    else if h = "click" then Click(form_coordinate t)
    else raise (Malformed)