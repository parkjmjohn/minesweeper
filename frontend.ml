open Backend

type sqaure = New | Flag | Bomb | Reveal of int
type t = sqaure list list
(** [ftnd_get ftnd colrow] is the entry which isin column [col] of row [row] in 
    [ftnd]. *)
let ftnd_get ftnd c1 c2 = List.nth (List.nth ftnd c1) c2
(** [ftnd_get_row ftnd row] is the [row-th] row of [ftnd]  *)
let ftnd_get_row ftnd c1 = List.nth ftnd c1

let rec all_revealed lst ftnd' : bool= 
  match ftnd' with 
  | None -> false
  | Some ftnd -> 
    match lst with 
    | []-> true
    | (y,x)::t -> 
      (begin match ftnd_get ftnd y x with
         | New 
         | Flag -> false 
         | _-> true end) && (all_revealed t ftnd')

(** [none_revealed lst ftnd] is true if no square of [ftnd] corresponding to a 
    coordinate in [lst] is revealed, false if otherwise. *)
let rec none_revealed lst ftnd' : bool= 
  match ftnd' with 
  | None -> false
  | Some ftnd -> 
    match lst with 
    | []-> true
    | (y,x)::t -> 
      (begin match ftnd_get ftnd y x with
         | New 
         | Flag -> true 
         | _ -> false end) && (none_revealed t ftnd')

(** [get_all n bknd] is a list of the coordinates [(y,x)] of [Clear n's] in 
    [bknd] where [y] is the row of an [a] in [bknd] and [x] is the column *)
let get_all (n) bknd = 
  let rows = List.length bknd
  in let cols = List.length (List.hd bknd) in
  let rec loop_row rid cur_col = if cur_col >= cols then [] 
    else match bknd_get bknd rid cur_col with
      |Backend.Clear n -> (rid,cur_col)::(loop_row rid (cur_col + 1))
      |_ -> loop_row rid (cur_col + 1) in
  let rec loop_rows cur_row = if cur_row >= rows then []
    else loop_row cur_row 0 @ (loop_rows (cur_row + 1))
  in loop_rows 0

(** [get_zeros bknd] is a list of the coordinates [(y,x)] of [Clear 0's] in
    [bknd] where [y] is the row of a [Clear 0] in [bknd] and [x] is the column*)
let get_zeros bknd = 
  let rows = List.length bknd
  in let cols = List.length (List.hd bknd) in
  let rec loop_row rid cur_col = if cur_col >= cols then [] 
    else match bknd_get bknd rid cur_col with
      |Backend.Clear 0 -> (rid,cur_col)::(loop_row rid (cur_col + 1))
      |_ -> loop_row rid (cur_col + 1) in
  let rec loop_rows cur_row = if cur_row >= rows then []
    else loop_row cur_row 0 @ (loop_rows (cur_row + 1))
  in loop_rows 0

(** [get_nonbombs bknd] is a list of the coordinates [(y,x)] of all elements 
    which are not [Bomb's] in [bknd] where [y] is the row of a [Clear 0] in 
    [bknd] and [x] is the column *)
let get_nonbombs bknd = 
  let rows = List.length bknd
  in let cols = List.length (List.hd bknd) in
  let rec loop_row rid cur_col = if cur_col >= cols then [] 
    else match bknd_get bknd rid cur_col with
      |Backend.Bomb ->  loop_row rid (cur_col + 1)
      |_-> (rid,cur_col)::(loop_row rid (cur_col + 1)) in
  let rec loop_rows cur_row = if cur_row >= rows then []
    else loop_row cur_row 0 @ (loop_rows (cur_row + 1))
  in loop_rows 0

(** [get_bombs bknd] is a list of the coordinates [(y,x)] of [Bomb's] in [bknd]
    where [y] is the row of a [Clear 0] in [bknd] and [x] is the column *)
let get_bombs bknd = 
  let rows = List.length bknd
  in let cols = List.length (List.hd bknd) in
  let rec loop_row rid cur_col = if cur_col >= cols then [] 
    else match bknd_get bknd rid cur_col with
      | Backend.Bomb -> (rid,cur_col)::(loop_row rid (cur_col + 1))
      | _ -> loop_row rid (cur_col + 1) in
  let rec loop_rows cur_row = if cur_row >= rows then []
    else loop_row cur_row 0 @ (loop_rows (cur_row + 1))
  in loop_rows 0

let has_won ftnd' bknd =
  match ftnd' with 
  | None -> false
  | Some ftnd ->  (all_revealed (get_nonbombs bknd) ftnd') && (
      none_revealed (get_bombs bknd) ftnd')

let create_front n m = 
  let rec create_row_helper m_count m acc = 
    if m_count = m then acc else create_row_helper (m_count+1) m (New::acc) in
  let rec create_matrix_helper n_count n acc = 
    if n_count = n then acc else create_matrix_helper (n_count+1) n 
        ((create_row_helper 0 m [])::acc) in
  create_matrix_helper 0 n []

let rec ammend (ftnd : t) rowind colind inp : t =
  let insert inp lst = 
    List.mapi (fun i x -> if i = colind then inp else x) lst in
  let row = ftnd_get_row ftnd rowind in
  let changed_row = insert inp row in
  List.mapi (fun i y -> if i = rowind then changed_row else y) ftnd

(** [blank_ftnd n] create a n*n blank map *)
let blank_ftnd n = 
  let rec loop_1 i = if i = n then [] else New :: loop_1 (i+1) in
  let rec loop_2 j = if j = n then []else (loop_1 n ) :: (loop_2 (j+1)) in 
  loop_2 0 

(** [reveal_all bknd ftnd] reveal all the bombs and in the [ftnd] based on 
    [bknd]. *)
let reveal_all y x bknd = 
  let rec reveal_row row bknd ftnd cind rind = 
    match row with
    | [] -> ftnd
    | h::t ->  reveal_row t bknd (ammend ftnd rind cind (
        match bknd_get bknd rind cind with
        | Backend.Clear n -> Reveal n
        | Backend.Bomb -> Bomb
      )) (cind+1) rind in
  let rec loop n ftnd = 
    if n < (List.length ftnd) then loop (n+1) (reveal_row (List.nth ftnd n)
                                                 bknd ftnd 0 n)
    else ftnd
  in  loop 0 (create_front y x)


let rec reveal row col (bknd:Backend.t) (ftnd':t option) = 
  if (col<0) ||(row < 0) || (row >= List.length bknd) || (col >= List.length 
                                                            (List.hd bknd)) 
  then ftnd'  else
    match ftnd' with
    | None -> None
    | Some ftnd -> 
      let cur_sq = ftnd_get ftnd row col in
      let cur_bknd_sq = Backend.bknd_get bknd row col in
      match cur_sq with 
      | Reveal _ -> Some ftnd
      | _ -> 
        match cur_bknd_sq with 
        | Backend.Bomb -> Some (reveal_all (List.length bknd) 
                                  (List.length (List.hd bknd)) bknd)
        | Backend.Clear n when n > 0 -> Some (ammend ftnd row col (Reveal n))
        | Backend.Clear _ -> let ammended = ammend (ftnd) row col (Reveal 0) in 
          let reveal_surrounding row col = 
            reveal (row - 1) (col) bknd (
              reveal (row - 1) (col + 1) bknd (
                reveal (row) (col + 1) bknd (
                  reveal (row + 1) (col + 1) bknd (
                    reveal (row + 1) col bknd (
                      reveal (row + 1) (col - 1) bknd (
                        reveal (row) (col - 1) bknd (
                          reveal (row - 1) (col - 1) bknd (Some ammended)
                        )
                      )
                    )
                  )
                )
              )
            )
          in reveal_surrounding row col

let rec help bknd (ftnd') =
  let rec rev_rand lst ftnd = (
    let n = Random.int (List.length lst) in
    let coord = List.nth lst n in
    (match ftnd_get ftnd (fst coord) (snd coord)  with
     | New | Flag -> reveal (fst coord) (snd coord) bknd (Some ftnd)
     | _ -> rev_rand lst ftnd)) in
  let rec help_helper n bknd ftnd' =(
    match ftnd' with
    |None -> None 
    |Some ftnd -> if (all_revealed (get_all (n) bknd) (Some ftnd)) then 
        help_helper (n+1) bknd ftnd' 
      else (rev_rand (get_all (n) bknd) ftnd)) in help_helper 0 bknd (ftnd')

let flag c1 c2 ftnd =  
  if c1 >= List.length ftnd || c1 < 0 then None
  else let len = List.length (List.nth ftnd 0) in
    if c2 >= len || c2 < 0 then None
    else Some (ammend ftnd c1 c2 Flag)

let unflag c1 c2 ftnd =  
  if c1 >= List.length ftnd || c1 < 0 then None
  else let len = List.length (List.nth ftnd 0) in
    if c2 >= len || c2 < 0 then None
    else match ftnd_get ftnd c1 c2 with
      | Flag -> Some (ammend ftnd c1 c2 New)
      | _ -> None

(** [check_flag b x y]
    Checks whether this tile is a flag or not, accepts out of bounds coordinates
    Input: the board b: t, row coordinates x: int, and column coordinates y: int   
    Output: whether it's a flag or not: bool
*)
let check_flag (ftnd:t) x y =
  let n = List.length ftnd in
  let m = List.length (List.nth ftnd 0) in
  if x >= n || x < 0 || y >= m || y < 0 then 0 
  else if List.nth (List.nth ftnd x) y = Flag then 1 else 0

(** [count_flag b] return the number of flags in the board *)
let count_flag (ftnd:t) = 
  let rec count_flag_col rind acc_1 =
    if rind < List.length ftnd then
      let rec count_flag_row cind acc_2 = if cind < List.length (List.hd ftnd)
        then
          count_flag_row (cind + 1) (acc_2 + (check_flag ftnd rind cind))
        else acc_2 in count_flag_col (rind + 1) (acc_1 + count_flag_row 0 0)
    else acc_1 in count_flag_col 0 0

let num_bomb bknd ftnd = (count_bomb bknd) - (count_flag ftnd)

(** [timer start] return the string of the time taken *)
let timer start =
  let time = string_of_float (Unix.time () -. start) in
  String.sub time 0 ((String.length time) - 1)

(** [printX n] is used to print the indexes of the width [n] on the top. *)
let printX width =
  let rec printX_helper length count =
    if count = 0 then (print_string "   ";                 
                       printX_helper length (count + 1))
    else if count < length && count < 10 then 
      (ANSITerminal.(print_string [yellow] ((string_of_int count) ^ "  ")); 
       printX_helper length (count + 1))
    else if count < length && count >= 10 then 
      (ANSITerminal.(print_string [yellow] ((string_of_int count) ^ " ")); 
       printX_helper length (count + 1))
    else (ANSITerminal.(print_string [yellow] ((string_of_int count) ^ "\n")))
  in printX_helper width 0

(** [print_grid sqaure] is used to print the specific grid based on the type
    of the [sqaure] *)
let print_grid = function
  | Reveal n -> if n = 0 then print_string "   " 
    else if n = 1 then ANSITerminal.(print_string [blue] ((string_of_int n) ^
                                                          "  "))
    else if n = 2 then ANSITerminal.(print_string [green] ((string_of_int n) ^ 
                                                           "  "))
    else if n = 3 then ANSITerminal.(print_string [red] ((string_of_int n) ^ 
                                                         "  "))
    else if n = 4 then ANSITerminal.(print_string [cyan] ((string_of_int n) ^ 
                                                          "  "))
    else if n = 5 then ANSITerminal.(print_string [magenta] ((string_of_int n) ^ 
                                                             "  "))
    else if n = 6 then ANSITerminal.(print_string [yellow] ((string_of_int n) ^
                                                            "  "))
    else if n = 7 then ANSITerminal.(print_string [white] ((string_of_int n) ^
                                                           "  "))
    else if n = 8 then ANSITerminal.(print_string [black] ((string_of_int n) ^ 
                                                           "  "))
    else failwith "illegal configuration"
  | New -> ANSITerminal.(print_string [white] "⬜ ")
  | Flag -> ANSITerminal.(print_string [green] "🚩 ")
  | Bomb -> ANSITerminal.(print_string [red] "💣 ")

let print (ftnd:t) (bknd:Backend.t) (start:float) = 
  ANSITerminal.(print_string [red] ("Time Passed: "^(timer start)^"s"^"\n"));
  ANSITerminal.(print_string [red] 
                  ("Bombs Left: "^(string_of_int (num_bomb bknd ftnd))^"\n"));
  let width = List.length (List.hd ftnd) in
  printX width; 
  let rec print_helper (map:t) (count:int) = match map with
    | [] -> printX width;()
    | h1 :: t1 -> if count < 10 then
        ANSITerminal.(print_string [yellow] 
                        ((string_of_int count)^"  "))
      else ANSITerminal.(print_string [yellow] ((string_of_int count)^" ")); 
      let rec print_row (r:sqaure list) = match r with
        | [] -> failwith "Illegal configuration"
        | h::[] -> (print_grid h); 
          ANSITerminal.(print_string [yellow] (" " ^ (string_of_int count)));
          print_string "\n"
        | h::t -> (print_grid h); print_row t
      in print_row h1; print_helper t1 (count + 1)
  in print_helper ftnd 1
