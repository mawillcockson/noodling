#(print 
#    (let
#        [inner ~(any (if-not ">" 1))
#         after ~(/ (<- ,inner) ,string/ascii-upper)
#         whole ~(* "<" ,after)]
#         peg/match whole "<hello>"))
#(print (peg/match ~(* "<" (/ (<- (any (if-not ">" 1))) ,string/ascii-upper) ">") "<hello>"))

# (def pat
#     ~(<- (* "a" (> 0 "b"))))
# 
# (defn print/tuple [tup]
#     (prin "[")
#     (prin (string/join (map (fn [s] (string/format "%s" s)) tup) ", "))
#     (print "]"))
# 
# (def strings ["ab" "a" "abb" "cb"])
# (loop [str :in strings]
#     (let [match_ (peg/match pat str)]
#         (if (not (nil? match_))
#             (print (string/format "%j" (peg/match pat str))))))

(def pat ~{:conjunctions (+ "and" "or")
    :main (% (any (+ (* (/ "," ";") (<- (* :s+ :conjunctions))) (<- 1))))})

(->> (peg/match pat "this is dumb, confusing, and upsetting") (string/format "%j") (print))
