#let algorithm = (it) => box(inset: (x: 15pt, y: 10pt), stroke: black + 1pt, radius: 5pt, align(left, it))

#let algo_style = (it) => strong(it)
#let algo_call_style = (it) => smallcaps(it)
#let algo_instruction = (it) => it // for customization purposes

#let algo_if = (cond) => algo_instruction[ #algo_style[If] #cond #algo_style[then] ]
#let algo_else_if = (cond) => algo_instruction[ #algo_style[Else if] #cond #algo_style[then] ]
#let algo_else = algo_instruction(algo_style[Else])

#let algo_for = (cond) => algo_instruction[ #algo_style[For] #cond #algo_style[do] ]
#let algo_while = (cond) => algo_instruction[ #algo_style[While] #cond #algo_style[do] ]

// this function display the start of a procedure-like block
// it can be used for procedures, functions, or something custom if needed
#let algo_procedure_like = (label, name, args: none) => {
  if args == none { algo_instruction[ #label #algo_call_style(name) ] }
  else { algo_instruction(algo_style[#label ] + algo_call_style(name) + [(#args)]) }
}

#let algo_procedure = (name, args: none) => algo_procedure_like([Procedure], name, args: args)
#let algo_function = (name, args: none) => algo_procedure_like([Function], name, args: args)

#let algo_end_if = algo_instruction(algo_style[End If] + linebreak())
#let algo_end_for = algo_instruction(algo_style[End For] + linebreak())
#let algo_end_while = algo_instruction(algo_style[End While] + linebreak())
#let algo_end_procedure = algo_instruction(algo_style[End Procedure] + linebreak())
#let algo_end_function = algo_instruction(algo_style[End Function] + linebreak())

#let algo_return = algo_instruction(algo_style[Return])
#let algo_call = (name, args: none) => algo_call_style(name) + [(#args)]

#let algo_block = (it) => [
  #linebreak()
  #box(
    pad(
      left: 10pt,
      box(
        stroke: (left: 1pt),
        inset: (left: 10pt),
        outset: (y: 5pt),
        it,
      ),
    ),
  )
  #linebreak()
]
