type key = string
type value = string list

type t = (key * value) list

let rec get_keys (lst:t) = 
  List.sort_uniq compare (
    match lst with
    | [] -> []
    | (x,y) :: t -> x :: get_keys t
  )

let rec find (k : key )(d : t) : value option =
  match d with 
  | [] -> None
  | (x,y) :: t -> if x = k then Some y else find k t

let member (k :key) (d : t) : bool=
  match find k d with
  | None -> false
  | _ -> true

let remove (k:key)(d:t)=
  if (member k d) then
    (** [no_k] returns a copy of association list [lst] without values 
     * associated with [key]. *)
    let rec no_k (key : key) (lst :t ) acc = 
      match lst with 
      | [] -> acc
      | (x,y) :: t -> if key = x then let rec concat lst acc = match lst with
          | [] -> acc
          | h::t -> concat t (h::acc)
          in concat t acc
        else no_k key t ((x, y)::acc)
    in (no_k k d [])
  else d 

let insert k name d = if (not (member k d)) then (k,[name]) :: d
  else match (find k d) with
    | None -> d
    | Some y -> if (List.mem name y) then d else ((k, name::y)::(remove k d))
