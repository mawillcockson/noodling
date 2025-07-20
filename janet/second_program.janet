(defn print-greeting
    [greetee]
    (print "Hello, " greetee "!"))

(defn main
    [& args]
    (pp args)
    (print (length args))
    (print-greeting (get args 1)))
