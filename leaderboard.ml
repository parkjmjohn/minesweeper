open Dictionary

let file = "leaderboard.txt"

let calculate_score bombs squares time =
  let bomb_float = Pervasives.float_of_int bombs in
  let square_float = Pervasives.float_of_int squares in
  let score_float = bomb_float /. square_float /. time *. 10000000.0 in
  let score_int = Pervasives.int_of_float score_float in
  Pervasives.string_of_int score_int

let read_leaderboard = fun () -> 
  let open_file = open_in file in
  let scores = really_input_string open_file (in_channel_length open_file) in
  close_in open_file;
  let users = List.rev(String.split_on_char '\n' scores) in
  if List.hd users = "" then List.tl users else users

let rec write_leaderboard_helper scores output_channel =
  match scores with
  | [] -> () 
  | [""] -> ()
  | h::t -> 
    Printf.fprintf output_channel "%s\n" h; 
    write_leaderboard_helper t output_channel

let write_leaderboard name score =
  let scores = (name ^ " " ^ score)::(read_leaderboard ()) in
  let output_channel = open_out file in
  write_leaderboard_helper scores output_channel;
  flush stdout;
  close_out output_channel

let rec make_dict (leaderboard: string list) acc = match leaderboard with
  | [] -> acc
  | h::t -> let kv = String.split_on_char ' ' h in
    let key = List.nth kv 1 in let value = List.hd kv in
    make_dict t (insert key value acc)

(** [get_keys dict] is the list of the score of the leaderboard *)
let rec get_scores dict = get_keys dict

let rec string_list_to_int_list = function 
  | [] -> []
  | [""] -> []
  | h::t -> (Pervasives.int_of_string h)::(string_list_to_int_list t)

let rec int_list_to_string_list = function 
  | [] -> []
  | h::t -> (Pervasives.string_of_int h)::(int_list_to_string_list t)

let rec bubble_sort_helper l =
  match l with 
  | h1::h2::t when h1 > h2 -> h2::bubble_sort_helper (h1::t)
  | h::h2::t -> h::bubble_sort_helper (h2::t)
  | h -> h

let rec bubble_sort l = 
  let sorted = bubble_sort_helper l in
  if sorted <> l then bubble_sort sorted
  else sorted

let rec rev_list l = 
  match l with 
  | [] -> []
  | h::t -> (rev_list t)@[h]

let rec top_five_scores_helper (scores: int list) count =
  match scores with
  | [] -> []
  | h::t ->
    if count = 1 then [h]
    else h::top_five_scores_helper t (count-1)

let top_five_scores (scores: int list) =
  let sorted = bubble_sort scores in
  let rev_sorted = rev_list sorted in
  if (List.length scores) < 5 then rev_sorted
  else top_five_scores_helper rev_sorted 5

let rec print_scores_helper count dict scores = 
  match scores with 
  | [] -> ()
  | h1::t1 ->
    let order = Pervasives.string_of_int count in
    let users = find h1 dict in match users with
    | None -> ()
    | Some names -> match names with
      | [] -> ()
      | h2::t2 -> print_endline (order ^ ") " ^  h2 ^ " " ^ h1 ^ " points");
        print_scores_helper (count + 1) dict t1

let print_scores = fun () -> let dict = (make_dict (read_leaderboard ()) []) in
  get_scores dict
  |> string_list_to_int_list
  |> top_five_scores
  |> int_list_to_string_list
  |> print_scores_helper 1 dict