#import "algo.typ": *

#let version = "1.0.0"

#set page(
  numbering: "1/1",
  header: align(right, smallcaps[the typst-algo package, version #version]),
)

#let todo = (it) => text(red, 12pt, it)

#set heading(numbering: "1.")
#set par(justify: true)
#set raw(lang: "typ")

#show math.equation: set text(font: "Latin Modern Math")


// The following code has been extracted from "Typst Math for Undergrads"
#let kern(length) = h(length, weak: true)
#let normalsize = 10pt
#let TeX = style(styles => {
  let e = measure(text(normalsize, "E"), styles)
  let T = "T"
  let E = text(normalsize, baseline: e.height / 2, "E")
  let X = "X"
  box(T + kern(-0.1667em) + E + kern(-0.125em) + X)
})
#let LaTeX = style(styles => {
  let l = measure(text(10pt, "L"), styles)
  let a = measure(text(7pt, "A"), styles)
  let L = "L"
  let A = text(7pt, baseline: a.height - l.height, "A")
  box(L + kern(-0.36em) + A + kern(-0.15em) + TeX)
})
// End of extracted code

#show raw.where(block: false): box.with(
  fill: luma(250),
  inset: (x: 3pt, y: 0pt),
  outset: (y: 3pt),
  radius: 2pt,
)

#show raw.where(block: true): block.with(
  fill: luma(240),
  inset: 10pt,
  radius: 4pt,
)

#show "LaTeX" : (_) => LaTeX

#align(center)[
  #set par(leading: 0.8em)
  #text(20pt)[*The `typst-algo` package.*]\
  #text(14pt)[_Typeset algorithms in Typst._]\
  Hugo #smallcaps[Salou] --- #todo[Insert link here]\
  (last documentation update : #datetime.today().display())
]

#v(1fr)

*Goals.* This project aims to be a Typst equivalent of the LaTeX package `algpseudocode`.
There is already a Typst package aimed at algorithm typsetting, but `typst-algorithms`'s style is a lot closer to code than algorithms. The main objective of this package is to be able to render an algorithm like~@sample-algorithm. A step-by-step breakdown of the code (in @sample-algorithm-code) is available in @principles.

#figure(
  algorithm[
    $n <- "length"(T)$\
    #algo_while[$T$ isn't sorted] #algo_block[
      $i <- cal(U)({1, ..., n})$\
      $j <- cal(U)({1, ..., n})$\
      Swap elements at index $i$ and index $j$ in $T$
    ]
    #algo_end_while
  ],
  caption: [A _very efficient_ sorting algorithm],
  kind: "algo",
  supplement: [Algorithm],
) <sample-algorithm>

#v(1fr)
#outline()
#v(6fr)

#pagebreak()

= Principles <principles>

To typeset an algorithm with `typst-algo`, you use functions for each "instruction" you want to show.
In order to better understand, I'll explain step-by-step the code (@sample-algorithm-code) used to typeset @sample-algorithm.
In @examples, there are more complex examples (procedures, for loops, "blocks within blocks," _etc_).

#figure(
  [
    ```
    #algorithm[
      $n <- "length"(T)$\
      #algo_while[$T$ isn't sorted] #algo_block[
        $i <- cal(U)({1, ..., n})$\
        $j <- cal(U)({1, ..., n})$\
        Swap elements at index $i$ and index $j$ in $T$
      ]
      #algo_end_while
    ]
    ```
  ],
  caption: [The code used to typeset @sample-algorithm],
) <sample-algorithm-code>

Firstly, the whole algorithm is wrapped in a function named `algorithm`.
This function takes only one argument, the algorithm's content.
To write simple lines like $n <- "length"(T)$, you don't need special instructions; you can just add it inside the algorithm's content.
However, remember to add a `\` at the end of your line to add a line break.

To write the _while_ loop, you use the `algo_while` function. This function takes one argument, the "test" used by the while loop. The while loop's content needs to be added afterwards. If the content cannot be displayed after the while instruction, you need to use the `algo_block` function. (You can look at more examples in @examples.)
In our case, the while loop's body contains three lines so we need to add a _block_.
The `algo_block` function works in a similar manner to the `algorithm` function: you can directly write text, or add instructions (see more complex examples in @examples).
You don't need to add a line break after the while instruction, since `algo_block` does it automatically.

After the block is filled with instructions, we can call the `algo_end_while` function, it'll add "End While."

All other instructions work similarly, there's a list of usable functions in @reference.

= First examples <examples>

In this section, there will be some examples of algorithms typeset with `typst-algo` and the code used.

== An algorithm to approximate $pi$.

#grid(
  columns: (1fr, 1fr),
  gutter: 1cm,
  algorithm[
    Input a value $n$.\
    $m <- 0$\
    #algo_for[$i in {1,...,n}$] #algo_block[
      $x <- cal(U)([0,1])$\
      $y <- cal(U)([0,1])$\
      #algo_if[$x^2 + y^2 <= 1$] $m <- m + 1$
    ]
    #algo_end_for
    #algo_return $4 dot m \/ n$
  ],
  [
    ```
#algorithm[
  Input a value $n$.\
  $m <- 0$\
  #algo_for[$i in {1,...,n}$]
  #algo_block[
    $x <- cal(U)([0,1])$\
    $y <- cal(U)([0,1])$\
    #algo_if[$x^2 + y^2 <= 1$]
      $m <- m + 1$
  ]
  #algo_end_for
  #algo_return $4 dot m \/ n$
]
    ```
  ]
)

== The Quine–McCluskey algorithm for solving #smallcaps[sat].

#figure(
  algorithm[
    #algo_procedure(args: [$F,p,v$])[Assume]
    #algo_block[
      This procedure will return $F[p |-> v]$ where $F$ is written in #smallcaps[cnf], $p$ is one of its variables, and $v in BB$ is a boolean.
      #footnote[For boolean values, we'll write $bold(F)$ for false, and $bold(T)$ for true, and thus, $BB = {bold(F), bold(T) }$.]
      The notation $F[p |-> v]$ means we are substituting the variable $p$ with the value~$v$.\
      #v(0.5cm)
      Let $ell_bold(T)$ be the literal $p$ if $v = bold(T)$, otherwise $not p$.\
      Let $ell_bold(F)$ be the literal $p$ if $v = bold(F)$, otherwise $not p$.\
      #algo_for[$C in F$] #algo_block[
        #algo_if[$ell_bold(T) in C$] we remove $C$ from $F$.\
        #algo_else_if[$ell_bold(F) in C$] we remove $ell_bold(F)$ from $C$.\
        #algo_end_if
      ]
      #algo_end_for
    ]
    #algo_end_procedure

    #v(0.5cm)

    #algo_procedure(args: [$F$])[Quine]
    #algo_block[
      #algo_if[$nothing = F$] #algo_return $bold(T)$\
      #algo_else_if[$nothing in F$] #algo_return $bold(F)$\
      #algo_else_if[$exists {ell} in F$] #algo_block[
        #algo_if[$ell = p$, with $p in "vars"(F)$]
          #algo_return #algo_call([Quine], args: algo_call([Assume], args: [$F,p,bold(T)$]))\
        #algo_else_if[$ell = not p$, with $p in "vars"(F)$]
          #algo_return #algo_call([Quine], args: algo_call([Assume], args: [$F,p,bold(F)$]))\
        #algo_end_if
      ]
      #algo_else #algo_block[
        Let $p in "vars"(F)$.\
        #algo_return #algo_call([Quine], args: algo_call([Assume], args: [$F,p,bold(T)$]))
        $or$ #algo_call([Quine], args: algo_call([Assume], args: [$F,p,bold(F)$]))\
      ]
      #algo_end_if
    ]
    #algo_end_procedure
  ],
  caption: [The Quine–McCluskey algorithm for solving #smallcaps[sat]],
  kind: "algo",
  supplement: [Algorithm],
) <example1>

#figure(
  [
    ```
#algorithm[
  #algo_procedure(args: [$F,p,v$])[Assume]
  #algo_block[
    This procedure ... the variable $p$ with the value~$v$.\
    #v(0.5cm)
    Let $ell_bold(T)$ be the literal $p$ if $v = bold(T)$, otherwise $not p$.\
    Let $ell_bold(F)$ be the literal $p$ if $v = bold(F)$, otherwise $not p$.\
    #algo_for[$C in F$] #algo_block[
      #algo_if[$ell_bold(T) in C$] we remove $C$ from $F$.\
      #algo_else_if[$ell_bold(F) in C$] we remove $ell_bold(F)$ from $C$.\
      #algo_end_if
    ]
    #algo_end_for
  ]
  #algo_end_procedure

  #v(0.5cm)

  #algo_procedure(args: [$F$])[Quine]
  #algo_block[
    #algo_if[$nothing = F$] #algo_return $bold(T)$\
    #algo_else_if[$nothing in F$] #algo_return $bold(F)$\
    #algo_else_if[$exists {ell} in F$] #algo_block[
      #algo_if[$ell = p$, with $p in "vars"(F)$]
        #algo_return #algo_call([Quine], args:
          algo_call([Assume], args: [$F,p,bold(T)$]))\
      #algo_else_if[$ell = not p$, with $p in "vars"(F)$]
        #algo_return #algo_call([Quine], args:
          algo_call([Assume], args: [$F,p,bold(F)$]))\
      #algo_end_if
    ]
    #algo_else #algo_block[
      Let $p in "vars"(F)$.\
      #algo_return #algo_call([Quine], args:
        algo_call([Assume], args: [$F,p,bold(T)$]))
      $or$ #algo_call([Quine], args:
        algo_call([Assume], args: [$F,p,bold(F)$]))\
    ]
    #algo_end_if
  ]
  #algo_end_procedure
]
    ```
  ],
  caption: [Code used to typeset @example1]
)

= Reference <reference>

- *Conditionals.* `#algo_if[condition]` will produce "#algo_if[condition]".
  This should be followed by `#algo_end_if` (after the _if_ instruction's content).

- *Block.* `#algo_block[block\ content]` will produce 
  #algo_block[block\ content.]
  This can be used inside between any pairs of instructions (_e.g._ "if", "for", "while", ...) if the content needs to be on multiple lines.

- *Procedures.* `#algo_procedure(args: [args])[name]` will produce "#algo_procedure(args: [args])[name]".
  This should be followed by `#algo_end_procedure` (after the procedure's content).

- *Functions.* Similar to procedures, but using `#algo_function` and `#algo_end_function` instead.

- *Calling procedures or functions.* `#algo_call(args: [args])[name]` will appear in your document as "#algo_call(args: [args])[name]". This can be used to call a procedure or a function.

- *For loops.* `#algo_for[loop_iteration]` will result in "#algo_for[loop_iteration]".
  This should be followed by `#algo_end_for` (after the for loop's content).

- *While loops.* Similar to for loops, but using `#algo_while` and `#algo_end_while` instead.

If some instruction is missing, please see @contributing to know how to contribute to `typst-algo`.

= Contributing <contributing>

This project is open-source (MIT-licensed). Feel free to contribute if you think a feature is missing, the code could be improved, or anything else.

