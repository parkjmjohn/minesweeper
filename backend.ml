type square = Bomb | Clear of int

type t = square list list 

let bknd_get (bknd : t) c1 c2 = List.nth (List.nth bknd c1) c2

let rec bknd_get_rand_nonbomb bknd = 
  let n = List.length bknd in
  let m = List.length (List.hd bknd) in
  let x = Random.int n in
  let y = Random.int m in
  if (bknd_get bknd x y) <> Bomb then (x,y) else 
    bknd_get_rand_nonbomb bknd

let replace lst pos a = List.mapi (fun i x -> if i = pos then a else x) lst 

let check_bomb (b:t) x y =
  let n = List.length b in
  let m = List.length (List.hd b) in
  if x >= n || x < 0 || y >= m || y < 0 then 0 
  else if List.nth (List.nth b x) y = Bomb then 1 else 0

let count_bomb (b:t) = 
  let rec count_bomb_col rind acc_1 =
    if rind < List.length b then
      let rec count_bomb_row cind acc_2 = if cind < List.length (List.hd b) then
          count_bomb_row (cind + 1) (acc_2 + (check_bomb b rind cind))
        else acc_2 in count_bomb_col (rind + 1) (acc_1 + count_bomb_row 0 0)
    else acc_1 in count_bomb_col 0 0

let check_bomb_surround (b:t) x y = 
  let acc = check_bomb b x (y-1) + check_bomb b x (y+1) + check_bomb b (x-1) y 
            + check_bomb b (x+1) y + check_bomb b (x-1) (y-1)
            + check_bomb b (x+1) (y-1) + check_bomb b (x-1) (y+1)
            + check_bomb b (x+1) (y+1) in acc

let rec update_board (b:t) n_count m_count n m = 
  if m_count = m - 1 && n_count = n - 1 then 
    if List.nth (List.nth b n_count) m_count = Bomb then b
    else replace b n_count (replace (List.nth b n_count) m_count 
                              (Clear (check_bomb_surround b n_count m_count))) 
  else if m_count = m - 1 then 
    if List.nth (List.nth b n_count) m_count = Bomb then update_board b
        (n_count+1) 0 n m
    else update_board (replace b n_count 
                         (replace (List.nth b n_count) m_count 
                            (Clear (check_bomb_surround b n_count m_count))))
        (n_count+1) 0 n m 
  else if List.nth (List.nth b n_count) m_count = Bomb then 
    update_board b n_count (m_count+1) n m 
  else update_board (replace b n_count 
                       (replace (List.nth b n_count) m_count 
                          (Clear (check_bomb_surround b n_count m_count))))
      n_count (m_count+1) n m

let clear_area clicked_1 clicked_2 x y n m b = 
  if b <= n * m - 9 then
    (x = clicked_1 - 1 && y = clicked_2 + 1) ||
    (x = clicked_1 && y = clicked_2 + 1) ||
    (x = clicked_1 + 1 && y = clicked_2 + 1) ||
    (x = clicked_1 - 1 && y = clicked_2) ||
    (x = clicked_1 && y = clicked_2) ||
    (x = clicked_1 + 1 && y = clicked_2) ||
    (x = clicked_1 - 1 && y = clicked_2 - 1) ||
    (x = clicked_1 && y = clicked_2 - 1) ||
    (x = clicked_1 + 1 && y = clicked_2 - 1)
  else if b <= n * m - 1 then
    (x = clicked_1 && y = clicked_2)
  else false

let create (x:unit) clicked_1 clicked_2 n m b = 
  assert (n>0 && m>0 && b> 0 && b<m*n && clicked_1>=0 && clicked_1<n && 
          clicked_2>=0 && clicked_2<m);
  let rec create_row_helper m_count m acc = 
    if m_count = m then acc else create_row_helper (m_count+1) m (Clear 0::acc) 
  in let rec create_matrix_helper n_count n acc = 
       if n_count = n then acc else create_matrix_helper (n_count+1) n 
           ((create_row_helper 0 m [])::acc) in
  let rec create_bomb_helper b_count b acc = 
    if b_count = b then acc else 
      let () = Random.self_init() in
      let x = Random.int n in 
      let y = Random.int m in
      if List.nth (List.nth acc x) y = Bomb ||
         (clear_area clicked_1 clicked_2 x y n m b)
      then create_bomb_helper b_count b acc 
      else create_bomb_helper (b_count + 1) b 
          (replace acc x (replace (List.nth acc x) y Bomb)) in
  update_board (create_bomb_helper 0 b (create_matrix_helper 0 n [])) 0 0 n m