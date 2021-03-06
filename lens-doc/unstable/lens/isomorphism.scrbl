#lang scribble/manual

@(require lens/private/doc-util/main)

@title{Isomorphisms}

@defproc[(make-isomorphism-lens [f (a/c . -> . b/c)] [inv (b/c . -> . a/c)]) lens?]{
Creates a lens for an isomorphism. The @racket[f] argument should be a function
with an inverse, and the @racket[inv] argument should be its inverse.
The @racket[f] function converts targets to views, and the @racket[inv] function
converts views to targets.

So for instance a @racket[symbol->string-lens] could be defined with:
@racketblock[
  (define symbol->string-lens
    (make-isomorphism-lens symbol->string string->symbol))
]
@lens-unstable-examples[
  (lens-view symbol->string-lens 'something)
  (lens-transform symbol->string-lens 'something (λ (s) (string-append "make-" s)))
]}

@defproc[(isomorphism-lens? [v any/c]) boolean?]{
A predicate that returns true when @racket[v] is a lens constructed with
@racket[make-isomorphism-lens], @racket[isomorphism-lens-inverse], or
@racket[make-isomorphism-lenses], and returns false otherwise.
All isomorphism lenses are also lenses according to @racket[lens?].
}

@defproc[(isomorphism-lens-inverse [iso-lens isomorphism-lens?]) isomorphism-lens?]{
Returns the inverse of @racket[iso-lens].
}

@defproc[(make-isomorphism-lenses [f (a/c . -> . b/c)] [inv (b/c . -> . a/c)])
         (values isomorphism-lens? isomorphism-lens?)]{
Returns two values. The first value is the result of
@racket[(make-isomorphism-lens f inv)], and the second value is the inverse of that
lens.

The lenses @racket[symbol->string-lens] and @racket[string->symbol-lens], for
example, are defined like this:
@racketblock[
  (define-values [string->symbol-lens symbol->string-lens]
    (make-isomorphism-lenses string->symbol symbol->string))
]}

@defproc[(isomorphism-compose [lens isomorphism-lens?] ...) isomorphism-lens?]{
Like @racket[lens-compose], but works only on isomorphism lenses, and returns an
isomorphism lens. It is also more efficient than @racket[lens-compose].
}

@defproc[(isomorphism-thrush [lens isomorphism-lens?] ...) isomorphism-lens?]{
Like @racket[lens-thrush], but works only on isomorphism lenses, and returns an
isomorphism lens. It is also more efficient than @racket[lens-thrush].
}

@deflenses[[string->symbol-lens symbol->string-lens
            number->string-lens string->number-lens
            list->vector-lens vector->list-lens
            list->string-lens string->list-lens]]{
Isomorphim lenses for @racket[string->symbol], @racket[number->string], and so on.
}
