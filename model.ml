open Backend
open Frontend

type action = Click | Flag | Working
type coordinate = int * int * action (* This is (r, c) *)

let get_nth grid m n = 
  List.nth (List.nth grid m) n

let get_num rvl = 
  match rvl with
  |Reveal x -> x
  |_ -> -1

let check_token front m n token = 
  let row = List.length front in
  let col = List.length (List.hd front) in
  if m >= row || m < 0 then 0 else 
  if n >= col || n < 0 then 0 else
  if get_nth front m n = token then 1 else 0

let count_surround_token front m n token = 
  check_token front (m-1) (n+1) token + check_token front m (n+1) token 
  + check_token front (m+1) (n+1) token
  + check_token front (m-1) n token + check_token front (m+1) n token
  + check_token front (m-1) (n-1) token + check_token front m (n-1) token 
  + check_token front (m+1) (n-1) token

let find_empty_square front m n = 
  if check_token front (m-1) (n+1) New = 1 then (m-1, n+1) else
  if check_token front (m-1) (n-1) New = 1 then (m-1, n-1) else
  if check_token front (m-1) (n) New = 1 then (m-1, n) else
  if check_token front (m+1) (n+1) New = 1 then (m+1, n+1) else
  if check_token front (m+1) (n-1) New = 1 then (m+1, n-1) else
  if check_token front (m+1) (n) New = 1 then (m+1, n) else
  if check_token front (m) (n+1) New = 1 then (m, n+1) else
  if check_token front (m) (n-1) New = 1 then (m, n-1) else
    (-1, -1)

let get_grid (front: Frontend.t) = 
  let row = List.length front - 1 in
  let col = List.length (List.hd front) in
  let rec iter front row_count col_count row col = 
    if col_count = col && row_count = row then (0, 0, Working)
    else if col_count = col then (iter front (row_count+1) 0 row col)
    else 
      (let num = get_num (get_nth front row_count col_count) in 
       if num <> -1 || num <> 0 then
         (let coord = find_empty_square front row_count col_count in 
          if coord <> (-1, -1) then
            (if count_surround_token front row_count col_count New = 
                num - count_surround_token front row_count col_count Flag then 
               (Pervasives.fst coord, Pervasives.snd coord, Flag)
             else if count_surround_token front row_count col_count Flag = num 
             then (Pervasives.fst coord, Pervasives.snd coord, Click)
             else (iter front row_count (col_count+1) row col))
          else (iter front row_count (col_count+1) row col))
       else (iter front row_count (col_count+1) row col)) in
  iter front 0 0 row col

let rec find_random front = 
  let row = List.length front in
  let col = List.length (List.hd front) in
  let () = Random.self_init() in 
  let x = Random.int row in 
  let y = Random.int col in
  if check_token front x y New = 1 then (x, y)
  else find_random front

let take_out ft = 
  match ft with
  |Some f -> f
  |_ -> create_front 10 10

let check_flag (f:Frontend.t) x y =
  let n = List.length f in
  let m = List.length (List.hd f) in
  if x >= n || x < 0 || y >= m || y < 0 then 0 
  else if List.nth (List.nth f x) y = Flag then 1 else 0

let count_flag (f:Frontend.t) = 
  let rec count_flag_col rind acc_1 =
    if rind < List.length f then
      let rec count_flag_row cind acc_2 = if cind < List.length (List.hd f) then
          count_flag_row (cind + 1) (acc_2 + (check_flag f rind cind))
        else acc_2 in count_flag_col (rind + 1) (acc_1 + count_flag_row 0 0)
    else acc_1 in count_flag_col 0 0

let has_bomb (f:Frontend.t) = 
  let rec count_bomb_col rind  =
    if rind < List.length f then
      let rec count_bomb_row cind = if cind < List.length (List.hd f) then
          (if get_nth f rind cind = Bomb then true
           else count_bomb_row (cind + 1)) else count_bomb_col (rind + 1)
      in count_bomb_row 0
    else false in count_bomb_col 0

let has_new (f:Frontend.t) = 
  let rec count_new_col rind  =
    if rind < List.length f then
      let rec count_new_row cind = if cind < List.length (List.hd f) then
          (if get_nth f rind cind = New then true
           else count_new_row (cind + 1)) else count_new_col (rind + 1)
      in count_new_row 0
    else false in count_new_col 0

let is_ai_won ftnd bknd = (count_bomb bknd = count_flag ftnd && 
                           not (has_new ftnd))

let is_ai_lose ftnd = has_bomb ftnd

let play m n b t = 
  let x = Random.int m in
  let y = Random.int n in
  let ft = Frontend.create_front m n in
  let bk = Backend.create () x y m n b in
  let ftnd = Frontend.reveal x y bk (Some ft) in
  let rec play_helper ftnd bknd =
    print_endline "Processing...";
    Unix.sleepf 0.6;
    if is_ai_won ftnd bknd then (print ftnd bknd t;
                                 print_string "\n";
                                 ANSITerminal.(print_string [green] 
                                                 "\n \
                                                  Great! Your AI won! \n");)
    else if is_ai_lose ftnd then (print ftnd bknd t;
                                  print_string "\n";
                                  ANSITerminal.(print_string [green]
                                                  "\n \
                                                   Oops! Your AI lost! \
                                                   Try an easier game \
                                                   next time! \n");)
    else
      (print ftnd bknd t;
       print_string "\n";
       let cor = get_grid ftnd in
       match cor with
       | (r, c, a) -> match a with
         | Flag -> play_helper (take_out (Frontend.flag r c ftnd)) bknd
         | Click -> (play_helper (take_out (Frontend.reveal r c bknd 
                                              (Some ftnd))) bknd)
         | Working -> let cor = find_random ftnd in 
           (play_helper (take_out 
                           (Frontend.reveal (Pervasives.fst cor) 
                              (Pervasives.snd cor) bknd (Some ftnd))) bknd))
  in play_helper (take_out ftnd) bk
