// -*- C -*-
// File: sem_stubs.c
//
// Author: Paul Argentoff <argentoff@gmail.com>
//
// Created: Thu Apr 14 18:58:45 2005
//
// $Id: sem_stubs.c 358 2005-05-04 12:46:02Z paul $
//
#include <fcntl.h>
#include <semaphore.h>
#include <string.h>

#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/callback.h>
#include <caml/signals.h>
#include <caml/fail.h>

// from Unix ocaml library

#ifndef O_NONBLOCK
#define O_NONBLOCK O_NDELAY
#endif
#ifndef O_DSYNC
#define O_DSYNC 0
#endif
#ifndef O_SYNC
#define O_SYNC 0
#endif
#ifndef O_RSYNC
#define O_RSYNC 0
#endif

static int open_flag_table[] = {
    O_RDONLY, O_WRONLY, O_RDWR, O_NONBLOCK, O_APPEND, O_CREAT, O_TRUNC, O_EXCL,
    O_NOCTTY, O_DSYNC, O_SYNC, O_RSYNC
};

extern void uerror (char * cmdname, value cmdarg);

// my own code

#define NONE Val_int(0)
#define SOME 0


value stub_sem_open(value name,
                    value oflags,
                    value perm,
                    value init) {

    int cv_oflags;
    char * cv_name;
    sem_t * sem;

    CAMLparam4 (name, oflags, perm, init);

    cv_oflags = convert_flag_list(oflags, open_flag_table);
    cv_name = stat_alloc(string_length(name) + 1);
    strcpy(cv_name, String_val(name));
    enter_blocking_section();
    sem = sem_open(cv_name, cv_oflags, Int_val(perm), Int_val(init));
    leave_blocking_section();
    stat_free(cv_name);
    if (sem == SEM_FAILED) {
        uerror("sem_open", name);
    };

    CAMLreturn ((value) sem);
};

value stub_sem_close(value sem) {
    CAMLparam1(sem);
    CAMLlocal1(estr);

    estr = copy_string("");

    if (sem_close((sem_t *) sem) == -1) {
        uerror("sem_close", estr);
    };

    CAMLreturn(Val_unit);
};

value stub_sem_unlink(value name) {
    CAMLparam1(name);

    char * cv_name = stat_alloc(string_length(name) + 1);
    strcpy(cv_name, String_val(name));
    if (sem_unlink(cv_name) == -1) {
        uerror("sem_unlink", name);
    };
    stat_free(cv_name);

    CAMLreturn(Val_unit);
};

value stub_sem_post(value sem) {
    CAMLparam1(sem);
    CAMLlocal1(estr);

    estr = copy_string("");

    if (sem_post((sem_t *) sem) == -1) {
        uerror("sem_post", estr);
    };

    CAMLreturn(Val_unit);
};

value stub_sem_wait(value sem) {
    CAMLparam1(sem);
    CAMLlocal1(estr);

    estr = copy_string("");

    if (sem_wait((sem_t *) sem) == -1) {
        uerror("sem_wait", estr);
    };

    CAMLreturn(Val_unit);
};

value stub_sem_trywait(value sem) {
    CAMLparam1(sem);
    CAMLlocal1(estr);

    estr = copy_string("");

    if (sem_trywait((sem_t *) sem) == -1) {
        uerror("sem_trywait", estr);
    };

    CAMLreturn(Val_unit);
};

value stub_sem_getvalue(value sem) {
    int * vp;

    CAMLparam1(sem);
    CAMLlocal2(estr, v);

    estr = copy_string("");

    vp = calloc(1, sizeof(int));
    if (sem_getvalue((sem_t *)sem,vp) == -1) {
        uerror("sem_getvalue", estr);
    };
    v = Val_int(*vp);
    free(vp);

    CAMLreturn(v);
};

value stub_sem_init(value semop, value pshared, value ival) {
    sem_t * sem;
    CAMLparam3(semop, pshared, ival);
    CAMLlocal1(estr);

    estr = copy_string("");

    if (semop != NONE) {
        sem = (sem_t *) Field(semop, SOME);
    };
    if (sem_init(sem, Int_val(pshared), Int_val(ival)) == -1) {
        uerror("sem_init", estr);
    };

    CAMLreturn((value) sem);
};

value stub_sem_destroy(value sem) {
    CAMLparam1(sem);
    CAMLlocal1(estr);

    estr = copy_string("");

    if (sem_destroy((sem_t *) sem) == -1) {
        uerror("sem_destroy", estr);
    };

    CAMLreturn(Val_unit);
};
