#lang sweet-exp racket/base

provide struct->list-lens list->struct-lens

require racket/local
        unstable/lens/isomorphism/base
        for-syntax racket/base
                   racket/list
                   racket/struct-info
                   syntax/parse
module+ test
  require lens/private/base/base
          lens/private/test-util/test-lens
          rackunit

begin-for-syntax
  (define-syntax-class struct-id
    #:attributes (info constructor-id [accessor-id 1])
    [pattern struct-id:id
             #:attr v (syntax-local-value #'struct-id (λ () #f))
             #:when (struct-info? (attribute v))
             #:attr info (extract-struct-info (attribute v))
             #:with descriptor-id:id (first (attribute info))
             #:with constructor-id:id (syntax-property (second (attribute info))
                                                       'disappeared-use
                                                       (list (syntax-local-introduce #'struct-id)))
             #:with predicate-id:id (third (attribute info))
             #:with [accessor-id:id ...] (reverse (fourth (attribute info)))])

(define-syntax struct->list-lens
  (syntax-parser
    [(struct->list-lens s:struct-id)
     #'(local [(define (struct->list struct)
                 (list (s.accessor-id struct) ...))
               (define (list->struct list)
                 (apply s.constructor-id list))]
         (make-isomorphism-lens struct->list list->struct))]))

(define-syntax list->struct-lens
  (syntax-parser
    [(list->struct-lens s:struct-id)
     #'(isomorphism-lens-inverse (struct->list-lens s))]))

module+ test
  (struct foo (a b c))
  ;; foo is opaque, so struct->vector doesn't work
  (check-equal? (struct->vector (foo 1 2 3)) '#(struct:foo ...))
  (test-case "without inheritance"
    (check-equal? (lens-view (struct->list-lens foo) (foo 1 2 3)) '(1 2 3))
    (check-match (lens-set (struct->list-lens foo) (foo 1 2 3) '(4 5 6)) (foo 4 5 6))
    (check-match (lens-view (list->struct-lens foo) '(1 2 3)) (foo 1 2 3))
    (check-equal? (lens-set (list->struct-lens foo) '(1 2 3) (foo 4 5 6)) '(4 5 6)))
  (struct bar foo (d e))
  (test-case "inheriting from foo"
    (check-equal? (lens-view (struct->list-lens bar) (bar 1 2 3 4 5)) '(1 2 3 4 5))
    (check-match (lens-set (struct->list-lens bar) (bar 1 2 3 4 5) '(6 7 8 9 10)) (bar 6 7 8 9 10))
    (check-match (lens-view (list->struct-lens bar) '(1 2 3 4 5)) (bar 1 2 3 4 5))
    (check-equal? (lens-set (list->struct-lens bar) '(1 2 3 4 4) (bar 6 7 8 9 10)) '(6 7 8 9 10)))

