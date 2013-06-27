;; Filename: VirusContainer
;; Author: Travis A. Ebesu
;; Description: 
;; Notes:


globals [
  WorldLength             ;; Length to resize world
  GridSize                ;; Size of each grid 
  GridCount              ;; Total number of grids
  
  VirusSequenceLength     ;; Length of virus sequence
  VirusSequence           ;; Starting Virus sequence
  ContainerSequence       ;; Mutation sequence for each container

  ContainerInfected       ;; Tracks infected containers 
  MutationLength          ;; Length of mutation of each container
  MutationCount           ;; Count of useable mutations
  
  Debug                   ;; 
  DebugMutation           ;; Output for mutation
  DebugReplicate          ;; Output for replication
  
  InfectedColor
  VirusColor
]

breed [viruses virus]
viruses-own [
  sequence               ;; Virus sequence
  containerNumber        ;; Virus in current container
  target                 ;; Coordinates for target container (if applicable)
  targetContainer        ;; Target container # (if applicable)
]

patches-own [
  container              ;; Numbers each container 0... (n - 1)
]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;     Setup     ;;;;;;;;;;;;;;;;;;;;;;;;;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to setup
  ca
  setup-variables
  setup-patches
  setup-viruses
  reset-ticks
end


;;;;;;;;;;;;;;;;;;;;;
;; Setup-Variables ;;
;;;;;;;;;;;;;;;;;;;;;

to setup-variables




  ;;;;;;;;;;;;;;;;;;;;
  ;; Debug Settings ;;
  ;;;;;;;;;;;;;;;;;;;;
  set Debug false
  set DebugMutation false
  set DebugReplicate false
  
  ;;;;;;;;;;;;;;;;;;;;; 
  ;; World Variables ;;
  ;;;;;;;;;;;;;;;;;;;;;
  
  set GridSize 2 ; x + 1 => x by x size for each grid
  ; GridLengthUI is X by X 
  set WorldLength GridLengthUI
  set GridCount GridLengthUI * GridLengthUI
  ; resize-world min-pxcor max-pxcor min-pycor max-pycor 
  resize-world (- WorldLength) WorldLength (- WorldLength) WorldLength
  set InfectedColor RGB 252 244 228
  
  
  ;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Mutation Variables ;;
  ;;;;;;;;;;;;;;;;;;;;;;;;
      
  set ContainerSequence [ ] ; Needs to be initalized as a list before adding it
  set ContainerInfected [ ]
  set MutationLength length convertBinary GridCount
  set VirusSequenceLength MutationLength              ;; Currently VirusSequenceLength = MutationLength
  let i 0
  while [ i < GridCount ] [
      set ContainerSequence lput (n-values MutationLength [one-of [0 1]]) ContainerSequence
      set ContainerInfected lput false ContainerInfected
      set i i + 1
  ]

  ;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Additional Settings ;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;
  
;  set VirusSequence n-values VirusSequenceLength [one-of [0 1]]
  set VirusSequence n-values VirusSequenceLength [one-of [0]]
;  set-default-shape viruses "dot" 

end


;;;;;;;;;;;;;;;;;;;;
;; Setup Patches  ;;
;;;;;;;;;;;;;;;;;;;;
to setup-patches
  let x (- WorldLength)
  let y WorldLength
  
  let halfGridSize round ( GridSize / 2 )
  let containerX (- WorldLength) + halfGridSize
  let containerY WorldLength - halfGridSize
  let c 0
  
  ; Iterate over patches, top to bottom, right to left
  while [ y >= (- WorldLength) ] [
      while [ x <= WorldLength ] [
         ; Color border of grids
         ask patch x y [ set pcolor grey set container -1 ]
         ask patch y x [ set pcolor grey set container -1 ] 
         
         ; To setup/color inside the grids, slightly different parameters
         if (containerY >= (- WorldLength) and containerX <= WorldLength ) [
             ask patch containerX containerY [  
                 set container c
                 
                 ask neighbors with [not (pcolor = grey)] [ 
                     set container c 
                 ]
             ]
             set c c + 1 
             set containerX containerX + GridSize
         ]
         set x x + GridSize
     ]
     ; containerX/Y are separate because they mark the inside of grids and x y mark the outside
     set containerY containerY - GridSize      
     set containerX (- WorldLength) + halfGridSize
     set y y - 1 
     set x (- WorldLength)
  ]
;  ask patches with [ not (pcolor = grey)] [ set pcolor white]
end


;;;;;;;;;;;;;;;;;;;
;; Setup-Viruses ;;
;;;;;;;;;;;;;;;;;;;
 
to setup-viruses
  let xy getRandomPosition
  create-viruses 1 [
    set color red
    setxy (item 0 xy) (item 1 xy)
    set containerNumber (item 2 xy)
    set sequence VirusSequence
  ]
  
  ask viruses [
      let temp containerNumber
      ask patches with [ container = temp ] [ ;set pcolor InfectedColor 
      set ContainerInfected replace-item container ContainerInfected true]
      set target [ ]
      set targetContainer -1 
  ]
end



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   Go   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to go
  ;; All dead  
  if not any? viruses [ print "\n\nNo Viruses Left" stop ] 
  if getInfectedCount = GridCount [ print "\n\nAll Containers Infected" stop ]
  ; Try to create a little sychronization 
  
  ;; Kill viruses, probability outside ask virus doesn't generate probability per a virus
  ask viruses [ if random-float 100 < DeathProbability [ die ] ] 
  
  

  ;; Move mutated viruses first
  ask viruses with [ not (target = [ ]) ] [ move ]
  
  ;; Viruses not mutated replicate
  ask viruses with [ target = [ ] ] [ if random-float 100 < ReplicationProbability [ replicate ] ]
      
  tick
end






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;   Subroutines   ;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to replicate     
    let parent sequence
    hatch-viruses 1  [ 
    
         ;; Mutate the parents sequence
         set sequence (mutateSequence parent)
         
         ;; Color viruses by mutation
         ;; lets not go over 256, convert the binary to base 10
         let dif (convertDecimal sequence)         
        
                 
                                                                                                                                       
                                                                                                                                      
          set color scale-color red dif (GridCount * 2) 0
         
         if DebugReplicate [ print (word "Parent: " parent "  ==>  " sequence) ]
         
         ;; Check for mutation matches
         let targetList getAccessibleContainers sequence (getAdjacentContainers containerNumber)
         
         ;; We found a mutation, set target and move towards
         if not (targetList = [ ]) [ 
             set targetContainer one-of targetList ; targetList may return one or more elements, take one
             set target getRandomPositionInContainer targetContainer (list pxcor pycor) ; get a coordinate in the container
             facexy item 0 target item 1 target
             fd 1
             set MutationCount MutationCount + 1
         ]
    ]

end

to move

    if not (target = [ ]) [ 
         ;; Virus should not be starting at target cell, moving to it first should be fine
         facexy item 0 target item 1 target
         fd 1
         let cur [ ]
         
         ask patch-here [
             set cur container ; each patch was previously assigned either a cell number or -1
         ]
         
         ;; Check if we are at the destination
         if cur = targetContainer [
               ; Arrived at destination
               let temp targetContainer ; due to context, needed to store in another var
               ask patches with [ container = temp ] [ ;set pcolor InfectedColor 
                 set ContainerInfected replace-item container ContainerInfected true ]
               set containerNumber targetContainer
               set target [ ]
               set targetContainer -1
         ]

    ]
end


to-report mutateSequence [ s ]
    let i 0
    while [ i < length s ] [
        if random-float  100 > MutationProbability [
            set s replace-item i s one-of [0 1]
        ]
        set i i + 1
    ]
    report s 
end

; Returns: random (x y) in cell
to-report getRandomPositionInContainer [ c currentXY]
  let xy [ ]
  let coord [ ]
  let d 0
  while [ d < 1 ] [
     set xy [ ]
     ask patches with [ container = c ] [ 
         set xy lput (list pxcor pycor) xy 
     ]
     set coord one-of xy
     set d round (getDistance (item 0 coord) (item 1 coord) (item 0 currentXY) (item 1 currentXY))
  ]
  report coord
end

; Returns: random (x y container-number)
to-report getRandomPosition
  let r random (GridCount - 1)
  let xy [ ]
  ask patches with [ container = r ] [ set xy lput (list pxcor pycor r) xy]
  set r random (length xy - 1)
  report item r xy
end

;; Current Cell #
to-report getAdjacentContainers [ current ]
  let containerNumbers [ ]
  let result [ ]
  
  ; GridLengthUI is the original X by X, 
  let edge (current mod GridLengthUI) ; left edge = 0 and right edge = (n - 1), where n = GridLengthUI
  let row floor (current / GridLengthUI) ; Gets row # 0 - (n - 1), n = GridLengthUI
  
  if debug [ print (word "Row: " row " Edge: " edge )]
  
  if edge != 0 and current > 0 [ ; Do we have a left side avaliable?
    set containerNumbers lput (current - 1) containerNumbers 
    if debug [ print "Has a left side" ]
  ]     
  if edge != (GridLengthUI - 1) and current < GridCount [  ; check right
    set containerNumbers lput (current + 1) containerNumbers 
    if debug [print "Has a right side"]
  ]
 
  if row != 0 [ ; top
    set containerNumbers lput (current - GridLengthUI) containerNumbers 
    if debug [print "Has top" ]
  ]
  if row != (GridLengthUI - 1) [ 
    set containerNumbers lput (current + GridLengthUI) containerNumbers 
    if debug [print "has bottom" ]
  ]
  
  report containerNumbers
end

; Input: sequence (list), container numbers to check sequence against (list)
; Returns cell numbers, that match
to-report getAccessibleContainers [ genome containerNumbers ]
; simple linear search
  let mutation [ ]
  let result [ ]
  ; Get mutation from each container number
  foreach containerNumbers [
    set mutation lput item ? ContainerSequence mutation
  ]
  if DebugMutation [  print (word "Mutation: " mutation)  ]
  let j 0
 if DebugMutation [print "Testing: Genome  =>  Mutation \n\n"]
 foreach mutation [
      ifelse length ? > length genome [ print "Error: Mutation Length > Genome Length         Trace => isMutated" ][
           let mutationSum sum mutation
           let i 0
           while [ (i + length ?) <= length genome ] [
               if DebugMutation [ print (word sublist genome i ( i + length ? ) "  ==>  " ?) ]
               
               if (sublist genome i ( i + length ? )) = ? [
                    set result lput (item j containerNumbers) result
                    
               ]
               set i i + 1
           ]
           set j j + 1
      ]
  ]   
  report result
end



to-report getDistance [x1 y1 x2 y2]
  report round sqrt ( getSquare (x2 - x1) + getSquare (y2 - y1) )
end

to-report getSquare [n]
  report n * n 
end

; Convert base 10 to binary 
to-report convertBinary [ num ]
  let k 2 ; change k to convert to different bases
  let digit [ ]
  while [ num != 0 ] [
    let rem floor ( num mod k )
    set num floor ( num / k )
    set digit lput rem digit
  ]
  report digit
end

to-report convertDecimal [ num ]
  let i 0
  let total 0
  while [ i < length num ] [
      if item i num = 1 [
          set total total + pow 2 i
      ]
      set i i + 1
  ]
  
  report total
end

to-report getInfectedCount
  let total 0
  foreach ContainerInfected [
      if ? [ set total total + 1 ]
  ]
  report total
end

;; b ^ n
to-report pow [ b n ]
  if n = 0 [ report 1 ]
  if n = 1 [ report b ] 
  report b * pow b (n - 1)
end


;; Only called manually 
to testMutate
let i false
while [ not i ] [
ask viruses [
        let parent sequence
         set sequence (mutateSequence parent)
        if DebugReplicate [ print (word "Parent: " parent "  ==>  " sequence) ]
         let targetList getAccessibleContainers sequence (getAdjacentContainers containerNumber)
         
         ifelse not (targetList = [ ]) [ 
             set targetContainer one-of targetList ; targetList may return one or more elements, take one
             set target getRandomPositionInContainer targetContainer (list pxcor pycor) ; get a coordinate in the container
             facexy item 0 target item 1 target
             fd 1
             set i true

         ][
             let coord getRandomPositionInContainer containerNumber (list pxcor pycor)   ; Gets a coordinate within the cell
             facexy item 0 coord item 1 coord  
             fd 1
         ]
]
]
end
@#$#@#$#@
GRAPHICS-WINDOW
260
10
587
358
4
4
35.22222222222222
1
10
1
1
1
0
0
0
1
-4
4
-4
4
0
0
1
ticks
30.0

BUTTON
123
12
189
45
NIL
setup\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
5
109
225
142
GridLengthUI
GridLengthUI
1
20
4
1
1
 by X
HORIZONTAL

BUTTON
123
57
186
90
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
6
153
225
186
DeathProbability
DeathProbability
0
100
0
1
1
%
HORIZONTAL

SLIDER
6
194
226
227
MutationProbability
MutationProbability
0
100
22
1
1
% per a base
HORIZONTAL

MONITOR
143
287
230
332
# of Viruses
count viruses
0
1
11

SLIDER
8
236
206
269
ReplicationProbability
ReplicationProbability
0
100
100
1
1
%
HORIZONTAL

BUTTON
17
12
87
45
Go * 2
go go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
18
57
88
90
Go * 1
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

OUTPUT
18
424
258
478
12

MONITOR
25
285
95
330
Infected %
getInfectedCount / GridCount * 100
2
1
11

MONITOR
23
347
132
392
Mutation Count
MutationCount
2
1
11

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.0.4
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 1.0 0.0
0.0 1 1.0 0.0
0.2 0 1.0 0.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
