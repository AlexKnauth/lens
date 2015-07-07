#lang scribble/manual

@(require scribble/eval
          syntax/parse/define
          "../lenses-examples.rkt"
          "../deflenses.rkt"
          (for-syntax racket/base
                      racket/syntax)
          (for-label lens
                     racket/base
                     racket/contract))

@title{Pair lenses}

@deflenses[(car-lens cdr-lens)]{
  Lenses for examining the @racket[car] and @racket[cdr] of
  a pair.
  @lenses-examples[
    (lens-view car-lens '(a . b))
    (lens-view cdr-lens '(a . b))
]}


@(define-for-syntax (c_r-lens-id id-stx)
   (format-id id-stx "c~ar-lens" id-stx #:source id-stx #:props id-stx))

@(define-simple-macro (defc_rlenses [c_r-id:id ...] pre-flow ...)
   (deftogether ((defc_rlens c_r-id) ...) pre-flow ...))

@(define-simple-macro (defc_rlens c_r-id)
   #:with c_r-lens (c_r-lens-id #'c_r-id)
   (deflens c_r-lens))

@defc_rlenses[(
  aa ad da dd
  aaa aad ada add
  daa dad dda ddd
  aaaa aaad aada aadd
  adaa adad adda addd
  daaa daad dada dadd
  ddaa ddad ddda dddd)]{
    Lenses for accessing nested pairs. Each lens's view is the
    equivalently named pair-accessor function.
    @lenses-examples[
      (cdaddr '(9 8 (6 5 4 3 2 1) 7))
      (lens-view cdaddr-lens '(9 8 (6 5 4 3 2 1) 7))
      (lens-transform cdaddr-lens list->vector '(9 8 (6 5 4 3 2 1) 7))
]}