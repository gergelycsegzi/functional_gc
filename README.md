# Functional garbage collector - copying collector
There is an automated memory management technique called copying collector [1]. In
here, the overall system’s memory is split in two. One half is used as the heap, and all allocations
are taking place in this section of memory. Once this half is full, the copying collector makes a copy
of the reachable data structures to the other half. The roles of the two halves is then swapped, and
computation can resume.

The organisation of the memory returned by copy is arbitrary. A way of handling cycles is to
“copy a pair in a temporary location” of the to-space, as soon as it is encountered, before traversing
its car and cdr. This way, if there is a cycle leading back to the pair, we can detect that it has already
been processed.
The challenge is that at that point we do not know the addresses for the car and cdr of the temporalily
allocated pair. Once the addresses of the car and cdr in the to-space have been identified, the pair in
the temporary location need to be “updated”. This is achieved without side-effects in a functional manner.

[1] Richard Jones and Rafael Lins. Garbage Collection. Algorithms for Automatic Dynamic Memory
Management. Wiley, 1996.
