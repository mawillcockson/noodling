(each [digits (string.gmatch "244 127 163" "%d+")]
  (print (tonumber digits)))
(let [result
       (accumulate [sum 0
                 digits (string.gmatch "244 127 163" "%d+")]
         (+ sum (tonumber digits)))]
  (print result))
