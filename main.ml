open Command
open Frontend
open Leaderboard

(** [resize_terminal] resizes terminal based on the content printed *)
let resize_terminal cor = 
  let y = cor |> Pervasives.fst in
  let x = cor |> Pervasives.snd in
  if y < 7 then ANSITerminal.resize 25 (19 + y)
  else ANSITerminal.resize (x * 3 + 48) (19 + y)

(** [make_front] returns a new frontend *)
let make_front m n = fun () ->
  resize_terminal (m, n);
  create_front m n

(** [make_back] returns a new backend *)
let make_back fst_r fst_c m n num_b = fun () ->
  Backend.create () fst_r fst_c m n num_b

(** [flag] function returns a new type t given a coordinate to flag by 
    calling the flag function from the frontend *)
let flag cor t = 
  let x = cor |> Pervasives.fst in
  let y = cor |> Pervasives.snd in
  let print_statement = "\nFlagged (" ^ Pervasives.string_of_int x ^ ", " ^ 
                        Pervasives.string_of_int y ^ ")\n" in
  print_endline print_statement;
  flag (x-1) (y-1) t

(** [flag] function returns a new type t given a coordinate to flag by 
    calling the flag function from the frontend *)
let unflag cor t = 
  let x = cor |> Pervasives.fst in
  let y = cor |> Pervasives.snd in
  let print_statement = "\nUnflagged (" ^ Pervasives.string_of_int x ^ ", " ^ 
                        Pervasives.string_of_int y ^ ")\n" in
  print_endline print_statement;
  unflag (x-1) (y-1) t

(** [click] function returns a new type t given a coordinate and a backend 
    to click by calling the flag function from the frontend *)
let click cor b t = 
  let x = cor |> Pervasives.fst in
  let y = cor |> Pervasives.snd in
  let print_statement = "\nClicked (" ^ Pervasives.string_of_int x ^ ", " ^ 
                        Pervasives.string_of_int y ^ ")\n" in
  print_endline print_statement;
  if (x - 1 <0) ||(y - 1 < 0) || (x - 1 >= List.length b) 
     || y - 1 >= List.length (List.hd b) then None
  else reveal (x-1) (y-1) b t

(** [quit_helper ()] is the string containing the "good bye" message  *)
let quit_helper = fun () -> 
  ANSITerminal.(print_string [blue] "\n\n\n\n\n
★─▄█▀▀║░▄█▀▄║▄█▀▄║██▀▄║─★
★─██║▀█║██║█║██║█║██║█║─★
★─▀███▀║▀██▀║▀██▀║███▀║─★
★───────────────────────★
★───▐█▀▄─ ▀▄─▄▀ █▀▀──█───★
★───▐█▀▀▄ ──█── █▀▀──▀───★
★───▐█▄▄▀ ──▀── ▀▀▀──▄───★\n\n\n\n\n\n")

(** [quit] function calls the ANSITerminal to print a quit message = *)
let quit = fun () ->
  let x = ANSITerminal.size () |> Pervasives.fst in
  if x < 39
  then
    let new_x = 38 in
    ANSITerminal.resize new_x 17;
    quit_helper ()
  else 
    let new_x = x in
    ANSITerminal.resize new_x 17;
    quit_helper ()

(** [new_bknd fst_r fst_c b] is a randombly generated backend with the same
    size and number of bombs as [b] and with guaranteed no [Bomb] on the square
    in row [fst_r] and column [fst_c.] *)
let new_bknd fst_r fst_c b = make_back fst_r fst_c (List.length b) 
    (List.length (List.hd b)) (Backend.count_bomb b)

(** [is_new_bknd] checks to ensure valid coordinates have been given, and then
    generates a new backend with the first click at those coordinates, otherwise 
    it returns the original backend  *)
let is_new_bknd cor b = 
  let x = cor |> Pervasives.fst in
  let y = cor |> Pervasives.snd in
  if (x - 1 <0) ||(y - 1 < 0) || (x - 1 >= List.length b) 
     || y - 1 >= List.length (List.hd b) then b
  else new_bknd (x - 1) (y - 1) b ()

(** [game_inro ()] is simply the intro text to the  game, to be 
    displayed upon beginning.  *)
let game_intro () =
  (ANSITerminal.(print_string [green] "\nType in \n \
                                       \"make\" to start with a 9 by 9 board wi\
                                       th 10 bombs \n \
                                       \"make [r] [c] [b]\" to start with \
                                       a [r] by [c] board with [b] bombs \n \
                                       \"AI [r] [c] [b]\" to watch the AI playing \
                                       a [r] by [c] board with [b] bombs \n \
                                       \"quit\" to exit\n \
                                       \"leaderboard\" to see the top \
                                       scores\n");
   print_string "\n> ";)

(** [play] is the game loop that works with the backend and the frontend *)
let rec play (step:int) (b:Backend.t) (t:Frontend.t) (start_time:float) 
    (user:string) =
  if (not (has_won (Some t) b)) then
    (print t b start_time;
     ANSITerminal.(print_string [green] "\n\nMoves:\n");
     ANSITerminal.(print_string [green] "  \"click x y\" to reveal\n");
     ANSITerminal.(print_string [green] "  \"flag x y\" to indicate\n");
     ANSITerminal.(print_string [green] "  \"unflag x y\" to cancel the \
                                         flag\n");
     ANSITerminal.(print_string [green] "  \"help\" to get a next move hint\n");
     ANSITerminal.(print_string [green] "  \"restart\" to restart the game \
                                         with the same board size and bombs \
                                         number\n");
     ANSITerminal.(print_string [green] "  \"quit\" to go back to the \
                                         homepage\n\n\n");
     print_string "> ";
     let command = read_line () in
     match parse command with
     | exception Empty -> 
       play step b t start_time user
     | exception Malformed -> 
       print_endline "\nMalformed Command\n";
       play step b t start_time user
     | Flag(cor) ->
       let flagged_t = flag cor t in
       begin
         match flagged_t with
         | None ->
           print_endline "\nMalformed Command\n";
           play step b t start_time user
         | Some new_t ->
           play step b new_t start_time user
       end
     | Unflag(cor) ->
       let unflagged_t = unflag cor t in
       begin
         match unflagged_t with
         | None ->
           print_endline "\nMalformed Command\n";
           play step b t start_time user
         | Some new_t ->
           play step b new_t start_time user
       end
     | Click(cor) ->
       let bknd = if step = 0 then is_new_bknd cor b else b in
       let clicked_t = click cor bknd (Some t) in
       begin
         match clicked_t with
         | None ->
           print_endline "\nMalformed Command\n";
           play step bknd t start_time user
         | Some new_t ->
           if (Backend.check_bomb bknd 
                 (Pervasives.fst cor - 1) (Pervasives.snd cor - 1) = 0)
           then (play (step + 1) bknd new_t start_time user)
           else (print (Frontend.reveal_all (List.length bknd) 
                          (List.length (List.hd bknd)) bknd) bknd start_time;
                 ANSITerminal.(print_string [green] 
                                 "\n \
                                  Oops! You lost! Do you want to play it \
                                  again? \n \
                                  input [yes/no] to restart/go back to the \
                                  homepage\n");
                 let command = read_line () in 
                 let rec after_lose command (b:Backend.t) (t:Frontend.t) =
                   if command = "yes" then (let r = List.length b in 
                                            let c = List.length (List.hd b) in
                                            let n = Backend.count_bomb b in
                                            play 0 (make_back 0 0 r c n ()) 
                                              (make_front r c ())
                                              (Unix.time ())) user
                   else if command = "no" then 
                     (game_intro ();
                      let command = read_line () in start user command)
                   else 
                     (ANSITerminal.(print_string [green] 
                                      "\nInvalid Input. Please input \
                                       [yes/no]\n");
                      let new_command = read_line () in 
                      after_lose new_command b t)
                 in after_lose command bknd t)
       end
     | Restart -> let r = List.length b in let c = List.length (List.hd b) in
       let n = Backend.count_bomb b in
       play 0 (make_back 0 0 r c n ()) (make_front r c ()) (Unix.time ()) user
     | Help ->
       begin
         let new_t = help b (Some t) in 
         match new_t with
         | None ->
           print_endline "\nMalformed Command\n";
           play step b t start_time user
         | Some new_t ->
           play step b new_t start_time user
       end
     | Quit -> 
       game_intro ();
       let command = read_line () in start user command
     | _ -> 
       print_endline "\n\nInvalid Command\n";
       play step b t start_time user)

  else (print (Frontend.reveal_all (List.length b) 
                 (List.length (List.hd b)) b) b start_time;
        let bombs = Backend.count_bomb b in
        let squares = (List.length b) * (List.length (List.hd b)) in
        let score = calculate_score bombs squares (Unix.time () -. start_time) 
        in write_leaderboard user score;
        ANSITerminal.(print_string [green] 
                        ("\n Your score was " ^ score));
        ANSITerminal.(print_string [green] 
                        "\n \
                         You won! Congratulations! Do you want to play it \
                         again? \n \
                         input [yes/no] to restart/go back to the \
                         homepage\n");
        print_string "\n> ";
        let command = read_line () in 
        let rec after_win command (b:Backend.t) (t:Frontend.t) =
          if command = "yes" then (let r = List.length b in 
                                   let c = List.length (List.hd b) in
                                   let n = Backend.count_bomb b in
                                   play 0 (make_back 0 0 r c n ()) 
                                     (make_front r c ()) (Unix.time ()) user)
          else if command = "no" then 
            (game_intro (); let command = read_line () in start user command)
          else (ANSITerminal.(print_string [green] 
                                "Invalid Input. Please input [yes/no]\n");
                let new_command = read_line () in after_win new_command b t)
        in after_win command b t)

(** [start] is the loop that occurs prior to the game *)
and start name first_command =
  match parse first_command with
  | exception Empty -> 
    begin
      print_string "> ";
      match read_line () with
      | exception End_of_file -> ()
      | first_command -> start name first_command
    end
  | exception Malformed -> 
    begin
      print_endline "\n\nInvalid Input\n";
      print_string "> ";
      match read_line () with
      | exception End_of_file -> ()
      | first_command -> start name first_command
    end
  | Play ->
    let t = make_front 9 9 () in
    let b = make_back 5 5 9 9 10 () in
    let start = Unix.time () in
    print_string "\n\n\n";
    play 0 b t start name
  | Make(config) -> 
    let t = make_front (List.hd config) (List.nth config 1) () in
    let b = make_back 0 0 (List.hd config) (List.nth config 1) 
        (List.nth config 2) () in 
    let start_time = Unix.time () in
    print_string "\n\n\n";
    play 0 b t start_time name
  | AI(config) ->
    (Model.play (List.hd config) (List.nth config 1) 
       (List.nth config 2) (Unix.time ());
     print_string "\n\n\n";
     game_intro ();
     match read_line () with
     | exception End_of_file -> ()
     | first_command -> start name first_command)
  | Scores ->
    begin
      print_endline "\n\nTop Scores:\n";
      print_scores ();
      print_string "\n> ";
      match read_line () with
      | exception End_of_file -> ()
      | first_command -> start name first_command
    end
  | Quit -> 
    quit ()
  | _ -> 
    begin
      print_endline "\n\nInvalid Command\n";
      game_intro ();
      match read_line () with
      | exception End_of_file -> ()
      | first_command -> start name first_command
    end

(** [saved_name name] saves the given name to the data file.  *)
let saved_name name =
  print_string ("\n\nHello " ^ name ^ "!\n");
  game_intro ();
  match read_line () with
  | exception End_of_file -> ()
  | first_command -> start name first_command

(** [main ()] prompts for the game to play, then starts it. *)
let main () =
  ANSITerminal.resize 72 17;
  ANSITerminal.(print_string [blue] "\n\n
          (_)                                                  
 _ __ ___  _ _ __   ___  _____      _____  ___ _ __   ___ _ __ 
| '_ ` _ \\| | '_ \\ / _ \\/ __\\ \\ /\\ / / _ \\/ _ \\ '_ \\ / _ \\ '__|
| | | | | | | | | |  __/\\__ \\\\ V  V /  __/  __/ |_) |  __/ |   
|_| |_| |_|_|_| |_|\\___||___/ \\_/\\_/ \\___|\\___| .__/ \\___|_|   
                                              | |              
                                              |_| \n\n");
  ANSITerminal.(print_string [green] "\nWelcome to MINESWEEPER\n");
  print_endline "\nEnter your name";
  print_string "\n> ";
  match read_line () with
  | exception End_of_file -> ()
  | name ->
    saved_name name

(* Execute the game engine *)
let () = main ()
