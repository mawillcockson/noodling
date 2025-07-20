(defn compare-them
  [&keys {:apples apples
          :oranges oranges}]
  (def quantity
    (cond
      (compare= apples oranges) "no more or fewer"
      (compare> apples oranges) "more"
      "fewer"))
  (string/join ["you have " quantity " apples than oranges"]))

(defn main [&opt & args]
    (print (compare-them (get 0 args) (get 1 args))))
