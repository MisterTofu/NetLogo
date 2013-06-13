;; DemGenTrout 1.0 (2012)
;;
;; Developed by
;; Beatrice M. Frank
;; Earth and Life Institute
;; Universite catholique de Louvain
;; Beatrice.Frank@gmail.com
;; 
;; Last updated: September 2012

breed[ trout ]
breed[ dead ]
breed[ gone ]

;; trout state variables
trout-own[ sex genotype natal-stream week-of-birth week-of-birth2 ;; fixed
  current-stream age stage status body-length body-weight condition-factor num-offspring
  spawned? moved-to-spawn? returned? ]

;; gone trout state variables
gone-own[ sex genotype natal-stream week-of-birth week-of-birth2 ;; fixed
  current-stream age stage status body-length body-weight condition-factor num-offspring
  spawned? moved-to-spawn? returned? ]

;; dead trout state variables
dead-own[ sex genotype natal-stream week-of-birth week-of-birth2 ;; fixed
  current-stream age stage status body-length body-weight condition-factor num-offspring
  spawned? moved-to-spawn? returned? ]
  
;; stream state variables
patches-own [ stream flow temperature ] 

globals[ week week-of-year month-of-year year
 ;; trout initialisation
 prop-C prop-L init-N
 prop-age0-C prop-age1-C prop-age2-C prop-age3-C
 prop-age0-L prop-age1-L prop-age2-L
 meanl-age0-C meanl-age0-L meanl-age1-C meanl-age1-L meanl-age2-C meanl-age2-L meanl-age3-C meanl-age3-L
 sdl-age0-C sdl-age0-L sdl-age1-C sdl-age1-L sdl-age2-C sdl-age2-L sdl-age3-C sdl-age3-L 
 trdown-age0-C trdown-age0-L trdown-age1-C trdown-age1-L trdown-age2-C trdown-age2-L trdown-age3-C trdown-age3-L
 trup-age0-C trup-age0-L trup-age1-C trup-age1-L trup-age2-C trup-age2-L trup-age3-C trup-age3-L
 meanl-birth-C sdl-birth-C meanl-birth-L sdl-birth-L trdown-C trup-C trdown-L trup-L 
 mean-bcf-C sd-bcf-C mean-bcf-L sd-bcf-L
 propC-inL 
 ;; stream input data
 streamC-discharge streamL-discharge streamC-temperature streamL-temperature 
 mean-dischargeC sd-dischargeC mean-dischargeL sd-dischargeL
 mean-temperatureC sd-temperatureC mean-temperatureL sd-temperatureL
 max-dischargeC max-dischargeL

 ;; survival parameters 
 streamC-age0-survival streamC-age1-survival streamC-age2-survival streamC-age3-survival
 streamL-age0-survival streamL-age1-survival streamL-age2-survival streamL-age3-survival 
 streamC-age0-survival-list streamC-age1-survival-list streamC-age2-survival-list streamC-age3-survival-list
 streamL-age0-survival-list streamL-age1-survival-list streamL-age2-survival-list streamL-age3-survival-list  
; predation-factor
 ;; growth parameters
; streamC-parK streamL-parK
 streamC-max-length streamC-parA streamC-parB streamL-max-length streamL-parA streamL-parB   
 ;; spawning parameters
 ;spawn-start spawn-end moved-prop spawn-mean-length spawn-mean-cond
 spawn-sd-length spawn-sd-cond spawn-min-age
 spawn-mean-temperature spawn-sd-temperature spawn-mean-flow spawn-sd-flow
 streamC-capacity offprod offprod-min-length offprod-max-length offprod-min
 offspringC-varA offspringC-varB offspringL-varA offspringL-varB
 ;offprodC-max offprodL-max 
 length-heritability 
 ;; hatching parameters
 hatch-start hatch-end
 ;; downstream movement parameters
 ;move-start move-end move-min-age move-max-age
 move-mean-length move-sd-length 
 move-age1-prob move-age1-varB move-age1-varA
 move-age2-prob move-age2-varB move-age2-varA 
 move-mean-temperature move-sd-temperature move-mean-flow move-sd-flow
 ;; leaving stream L forever parameters
 leaving-propC leaving-propL
 
 out-year out-month out-week
 ]  

to restore-defaults
  clear-all      
  no-display   
  ;; controlling the random numbers
  random-seed 1223251200  
  
  ;; first week of the year = 1st to 7th October included
  set week 1
  set week-of-year 1
  set month-of-year 1
  set year 1

  ;; restore the default parameters         
  ;;; input parameters ;;;
  file-open "init-params.txt"
  ;; weekly survival rates for trout in stream C
  if file-read = "streamC.age0.survival" [set streamC-age0-survival file-read]
  if file-read = "streamC.age1.survival" [set streamC-age1-survival file-read] 
  if file-read = "streamC.age2.survival" [set streamC-age2-survival file-read]
  if file-read = "streamC.age3.survival" [set streamC-age3-survival file-read]
  ;; weekly survival rates for trout in stream L  
  if file-read = "streamL.age0.survival" [set streamL-age0-survival file-read]  
  if file-read = "streamL.age1.survival" [set streamL-age1-survival file-read]
  if file-read = "streamL.age2.survival" [set streamL-age2-survival file-read]
  if file-read = "streamL.age3.survival" [set streamL-age3-survival file-read]  
  if file-read = "predation.factor" [set predation-factor file-read]   
  ;; growth parameters
  if file-read = "streamC.parK" [set streamC-parK file-read]
  if file-read = "streamL.parK" [set streamL-parK file-read]  
  if file-read = "streamC.max.length" [set streamC-max-length file-read]
  if file-read = "streamL.max.length" [set streamL-max-length file-read]  
  if file-read = "streamC.parA" [set streamC-parA file-read]
  if file-read = "streamL.parA" [set streamL-parA file-read]  
  if file-read = "streamC.parB" [set streamC-parB file-read]
  if file-read = "streamL.parB" [set streamL-parB file-read]           
  ;; spawning parameters
  if file-read = "spawn.start" [set spawn-start file-read]
  if file-read = "spawn.end" [set spawn-end file-read] 
  if file-read = "spawn.min.age" [set spawn-min-age file-read]      
  if file-read = "spawn.mean.length" [set spawn-mean-length file-read]  
  if file-read = "spawn.sd.length" [set spawn-sd-length file-read]   
  if file-read = "spawn.mean.cond" [set spawn-mean-cond file-read] 
  if file-read = "spawn.sd.cond" [set spawn-sd-cond file-read]  
  if file-read = "moved.prop" [set moved-prop file-read]       
  if file-read = "spawn.mean.flow" [set spawn-mean-flow file-read]  
  if file-read = "spawn.sd.flow" [set spawn-sd-flow file-read]   
  if file-read = "streamC.capacity" [set streamC-capacity file-read]    
  if file-read = "offprod.min.length" [set offprod-min-length file-read] 
  if file-read = "offprod.max.length" [set offprod-max-length file-read]     
  if file-read = "offprod.min" [set offprod-min file-read]         
  if file-read = "offprodC.max" [set offprodC-max file-read] 
  if file-read = "offprodL.max" [set offprodL-max file-read] 
  if file-read = "length.heritability" [set length-heritability file-read]     
  ;; hatching parameters
  if file-read = "hatch.start" [set hatch-start file-read]
  if file-read = "hatch.end" [set hatch-end file-read]      
  ;; downstream movement parameters
  if file-read = "move.start" [set move-start file-read] 
  if file-read = "move.end" [set move-end file-read] 
  if file-read = "move.min.age" [set move-min-age file-read] 
  if file-read = "move.max.age" [set move-max-age file-read]  
  if file-read = "move.mean.length" [set move-mean-length file-read] 
  if file-read = "move.sd.length" [set move-sd-length file-read]     
  if file-read = "move.age1.varA" [set move-age1-varA file-read] 
  if file-read = "move.age1.varB" [set move-age1-varB file-read]  
  if file-read = "move.age2.varA" [set move-age2-varA file-read] 
  if file-read = "move.age2.varB" [set move-age2-varB file-read] 
  if file-read = "move.mean.temperature" [set move-mean-temperature file-read] 
  if file-read = "move.sd.temperature" [set move-sd-temperature file-read] 
  if file-read = "move.mean.flow" [set move-mean-flow file-read] 
  if file-read = "move.sd.flow" [set move-sd-flow file-read]            
  ;; leaving streamL forever parameters
  if file-read = "leaving.propC" [set leaving-propC file-read]  
  if file-read = "leaving.propL" [set leaving-propL file-read]    
  file-close

  set C-age0-survival 0.39 set C-age1-survival 0.37 set C-age2-survival 0.85 set C-age3-survival 0.70
  set L-age0-survival 0.38 set L-age1-survival 0.74 set L-age2-survival 0.87 set L-age3-survival 0.69
end    
 
to setup 
  ;; weekly survival rates for trout in stream C  
  file-open "streamC-age0-survival.txt"  
  set streamC-age0-survival-list file-read file-close
  file-open "streamC-age1-survival.txt"  
  set streamC-age1-survival-list file-read file-close  
  file-open "streamC-age2-survival.txt"  
  set streamC-age2-survival-list file-read file-close
  file-open "streamC-age3-survival.txt"  
  set streamC-age3-survival-list file-read file-close  
  ;; weekly survival rates for trout in stream L  
  file-open "streamL-age0-survival.txt"  
  set streamL-age0-survival-list file-read file-close  
  file-open "streamL-age1-survival.txt"  
  set streamL-age1-survival-list file-read file-close 
  file-open "streamL-age2-survival.txt"  
  set streamL-age2-survival-list file-read file-close     
  file-open "streamL-age3-survival.txt"  
  set streamL-age3-survival-list file-read file-close   
  
  let seq (list 0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09
                     0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19
                     0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29
                     0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39
                     0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49
                     0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59
                     0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69
                     0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79
                     0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89
                     0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00)
  let index (list 0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19
                 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39
                 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59
                 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79
                 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99
                 100)
  
  (foreach seq index
    [
      if C-age0-survival = ?1 [set streamC-age0-survival item ?2 streamC-age0-survival-list]
      if C-age1-survival = ?1 [set streamC-age1-survival item ?2 streamC-age1-survival-list]
      if C-age2-survival = ?1 [set streamC-age2-survival item ?2 streamC-age2-survival-list]
      if C-age3-survival = ?1 [set streamC-age3-survival item ?2 streamC-age3-survival-list]                  
      if L-age0-survival = ?1 [set streamL-age0-survival item ?2 streamL-age0-survival-list]
      if L-age1-survival = ?1 [set streamL-age1-survival item ?2 streamL-age1-survival-list]
      if L-age2-survival = ?1 [set streamL-age2-survival item ?2 streamL-age2-survival-list]
      if L-age3-survival = ?1 [set streamL-age3-survival item ?2 streamL-age3-survival-list]
    ])    
  
  ;;; load input data ;;;
  file-open "input-data.txt"
  if file-read = "dischargeC" [set streamC-discharge file-read]    
  if file-read = "dischargeL" [set streamL-discharge file-read]     
  if file-read = "temperatureC" [set streamC-temperature file-read] 
  if file-read = "temperatureL" [set streamL-temperature file-read]
  if file-read = "max.dischargeC" [set max-dischargeC file-read]  
  if file-read = "mean.dischargeC" [set mean-dischargeC file-read] 
  if file-read = "sd.dischargeC" [set sd-dischargeC file-read]   
  if file-read = "max.dischargeL" [set max-dischargeL file-read]    
  if file-read = "mean.dischargeL" [set mean-dischargeL file-read]
  if file-read = "sd.dischargeL" [set sd-dischargeL file-read] 
  if file-read = "mean.temperatureC" [set mean-temperatureC file-read]
  if file-read = "sd.temperatureC" [set sd-temperatureC file-read]
  if file-read = "mean.temperatureL" [set mean-temperatureL file-read]
  if file-read = "sd.temperatureL" [set sd-temperatureL file-read]     
  file-close
     
  ;;; setup ;;; 
  set-patch-size 80  
  resize-world 0 1 0 0
  
  ;; initialise stream agents  
  setup-streams 
  
  ;; initialise trout agents
  file-open "init-trout.txt"   
  if file-read = "init.N" [set init-N file-read]    
  if file-read = "prop.C" [set prop-C file-read]   
  set prop-L (1 - prop-C)
  ;; in stream C
  if file-read = "prop.age0.C" [set prop-age0-C file-read]   
  if file-read = "prop.age2.C" [set prop-age2-C file-read]  
  if file-read = "prop.age3.C" [set prop-age3-C file-read] 
  set prop-age1-C (1 - prop-age0-C - prop-age2-C - prop-age3-C)   
  if file-read = "meanl.birth.C" [set meanl-birth-C file-read] if file-read = "sdl.birth.C" [set sdl-birth-C file-read]    
  if file-read = "meanl.age0.C" [set meanl-age0-C file-read] if file-read = "sdl.age0.C" [set sdl-age0-C file-read]
  if file-read = "meanl.age1.C" [set meanl-age1-C file-read] if file-read = "sdl.age1.C" [set sdl-age1-C file-read]  
  if file-read = "meanl.age2.C" [set meanl-age2-C file-read] if file-read = "sdl.age2.C" [set sdl-age2-C file-read]
  if file-read = "meanl.age3.C" [set meanl-age3-C file-read] if file-read = "sdl.age3.C" [set sdl-age3-C file-read]  
  ;; in stream L
  if file-read = "prop.age0.L" [set prop-age0-L file-read]   
  if file-read = "prop.age1.L" [set prop-age1-L file-read]  
  if file-read = "prop.age2.L" [set prop-age2-L file-read]  
  if file-read = "meanl.birth.L" [set meanl-birth-L file-read] if file-read = "sdl.birth.L" [set sdl-birth-L file-read]  
  if file-read = "meanl.age0.L" [set meanl-age0-L file-read] if file-read = "sdl.age0.L" [set sdl-age0-L file-read]
  if file-read = "meanl.age1.L" [set meanl-age1-L file-read] if file-read = "sdl.age1.L" [set sdl-age1-L file-read]  
  if file-read = "meanl.age2.L" [set meanl-age2-L file-read] if file-read = "sdl.age2.L" [set sdl-age2-L file-read]
  if file-read = "meanl.age3.L" [set meanl-age3-L file-read] if file-read = "sdl.age3.L" [set sdl-age3-L file-read]  
  if file-read = "mean.bcf.C" [set mean-bcf-C file-read] if file-read = "sd.bcf.C" [set sd-bcf-C file-read] 
  if file-read = "mean.bcf.L" [set mean-bcf-L file-read] if file-read = "sd.bcf.L" [set sd-bcf-L file-read]
  if file-read = "propC.inL" [set propC-inL file-read]            
  file-close

  ;; truncation of birth trout length normal distribution (at 'range-sd' standard deviations)
  let range-sd 4
  set trdown-C (meanl-birth-C - range-sd * sdl-birth-C) set trup-C (meanl-birth-C + range-sd * sdl-birth-C) 
  set trdown-L (meanl-birth-L - range-sd * sdl-birth-L) set trup-L (meanl-birth-L + range-sd * sdl-birth-L)
  if trdown-C < 1 [set trdown-C 1] if trdown-L < 1 [set trdown-L 1]  
  ;; truncation of age-0 trout length normal distribution (at 'range-sd' standard deviations)   
  set trdown-age0-C (meanl-age0-C - range-sd * sdl-age0-C) set trup-age0-C (meanl-age0-C + range-sd * sdl-age0-C) 
  set trdown-age0-L (meanl-age0-L - range-sd * sdl-age0-L) set trup-age0-L (meanl-age0-L + range-sd * sdl-age0-L)
  ;; truncation of age-1 trout length normal distribution (at 'range-sd' standard deviations)   
  set trdown-age1-C (meanl-age1-C - range-sd * sdl-age1-C) set trup-age1-C (meanl-age1-C + range-sd * sdl-age1-C) 
  set trdown-age1-L (meanl-age1-L - range-sd * sdl-age1-L) set trup-age1-L (meanl-age1-L + range-sd * sdl-age1-L)
  ;; truncation of age-2 trout length normal distribution (at 'range-sd' standard deviations)   
  set trdown-age2-C (meanl-age2-C - range-sd * sdl-age2-C) set trup-age2-C (meanl-age2-C + range-sd * sdl-age2-C) 
  set trdown-age2-L (meanl-age2-L - range-sd * sdl-age2-L) set trup-age2-L (meanl-age2-L + range-sd * sdl-age2-L)
  ;; truncation of age-3 trout length normal distribution (at 'range-sd' standard deviations) 
  set trdown-age3-C (meanl-age3-C - range-sd * sdl-age3-C) set trup-age3-C (meanl-age3-C + range-sd * sdl-age3-C) 
  set trdown-age3-L (meanl-age3-L - range-sd * sdl-age3-L) set trup-age3-L (meanl-age3-L + range-sd * sdl-age3-L)      
      
  setup-trout-C  
  setup-trout-L
  
  ;; change the natal stream of some trout in L 
  let num-streamL count trout with [current-stream = "L"]  
  ask n-of (num-streamL * propC-inL) trout with [current-stream = "L"] [set natal-stream "C"]   
  ;; supplementary variable to reinitialise offprodC-max when abundance in stream C is ok
  set offprod offprodC-max
  
  reset-ticks  
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; INITIALISATION ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to setup-streams
  ask patches
  [
    ifelse pxcor = 0
    ;; Lesse River (stream L)    
    [ set pcolor gray set stream "L" ] 
    ;; Chicheron brook (stream C)
    [ set pcolor gray + 2 set stream "C" ]    
  ]
end

to setup-trout-C
  create-trout init-N * prop-C
  [
    setxy random-xcor 1
    set current-stream "C"
    set natal-stream "C"
    ifelse random-float 1 > 0.5 [ set sex "M" ] [ set sex "F" ]
    ;; attribute trout genotypes at 12 microsatellites markers (loci)     
    let markers []
    file-open "input-genotypes-streamC-12markers.txt"
    set markers file-read
    file-close
    let freq []
    file-open "input-genofreq-streamC-12markers.txt"
    set freq file-read
    file-close    
    set genotype []      
    set genotype assign-genotype (markers) (freq)
    set num-offspring 0     
    set status "non-spawner" set spawned? false
    set moved-to-spawn? false set returned? false   
    ;; attribute trout age according to the defined proportion
    ifelse who < (init-N * prop-C * prop-age0-C) [ set age 0 set week-of-birth2 age * -52 ][
    ifelse who < (init-N * prop-C * (prop-age0-C + prop-age1-C)) [ set age 1 set week-of-birth2 age * -52 ][
    ifelse who < (init-N * prop-C * (prop-age0-C + prop-age1-C + prop-age2-C)) [ set age 2 set week-of-birth2 age * -52 ][
    ;; adults' age is drawn from a uniform integer distribution between 3 and 6
    ifelse who < (init-N * prop-C * 1.00) [ set age 3 + random 4 set week-of-birth2 age * -52 ][            
    ]]]]                    
    trout-update-stage ;; a trout procedure setting stage from age
    ;; attribute body-length, body-weight and condition-factor
    let val-age0-C (random-normal meanl-age0-C sdl-age0-C)  
    if val-age0-C < trdown-age0-C  [set val-age0-C trdown-age0-C] if val-age0-C > trup-age0-C [set val-age0-C trup-age0-C]     
    if age = 0 [set body-length val-age0-C set condition-factor (random-normal mean-bcf-C sd-bcf-C)
      set body-weight (condition-factor * ((body-length) ^ 3) / 100000) stop]
    let val-age1-C (random-normal meanl-age1-C sdl-age1-C)  
    if val-age1-C < trdown-age1-C  [set val-age1-C trdown-age1-C] if val-age1-C > trup-age1-C [set val-age1-C trup-age1-C]     
    if age = 1 [set body-length val-age1-C set condition-factor (random-normal mean-bcf-C sd-bcf-C)
      set body-weight (condition-factor * ((body-length) ^ 3) / 100000) stop]      
    let val-age2-C (random-normal meanl-age2-C sdl-age2-C)  
    if val-age2-C < trdown-age2-C  [set val-age2-C trdown-age2-C] if val-age2-C > trup-age2-C [set val-age2-C trup-age2-C]       
    if age = 2 [set body-length val-age2-C set condition-factor (random-normal mean-bcf-C sd-bcf-C)
      set body-weight (condition-factor * ((body-length) ^ 3) / 100000) stop]      
    let val-age3-C (random-normal meanl-age3-C sdl-age3-C)  
    if val-age3-C < trdown-age3-C  [set val-age3-C trdown-age3-C] if val-age3-C > trup-age3-C [set val-age3-C trup-age3-C]       
    if age > 2 [set body-length val-age3-C set condition-factor (random-normal mean-bcf-C sd-bcf-C)
      set body-weight (condition-factor * ((body-length) ^ 3) / 100000) stop]      
    ;; test for negative length and negative weight
    if body-length < 0 [ user-message "Negative fish length" ]
    if body-weight < 0 [ user-message "Negative fish weight" ]              
  ] ;; end of create-trout for stream C    
end

to setup-trout-L
  create-trout init-N * prop-L
  [ 
    setxy random-xcor 0
    set current-stream "L"
    set natal-stream "L"
    ifelse random-float 1 > 0.5 [ set sex "M" ] [ set sex "F" ]
    ;; attribute trout genotypes at 12 microsatellite loci
    let markers []
    file-open "input-genotypes-streamL-12markers.txt"
    set markers file-read
    file-close
    let freq []
    file-open "input-genofreq-streamL-12markers.txt"
    set freq file-read
    file-close    
    set genotype []          
    set genotype assign-genotype (markers) (freq)
    set num-offspring 0     
    set status "non-spawner" set spawned? false 
    set moved-to-spawn? false set returned? false   
    ;; attribute trout age                    
    ifelse (who - init-N * prop-C) < (init-N * prop-L * prop-age0-L) [ set age 0 set week-of-birth2 age * -52 ][
    ifelse (who - init-N * prop-C) < (init-N * prop-L * (prop-age0-L + prop-age1-L)) [ set age 1 set week-of-birth2 age * -52 ][
    ifelse (who - init-N * prop-C) < (init-N * prop-L * (prop-age0-L + prop-age1-L + prop-age2-L)) [ set age 2 set week-of-birth2 age * -52 ][
    ifelse (who - init-N * prop-C) < (init-N * prop-L * 1.00) [ set age 3 + random 4 set week-of-birth2 age * -52 ][             
    ]]]]       
    trout-update-stage ;; a trout procedure setting stage from age  
    ;; attribute body-length, body-weight and condition-factor
    let val-age0-L (random-normal meanl-age0-L sdl-age0-L)  
    if val-age0-L < trdown-age0-L  [set val-age0-L trdown-age0-L] if val-age0-L > trup-age0-L [set val-age0-L trup-age0-L]     
    if age = 0 [set body-length val-age0-L set condition-factor (random-normal mean-bcf-L sd-bcf-L)
      set body-weight (condition-factor * ((body-length) ^ 3) / 100000) stop]
    let val-age1-L (random-normal meanl-age1-L sdl-age1-L)  
    if val-age1-L < trdown-age1-L  [set val-age1-L trdown-age1-L] if val-age1-L > trup-age1-L [set val-age1-L trup-age1-L]   
    if age = 1 [set body-length val-age1-L set condition-factor (random-normal mean-bcf-L sd-bcf-L)
      set body-weight (condition-factor * ((body-length) ^ 3) / 100000) stop]      
    let val-age2-L (random-normal meanl-age2-L sdl-age2-L)  
    if val-age2-L < trdown-age2-L  [set val-age2-L trdown-age2-L] if val-age2-L > trup-age2-L [set val-age2-L trup-age2-L]      
    if age = 2 [set body-length val-age2-L set condition-factor (random-normal mean-bcf-L sd-bcf-L)
      set body-weight (condition-factor * ((body-length) ^ 3) / 100000) stop]      
    let val-age3-L (random-normal meanl-age3-L sdl-age3-L)  
    if val-age3-L < trdown-age3-L  [set val-age3-L trdown-age3-L] if val-age3-L > trup-age3-L [set val-age3-L trup-age3-L]     
    if age > 2 [set body-length val-age3-L set condition-factor (random-normal mean-bcf-L sd-bcf-L)
      set body-weight (condition-factor * ((body-length) ^ 3) / 100000) stop]      
    ;; test for negative length and negative weight
    if body-length < 0 [ user-message "Negative fish length" ]
    if body-weight < 0 [ user-message "Negative fish weight" ]               
  ] ;; end of create-trout for stream L  
end

to-report assign-genotype [markers freq]
  let locus []
  let bit 0
  repeat length markers
  [
    set locus assign-locus (bit) (markers) (freq)     
    set genotype lput (first locus) genotype  
    set bit bit + 1
  ] 
  report genotype
end

to-report assign-locus [bit markers freq]
    let locus []
    let q 0
    let ran random-float 1.0
    (foreach (item bit markers) (item bit freq)
    [
      set q q + ?2
      if ran <= q [set locus lput ?1 locus] 
      if empty? locus and ?1 = last (item bit markers)
      [ set locus assign-locus (bit) (markers) (freq) ]
    ])    
    report locus
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SCHEDULING ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to go 
  no-display   
  tick 
  if ticks = 1820 [ user-message "Input data are only available for 35 years."  stop ]
  ;; a year = 52 weeks  
  set week-of-year (week mod 52) + 1
  set month-of-year (int(week-of-year / 4.5) mod 52) + 1 
  set year (int(week / 52)) + 1 ; mod 52  
  
  ;; each week

;-- 1. Update stream hydrological conditions ----------------------------------------------------------
  
  ask patches [ update-stream-conditions ] 
  
;-- 2. Kill trout in each stream ----------------------------------------------------------------------

  ask trout [ trout-die ]      
    
;-- 3. Update trout length, weight, and condition factor -----------------------------------------------
  
  ask trout [ trout-grow ]  
      
;-- 4. Reproduce trout in each stream ----------------------------------------------------------------- 

  ;; spawning time window: duration = 11 weeks
  if week-of-year >= spawn-start and week-of-year <= spawn-end
  [   
    ;--- 4.1. Identify candidate spawners ---;
    ask trout [ trout-become-candidate-spawners ] 
    ;; select some of the candidate spawners born in stream L in order to make them reproduce in C
    let candidate-spawners-streamL trout with [ status = "candidate-spawner" and current-stream = "L" 
      and natal-stream = "L" and not moved-to-spawn? ]
    while [ (count trout with [status = "selected-candidate-spawner"]) < (moved-prop * count candidate-spawners-streamL) ]
    [ ask one-of candidate-spawners-streamL [ set status "selected-candidate-spawner" ] ]      
    
    ;--- 4.2. Move candidate spawners upstream ---;   
    ask trout [ trout-move-to-spawn ]         
    
    ;; adapt offspring production if abundance in C is strictly higher than streamC-capacity
    ifelse count trout with [ current-stream = "C" ] > streamC-capacity 
    [ set offprodC-max offprod / 10 ]
    [ set offprodC-max offprod ]        

    ;--- 4.3. Produce offspring in each stream ---;  
    trout-spawn-in-streamC
    trout-spawn-in-streamL
  ]
    
;-- 5. Increment trout age and update stage -----------------------------------------------------------

  if week-of-year = (hatch-start - 1) ;; one week before hatching
  [ 
    ask trout [ trout-update-age ]
    ask trout with [age > 6] [die!] ;; trout die at age 7    
  ]     
   
;-- 6. Reveal offspring -------------------------------------------------------------------------------   
  
  ;; hatching time window: duration = 11 weeks
  if week-of-year >= hatch-start and week-of-year <= hatch-end
  [ (foreach sort trout with [age = -1]
      [ ask ?
        [
          if (week-of-year - week-of-birth) = (hatch-start - spawn-start) ;; delay = 10 weeks
          [ set hidden? false set age 0 ]
        ]])
  ]
  
;-- 7. Move trout of stream C downstream ----------------------------------------------------------
    
  ;; migration time window: duration = 25 weeks
  if week-of-year >= move-start and week-of-year <= move-end
  [             
    ;--- 7.1. Identify candidate migrants among juveniles ---; 
    ask trout [ trout-become-candidate-migrants ]          
     
    ;--- 7.2. Update movement probabilities ---;     
    update-move-age1-prob   
    update-move-age2-prob      
            
    ;--- 7.3. Move candidate migrants ---;
    ask trout [ trout-move-downstream ]                  
  ]       

;-----------------------------------------# Trout post-spawning homing #------------------------------;   
;-- 8. Move upswimming spawners back to stream L ----------------------------------------------------- 

  if week-of-year = (spawn-end + 1) ;; the week after the spawning process
  [ 
    ask trout [ trout-move-back ]
  ]                                           
  
;-----------------------------------------# Trout leaving the system forever #------------------------;  
;-- 9. Remove young trout of stream L from the system ------------------------------------------------   
  
  ;; at the end of the year
  if week-of-year = 52
  [ 
    ;; some juveniles born in C and living in stream L do not settle and go elsewhere 
    let bornC-in-streamL trout with [current-stream = "L" and natal-stream = "C" and status = "migrant"]    
    let bornC-leaving (leaving-propC * count bornC-in-streamL)
    ask n-of bornC-leaving bornC-in-streamL [ leave-streamL ]  
    ;; some juveniles born in L and living in stream L do not settle and go elsewhere  
    let bornL-in-streamL trout with [current-stream = "L" and natal-stream = "L" and (age = 1 or age = 2)]
    let bornL-leaving (leaving-propL * count bornL-in-streamL)
    ask n-of bornL-leaving bornL-in-streamL [ leave-streamL ]   
  ]                
  
; Trout reset --------------------------------------------------------------------------------------
  
  ;; at the end of the year
  if week-of-year = 52
  [      
    ;; reset trout status and boolean state variables    
    ask trout [ set status "non-spawner" set moved-to-spawn? false set spawned? false set returned? false ] 
    ;; kill all hidden turtles  
    ask gone [die]     
    ask dead [die]          
  ]

; Increment the week -------------------------------------------------------------------------------
   
  set week week + 1  
end

;;;;;;;;;;;;;;;;;;;;;;;;;;; STREAM PROCEDURE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; update water temperature and flow of each stream
to update-stream-conditions
  ifelse ticks < (6 * 52)
  ;; first 6 years (2004 to 2009)
  [
    ifelse stream = "C"
    [
      set flow item week streamC-discharge
      set temperature item week streamC-temperature 
    ]
    [
      set flow item week streamL-discharge
      set temperature item week streamL-temperature
    ]  
  ]
  ;; next years (2010 to 2038)
  [
    ifelse stream = "C"
    [
      set flow min (list max-dischargeC (item week streamC-discharge + random-lognormal mean-dischargeC sd-dischargeC))
      set temperature (item week streamC-temperature + random-normal mean-temperatureC sd-temperatureC) 
    ]
    [
      set flow min (list max-dischargeL (item week streamL-discharge + random-lognormal mean-dischargeL sd-dischargeL))
      set temperature (item week streamL-temperature + random-normal mean-temperatureL sd-temperatureL)
    ]  
  ]
end

;;;;;;;;;;;;;;;;;;;;;;;;;; TROUT PROCEDURES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; trout mortality
to trout-die
  ;; in stream C
  if stage = "fry" and current-stream = "C" [if random-float 1 > ((item week-of-year streamC-age0-survival) ^ (1 / 52)) [die!]]
  if stage = "juvenile" and age = 1 and current-stream = "C" [if random-float 1 > ((item week-of-year streamC-age1-survival) ^ (1 / 52)) [die!]]
  if stage = "juvenile" and age = 2 and current-stream = "C" [if random-float 1 > ((item week-of-year streamC-age2-survival) ^ (1 / 52)) [die!]]
  if stage = "adult" and age < 6 and current-stream = "C" [if random-float 1 > ((item week-of-year streamC-age3-survival) ^ (1 / 52)) [die!]] 
  if week-of-year >= spawn-start and week-of-year <= spawn-end and moved-to-spawn? = true and current-stream = "C" 
   [if random-float 1 > (((item week-of-year streamC-age3-survival) / predation-factor) ^ (1 / (spawn-end - spawn-start))) [die!]] 
  ;; in stream L
  if stage = "fry" and current-stream = "L" [if random-float 1 > ((item week-of-year streamL-age0-survival) ^ (1 / 52)) [die!]]
  if stage = "juvenile" and age = 1 and current-stream = "L" [if random-float 1 > ((item week-of-year streamL-age1-survival) ^ (1 / 52)) [die!]]
  if stage = "juvenile" and age = 2 and current-stream = "L" [if random-float 1 > ((item week-of-year streamL-age2-survival) ^ (1 / 52)) [die!]]
  if stage = "adult" and age < 6 and current-stream = "L" [if random-float 1 > ((item week-of-year streamL-age3-survival) ^ (1 / 52)) [die!]]
end

;; individual growth
to trout-grow
  ifelse current-stream = "C"
  [
    ;; von Bertalanffy growth equation for trout in stream C
    set body-length (body-length + (streamC-parK * (streamC-max-length - body-length)))
    let healthy-weight (streamC-parA * ((body-length) ^ streamC-parB)) ;; weight-length regression 
    set body-weight (condition-factor * healthy-weight)      
  ]
  [
    ;; von Bertalanffy growth equation for trout in stream L
    set body-length (body-length + (streamL-parK * (streamL-max-length - body-length)))  
    let healthy-weight (streamL-parA * ((body-length) ^ streamL-parB)) ;; weight-length regression
    set body-weight (condition-factor * healthy-weight)      
  ]
  set condition-factor max (list 0.5 (condition-factor + (- 0.008 + random-float 0.016)))
  ;; test for negative length and negative weight
  if body-length < 0 [ user-message "Negative fish length" ]
  if body-weight < 0 [ user-message "Negative fish weight" ]    
end

to die!
  set breed dead
  hide-turtle
end

;; identification of candidate spawners
to trout-become-candidate-spawners
  if age >= spawn-min-age and status != "spawner" and not moved-to-spawn? 
  [ if random-normal spawn-mean-length spawn-sd-length < body-length and 
    random-normal spawn-mean-cond spawn-sd-cond < condition-factor
    [ set status "candidate-spawner" ] ]  
end

;; movement to stream C for reproduction
to trout-move-to-spawn
 let temperature-streamL [temperature] of one-of patches with [ stream = "L" ]      
 let flow-streamL [flow] of one-of patches with [ stream = "L" ] 
 ;; spawners born in C or in L move to C
 if (status = "candidate-spawner" and not moved-to-spawn? and current-stream = "L" and natal-stream = "C") 
   or (status = "selected-candidate-spawner" and not moved-to-spawn?)     
 [ if random-lognormal spawn-mean-flow spawn-sd-flow < flow-streamL   
   [ set current-stream "C" set xcor 1 set moved-to-spawn? true set status "candidate-spawner" ] ]  
end

;; update trout age and stage
to trout-update-age
  set age age + 1
  trout-update-stage 
end  

;; update trout stage: fry, juvenile, adult 
to trout-update-stage
  if age < 1 [ set stage "fry" stop ]
  if age >= 1 and age <= 2 [ set stage "juvenile"stop ]
  if age > 2 [ set stage "adult" stop ] 
end

;; reproduction
to trout-spawn-in-streamC
  let spawners trout with [ status = "candidate-spawner" or status = "spawner" and current-stream = "C" ]  
  ifelse count spawners < 2
  [ stop ]
  [  
    ;; length of parents when born (VBLF backwards)
    let born-length-parents VBLF-reverse spawners    
    ;; mean and variance of length of parents when born
    if length born-length-parents < 2 [ stop ]
    let mean-parents mean born-length-parents
    let var-parents variance born-length-parents
    let num-crossover (floor (count spawners / 2))  
    ;; polygamous mating with satellite males (not in good condition)    
    repeat num-crossover
    [
      let num-males 1 + random 4 ; number of males drawn randomly from an uniform distribution from 1 to 4
      let all-parent-M spawners with [ sex = "M" ]
      if count all-parent-M < num-males [ stop ]         
      let no-parent-M max-n-of num-males spawners with [ sex = "M" ] [condition-factor]
      let sel-parent-M all-parent-M with [ not member? self no-parent-M and not spawned? ]  
      if count spawners with [ sex = "F" and not spawned? ] <= 1 [ stop ] 
      if count sel-parent-M < num-males [ stop ]  
      ;; select the parents: first, the spawners that have moved to spawn, then the other spawners  
      let parent-M n-of num-males sel-parent-M
      let parent-F max-one-of spawners with [ sex = "F" and not spawned? ] [condition-factor]     
      if (count spawners with [ sex = "M" and not spawned? and moved-to-spawn? ] - num-males) >= num-males  
      [ 
        if any? spawners with [ sex = "M" and not spawned? and moved-to-spawn? ] 
        [
          set all-parent-M spawners with [ sex = "M" and moved-to-spawn? ]
          set no-parent-M max-n-of num-males spawners with [ sex = "M" and moved-to-spawn? ] [condition-factor]
          set sel-parent-M all-parent-M with [ not member? self no-parent-M and not spawned? ]           
          set parent-M n-of num-males sel-parent-M
        ]
      ]
      if any? spawners with [ sex = "F" and not spawned? and moved-to-spawn?]
      [ set parent-F max-one-of spawners with [ sex = "F" and not spawned? and moved-to-spawn?] [condition-factor] ]
      ;; length deviances of parents M and F from mean-parents
      let dummy VBLF-reverse parent-M
      let dev-M 0
      let temp (random-normal meanl-birth-C sdl-birth-C)
      if temp < trdown-C [set temp trdown-C]   
      if temp > trup-C [set temp trup-C]                
      if length dummy = 0 [ set dev-M (mean-parents - temp) ]      
      if length dummy = 1 [ set dev-M (mean-parents - (item 0 dummy)) ]        
      if length dummy > 1 [ set dev-M (mean-parents - mean dummy) ]
      let dev-F (mean-parents - (VBLF-reverse parent-F)) 
      ask parent-F
      [
        set spawned? true
        set status "spawner"
        set xcor 1
        let num-fry update-num-offspringC [body-length] of parent-F   
        hatch-trout num-fry
        [
          set hidden? true ;; hide trout until hatching
          set age -1 set stage "fry"  
          ; genotype of parent-M is a mixture of the several genotypes of males
          let genotype-mix mixture ([genotype] of parent-M)
          ;; define genotypes for eggs
          let egg-genotype cross-genotype (genotype-mix) ([genotype] of parent-F)                
          set genotype egg-genotype                         
          set xcor 1
          set current-stream "C"
          set natal-stream "C"
          set num-offspring 0
          set week-of-birth week-of-year      
          set week-of-birth2 (week + 1)          
          ifelse random-float 1 > 0.5 [ set sex "M" ] [ set sex "F" ]
          set status "non-spawner" set spawned? false
          set moved-to-spawn? false set returned? false          
          ;; set body-length as function of parents' length and environment
          let genetic-dev (sqrt length-heritability) * (dev-M + dev-F)    
          let envi-var ((1 - length-heritability) ^ 2) * var-parents
          let envi-dev random-normal 0 (sqrt envi-var) 
          set body-length mean-parents + genetic-dev + envi-dev
          let temp2 (random-normal meanl-birth-C sdl-birth-C)  
          if temp2 < trdown-C [set temp2 trdown-C]   
          if temp2 > trup-C [set temp2 trup-C]                
          if body-length < trdown-C or body-length > trup-C [ set body-length temp2 ]           
          ;; set body-weight and condition-factor
          set condition-factor (random-normal mean-bcf-C sd-bcf-C)         
          set body-weight (condition-factor * ((body-length) ^ 3) / 100000)       
        ] 
        set num-offspring num-fry
      ]
      ask parent-M
      [
        ;set spawned? true ;; shut because males can reproduce more than once
        set status "spawner" 
        set xcor 1        
        set num-offspring [num-offspring] of parent-F               
      ] 
    ]
  ]               
end 

to trout-spawn-in-streamL
  let spawners trout with [ status = "candidate-spawner" or status = "spawner" and current-stream = "L" ]
  ifelse count spawners < 2
  [ stop ]
  [  
    let born-length-parents VBLF-reverse spawners 
    ;; mean and variance of length of parents when born
    if length born-length-parents < 2 [ stop ]  
    let mean-parents mean born-length-parents
    let var-parents variance born-length-parents  
    let num-crossover (floor (count spawners / 2))   
    ;; polygamous mating with satellite males (not in good condition)    
    repeat num-crossover  
    [
      let num-males 1 + random 4 ; number of males drawn randomly from an uniform distribution from 1 to 4
      let all-parent-M spawners with [ sex = "M" ]
      if count all-parent-M < num-males [ stop ]         
      let no-parent-M max-n-of num-males spawners with [ sex = "M" ] [condition-factor]
      let sel-parent-M all-parent-M with [ not member? self no-parent-M and not spawned? ]  
      if count spawners with [ sex = "F" and not spawned? ] <= 1 [ stop ] 
      if count sel-parent-M < num-males [ stop ]  
      ;; select the parents: first, the spawners that have moved to spawn, then the other spawners  
      let parent-M n-of num-males sel-parent-M
      let parent-F max-one-of spawners with [ sex = "F" and not spawned? ] [condition-factor]     
      if (count spawners with [ sex = "M" and not spawned? and moved-to-spawn? ] - num-males) >= num-males  
      [ 
        if any? spawners with [ sex = "M" and not spawned? and moved-to-spawn? ] 
        [
          set all-parent-M spawners with [ sex = "M" and moved-to-spawn? ]
          set no-parent-M max-n-of num-males spawners with [ sex = "M" and moved-to-spawn? ] [condition-factor]
          set sel-parent-M all-parent-M with [ not member? self no-parent-M and not spawned? ]           
          set parent-M n-of num-males sel-parent-M
        ]
      ]
      if any? spawners with [ sex = "F" and not spawned? and moved-to-spawn?]
      [ set parent-F max-one-of spawners with [ sex = "F" and not spawned? and moved-to-spawn?] [condition-factor] ]
      ;; length deviances of parents M and F from mean-parents
      let dummy VBLF-reverse parent-M
      let dev-M 0
      let temp (random-normal meanl-birth-L sdl-birth-L)
      if temp < trdown-L [set temp trdown-L]   
      if temp > trup-L [set temp trup-L]                
      if length dummy = 0 [ set dev-M (mean-parents - temp) ]            
      if length dummy = 1 [ set dev-M (mean-parents - (item 0 dummy)) ]        
      if length dummy > 1 [ set dev-M (mean-parents - mean dummy) ]    
      let dev-F (mean-parents - (VBLF-reverse parent-F))      
      ask parent-F
      [
        set spawned? true
        set status "spawner"
        set xcor 0
        let num-fry update-num-offspringL [body-length] of parent-F 
        hatch-trout num-fry
        [
          set hidden? true ;; hide trout until hatching
          set age -1 set stage "fry"
          ; genotype of parent-M is a mixture of the several genotypes of males
          let genotype-mix mixture ([genotype] of parent-M)
          ;; define genotypes for eggs
          let egg-genotype cross-genotype (genotype-mix) ([genotype] of parent-F)              
          set genotype egg-genotype                                 
          set xcor 0
          set current-stream "L"
          set natal-stream "L"  
          set num-offspring 0   
          set week-of-birth week-of-year      
          set week-of-birth2 (week + 1)              
          ifelse random-float 1 > 0.5 [ set sex "M" ] [ set sex "F" ]    
          set status "non-spawner" set spawned? false
          set moved-to-spawn? false set returned? false                   
          ;; set body-length as function of parents' length and environment
          let genetic-dev (sqrt length-heritability) * (dev-M + dev-F)     
          let envi-var ((1 - length-heritability) ^ 2) * var-parents
          let envi-dev random-normal 0 (sqrt envi-var) 
          set body-length mean-parents + genetic-dev + envi-dev
          let temp2 (random-normal meanl-birth-L sdl-birth-L)  
          if temp2 < trdown-L [set temp2 trdown-L]   
          if temp2 > trup-L [set temp2 trup-L]                         
          if body-length < trdown-L or body-length > trup-L [ set body-length temp2 ]       
          ;; set body-weight and condition-factor
          set condition-factor (random-normal mean-bcf-L sd-bcf-L)
          set body-weight (condition-factor * ((body-length) ^ 3) / 100000)              
        ]
        set num-offspring num-fry
      ]
      ask parent-M
      [
        ;set spawned? true ;; shut because males can reproduce more than once
        set status "spawner"
        set xcor 0      
        set num-offspring [num-offspring] of parent-F
      ]       
    ]  
  ]      
end  

;; stream C
to-report update-num-offspringC [ female-length ] ;; linear function
  ;; compute the intermediate variables for the linear offspring production function for trout of stream C
  set offspringC-varA (offprodC-max - offprod-min) / (offprod-max-length - offprod-min-length)
  set offspringC-varB offprod-min - (offspringC-varA * offprod-min-length) 
  report ((offspringC-varA * female-length) + offspringC-varB)
end

;; stream L
to-report update-num-offspringL [ female-length ] ;; linear function
  ;; compute the intermediate variables for the linear offspring production function  for trout of stream C
  set offspringL-varA (offprodL-max - offprod-min) / (offprod-max-length - offprod-min-length)
  set offspringL-varB offprod-min - (offspringL-varA * offprod-min-length)    
  report ((offspringL-varA * female-length) + offspringL-varB)
end

to-report cross-genotype [ genotype1 genotype2 ]
  let new-genotype []
  let bit 0
  repeat length genotype1
  [
    let choice random 4
    if choice = 0
    [ set new-genotype (lput (word(substring (item bit genotype1) 0 4)(substring (item bit genotype2) 0 3)) new-genotype)]
    if choice = 1
    [ set new-genotype (lput (word(substring (item bit genotype1) 0 3) (substring (item bit genotype2) 3 7)) new-genotype)]
    if choice = 2
    [ set new-genotype (lput (word(substring (item bit genotype2) 0 3) (substring (item bit genotype1) 3 7)) new-genotype)]
    if choice = 3
    [ set new-genotype (lput (word(substring (item bit genotype1) 4 7) (substring (item bit genotype2) 3 7)) new-genotype)]      
    set bit bit + 1
  ]
  report new-genotype
end

to-report mixture [ genotype-temp ]
  let genotype-mix []
  let bit 0
  repeat length one-of genotype-temp
  [
    let choice random (length genotype-temp) ; choose randomly one genotype among n males
    set genotype-mix lput item bit (item choice genotype-temp) genotype-mix
    set bit bit + 1
  ] 
  report genotype-mix
end

to-report VBLF-reverse [ trout-indiv ]  
  ifelse is-agentset? trout-indiv
  [
    let length-when-born []
    (foreach sort trout-indiv
      [
        let time 0
        let length-diff 0
        let length-when-born-temp 0
        ask ?
        [
          set time (week - week-of-birth2)
          ifelse natal-stream = "C" 
          [ 
            set length-diff (streamC-max-length - body-length)
            set length-when-born-temp (streamC-max-length - (length-diff / ((1 - streamC-parK) ^ (time))))            
          ]
          [ 
            set length-diff (streamL-max-length - body-length)
            set length-when-born-temp (streamL-max-length - (length-diff / ((1 - streamL-parK) ^ (time))))            
          ]
        ]     
        set length-when-born lput length-when-born-temp length-when-born                
      ])
    report length-when-born 
  ]  
  [
    let time (week - ([week-of-birth2] of trout-indiv))      
    ifelse [natal-stream] of trout-indiv = "C"
    [ 
      let length-when-born (streamC-max-length - ((streamC-max-length - [body-length] of trout-indiv) / ((1 - streamC-parK) ^ (time)))) 
      report length-when-born
    ]
    [ 
      let length-when-born (streamL-max-length - ((streamL-max-length - [body-length] of trout-indiv) / ((1 - streamL-parK) ^ (time)))) 
      report length-when-born  
    ]   
  ]   
end

to trout-become-candidate-migrants
  if (age = move-min-age or age = move-max-age) and current-stream = "C" and natal-stream = "C" 
  [ if random-normal move-mean-length move-sd-length < body-length
    [ set status "candidate-migrant" ] ]
end

;; movement from C to L
to trout-move-downstream
  let temperature-streamC [temperature] of one-of patches with [ stream = "C" ]  
  let flow-streamC [flow] of one-of patches with [ stream = "C" ]    
  if status = "candidate-migrant"
  [ if random-normal move-mean-temperature move-sd-temperature < temperature-streamC 
    and random-lognormal move-mean-flow move-sd-flow < flow-streamC
    [ ifelse age = 1
      ;; juveniles age 1
      [ if random-float 1 < move-age1-prob 
        [ set xcor 0 set current-stream "L" set status "migrant" ] ]
      ;; juveniles age 2
      [ if random-float 1 < move-age2-prob
        [ set xcor 0 set current-stream "L" set status "migrant" ] ]
    ] 
  ]   
end    

to update-move-age1-prob ;; logistic function
  let nb1 count trout with [current-stream = "C" and body-length > 70]
  let Z1 (exp((move-age1-varA * nb1) + move-age1-varB))
  set move-age1-prob (Z1 / (1 + Z1))  
end

to update-move-age2-prob ;; logistic function
  let nb2 count trout with [current-stream = "C" and body-length > 70]
  let Z1 (exp((move-age2-varA * nb2) + move-age2-varB))
  set move-age2-prob (Z1 / (1 + Z1))  
end

to trout-move-back
  ;; candidate spawners return to previous stream
  if (status = "candidate-spawner" and current-stream = "C" and moved-to-spawn?)
  ;; effective spawners return to previous stream
    or (status = "spawner" and current-stream = "C" and moved-to-spawn?)
  [ set current-stream "L" set xcor 0 set returned? true ]  
end

to leave-streamL
  set breed gone
  hide-turtle
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to-report random-lognormal [mu sigma]
  let S sqrt(ln(((sigma / mu) ^ 2) + 1))
  let M ln (mu) - ((S ^ 2) / 2)
  report exp(random-normal M S)
end
@#$#@#$#@
GRAPHICS-WINDOW
10
405
255
516
-1
0
80.0
1
10
1
1
1
0
1
1
1
0
1
0
0
1
1
1
ticks
30.0

PLOT
825
10
1240
165
Trout abundance in the tributary and in the main river
Years
Number
0.0
10.0
0.0
3500.0
true
true
"" ""
PENS
"stream C" 1.0 0 -13345367 true "" "if week-of-year = 1 [plotxy year count trout with [current-stream = \\"C\\" and body-length > 70]]"
"stream L" 1.0 0 -7500403 true "" "if week-of-year = 1 [plotxy year count trout with [current-stream = \\"L\\" and body-length > 70]]"

BUTTON
5
30
142
63
default parameters
restore-defaults
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
75
275
135
308
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

MONITOR
10
315
67
360
week
week-of-year
17
1
11

MONITOR
70
315
127
360
month
month-of-year
17
1
11

MONITOR
130
315
187
360
year
year
17
1
11

BUTTON
10
365
65
398
step-W
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

PLOT
825
175
1240
330
Spawners ascending and descending the tributary
Years
Number
0.0
10.0
-300.0
500.0
true
true
"" ""
PENS
"up" 1.0 1 -10899396 true "" "if week-of-year = 19 [plotxy year count turtles with [moved-to-spawn? = true]]"
"down" 1.0 1 -2674135 true "" "if week-of-year = 19 [plotxy year (- (count turtles with [moved-to-spawn? = true and returned? = true]))]"
"axis" 1.0 0 -16777216 false "" ";; we don't want the \\"auto-plot\\" feature to cause the\\n;; plot's x range to grow when we draw the axis.  so\\n;; first we turn auto-plot off temporarily\\nauto-plot-off\\n;; now we draw an axis by drawing a line from the origin...\\nplotxy 0 0\\n;; ...to a point that's way, way, way off to the right.\\nplotxy 1000000000 0\\n;; now that we're done drawing the axis, we can turn\\n;; auto-plot back on again\\nauto-plot-on"

BUTTON
70
365
125
398
step-M
repeat 4.3 [go]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
130
365
185
398
step-Y
repeat 52 [go]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

MONITOR
270
495
320
540
age 0
count trout with [current-stream = \\"C\\" and age = 0]
17
1
11

MONITOR
340
495
390
540
age 1
count trout with [current-stream = \\"C\\" and age = 1]
17
1
11

MONITOR
410
495
460
540
age 2
count trout with [current-stream = \\"C\\" and age = 2]
17
1
11

MONITOR
480
495
530
540
age 3+
count trout with [current-stream = \\"C\\" and age > 2]
17
1
11

MONITOR
760
495
810
540
age 3+
count trout with [current-stream = \\"L\\" and age > 2]
17
1
11

MONITOR
690
495
740
540
age 2
count trout with [current-stream = \\"L\\" and age = 2]
17
1
11

MONITOR
620
495
670
540
age 1
count trout with [current-stream = \\"L\\" and age = 1]
17
1
11

MONITOR
550
495
600
540
age 0
count trout with [current-stream = \\"L\\" and age = 0]
17
1
11

MONITOR
825
330
900
375
up-spawners
count turtles with [moved-to-spawn? = true]
0
1
11

MONITOR
980
330
1070
375
down-spawners
count turtles with [moved-to-spawn? = true and returned? = true]
0
1
11

MONITOR
900
330
970
375
% homing
(count trout with [moved-to-spawn? = true and natal-stream = \\"C\\"] / count trout with [moved-to-spawn? = true]) * 100
0
1
11

MONITOR
1090
330
1165
375
offspring in C
sum [num-offspring] of turtles with [current-stream = \\"C\\" and sex = \\"F\\"]
0
1
11

MONITOR
1165
330
1240
375
offspring in L
sum [num-offspring] of turtles with [current-stream = \\"L\\" and sex = \\"F\\"]
0
1
11

PLOT
825
385
1240
540
Young trout migrating from the tributary to the main river
Years
Number
0.0
10.0
0.0
1500.0
true
true
"" ""
PENS
"age 1" 1.0 1 -955883 true "" "if week-of-year = 49 [plotxy year count turtles with [age = 1 and current-stream = \\"L\\" and status = \\"migrant\\"]]"
"age 2" 1.0 1 -8630108 true "" "if week-of-year = 49 [plotxy year count turtles with [age = 2 and current-stream = \\"L\\" and status = \\"migrant\\"]]"

TEXTBOX
5
10
590
36
1. Click the button below, then change the value of each parameter (or keep the defaults)
12
0.0
1

TEXTBOX
10
255
210
281
2. Initialize, then run the model
12
0.0
1

SLIDER
275
100
410
133
spawn-start
spawn-start
1
11
6
1
1
NIL
HORIZONTAL

SLIDER
410
100
555
133
spawn-end
spawn-end
12
52
17
1
1
NIL
HORIZONTAL

SLIDER
275
205
410
238
spawn-mean-cond
spawn-mean-cond
0.5
1.5
0.936
0.01
1
NIL
HORIZONTAL

TEXTBOX
375
80
465
98
Reproduction
12
0.0
1

TEXTBOX
115
75
265
93
Survival
12
0.0
1

TEXTBOX
615
80
765
106
Downstream movement
12
0.0
1

TEXTBOX
670
185
820
211
Growth
12
0.0
1

SLIDER
275
170
410
203
predation-factor
predation-factor
1
5
2
1
1
NIL
HORIZONTAL

SLIDER
410
170
555
203
moved-prop
moved-prop
0
1
0.45
0.05
1
NIL
HORIZONTAL

SLIDER
410
135
555
168
offprodL-max
offprodL-max
1
10
5
1
1
NIL
HORIZONTAL

SLIDER
410
205
555
238
spawn-mean-length
spawn-mean-length
148
335
222.9
0.1
1
NIL
HORIZONTAL

SLIDER
275
135
410
168
offprodC-max
offprodC-max
1
200
168
1
1
NIL
HORIZONTAL

SLIDER
565
100
690
133
move-start
move-start
1
28
23
1
1
NIL
HORIZONTAL

SLIDER
690
100
810
133
move-end
move-end
29
52
48
1
1
NIL
HORIZONTAL

SLIDER
565
135
690
168
move-min-age
move-min-age
0
6
1
1
1
NIL
HORIZONTAL

SLIDER
690
135
810
168
move-max-age
move-max-age
1
6
2
1
1
NIL
HORIZONTAL

SLIDER
565
205
690
238
streamC-parK
streamC-parK
0
0.02
0.012
0.001
1
NIL
HORIZONTAL

SLIDER
690
205
810
238
streamL-parK
streamL-parK
0
0.02
0.011
0.001
1
NIL
HORIZONTAL

TEXTBOX
45
85
195
103
Stream C
11
0.0
1

TEXTBOX
180
85
330
103
Stream L
11
0.0
1

SLIDER
135
100
265
133
L-age0-survival
L-age0-survival
0
1
0.38
0.01
1
NIL
HORIZONTAL

SLIDER
5
100
135
133
C-age0-survival
C-age0-survival
0
1
0.39
0.01
1
NIL
HORIZONTAL

SLIDER
5
135
135
168
C-age1-survival
C-age1-survival
0
1
0.37
0.01
1
NIL
HORIZONTAL

SLIDER
5
170
135
203
C-age2-survival
C-age2-survival
0
1
0.85
0.01
1
NIL
HORIZONTAL

SLIDER
5
205
135
238
C-age3-survival
C-age3-survival
0
1
0.7
0.01
1
NIL
HORIZONTAL

SLIDER
135
135
265
168
L-age1-survival
L-age1-survival
0
1
0.74
0.01
1
NIL
HORIZONTAL

SLIDER
135
170
265
203
L-age2-survival
L-age2-survival
0
1
0.87
0.01
1
NIL
HORIZONTAL

SLIDER
135
205
265
238
L-age3-survival
L-age3-survival
0
1
0.69
0.01
1
NIL
HORIZONTAL

PLOT
270
275
530
495
Trout in the tributary (stream C)
Age
Number
-1.0
6.0
0.0
4000.0
true
false
"set-histogram-num-bars 8" ""
PENS
"trout" 1.0 1 -13345367 true "" "histogram [age] of trout with [current-stream = \\"C\\"]"

PLOT
550
275
810
495
Trout in the main river (stream L)
Age
Number
-1.0
6.0
0.0
1000.0
true
false
"set-histogram-num-bars 7" ""
PENS
"trout" 1.0 1 -7500403 true "" "histogram [age] of trout with [current-stream = \\"L\\"]"

BUTTON
10
275
70
308
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## WHAT IS IT?

This is the first version (1.0) of a brown trout demogenetic model developed by Beatrice Frank during her PhD thesis (Supervisor: Prof. Philippe Baret, Earth and Life Institute, Universite catholique de Louvain). This model is described in [Frank & Baret, 2013](http://dx.doi.org/10.1016/j.ecolmodel.2012.09.017).

## HOW IT WORKS

The model description follows the ODD (Overview, Design concepts, Details) protocol ([Grimm et al., 2006](http://dx.doi.org/10.1016/j.ecolmodel.2006.04.023); [2010](http://dx.doi.org/10.1016/j.ecolmodel.2010.08.019)). This protocol consists of seven elements. The first three elements provide an overview of the model, by stating (i) the question addressed, (ii) its structure in terms of entities (agents), state variables, temporal and spatial scales, and (iii) its dynamics, i.e., the order in which the processes (submodels) of the model are executed. In the fourth element, general concepts underlying the model's design are explained. The remaining three elements complete the model description by providing further details about initialisation, input data, and submodels.

### OVERVIEW

#### PURPOSE

The model, named DemGenTrout, was designed to understand how anthropogenic disturbances can affect a brown trout (_Salmo trutta_ L.) population living in a river / nursery brook system of the Lesse River network (Belgium). Changes in the demogenetic (i.e., demography and genetics) structure of the population were monitored, and at a latter stage, the model was used to predict how trout populations might respond to migration barriers and stocking with hatchery trout ([Frank & Baret, 2013](http://dx.doi.org/10.1016/j.ecolmodel.2012.09.017)). 

#### ENTITIES, STATE VARIABLES, AND SCALES

Two types of entities are comprised in the model: two streams, representing the studied hydrological system, and trout agents. The stream agent corresponds to the tributary and the main river, and each stream has three state variables: code, current flow, and current water temperature. Trout agents are characterised by 15 state variables: natal stream, sex, genotype, and week of birth (static variables); age, stage, status, length, weight, condition factor, number of offspring, current status of spawning, movement or return, and current stream they are in. 

The spatial resolution and extent of the model are defined by the two possible locations for trout in the system: the Chicheron Brook (referred as stream C), and a section of the Lesse River (stream L). One time step represents one week and simulations last 35 years, corresponding to 10 trout generations.

#### PROCESS OVERVIEW AND SCHEDULING

Nine processes are considered in the model: the update of hydrological conditions for each stream agent; survival, growth, reproduction, ageing, hatching, moving downstream, post-spawning homing, and leaving the system forever for each trout agent. 

Each time step, stream agents first update their water temperature and flow. Second, trout agents challenge their survival. If alive, they update their length, weight, and condition factor. Third, if spawning conditions are met, trout possibly produce offspring that will hatch ten weeks later. Fourth, trout update their age and stage one week before the beginning of the hatching period. Fifth, if conditions for movement are met, trout of the tributary have the possibility to move downstream (i.e., from stream C to stream L). Sixth, alive spawners return to their previous stream one week after the spawning process (post-spawning homing behaviour). The last week of the year, some juveniles (i.e., trout of age 1 and 2) living in stream L do not settle in this stream and disappear from the system to search for more suitable locations.

All actions occur in the same predetermined order, and are executed either once per time step, at specific time windows, or only once a year, as specified in the fixed scheduling of the model:

  - Initialise trout and stream agents.
  - Weekly stream action: update stream hydrological conditions (water temperature and flow).
  - Weekly trout actions: determine how many trout die in each stream; update trout length, weight, and condition factor.
  - Trout actions during the spawning time window: identify candidate spawners using physiological criteria; move candidate spawners upstream when hydrological conditions are suitable; produce offspring in each stream.
  - Trout actions during the movement time window: identify candidates for migration using physiological criteria; move candidate migrants downstream when hydrological conditions are suitable.
  - Yearly trout actions: increment trout age and update stage in each stream.
  - Trout action during the hatching time window: reveal offspring in each stream.
  - Yearly trout action: move upswimming spawners back to stream L.
  - Yearly trout action: remove young trout of stream L from the system.

### DESIGN CONCEPTS

**Basic principles:** The model is underpinned by demogenetics, an emerging field in ecology that integrates both population dynamics and population genetics. Population abundance and structure can be influenced by density-dependent or density-independent processes. In the model, we considered both types of processes at the submodel-level: on the one hand, the downstream migration of young trout is density-dependent and is expected to have a strong effect on the regulation of abundance in the brook; on the other hand, environmental variability may affect the behaviour of individuals such as their decision of moving between streams which in turn shapes the demographic structure. Individuals inhabiting large rivers usually move into first-order tributaries to spawn, and return to their original territory once reproduction is complete (i.e., post-spawning homing behaviour). Homing to natal rivers is particularly strong in salmonids. However, some individuals might decide to not reproduce in their home river (i.e., straying behaviour). Natural selection is the key micro-evolutionary process of population genetics considered in the model. Its effect is evaluated indirectly through the use of microsatellite markers, which allow describing the genetic structure of the population with F-statistics. 

**Emergence:** Survival, growth, spawning, and movements of individuals are imposed behaviours that are empirically described in the model using real data. Spawning and downstream movement processes are affected by hydrological variables. Population dynamics and genetics (i.e., demogenetics) emerge from these behaviours acting at the individual level: on the one hand, the demographic structure of the population (fry, juveniles and adults proportions) is shaped by the number of reproducing individuals; on the other hand, the number of produced offspring is determined by the female length and new genotypes emerge as a result of genetic adaptation and natural selection. 

**Adaptation:** Juvenile and mature adult movements are the adaptive traits in the model. They are modelled as indirect fitness-seeking, in which individuals make decisions of life history tactics that indirectly contribute to future success at passing genes on. Juveniles decide whether and when they migrate to the main stream, and this decision affects their growth. Mature adults decide whether, when and where they spawn each year, and this decision affects the offspring production in each stream. The selection of spawners is based on their body condition factor, and offspring length is inherited from their parents. 

**Objectives:** Fitness-seeking is not explicitly considered in the model. 

**Learning:** This concept is not explicitly considered in the model.

**Prediction:** This concept is not explicitly formalised in the model. However, tacit predictions are included because fitness-seeking is implicitly modelled. In addition, the tributary is supposed to offer more favourable zones for reproduction, so the probability of reproducing successfully is highest if trout chose to spawn in the brook. 

**Sensing:** No sensing mechanisms are explicitly represented. Individuals are assumed to know the status or value of all their state variables, which affect their survival, growth, spawning and movements. They also have access to information about their current stream, such as water temperature and flow. 

**Interaction:** Individuals do not directly interact together, but competition for shared resources is taken into account in the downstream movement process of juveniles. The probability of moving depends on the number of similar age trout present in the tributary (density-dependent population regulation).

**Stochasticity:** Most processes of the model are drawn from empirical probability distributions in order to include individual variability. The model incorporates environmental variability through the hydrological variables (i.e., input data), for which additional stochasticity was introduced using random floating point numbers. 
Survival and downstream dispersal are stochastic events. Whether a trout actually dies or moves to the main stream is determined by comparing a random number to the survival rate or the movement probability. Stochasticity is also used in the spawning process for the selection of spawners, the production of offspring and the definition of their state variables. 

**Collectives:** Collectives are not included in the model.

**Observation:** The following demographic and genetic outputs were recorded to follow the changes through time of the brown trout population demogenetic structure: the number of migrant juveniles and the number of spawners moving between both streams over each year and, for each stream, the total number of individuals, the number of individuals with a body length > 70 mm, the number of offspring, and the genotypes of 48 randomly chosen individuals. Three genetic outputs were derived from genotypes using the [adegenet](http://cran.r-project.org/web/packages/adegenet/index.html) and [pegas](http://cran.r-project.org/web/packages/pegas/index.html) R packages: (i) the effective number of alleles, E<sub>A</sub>, to measure the genetic diversity for trout of each stream, (ii) the inbreeding coefficient, Fis, to measure the extent of genetic inbreeding within trout of each stream, and (iii) the fixation index, Fst, to measure the degree of genetic differentiation between trout of both streams.


### DETAILS

#### INITIALISATION

Initialisation does not vary among simulations. We used a seed value of 1223251200 to start the random number generator. Each simulated year starts on October 1, and lasts 52 weeks. Hydrological variables (water temperature and flow) are assumed uniform throughout a stream and are initialised with the input data corresponding to the first week of simulation (see next section Input data). Trout abundance, age-class repartition, age-specific length and condition factor random Normal distributions in both streams, as well as age-specific proportions of trout living in stream L that changed their natal-stream state variable from L to C are initialised with the text file ''init-trout''. 

In the model, length distributions are truncated at +- 4 standard deviations. Values of initial trout abundance and age-class repartition of individuals in each stream were calibrated using standard genetic algorithms implemented in [BehaviorSearch](http://behaviorsearch.org/). Trout condition factor corresponds to Fulton's coefficient K, which assumes that the standard weight W of a fish is proportional to the cube of its length L, i.e., K = W / L^3. The value of this factor is 1 when an individual has a healthy weight for its length; a value > 1 indicates an overweight, and a value < 1 a poor condition. Trout current and natal stream are assigned according to the location of the individual or to its stream of birth. As the presence of natal homing behaviour was demonstrated for trout of the studied system, some randomly selected individuals living in stream L change their natal-stream state variable from L to C. Their proportion was obtained by calibration. 

The other trout variables are initialised as follows: each trout weight is calculated as its body condition factor times its length cubed according to Fulton's formula; trout sex is randomly assigned with even probability of being female or male; each trout genotype is constituted of twelve loci, with two alleles at each locus randomly assigned in accordance with observed allelic frequencies (see text files ''input-genotypes-streamC-12markers'', ''input-genotypes-streamL-12markers'', ''input-genofreq-streamC-12markers'' and ''input-genofreq-streamL-12markers''); age of adults is drawn from a uniform integer distribution between 3 and 6; stage is set according to age; trout status is set to 'non-spawner'; the week of birth is set to the trout age multiplied by -52; the number of offspring is set to 0; and the Boolean variables spawned?, moved-to-spawn? and returned? are set to false. 


#### INPUT DATA

The input data of the DemGenTrout model are weekly time series of observations: water temperatures (_C) and flow rates (m_/s) in both streams (see text file ''input-data''). The first four years are real field data (2004-2008) and the 31 subsequent years were simulated using the Holt-Winters method implemented in [R](http://www.R-project.org). 


#### SUBMODELS

The model contains 51 parameters, which are listed with their values in the text file ''init-params''. The values of 38 of them were directly obtained from field studies conducted on the Lesse River / Chicheron Brook hydrological system. For the length-heritability parameter, the value was derived from the literature. Four parameters were guestimated (i.e., we had only an idea of what would be a realistic value for each of them) and 8 parameters were calibrated. 

The model comprises nine submodels or processes, and their description follows the fixed scheduling presented in the Process Overview and Scheduling section. We used the following conventions when a parameter name is referring to either both streams or several age classes: streamX, where X corresponds to C or L; ageY, where Y corresponds to age class 0, 1, 2 or >= 3; ageZ, where Z corresponds to age class 1 or 2. 

**1. Update stream hydrological conditions:** Each week, the flow and water temperature of each stream are updated from the input data. They are assumed uniform throughout a stream. 

**2. Kill trout in each stream:** Each week, a random number between 0 and 1 is drawn for each trout. If this number is higher than the survival rate corresponding to the trout current age and stream location (streamX-ageY-survival parameters), then the trout dies. Probability density functions were used to get annual trout survival rates, which were transformed into weekly values in the model (i.e., survival rates exponent 1/52). The value of streamC-age3-survival was guestimated from streamL-age3-survival. Three mortality sources were indirectly taken into account when the survival functions were drawn: predation by spawners for young trout of the brook during the reproduction period, high temperatures in summer for all trout, predation by grey herons (_Ardea cinerea_ L.) in autumn for trout of age equal or higher than 2. For brown trout, the upper lethal temperature in fresh water is at 24.7_C. Trout frequently eat eggs or smaller conspecifics, while birds have been observed to remove large numbers of individuals from small shallow streams. As a high mortality was observed in the brook for spawners during winter, mainly due to predation by herons, the survival rate of trout moving from stream L to stream C for reproduction (i.e., individuals for which the moved-to-spawn? state variable is true) was divided by 2 (predation-factor; guestimated value). 

**3. Update trout length, weight and body condition factor in each stream:** Growth in length is modelled with the von Bertalanffy equation, for which the parameters differ between both streams. Each week, each trout length is updated according to its previous length: L(t+1) = L(t) + k * (L<sub>inf</sub> - L(t)), where k is the growth coefficient (streamX-parK parameter) and L<sub>inf</sub> is the asymptotic length (streamX-max-length). Then, the trout new length is used to calculate its healthy weight W<sub>h</sub>, using parameters a and b of the length-weight relationship (streamX-parA and streamX-parB), which also vary between streams: W<sub>h</sub> = a * L(t+1)^b. Finally, the weight W of each trout is computed as its relative condition factor (K<sub>r</sub>; corresponding to the condition-factor state variable) multiplied by its healthy weight according to Le Cren's formula: W = K<sub>r</sub> * W<sub>h</sub>. An inter-individual variability is randomly generated for the condition factor, which value can vary by +- 0.008 (a conditional statement avoids values strictly lower than 0.5). 

**4. Reproduce trout in each stream:** Trout are iteroparous; spawning only occurs during the breeding season each year, but individuals can spawn several times during their life. Trout adapt their reproductive behaviour to external conditions and their own state, and the location and time of spawning are influenced by both their physical state and hydrological conditions. Each week of the spawning period (i.e., week 6 to 17; spawn-start and spawn-end parameters), each trout first determines if it belongs to the group of candidates for reproduction. Then, when hydrological conditions in stream L are suitable, each candidate spawner determines if it moves upstream (i.e., from stream L to stream C). Eventually, candidates of each stream become spawners when they produce offspring. 

_4.1. Identify candidate spawners:_ Each trout determines whether it meets a series of criteria: adequate age (equal or higher than 3; spawn-min-age parameter), length (normal distribution of mean and standard deviation equal to spawn-mean-length and spawn-sd-length) and condition factor (normal distribution of mean and standard deviation equal to spawn-mean-cond and spawn-sd-cond), not spawned or moved to spawn the current year. If it does, its status is changed from 'non-spawner' to 'candidate-spawner'. Then, candidate spawners living in stream L are randomly selected to move upstream for reproduction, among which 55% (1 - \\moved-prop) of individuals born in stream C (natal-homing behaviour) and 45% (moved-prop) of individuals born in stream L (straying behaviour). 

_4.2. Move candidate spawners upstream:_ The upstream movement of candidate spawners occurs when flow rate in stream L follows a log-normal distribution of mean and standard deviation equal to spawn-mean-flow and spawn-sd-flow parameters. On weeks meeting this criterion, the current location of each selected candidate spawner as well as each candidate spawner born in stream C and currently living in stream L is changed from 'L' to 'C'. 

_4.3. Create offspring:_ Each week of the spawning period and for each stream, the number of crosses is computed as half the total number of candidate spawners. Females can reproduce only once each year, while several small subordinate males can contribute to the fertilization of the eggs of one female (polygamous mating strategy). For each cross, the female is selected among the list of candidate female spawners ranked in descending order by condition factor. The number of males per female (n) is randomly drawn from a uniform distribution from 1 to 4. Then, the n males are randomly selected among a list containing all the candidate male spawners minus n males having the highest condition factor. Upswimming spawners are prioritized over other spawners of stream C by a statement that first identifies the candidate spawners that have moved (moved-to-spawn? state variable is true), and then selects them before the others. 

The number of offspring produced per female per week in each stream depends on its length and follows a linear function, with a slope alpha equal to (F<sub>2</sub> - F<sub>1</sub>) / (L<sub>+</sub> - L<sub>-</sub>) and an intercept beta given by F<sub>1</sub> - alpha * L<sub>-</sub>. Values of L<sub>-</sub> and L<sub>+</sub> (offprod-min-length and offprod-max-length parameters) were derived from observations at the trapping facility; values of alpha and beta were obtained by linear regression of produced offspring vs. female length, and were then used to derive the value of F<sub>1</sub> (offprod-min), which was considered identical for both streams. F<sub>2</sub> corresponds to offprodX-max and was set to 168 for stream C and 5 for stream L (calibrated values). _A demographic explosion was observed when the model was simulated over 35 simulated years. Consequently, we decided to limit offspring production in stream C by dividing offprodC-max by 10 whenever trout abundance in this stream reaches a capacity of 6700 individuals (streamC-capacity parameter)._

The process continues until the precomputed number of crosses is reached. After each cross, the num-offspring state variable of females and males that have effectively spawned is updated. The state variables of each offspring are set as follows. Genotype is given by a random combination of the parental genotypes (the female genotype and a random genotype constructed from the genotypes of the n males), with equal probability of getting each parent allele; age and stage are set to -1 and 'fry', respectively; sex is randomly assigned with even probability of being female or male; current and natal streams are assigned according to the location where the reproduction occurs; birth week is set to the current week; body condition factor is drawn from the same stream-specific normal distributions used for model initialisation and weight is calculated as condition factor times length cubed according to Fulton's formula. 

Offspring lengths L<sub>off</sub> are modelled as being inherited from their parents, following the equation: L<sub>off</sub> = mu<sub>par</sub> + dev<sub>off</sub>(P) = mu<sub>par</sub> + dev<sub>off</sub>(G) + dev<sub>off</sub>(E), where mu<sub>par</sub> is the parental population mean, dev<sub>off</sub>(P) is the total phenotypic deviance of the offspring population, dev<sub>off</sub>(G) and dev<sub>off</sub>(E) are the genetic and environmental contributions to the total phenotypic deviance, respectively. First, mu<sub>par</sub> and var<sub>par</sub> are derived from the distribution of the parents lengths at the fry stage, Lpar<sub>0</sub>, known from the reverse von Bertalanffy growth equation: L<sub>par</sub>(0) = L<sub>inf</sub> - ((L<sub>inf</sub> - L<sub>par</sub>(t)) / (1 - k)^t), where k and L<sub>inf</sub> correspond to the streamX-parK and streamX-max-length parameters, and t is the time elapsed since the birth of the trout (k and L<sub>inf</sub> are set according to the natal stream). Second, dev<sub>off</sub>(G) is given by sqrt(h<sup>2</sup>) * (dev<sub>par1</sub> + dev<sub>par2</sub>), where h<sup>2</sup> is the narrow-sense heritability, dev<sub>par1</sub> (length-heritability parameter) and dev<sub>par2</sub> are the deviation of each parents length from the population mean mu<sub>par</sub>. Third, dev<sub>off</sub>(E) is drawn from a random normal distribution with mean 0 and variance (1-h<sup>2</sup>)<sup>2</sup> * var<sub>par</sub>. To avoid negative lengths, each L<sub>off</sub> value not included in a trout length distribution defined for each stream by the meanl-birth-X and sdl-birth-X initial conditions, truncated at +- 4 standard deviations and rounded to 1 mm when negative values are drawn, are set to a random value drawn from this distribution.

**5. Increment age and update stage of trout in each stream:** One week before the beginning of the hatching period (i.e., week 15; hatch-start parameter - 1), the age of each trout is incremented by one. The stage is updated as follows: if the age is strictly lower than 1, the stage is set to 'fry'; if the age is equal to 1 or 2, it is set to 'juvenile'; if the age is strictly higher than 2, it is set to 'adult'. All individuals die once they reach the age of 7.

**6. Reveal offspring in each stream:** Offspring that have been previously created during reproduction have an age equal to -1 and are hidden until a 10-week delay is reached. When it does, offspring progressively set their age to 0 and become visible in the system. This action occurs once a week during the hatching period (i.e., week 16 to 27; hatch-start and hatch-end parameters). Values chosen for these parameters were based on the hypothesis that the mean number of degree-days for brown trout to complete the egg stage was equal to 444. As we observed an average water temperature of 6_C in both streams during the spawning period, we supposed there was a delay of 10 weeks between the spawning and hatching periods. 

**7. Move trout of stream C downstream:** Each week during the migration period (i.e., week 23 to 48; move-start and move-end parameters), each trout determines if it belongs to the group of candidate migrants. Then, if the flow in stream C is adequate, the candidate migrants that actually move to stream L become migrants. 

_7.1. Identify candidate migrants:_ Trout are candidate migrants if they are born in stream C and currently live in stream C, if their age is equal to 1 or 2 (move-min-age and move-max-age parameters), and if their length follows a normal distribution of mean and standard deviation equal to move-mean-length and move-sd-length. The status of trout meeting these criteria is set to 'candidate-migrant'. 

_7.2. Move candidate migrants:_ Young individuals often leave their home tributary to large rivers for feeding. It appears there is an apparent advantage in form of increased growth, size and thereby reproductive potential by moving instead of remaining resident in the nursery area. Several factors can trigger these movements, such as the physical state of the individuals and hydrological criteria. This migration can also be explained by density-dependent mechanisms. Juveniles that are unable to establish a territory in the nursery brook may be displaced by competition with dominant individuals. In the model, the downstream movement of candidate migrants occurs when water temperature and flow rate in stream C follow distributions of means and standard deviations equal to move-mean-temperature, move-mean-flow, move-sd-temperature and move-sd-flow, respectively. On weeks meeting these criteria, a random number between 0 and 1 is drawn for each candidate migrant. If this number is lower than the probability of moving downstream, then the current location of the candidate is changed from 'C' to 'L' and its status is set to 'migrant'. The migration of individuals is age-specific and follows a density-based logistic function given by: P = exp (A * X + B) / (1 + exp (A * X + B)), where A and B correspond to parameters move-ageZ-varA and move-ageZ-varB, respectively. Their values were obtained by calibration. 

**8. Move upswimming spawners back to stream L:** One week after the end of the spawning period (i.e., week 18; spawn-end + 1), candidate and effective spawners that have moved to spawn return to their original stream (post-spawning homing behaviour). Their current location is changed from 'C' to 'L'.  

**9. Remove young trout of stream L from the system:** The last week of the year (i.e., week 52), trout are randomly selected among (i) migrants from stream C currently living in stream L, with a proportion of 57% corresponding to the leaving-propC parameter (calibrated value), (ii) juveniles born in stream L and currently living in stream L, with a proportion equal to 7% (leaving-propL parameter; calibrated value). These selected trout are assumed to leave the system to search for more suitable locations, owing to their territorial behaviour.

## HOW TO USE IT

Click the 'Default parameters' button to set the values of each parameter. You can then change the values of parameters with the sliders, or you can keep the default values. Not all parameters can be changed, but the ones that were identified as the most influential in the model are included ([Frank & Baret, 2013](http://dx.doi.org/10.1016/j.ecolmodel.2012.09.017)). In particular, the survival rate of fry in the brook (C-age0-survival) and the mean of the spawner condition factor (spawn-mean-cond) showed the strongest influence, followed by the survival rates of age 1 and age 2 trout in stream C (C-age1-survival and C-age2-survival), the survival rate of fry in stream L (L-age0-survival), and the von Bertalanffy growth coefficient for trout in stream L (streamL-parK).

Click the 'Setup' button to initialise the model. Input data are loaded, the stream and trout agents are created, and the outputs are initialised.

Click the 'go' button to start the simulation (click 'go' again to stop it). The model can also be run weekly ('step-W' button), monthly ('step-M') or yearly ('step-Y'). The two plots on the left vary with time, and show the age distribution of trout in both streams (numbers of trout in each age-class are also displayed below each plot). The first plot on the right shows trout abundance in both streams, and is updated each year at week 1. The second plot represents the number of spawners moving from stream L to stream C for reproduction in winter (upswimming spawners), then moving back to stream L (downswimming spawners). For upswimming spawners, the percentage of spawners born in stream C is indicated  (natal homing behaviour). The number of offspring produced in each stream is also monitored. The last plot shows the number of age-1 and age-2 trout migrating from stream C in spring and summer.

## THINGS TO NOTICE AND TO TRY

As genetic outputs are derived from analyses of trout genotypes with R, only demographic outputs can be watched here. 

Notice how the trout age distributions are different. Trout of age class 0 and 1 are less represented in the main river than in the Chicheron Brook, showing the nursery role of the tributary. Abundance is more stable in the main river than in the brook. You can modify the demographic structure by moving the slider corresponding to the survival rate of fry in the brook (C-age0-survival). A value close to 0 will induce trout extinction in both streams, a value close to 1 will cause the reverse effect (i.e., demographic explosion). 

Look at the annual number of spawners ascending or descending the tributary: the ratio is around 50%. You can alter the mortality of spawners during their stay in the brook by moving the slider corresponding to the predation-factor parameter. The number of upswimming spawners can also be changed by varying the moved-prop parameter. 

## EXTENDING THE MODEL

Possibilities for improving the realism of the DemGenTrout model are (i) the consideration of density-dependence in other submodels than the downstream movement of juveniles (e.g., survival and growth processes), (ii) the integration of the quantitative genetics dimension, (iii) the inclusion of additional environmental factors such as rainfall. 

The extension of the model spatial scale could also be envisaged: we could switch from the 6 km_ system comprising the Lesse River / Chicheron Brook, to a 1343 km_ system formed by the Lesse watershed. Several populations would interact, and the impact of brown trout behaviour on the exchange of genetic material among populations could therefore be studied.

## RELATED MODELS

DemGenTrout 1.1: In comparison with DemGenTrout 1.0, the initialisation of this version is faster.

DemGenTrout 1.2: This version includes features of DemGenTrout 1.1 (faster initialisation) and simulates a barrier to upstream spawning migration.

DemGenTrout 1.3: This version includes features of DemGenTrout 1.1 (faster initialisation) and simulates stocking with hatchery trout.

## CREDITS AND CITATION

The development of the model was funded by the "Fonds pour la formation a la Recherche dans l'Industrie et dans l'Agriculture" (F.R.I.A.). During the formulation phase, the report describing the inSTREAM model of [Railsback et al. (2009)](http://www.fs.fed.us/psw/publications/documents/psw_gtr218) has been an inspirational source. For the programming phase, many of the sample NetLogo models were of great use.

To refer to this model in academic publications, please use: Frank, B.M., Baret, P.V. (2013). Simulating brown trout demogenetics in a river/nursery brook system: The individual-based model DemGenTrout. Ecological Modelling 248: 184-202.

## COPYRIGHT AND LICENSE

DemGenTrout 1.0 (2012)

Beatrice M. Frank

Earth and Life Institute

Universite catholique de Louvain

Beatrice.Frank@gmail.com

![CC BY-NC-SA 3.0](http://i.creativecommons.org/l/by-nc-sa/3.0/88x31.png)
 
This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/.
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
0
Rectangle -7500403 true true 151 225 180 285
Rectangle -7500403 true true 47 225 75 285
Rectangle -7500403 true true 15 75 210 225
Circle -7500403 true true 135 75 150
Circle -16777216 true false 165 76 116

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

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.0.2
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
1
@#$#@#$#@
