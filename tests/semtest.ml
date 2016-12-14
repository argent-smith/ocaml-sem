(* $Id: semtest.ml 323 2005-04-19 06:16:09Z paul $ *)

open Sem
open Printf

let _ =
  let oflags = [Unix.O_CREAT;
		Unix.O_EXCL] in
    try
      print_endline "opening sem";
      let sem = sem_open "/foobar" ~oflags () in
	printf "sem value is %d\n" (sem_getvalue sem);
	print_endline "posting sem";
	sem_post sem;
	printf "sem value is %d\n" (sem_getvalue sem);
	print_endline "waiting sem";
	sem_wait sem;
	printf "sem value is %d\n" (sem_getvalue sem);(*
	print_endline "try-waiting sem";
	sem_trywait sem;*)
	printf "sem value is %d\n" (sem_getvalue sem);
	print_endline "closing sem";
	sem_close sem;
	print_endline "deleting sem";
	sem_unlink "/foobar";
	print_endline "end"
    with
      | Unix.Unix_error (err,fn,arg) -> 
	  Printf.printf "In function '%s', arg '%s':\n\t" fn arg;
	  failwith (Unix.error_message err)
    
