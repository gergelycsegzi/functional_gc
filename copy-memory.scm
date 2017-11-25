(define copy-memory
  (lambda (roots vector-mem)
    (copy roots '() vector-mem 0 '() '())))

(define copy
  ;;address is also current length  -------- new root is in association list with old root
  (lambda (old-roots new-roots vector-mem address memory seen)
    ;;if we went through the whole list of reachable roots return 
    (if (null? old-roots)
        (list new-roots memory (+ 1 address))
        (let* ((old-root (car old-roots))
               (new-root (assq old-root seen)))
          ;;if we haven't analyzed the root (new-root returns false)
          (if (not new-root)
              (let ((element (vector-ref vector-mem old-root)))
                (if (not (pair? element))  ;;if it is a single string

                    (copy (cdr old-roots) (cons address new-roots)
                         vector-mem (+ 1 address) ;;add it to the memory, the root to the seen list
                         (cons element memory) (cons (cons root address) seen)) ;;address is also location for new root

                    (let* ((root-memory (see address old-root vector-mem memory seen))
                           (newAddr (car root-memory))
                           (newMem (cdr root-memory)));;trace from one root and build memory
                      (copy (cdr old-roots) (cons address new-roots)
                           vector-mem newAddr newMem seen)
                      ))))))))


(define see
  ;;return address x memory x seen
  (lambda (newAddr v-index vect-mem memory seen)
    (let* ((old-root v-index)
           (new-root (assq old-root seen))
           (element (vector-ref vect-mem v-index)))
      (if (not new-root)
          (if (not (pair? element))
              
              (cons newAddr (cons (cons element memory) seen))
              
              (let* ((toSeen (cons (cons old-root newAddr) seen))
                     (resA (see (+ 1 newAddr) (car element) vect-mem memory toSeen))
                     (addrA (car resA))
                     (memoryA (cadr resA))
                     (seenA (cddr resA))
                     (resB (see (+ 1 addrA) (cdr element) vect-mem memoryA seenA))
                     (addrB (car resB))
                     (memoryB (cadr resB))
                     (seenB (cddr resB)))
                (cons (+ 1 addrB) (cons (cons (cons addrA addrB) memory) seenB))))

                ;;if we have seen the element before build / index it
          (let ((new-place (cdr new-root)))
                (cons new-place (cons (cons new-place memory) seen)))))))
             

(define make-memory
  (lambda (l)
    (apply vector (reverse l))))
(copy-memory '(5) (make-memory '((2 . 5) (5 . 5) "b" "a" (0 . 1) "y" "x")))
(copy-memory '(6) (make-memory '((2 . 2) (3 . 4) "b" "a" (0 . 1) "y" "x")))