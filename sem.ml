(* $Id: sem.ml 358 2005-05-04 12:46:02Z paul $ *)

(**
  {b Author:} Paul Argentoff, argentoff\@gmail.com.
  @see <http://argentoff.rtelekom.ru> my homepage.
  @version $Id: sem.ml 358 2005-05-04 12:46:02Z paul $
*)

type t

external _sem_open : string -> Unix.open_flag list -> Unix.file_perm -> int -> t = "stub_sem_open"

let sem_open name ?(oflags = []) ?(mode = 0o600) ?(ival = 0) () =
  _sem_open name oflags mode ival

external sem_close : t -> unit = "stub_sem_close"

external sem_unlink : string -> unit = "stub_sem_unlink"

external sem_post : t -> unit = "stub_sem_post"

external sem_wait : t -> unit = "stub_sem_wait"

external sem_trywait : t -> unit = "stub_sem_trywait"

external sem_getvalue : t -> int = "stub_sem_getvalue"

external _sem_init : t option -> int -> int -> t = "stub_sem_init"

let sem_init ?(semop = None) ?(pshared = 0) ?(ival = 0) () =
  _sem_init semop pshared ival

external sem_destroy : t -> unit = "stub_sem_destroy"
