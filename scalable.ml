(** A naive implementation of big integers

This module aims at creating a set of big integers naively. Such data
types will be subsequently called bitarrays. A bitarray is a list of
zeros and ones ; first integer representing the sign bit. In this
context zero is reprensented by the empty list []. The list is to
be read from left to right ; this is the opposite convention to the
one you usually write binary decompositions with. After the sign bit
the first encountered bit is the coefficient in front of two to
the power zero. This convention has been chosen to ease writing
down code. A natural bitarray is understood as being a bitarray of
which you've taken out the sign bit, it is just the binary
decomposition of a non-negative integer.

 *)

(** Creates a bitarray from a built-in integer.
    @param x built-in integer.
*)

let inverse p =
  let rec f d = function
  [] -> d
    |e::l -> f (e::d) l
  in f [] p;;

let inverse_n p =
  let a = inverse p in
  let rec inv = function
  [] -> []
    |e::l when e = 0 -> inv l
    |e::l -> e::l
  in inv a

let enzero p =
  let a = inverse_n p in
  inverse a;;

  
let inverse_b p =
  let rec fi d = function
  [] -> d
    |e::l -> fi (e::d) l
  in
  match p with
      [] -> []
    |e::l -> e:: (fi [] l);;

let rec length = function
[]-> 0
  |e::l -> 1+ length l;;

let from_int x = if x = 0 then [] else let y = x in 
  let rec dectobin = function
  n  when n <= 0 -> []
    |n -> (n mod 2) :: dectobin (n/2)
  in if y < 0 then 1::dectobin (-x) else 0::dectobin x ;;

(** Transforms bitarray of built-in size to built-in integer.
    UNSAFE: possible integer overflow.
    @param bA bitarray object. ()
 *)
let to_int bA =
  let rec bintodec b = function
     [] -> 0
    |e::l when e = 1 ->  b +  bintodec (2*b) l
    |e::l  ->  bintodec (b*2) l
  in
  match bA with
      [] -> 0
    |e::bA when e = 1 -> -1* bintodec 1 bA
    |e::bA -> 1* bintodec 1 bA;;

(** Prints bitarray as binary number on standard output.
    @param bA a bitarray.
  *)
let print_b bA =
  let rec print d = function
    []-> d
    |e::l -> (if e = 1 then
              print ("1"^d) l else
      print ("0"^d) l)
  in
  match bA with
      [] -> print_string  "0";
   |e::bA when  e = 1 -> print_string "1" ;
                           print_string (print "" bA)
    |e::bA ->  print_string "0" ;
      print_string (print "" bA) ;;



let rec compare_n nA nB =
  let a = inverse_n nA in 
  let b = inverse_n nB in
  let rec comp = function 
  ([],[]) -> 0
    |(e::l, []) ->  1
    |([], e::l) ->  -1
    |(e::l,f::g) when e = f -> comp (l,g)
    |(e::l,f::g) when e > f -> 1
    |(e::l,f::g)  -> -1
  in
  if (length a) > (length b) then 1  else (if (length a) < (length b) then -1 else comp (a,b));;

(** Bigger inorder comparison operator on naturals. Returns true if
    first argument is bigger than second and false otherwise.
    @param nA natural.
    @param nB natural.
*)


let (>>!) nA nB =
if compare_n nA nB = 1 then true else false;;

(** Smaller inorder comparison operator on naturals. Returns true if
    first argument is smaller than second and false otherwise.
    @param nA natural.
    @param nB natural.
 *)
let (<<!) nA nB =
 if compare_n nA nB = (-1) then true else false;;

(** Bigger or equal inorder comparison operator on naturals. Returns
    true if first argument is bigger or equal to second and false
    otherwise.
    @param nA natural.
    @param nB natural.
 *)
let (>=!) nA nB =
 if compare_n nA nB = (-1) then false else true;;

(** Smaller or equal inorder comparison operator on naturals. Returns
    true if first argument is smaller or equal to second and false
    otherwise.
    @param nA natural.
    @param nB natural.
 *)
let (<=!) nA nB =
 if compare_n nA nB = 1 then false else true;;


(** Comparing two bitarrays. Output is 1 if first argument is bigger
    than second -1 if it smaller and 0 in case of equality.
    @param bA A bitarray.
    @param bB A bitarray.
*)

let rec length = function
[]-> 0
  |e::l -> 1+ length l;;

let compare_b bA bB = 
  match (bA,bB) with
      ([],[]) -> 0
    |(e::_, []) -> if e = 1 then -1 else 1
    |([], _::_) -> -1
    |(e::l,f::g) when (e = f && (length (enzero (e::l)) > (length (enzero (f::g))))) -> 1
    |(e::l,f::g) when (e = f && (length (enzero (e::l)) < (length (enzero (f::g))))) -> -1
    |(e::l,f::g) when (e = f && e=1) -> -1 * compare_n  l g
    |(e::l,f::g) when (e = f && e=1) -> -1 * compare_n  l g
    |(e::l,f::g) when (e = f && e=0) -> compare_n l g
    |(e::l,f::g) when  e=1  -> -1
    |(e::l,f::g) -> 1;;


  
(** Bigger inorder comparison operator on bitarrays. Returns true if
    first argument is bigger than second and false otherwise.
    @param nA natural.
    @param nB natural.
 *)
let (<<) bA bB =
  if compare_b bA bB = -1 then true else false;;

(** Smaller inorder comparison operator on bitarrays. Returns true if
    first argument is smaller than second and false otherwise.
    @param nA natural.
    @param nB natural.
 *)
let (>>) bA bB =
 if compare_b bA bB = 1 then true else false;;
(** Bigger or equal inorder comparison operator on bitarrays. Returns
    true if first argument is bigger or equal to second and false
    otherwise.
    @param nA natural.
    @param nB natural.
 *)
let (<<=) bA bB =
 if compare_b bA bB = 1 then false else true;;

(** Smaller or equal inorder comparison operator on naturals. Returns
    true if first argument is smaller or equal to second and false
    otherwise.
    @param nA natural.
    @param nB natural.
 *)
let (>>=) bA bB =
  if compare_b bA bB = (-1) then false else true;;

(** Sign of a bitarray.
    @param bA Bitarray.
*)
let sign_b bA =
  match bA with
      [] -> 1
    |e::l when e = 1 -> -1
    |e::l-> 1;;

(** Absolute value of bitarray.
    @param bA Bitarray.
*)
let abs_b bA =
   match bA with
      [] -> []
    |e::l when e = 1 -> 0::l
    |e::l-> e::l;;

(** Quotient of integers smaller than 4 by 2.
    @param a Built-in integer smaller than 4.
*)
let _quot_t a = 0

(** Modulo of integer smaller than 4 by 2.
    @param a Built-in integer smaller than 4.
*)
let _mod_t a = 0

(** Division of integer smaller than 4 by 2.
    @param a Built-in integer smaller than 4.
*)
let _div_t a = (0, 0)

(** Addition of two naturals.
    @param nA Natural.
    @param nB Natural.
*)
let add_n nA nB =
  let rec add d= function 
  ([],[]) -> if d = 1 then 1 :: [] else []
    |(e::l, []) |([], e::l) when e = 1 -> (if d =1  then 0:: add 1 (l,[]) else 1::add 0 (l,[]))
    |(e::l, []) |([], e::l) -> (if d =0  then 0:: add 0 (l,[]) else 1::add 0 (l,[]))
    |(e::l,f::g) when (e = f && e = 0) -> (if d = 0 then 0:: add 0 (l,g) else 1:: add 0 (l,g)) 
    |(e::l,f::g) when (e = f && e = 1) -> (if d = 1 then 1:: add 1 (l,g) else 0:: add 1 (l,g))
    |(e::l,f::g) -> (if d = 1 then 0:: add 1 (l,g) else 1:: add 0 (l,g))
  in add 0 (nA,nB);;

(** Difference of two naturals.
    UNSAFE: First entry is assumed to be bigger than second.
    @param nA Natural.
    @param nB Natural.
*)
let diff_n nA nB =
   let rec add d = function 
   ([],[]) -> []
     |(e::l, []) |([], e::l) when e = 1 -> (if d =1  then 0:: add 0 (l,[]) else 1::add 0 (l,[]))
     |(e::l, []) |([], e::l) -> (if d =0  then 0:: add 0 (l,[]) else 1::add 1 (l,[]))
     |(e::l,f::g) when (e = f && e = 0) -> (if d = 0 then 0:: add 0 (l,g) else 1:: add 1 (l,g)) 
     |(e::l,f::g) when (e = f && e = 1) -> (if d = 1 then 1:: add 1 (l,g) else 0:: add 0 (l,g))
     |(e::l,f::g) when e = 1 -> (if d = 1 then 0:: add 0 (l,g) else 1:: add 0 (l,g))
     |(e::l,f::g) -> (if d = 1 then 0:: add 1 (l,g) else 1:: add 1 (l,g))
   in if (<=!) nA nB then enzero (add 0 (nB,nA)) else enzero (add 0 (nA,nB));;

(** Addition of two bitarrays.
    @param bA Bitarray.
    @param bB Bitarray.
 *)
let add_b bA bB =
  match (bA,bB) with
      ([],[]) -> []
    |((e::f, [])|([], e::f)) -> e::f
    |(e::l,f::g) when e = f -> e :: (add_n l g )
    |(e::l,f::g) -> if ((<<) (abs_b (e::l)) (f::g)) then 0:: (diff_n g l ) else 1:: (diff_n l g )
      

(** Difference of two bitarrays.
    @param bA Bitarray.
    @param bB Bitarray.
*)
let diff_b bA bB =
  match (bA,bB) with
      ([],[]) -> []
    |(e::l, []) -> e::l
    |([], e::l) -> 1::l
    |(e::[],f::g) -> 1::g
    |(e::l,f::g) when (e = f && e = 1) -> enzero ( 1 :: (diff_n l g ))
    |(e::l,f::g) when (e = f && e = 0) -> (if (<<) (e::l) (f::g) then enzero (1:: (diff_n l g))  else enzero ( 0 ::(diff_n l g )))
    |(e::l,f::g) when e = 1 -> enzero ( 1:: (add_n g l ))
    |(e::l,f::g) -> enzero (0 :: (add_n l g)) ;;

(** Shifts bitarray to the left by a given natural number.
    @param bA Bitarray.
    @param d Non-negative integer.
*)
let shift bA d =
  let rec shi bA= function
     d when d = 0 -> bA
    |d ->  shi (0::bA) (d-1)
  in match bA with
      [] -> []
    |e::l-> e :: shi l d;;

(** Multiplication of two bitarrays.
    @param bA Bitarray.
    @param bB Bitarray.
*)
let mult_b bA bB =
  let rec mult d = function
  ([],[]) -> []
    |((e::f, [])|([], e::f))-> []
    |(e::f,l::g) when l = 1 -> add_b (shift (e::f) d) (mult (d+1) (e::f,g))
    |(e::f,l::g) -> mult (d+1) (e::f,g)
  in match (bA,bB) with
      ([],[]) -> []
    |((_::_, [])|([], _::_))-> []
    |(e::l,f::g) when (e = f && (e = 0 || e = 1)) -> mult 0 (0::l,g)
    |(e::l,f::g) -> mult 0 (1::l,g);;

(** Quotient of two bitarrays.
    @param bA Bitarray you want to divide by second argument.
    @param bB Bitarray you divide by. Non-zero!
*)
(*let mod_b bA bB =
  let rec modu = function
     ([],[]) -> []
    |(e::l, [])|([], e::l) -> e::l
    |(e,f) when (compare_b e f = 0) -> []
    |(e,f) when (compare_b e f = -1) -> e
    |(e,f) -> modu (diff_b e f,f)
  in
 if (<<) bA [] then abs_b (diff_b (modu (abs_b bA,bB)) bB) else modu (bA,bB);;*)


  

(*let quot_b bA bB =
  let rec quot d  = function
  ([],[]) -> d
    |(e::l, [])|([], e::l) -> d
    |(e::l,f::g) when (compare_n (e::l) (f::g) = -1)  -> d
    |(e::l,f::g) -> (quot (add_n [1] d) (diff_n (e::l) (f::g),f::g))
  in 
  match (bA,bB) with
      ([],[]) -> []
    |((e::l, [])|([], e::l)) -> []
    |(e::l,f::g) when (e = f && (e = 1 || e= 0))  -> 0::(quot [0] (l,g)) 
    |(e::l,f::g) -> 1 :: (quot [0] (l,g)) ;;*)

let quot_b bA bB =
  let rec quot i j a bA bc = function
  [] ->([],true)
    |b when (((<<=) bA b) && ( j = [0;1] || j = [] )) -> if compare_b b bA <> 0 then (if j = [] then (a,false) else (add_b [0;1] a,false)) else (if j = [] then (add_b [0;1] a,true) else (add_b [0;0;1] a,true))
    |b when (<<=) bA b -> quot [0;1] [] (add_b j a) (diff_b bA bc) [] (bB)
    |b -> quot (mult_b i [0;0;1]) i a bA b (mult_b b [0;0;1])
  in match bA with
      [] -> []
    |l when bB = [0;1] -> bA
    |e::l when e = 0 -> let (r,_) = quot [0;1] [] [] bA [] bB in r
    |l -> match (quot [0;1] [] [] (abs_b bA) [] bB) with
	([],_) -> []
	|(e::l,b) when b = false-> add_b (1 :: l) [1;1]
	|(e::l,b) -> 1 :: l;;

let mod_b bA bB =
  if (bA = bB || bB = [0;1]) then [] else 
   let rec quot i j bA bc = function
  [] -> []
    |b when (((<<=) bA b) && ( j = [0;1] || j = [] )) -> if bA = b then [] else  if (j = [0;1]) then diff_b bA bB else bA
    |b when (<<=) bA b -> quot [0;1] [] (diff_b bA bc) [] (bB)
    |b -> quot (mult_b i [0;0;1]) i bA b (mult_b b [0;0;1])
   in  match bA with
      [] -> []
    |l when bB = [0;1] -> bA
    |e::l when e = 0 -> quot [0;1] [] bA [] bB
    |l when (quot [0;1] [] (abs_b bA) [] bB) = [] -> quot [0;1] [] (abs_b bA) [] bB
    |l  -> add_b (mult_b (quot [0;1] [] (abs_b bA) [] bB) [1;1]) bB;;

(** Modulo of a bitarray against a positive one.
    @param bA Bitarray the modulo of which you're computing.
    @param bB Bitarray which is modular base.
 *)


(** Integer division of two bitarrays.
    @param bA Bitarray you want to divide.
    @param bB Bitarray you wnat to divide by.
*)
let div_b bA bB = (quot_b bA bB, mod_b bA bB);;
