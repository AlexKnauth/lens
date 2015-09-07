#lang racket/base

(require racket/contract
         fancy-app
         "../base/main.rkt"
         "../util/immutable.rkt")

(module+ test
  (require rackunit "../test-util/test-lens.rkt"))

(provide
 (contract-out
  [vector-ref-lens (-> exact-nonnegative-integer?
                       (lens/c immutable-vector? any/c))]))


(define (vector-ref-lens i)
  (make-lens
   (vector-ref _ i)
   (vector-set _ i _)))

(define (vector-set v i x)
  (build-immutable-vector
   (vector-length v)
   (λ (j)
     (if (= i j)
         x
         (vector-ref v j)))))

(module+ test
  (check-lens-view (vector-ref-lens 0) #(a b c) 'a)
  (check-lens-set (vector-ref-lens 2) #(a b c) "C" #(a b "C")))
