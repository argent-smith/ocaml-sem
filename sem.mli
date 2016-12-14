(* $Id: sem.mli 358 2005-05-04 12:46:02Z paul $ *)

(** Ocaml interface to POSIX semaphores. Mimics the standard C library as met in
  * FreeBsd 5 (see [man sem_open], [man sem], etc.).
  * For the further reference see "ISO/IEC 9945-1:1996 (``POSIX.1'')." (find it youself ;)
  *
  * {b Author:} Paul Argentoff, argentoff\@gmail.com.
  *  @see <http://argentoff.rtelekom.ru> my homepage.
  *  @version $Id: sem.mli 358 2005-05-04 12:46:02Z paul $
*)

(** An abstract semaphore type. *)
type t

(** {2 Named semaphore operation }*)

(** [sem_open name oflags mode ival] creates or opens the named semaphore specified by
  [name].  The returned semaphore may be used in subsequent calls to
  [sem_getvalue], [sem_wait], [sem_trywait], [sem_post], and
  [sem_close]. [oflags] must be either [Unix.O_CREAT], [Unix.O_EXCL] or both.
  
  Default values:
  - [oflags = \[\]]
  - [mode = 0o600]
  - [ival = 0]
*)
val sem_open : string -> ?oflags: Unix.open_flag list -> ?mode: Unix.file_perm -> ?ival: int -> unit -> t

(** Closes the semaphore. *)
val sem_close : t -> unit

(** Erases the named semaphore. *)
val sem_unlink : string -> unit

(** {2 Generic semaphore operation} *)

(** [sem_post sem] increments (unlocks) the semaphore pointed to by
  [sem].  If there are threads blocked on the semaphore when [sem_post] is
  called, then the highest priority thread that has been blocked the long-
  est on the semaphore will be allowed to return from [sem_wait]. *)
val sem_post : t -> unit

(** [sem_wait sem] decrements (locks) the semaphore pointed to by
  [sem], but blocks if the value of [sem] is zero, until the value is non-zero
  and the value can be decremented. *)
val sem_wait : t -> unit

(** [sem_trywait sem] decrements (locks) the semaphore pointed to by
  [sem] only if the value is non-zero.  Otherwise, the semaphore is not
  decremented and an error is returned. *)
val sem_trywait : t -> unit

(** [sem_getvalue sem] returns a value of [sem]. *)
val sem_getvalue : t -> int

(** {2 Unnamed semaphore operation} *)

(** {b {i Note:}} the following two functions do semaphore creation/destruction
  only; all other operations (except [sem_open]) are common to named semaphores 
  and should be done by the functions documented above. *)

(** [sem_init semop pshared ival] initializes the unnamed semaphore. If 
  [semop = None], returns the newly created semaphore, else re-initializes 
  the existing one and returns it.
  The semaphore will have the value [ival].  A non-zero value for 
  [pshared] specifies a shared semaphore that can be used by multiple 
  processes, which this implementation is not capable of.
  
  Following a successful call to [sem_init], [sem] can be used as an argument
  in subsequent calls to [sem_wait], [sem_trywait], [sem_post], and
  [sem_destroy].  The sem argument is no longer valid after a successful
  call to [sem_destroy]).

  Default values:
  - [semop = None]
  - [pshared = 0]
  - [ival = 0]
*)
val sem_init : ?semop: t option -> ?pshared: int  -> ?ival:int -> unit -> t

(** [destroy sem] destroys the unnamed semaphore pointed to by
  [sem].  After a successful call to [sem_destroy], [sem] is unusable until re-
  initialized by another call to [sem_init]. *)
val sem_destroy : t -> unit
