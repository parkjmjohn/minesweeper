open OUnit2
open Frontend
open Backend
open Leaderboard
let empty_board = create_front 5 5

let bknd_test = [[Backend.Bomb; Backend.Clear 4; Backend.Bomb; Backend.Clear 2;
                  Backend.Clear 1];
                 [Backend.Bomb; Backend.Bomb; Backend.Clear 4; Backend.Bomb; Backend.Clear 1];
                 [Backend.Bomb; Backend.Bomb; Backend.Clear 3; Backend.Clear 2;
                  Backend.Clear 2];
                 [Backend.Clear 3; Backend.Clear 3; Backend.Clear 2; Backend.Clear 2;
                  Backend.Bomb];
                 [Backend.Bomb; Backend.Clear 1; Backend.Clear 1; Backend.Bomb;
                  Backend.Clear 2]]

let take_ftnd = function
  | None -> create_front 5 5
  | Some ftnd -> ftnd

let frontend_test = 
  [
    "initial_board" >:: (fun _ -> assert_equal empty_board [[New; New; New; New; New]; [New; New; New; New; New];
                                                            [New; New; New; New; New]; [New; New; New; New; New];
                                                            [New; New; New; New; New]] );
    "ammend_bomb_1_1" >:: (fun _ -> assert_equal (ammend empty_board 1 2 Bomb) [[New; New; New; New; New]; [New; New; Bomb; New; New];
                                                                                [New; New; New; New; New]; [New; New; New; New; New];
                                                                                [New; New; New; New; New]]);
    "flag_2_2" >:: (fun _ -> assert_equal (flag 2 2 empty_board)  (Some [[New; New; New; New; New]; [New; New; New; New; New];
                                                                         [New; New; Flag; New; New]; [New; New; New; New; New];
                                                                         [New; New; New; New; New]]))                                    
  ]

let combined_test =
  [
    "reveal_bomb" >:: (fun _ -> assert_equal (reveal 0 0 bknd_test (Some empty_board)) (Some [[Bomb; Reveal 4; Bomb; Reveal 2; Reveal 1];
                                                                                              [Bomb; Bomb; Reveal 4; Bomb; Reveal 1];
                                                                                              [Bomb; Bomb; Reveal 3; Reveal 2; Reveal 2];
                                                                                              [Reveal 3; Reveal 3; Reveal 2; Reveal 2; Bomb];
                                                                                              [Bomb; Reveal 1; Reveal 1; Bomb; Reveal 2]]));
    "reveal_clear_1" >:: (fun _ -> assert_equal (reveal 0 1 bknd_test (Some empty_board)) (Some [[New; Reveal 4; New; New; New]; [New; New; New; New; New];
                                                                                                 [New; New; New; New; New]; [New; New; New; New; New];
                                                                                                 [New; New; New; New; New]]));
    "flag_3_4" >:: (fun _ -> assert_equal (flag 3 4 (take_ftnd (reveal 0 1 bknd_test (Some empty_board)))) (Some [[New; Reveal 4; New; New; New]; [New; New; New; New; New];
                                                                                                                  [New; New; New; New; New]; [New; New; New; New; Flag];
                                                                                                                  [New; New; New; New; New]]));
    "reveal_clear_2" >:: (fun _ -> assert_equal (reveal 2 2 bknd_test (Some empty_board)) (Some [[New; New; New; New; New]; [New; New; New; New; New];
                                                                                                 [New; New; Reveal 3; New; New]; [New; New; New; New; New];
                                                                                                 [New; New; New; New; New]]));
    "reveal_clear_3" >:: (fun _ -> assert_equal (reveal 2 2 bknd_test (reveal 0 1 bknd_test (Some empty_board))) (Some [[New; Reveal 4; New; New; New]; [New; New; New; New; New];
                                                                                                                        [New; New; Reveal 3; New; New]; [New; New; New; New; New];
                                                                                                                        [New; New; New; New; New]]));
    "reveal_bomb_2" >:: (fun _ -> assert_equal (reveal 4 3 bknd_test (reveal 0 1 bknd_test (Some empty_board))) (Some [[Bomb; Reveal 4; Bomb; Reveal 2; Reveal 1];
                                                                                                                       [Bomb; Bomb; Reveal 4; Bomb; Reveal 1];
                                                                                                                       [Bomb; Bomb; Reveal 3; Reveal 2; Reveal 2];
                                                                                                                       [Reveal 3; Reveal 3; Reveal 2; Reveal 2; Bomb];
                                                                                                                       [Bomb; Reveal 1; Reveal 1; Bomb; Reveal 2]]));
    "random_test" >:: (fun _ -> assert_bool "random_equal" (not ((create () 4 4 5 5 5) = (create () 4 4 5 5 5))));
    "first_click_safe" >:: (fun _ -> let bknd = create () 5 5 8 6 45 in assert_bool "click_fail" (not (Bomb = (bknd_get bknd 5 5))))
  ]
let bubble_sort_gen name inp exp =
  name >:: (fun _ -> assert_equal (Leaderboard.bubble_sort inp) exp)

let bubble_sort_tests = [
  bubble_sort_gen "123" [1;2;3] [1;2;3];
  bubble_sort_gen "321" [3;2;1] [1;2;3];
  bubble_sort_gen "12354" [1;2;3;5;4] [1;2;3;4;5];
  bubble_sort_gen "(12)(2)(51)(1)" [12;2;51;1] [1;2;12;51];
  bubble_sort_gen "(-1)(-2)" [-1;-2] [-2;-1];
  bubble_sort_gen "1(-10)50(-100)(-1)" [1;-10;50;-100;-1] [-100;-10;-1;1;50]
]
let suite = "search test suite" >::: List.flatten [
    frontend_test;
    combined_test;
    bubble_sort_tests
  ]



let _ = run_test_tt_main suite